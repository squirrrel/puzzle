require 'couchrest_model'
require 'RMagick'
include Magick

# TODO: number_of_x_cuts and y_step of an image 
#  should be set within the scope of self.fragment_and_randomly_rotate method
#  these same properties should be set below
#  'imagenes' view should also be changed to emit them
class Imagen < CouchRest::Model::Base
	property :title,        String
	property :category,     String
	property :subcategory,  String
	property :complicated?, TrueClass, default: false
	property :created_at,   String, default: Time.now.strftime('%d-%m-%Y,%l:%M %p')
	# property :number_of_x_cuts
	# property :y_step

	design do
		view :imagenes,
			map:
				"function(doc) {
					if(doc['type'] == 'Imagen' && doc.title) {
						emit(doc.title, doc._id);
					}
				}"		
	end

	def self.get_all
		imagenes.rows.map! do |row|
			imagen = {}
			imagen[:title] = row.key
			imagen[:id] = row.value
			imagen
		end
	end

	# EXPLAIN: The method iterates through hashes, and based on their key-value pairs,
	#  creates corresponding Imagen objects in the DB
	# def self.create_imagenes
	# 	create!(
	# 	  id: 'ba546f2e47d2a915c3ffff08503e5b86',
	# 		title: 'geisha_fragments_1.jpg',
	# 		category: 'Art',
	# 		subcategory: 'Japanese'
	# 	)
	# end

	private
	# EXPLAIN: The method will be useful for cutting a picture into pieces which will be then referenced 
	#  by corresponding database records
	#
	#  Regarding rotation: later on it won't happen until after 
	#  pieces are collected by Backbone - it should be solely BB.js task to perform it  
	# def self.fragment_and_randomly_rotate title
	# 	Dir.chdir("/home/ninok/projects/puzzle/app/assets/images/")
	# 	image = Magick::Image::read(title).first
	# 	# p width = image.columns
	# 	# p height = image.rows
	# 	pieces_collection = []
	# 	metadata = {}
	# 	degrees = [-90, 0, 90, 180, 0]
	# 	y_step = [0, 150, 300, 450, 600, 750, 900] 
	# 	number_of_x_cuts = 13
	# 	metadata['width'] = number_of_x_cuts
	# 	metadata['height'] = y_step.size
	# 	pieces_collection << metadata

	# 	y_step.each do |start_y|
	# 		iteration = 0
	# 		start_x = 0

	# 		until iteration == number_of_x_cuts
	# 			cropped_image = image.crop(start_x, start_y, 150, 150, true)
	# 			file_name = "piece#{start_y}_#{iteration}.jpg"
	# 			cropped_image.rotate!(degrees[rand(5)])
	# 			 .write(file_name)

	# 			piece = {} 
	# 			piece["title"] = file_name
	# 			pieces_collection << piece

	# 			start_x = start_x + 150
	# 			iteration = iteration + 1
	# 		end
	# 	end
	# 	pieces_collection
	# end
end
