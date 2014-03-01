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
					if(doc['type'] == 'Imagen' && doc.title && doc.category && doc.subcategory) {
						emit(doc.title, [doc.category, doc.subcategory]);
					}
				}"
	end

  class << self
		def get_all
			imagenes.rows.map! do |row|
				imagen = {}
				imagen[:id] = row.id
				imagen[:title] = row.key
				imagen[:category] = row.value[0]
				imagen[:subcategory] = row.value[1] unless row.value[1] == 'none' 

				imagen
			end
		end

		# Add the subcategory information to the result in order to sort by subcategory also????
		def get_categories
		 	categories = by_category.reduce.group_level(1).rows
			categories.map!{ |category| { category: category['key'] } }			
		end
	end

	private
	# EXPLAIN: The method iterates through hashes, and based on their key-value pairs,
	#  creates corresponding Imagen objects in the DB
	# def self.create_imagenes
	# 	[ 
	# 		{ title: 'geisha_fragments_2.jpg', category: 'Art', subcategory: 'Japanese_classic_art'},
	# 		{ title: 'japanese_blava_nature.jpg', category: 'Art', subcategory: 'Japanese_classic_art'},
	# 		{ title: 'portrait-scenes-with-parasol-and-on-horseback.jpg', category: 'Art', subcategory: 'Japanese_classic_art'},
	# 		{ title: 'two-geishas.jpg', category: 'Art', subcategory: 'Japanese_classic_art'},
	# 		{ title: 'on-the-banks-of-the-river-sumida-in-mimayagashi.jpg', category: 'Art', subcategory: 'Japanese_classic_art'},
	# 		{ title: 'japanese_fight.jpg', category: 'Art', subcategory: 'Japanese_classic_art'},
	# 		{ title: 'japanese_war_fire.jpg', category: 'Art', subcategory: 'Japanese_classic_art'},
	# 		{ title: 'japanese_winter_fight.jpg', category: 'Art', subcategory: 'Japanese_classic_art'},
	# 		{ title: 'geisha-girls-walking-and-performing-calligraphy.jpg', category: 'Art', subcategory: 'Japanese_classic_art'},
	# 		{ title: 'geisha_1.jpg', category: 'Art', subcategory: 'Japanese_classic_art'},
	# 		{ title: 'geisha_2.jpg', category: 'Art', subcategory: 'Japanese_classic_art'},
	# 		{ title: 'geisha_3.jpg', category: 'Art', subcategory: 'Japanese_classic_art'},
	# 		{ title: 'geisha_4.jpg', category: 'Art', subcategory: 'Japanese_classic_art'},

	# 		{ title: 'klimt_tree.jpg', category: 'Art', subcategory: 'Picasso_Dalli_Klimt'},
	# 		{ title: 'las_meninas_black_and_white.jpg', category: 'Art', subcategory: 'Picasso_Dalli_Klimt'},
	# 		{ title: 'las_meninas_colored.jpg', category: 'Art', subcategory: 'Picasso_Dalli_Klimt'},
	# 		{ title: 'the-melting-watch.jpg', category: 'Art', subcategory: 'Picasso_Dalli_Klimt'},

	# 		{ title: 'antique_car.jpg', category: 'Cars'},
	# 		{ title: 'awesome_black.jpg', category: 'Cars'},
	# 		{ title: 'bordo_car.jpg', category: 'Cars'},
	# 		{ title: 'classic_blue.jpg', category: 'Cars'},
	# 		{ title: 'classic_red_car.jpg', category: 'Cars'},
	# 		{ title: 'mustang_yellow.jpg', category: 'Cars'},
	# 		{ title: 'old_darkblue.jpg', category: 'Cars'},
	# 		{ title: 'old-volkswagen.jpg', category: 'Cars'},
	# 		{ title: 'old_white_with_black_roof.jpg', category: 'Cars'},
	# 		{ title: 'old_yellow_car.jpg', category: 'Cars'},
	# 		{ title: 'red_jaguar.jpg', category: 'Cars'},
	# 		{ title: 'volkswagen_black.jpg', category: 'Cars'},
	# 		{ title: 'volkswagen-bug-yellow.jpg', category: 'Cars'},
	# 		{ title: 'volkswagen_bug_blue.jpg', category: 'Cars'},
	# 		{ title: 'volkswagen_truck_grey.jpg', category: 'Cars'},
	# 		{ title: 'zhygul_yellow.jpg', category: 'Cars'},

	# 		{ title: 'iceage_1.jpg', category: 'Cartoons', subcategory: 'Ice age'},
	# 		{ title: 'iceage_2.jpg', category: 'Cartoons', subcategory: 'Ice age'},
	# 		{ title: 'iceage_3.jpg', category: 'Cartoons', subcategory: 'Ice age'},
	# 		{ title: 'iceage_4.jpg', category: 'Cartoons', subcategory: 'Ice age'},
	# 		{ title: 'iceage_5.jpg', category: 'Cartoons', subcategory: 'Ice age'},
	# 		{ title: 'iceage_6.jpg', category: 'Cartoons', subcategory: 'Ice age'},

	# 		{ title: 'panda_1.jpg', category: 'Cartoons', subcategory: 'Panda'},
	# 		{ title: 'panda_2.jpg', category: 'Cartoons', subcategory: 'Panda'},
	# 		{ title: 'panda_3.jpg', category: 'Cartoons', subcategory: 'Panda'},
	# 		{ title: 'panda_4.jpg', category: 'Cartoons', subcategory: 'Panda'},
	# 		{ title: 'panda_5.jpg', category: 'Cartoons', subcategory: 'Panda'},
	# 		{ title: 'panda_6.jpg', category: 'Cartoons', subcategory: 'Panda'},
	# 		{ title: 'panda_7.jpg', category: 'Cartoons', subcategory: 'Panda'},
	# 		{ title: 'panda_8.jpg', category: 'Cartoons', subcategory: 'Panda'},
	# 		{ title: 'panda_9.jpg', category: 'Cartoons', subcategory: 'Panda'},

	# 		{ title: 'shrek_1.jpg', category: 'Cartoons', subcategory: 'Shrek'},
	# 		{ title: 'shrek_2.jpg', category: 'Cartoons', subcategory: 'Shrek'},
	# 		{ title: 'shrek_3.jpg', category: 'Cartoons', subcategory: 'Shrek'},
	# 		{ title: 'shrek_4.png', category: 'Cartoons', subcategory: 'Shrek'},
	# 		{ title: 'shrek_5.jpg', category: 'Cartoons', subcategory: 'Shrek'},
	# 		{ title: 'shrek_6.jpg', category: 'Cartoons', subcategory: 'Shrek'},

	# 		{ title: 'wallie_1.jpg', category: 'Cartoons', subcategory: 'Wallie'},
	# 		{ title: 'wallie_2.jpg', category: 'Cartoons', subcategory: 'Wallie'},
	# 		{ title: 'wallie_3.jpg', category: 'Cartoons', subcategory: 'Wallie'},
	# 		{ title: 'wallie_4.jpg', category: 'Cartoons', subcategory: 'Wallie'},
	# 		{ title: 'wallie_5.jpg', category: 'Cartoons', subcategory: 'Wallie'},

	# 		{ title: 'cat_1.jpg', category: 'Cats'},
	# 		{ title: 'cat_2.jpeg', category: 'Cats'},
	# 		{ title: 'cat_3.jpg', category: 'Cats'},
	# 		{ title: 'cat_4.jpg', category: 'Cats'},
	# 		{ title: 'cat_5.jpg', category: 'Cats'},
	# 		{ title: 'cat_6.jpg', category: 'Cats'},
	# 		{ title: 'cat_7.jpg', category: 'Cats'},
	# 		{ title: 'cat_8.jpg', category: 'Cats'},
	# 		{ title: 'cat_9.jpg', category: 'Cats'},

	# 		{ title: 'cp_1.jpg', category: 'Christmas postcards'},
	# 		{ title: 'cp_2.jpg', category: 'Christmas postcards'},
	# 		{ title: 'cp_3.jpg', category: 'Christmas postcards'},
	# 		{ title: 'cp_4.jpg', category: 'Christmas postcards'},
	# 		{ title: 'cp_5.jpg', category: 'Christmas postcards'},
	# 		{ title: 'cp_6.jpg', category: 'Christmas postcards'},
	# 		{ title: 'cp_7.jpg', category: 'Christmas postcards'},
	# 		{ title: 'cp_8.jpg', category: 'Christmas postcards'},
	# 		{ title: 'cp_9.jpg', category: 'Christmas postcards'},
	# 		{ title: 'cp_10.jpg', category: 'Christmas postcards'},
	# 		{ title: 'cp_11.jpg', category: 'Christmas postcards'},
	# 		{ title: 'cp_12.jpg', category: 'Christmas postcards'},
	# 		{ title: 'cp_13.jpg', category: 'Christmas postcards'},
	# 		{ title: 'cp_14.jpg', category: 'Christmas postcards'},

	# 		{ title: 'amsterdam_grey.jpg', category: 'Cultures'},
	# 		{ title: 'amsterdam_light.jpg', category: 'Cultures'},
	# 		{ title: 'aztec_1.jpg', category: 'Cultures'},
	# 		{ title: 'aztec_2.png', category: 'Cultures'},
	# 		{ title: 'bali.jpg', category: 'Cultures'},
	# 		{ title: 'joyful_amsterdam.jpg', category: 'Cultures'},
	# 		{ title: 'london.jpg', category: 'Cultures'},
	# 		{ title: 'machu_picchu_1.jpg', category: 'Cultures'},
	# 		{ title: 'machu_picchu_2.jpg', category: 'Cultures'},
	# 		{ title: 'old_venice.jpg', category: 'Cultures'},
	# 		{ title: 'paris.jpg', category: 'Cultures'},
	# 		{ title: 'venice.jpg', category: 'Cultures'},
	# 		{ title: 'venice_boats.jpg', category: 'Cultures'},
	# 		{ title: 'venice_bridge.jpg', category: 'Cultures'},

	# 		{ title: 'anime_city_girls.jpg', category: 'Japan'},
	# 		{ title: 'anime-cute-girl.jpg', category: 'Japan'},
	# 		{ title: 'anime-headphones-bird-bridge-anime.jpg', category: 'Japan'},
	# 		{ title: 'anime-paint-school-of-art-anime-and-fantasy.jpg', category: 'Japan'},
	# 		{ title: 'cartoon-city.jpg', category: 'Japan'},
	# 		{ title: 'christmas-new-year-anime.jpg', category: 'Japan'},
	# 		{ title: 'city-forest.jpg', category: 'Japan'},
	# 		{ title: 'dolina_dvorec_gory_tuman.jpg', category: 'Japan'},
	# 		{ title: 'fantasy-city.jpg', category: 'Japan'},
	# 		{ title: 'long-hair-girl-sakura.jpg', category: 'Japan'},
	# 		{ title: 'lying-elegant-tattoo-girl.jpg', category: 'Japan'},
	# 		{ title: 'samurai_girl.jpg', category: 'Japan'},
	# 		{ title: 'town-street.jpg', category: 'Japan'},
	# 		{ title: 'violinist_girl.jpg', category: 'Japan'},
	# 		{ title: 'women-dress-flowers.jpg', category: 'Japan'},

	# 		{ title: 'berlin_books.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'copengagen_bicycle_alley.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'creepy_modern.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'fachada casa batllo.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'germany_bright_building.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'light_modern.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'mirror_modern.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'museum_modern.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'parc_guell_2.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'parc_guell_4.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'parc_guell_5.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'parc_guell_3.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'parc_guell_1.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'prague_building.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'rectangle_modern.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'sagrada_familia.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'waves_modern.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'wien_1.jpg', category: 'Modern arquitecture'},
	# 		{ title: 'wien_2.jpg', category: 'Modern arquitecture'},

	# 		{ title: 'skier_1.jpg', category: 'Skiing'},
	# 		{ title: 'skier_2.jpg', category: 'Skiing'},
	# 		{ title: 'skier_3.jpg', category: 'Skiing'},
	# 		{ title: 'skiers.jpg', category: 'Skiing'},
	# 		{ title: 'skiing_resort.jpg', category: 'Skiing'},

	# 		{ title: 'newyork_1.jpg', category: 'Postcards'},
	# 		{ title: 'newyork_2.jpg', category: 'Postcards'},
	# 		{ title: 'newyork_3.jpg', category: 'Postcards'},
	# 		{ title: 'newyork_4.jpg', category: 'Postcards'},
	# 		{ title: 'newyork_5.jpg', category: 'Postcards'},
	# 		{ title: 'village_cartoon_field.jpg', category: 'Postcards'},

	# 		{ title: 'avatar_1.jpg', category: 'Movies', subcategory: 'Avatar'},
	# 		{ title: 'avatar_2.jpg', category: 'Movies', subcategory: 'Avatar'},
	# 		{ title: 'avatar_3.jpg', category: 'Movies', subcategory: 'Avatar'},
	# 		{ title: 'avatar_4.jpg', category: 'Movies', subcategory: 'Avatar'},
	# 		{ title: 'avatar_5.jpg', category: 'Movies', subcategory: 'Avatar'},
	# 		{ title: 'avatar_6.jpg', category: 'Movies', subcategory: 'Avatar'},
	# 		{ title: 'avatar_7.jpg', category: 'Movies', subcategory: 'Avatar'},
	# 		{ title: 'avatar_8.jpg', category: 'Movies', subcategory: 'Avatar'},
	# 		{ title: 'avatar_9.jpg', category: 'Movies', subcategory: 'Avatar'},
	# 		{ title: 'avatar_10.jpg', category: 'Movies', subcategory: 'Avatar'},
	# 		{ title: 'avatar_11.jpg', category: 'Movies', subcategory: 'Avatar'},

	# 		{ title: 'lord_1.jpg', category: 'Movies', subcategory: 'Lord of the rings'},
	# 		{ title: 'lord_2.jpg', category: 'Movies', subcategory: 'Lord of the rings'},
	# 		{ title: 'lord_3.jpg', category: 'Movies', subcategory: 'Lord of the rings'},
	# 		{ title: 'lord_4.jpg', category: 'Movies', subcategory: 'Lord of the rings'},
	# 		{ title: 'lord_5.jpg', category: 'Movies', subcategory: 'Lord of the rings'},

	# 		{ title: 'hungergames_1.jpg', category: 'Movies', subcategory: 'The hunger games'},
	# 		{ title: 'hungergames_2.jpg', category: 'Movies', subcategory: 'The hunger games'},
	# 		{ title: 'hungergames_3.jpg', category: 'Movies', subcategory: 'The hunger games'},
	# 		{ title: 'hungergames_4.jpg', category: 'Movies', subcategory: 'The hunger games'},
	# 		{ title: 'hungergames_5.jpg', category: 'Movies', subcategory: 'The hunger games'},
	# 		{ title: 'hungergames_6.jpg', category: 'Movies', subcategory: 'The hunger games'},
	# 		{ title: 'hungergames_7.jpg', category: 'Movies', subcategory: 'The hunger games'},
	# 		{ title: 'hungergames_8.jpg', category: 'Movies', subcategory: 'The hunger games'},
	# 		{ title: 'hungergames_9.jpg', category: 'Movies', subcategory: 'The hunger games'},
	# 		{ title: 'hungergames_10.jpg', category: 'Movies', subcategory: 'The hunger games'},
	# 		{ title: 'hungergames_11.jpg', category: 'Movies', subcategory: 'The hunger games'}
	# 	].map do |image|
	# 		new_record = 
	# 			if image[:subcategory]
 # 					{title: image[:title],
 # 				 	 category: image[:category],
 # 				 	 subcategory: image[:subcategory]}		
	# 			else
 # 					{title: image[:title],
 # 					 category: image[:category]}
	#  	  	end
	#  	  create!(new_record)
	#  	end
	#end

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
