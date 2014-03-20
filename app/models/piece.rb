require 'couchrest_model'
require 'RMagick'
include Magick

class Piece < CouchRest::Model::Base
  extend CouchSeeds

  property :title,      String
  property :imagen_id,  String
  property :deviation,  String
  property :order,      String
  property :created_at, String, default: Time.now.strftime('%d-%m-%Y,%l:%M %p')

  design do
    view :pieces,
      map:
        "function(doc) {
          if(doc['type'] == 'Piece' && doc.title && doc.order && doc.imagen_id) {
            emit(doc.order, [doc.imagen_id, doc.title]);
          }
        }"
  end

  class << self
    def get_and_transform_set id
      set = get_all_child_pieces(id).compact
      add_deviation_to(set)
      add_offset_to(set, id)
      set.shuffle!
    end

    #private

    def get_all_child_pieces picture_id
      pieces.rows.map! do |row|
        piece = {}
        if row.value[0] == picture_id
          piece[:title] = row.value[1]
          piece[:id] = row.id
          piece[:order]  = row.key
        # piece[:imagen_id] = row.value[0]
          piece.with_indifferent_access 
        end
      end
    end

    # def destroy_test picture_id
    #   pieces.rows.map do |row|
    #     if row.value[0] == picture_id
    #       piece = Piece.get(row.id)
    #       piece.destroy
    #       row
    #     else
    #       #donothing
    #     end
    #   end
    # end

    def add_offset_to set, id
      all_divs = DivContainer.get_all_divs()
      filtered_divs =
        if get(id).columns.to_i == 8
          filter_divs(all_divs, 'large')
        elsif set.size > 55 && set.size <= 110
          filter_divs(all_divs, 'small')
        elsif set.size > 110
          filter_divs(all_divs, 'large')
        else
          all_divs
        end

      divs = filtered_divs.shuffle!
      set.each do |piece|
        random_index = rand(divs.size)        
        piece.merge!(divs[random_index])
        divs.slice!(random_index)
      end
    end

    def filter_divs all_divs, opt
      actual_set = []
      all_divs.map! do |div|
        matched_pair = [] 
        (DivContainer.send "get_#{opt}_group_list").each do |_, pair|
          div['key'] == pair[0] && div['value'] == pair[1] ? (matched_pair << 'matched') : (true)
        end

        matched_pair.empty? ? (div) : (nil)
      end

      all_divs.compact
    end

    def add_deviation_to set
      degrees = [270, 360, 90, 180, 360]
      set.each do |piece|
        deviation = piece[:deviation] = degrees[rand(5)] 
        get(piece[:id]).update_attributes(deviation: deviation)
      end

      set
    end
  end
end 