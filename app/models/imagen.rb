require 'couchrest_model'
require 'RMagick'
include Magick

# TODO: Most of this classes' methods are to saturate couchdb with records after cloning the project
#  and potentially to perform some manipulations on asset images such as formatting and 
#  cutting on pieces. 
#  Two workflow are possible for getting couchdb ready to serve the app:
#  1. Given the asset images directory already keeping formatted images and their pieces:
#  a. Create image records running create_imagenes
#  b. Add width and height to image records running save_image_size
#  c. Create piece records running create_pedazos

#  2. Given the asset images directory keeping nothing but raw images/formatted images:
#  a. Create images running create_imagenes
#  b. Run format_save_size_crop_images_save_pieces

class Imagen < CouchRest::Model::Base
  extend CouchSeed

  PIECE_SIZE = 50

  property :width,        String
  property :height,       String
  property :title,        String
  property :category,     String
  property :subcategory,  String,    default: 'none'
  property :complicated?, TrueClass, default: false
  property :created_at,   String, default: Time.now.strftime('%d-%m-%Y,%l:%M %p')
  # property :number_of_x_cuts
  # property :y_step

  design do
    view :by_category
    view :imagenes,
      map:
        "function(doc) {
          if(doc['type'] == 'Imagen' && doc.title && doc.category) {
            emit(doc.title, doc);
          }
        }"
  end

  class << self

    def get_all
      imagenes.rows.map! do |row|
        imagen = {}
        val = row.value.with_indifferent_access
        
        imagen[:id] = row.id
        imagen[:title] = row.key
        imagen[:category] = val[:category]
        imagen[:width] = val[:width]
        imagen[:height] = val[:height]
        imagen[:subcategory] = val[:subcategory] unless val[:subcategory] == 'none' 

        imagen
      end
    end

    # Add the subcategory information to the result in order to sort by subcategory also????
    def get_categories
      categories = by_category.reduce.group_level(1).rows
      categories.map!{ |category| { category: category['key'] } }     
    end

  # private
    def create_imagenes
      images_list().map do |image|
        new_record = 
          if image[:subcategory]
              {title: image[:title],
               category: image[:category],
               subcategory: image[:subcategory]}    
          else
              {title: image[:title],
               category: image[:category]}
          end
        create!(new_record)
      end
    end

    def save_image_size
      Dir.chdir("/home/ninok/projects/puzzle/app/assets/images/")
      images_list().each do |img|
        image_file = ImageList.new(img[:title])

        id = imagenes.rows.select{ |row| img[:title] == row.key}.first.id

        Imagen.get(id)
         .update_attributes(width: image_file.columns,
                            height: image_file.rows)        
      end
    end

    def create_pedazos
      pieces_list().each do |piece|
        create_piece(piece[:title], 
                     piece[:imagen_id], 
                     piece[:order])
      end
    end

    def create_piece(file_name, id, order)
      Piece.create!(
        title: file_name, 
        imagen_id: id, 
        deviation: 0,
        order: order
      )     
    end

    def format_save_size_crop_images_save_pieces
      images_list().each do |image|
        id = imagenes.rows.select{ |row| image[:title] == row.key}.first.id

        image_params = format_save_size_of_image(image[:title])
        crop_image_save_pieces(image_params[:rows_quantity], 
                               image_params[:columns_quantity], 
                               image[:title], id)
      end
    end

    def crop_image_save_pieces rows_quantity, columns_quantity, title, id
      # Determine step intervals
      y_steps = []
      (0...rows_quantity).each do |number|
        number == 0 ? (y_steps << number) : (y_steps << y_steps.last + PIECE_SIZE)
      end
      
      @order = 1
      
      # Cut wisely
      y_steps.each do |y_step|
        iteration = 0
        x_step = 0

        until iteration == columns_quantity
          file_name = "#{title}_#{y_step}_#{iteration}.jpg"
          
          cropped_image = image.crop(x_step, y_step, 
                                     PIECE_SIZE, 
                                     PIECE_SIZE, 
                                     true)
          cropped_image.write(file_name)
          # The database part
          create_piece(file_name, id, @order)

          x_step = x_step + PIECE_SIZE
          iteration = iteration + 1
          @order = @order + 1
        end
      end     
    end



    def format_save_size_of_image title
      Dir.chdir("/home/ninok/projects/puzzle/app/assets/images/")
      image = ImageList.new(title)

      # Resize picture to fit a common format for all of the images
      percentage = (580*100).fdiv(image.columns)
      real_height = (percentage*image.rows).fdiv(100)
      image = image.resize_to_fill(580, real_height)


      # Get number of pieces per width and per height
      columns_quantity = image.columns/PIECE_SIZE
      rows_quantity = image.rows/PIECE_SIZE


      # Calculate even width and size of picture
      actual_width = PIECE_SIZE*columns_quantity
      actual_height = PIECE_SIZE*rows_quantity

      # Resize picture according to the previous calculation
      image = image.resize_to_fill(actual_width, actual_height).write(title)

      # Save image size to the db
      Imagen.get(id)
       .update_attributes(width: actual_width,
                          height: actual_height)
      
      { columns_quantity: columns_quantity,
        rows_quantity: rows_quantity }      
    end
  end
end
