require 'couchrest_model'
require 'RMagick'
include Magick

class Piece < CouchRest::Model::Base
	property :title,      String
	property :imagen_id,  String
  property :deviation,  String
	property :created_at, String, default: Time.now.strftime('%d-%m-%Y,%l:%M %p')

	design do
		view :pieces,
			map:
				"function(doc) {
					if(doc['type'] == 'Piece' && doc.title && doc.imagen_id) {
						emit(doc.title, doc.imagen_id);
					}
				}"
	end

  class << self
    def get_and_transform_set id
      set = get_all_child_pieces(id).compact
      add_deviation_to set
			add_offset_to set, id       
      set.shuffle!
    end

    private

  	def get_all_child_pieces picture_id
  		pieces.rows.map! do |row|
  			piece = {} 
  			piece[:title] = row.key 
        piece[:id] = row.id
  			piece.with_indifferent_access if row.value == picture_id
  		end
  	end

    def add_offset_to set, id
    	divs = (DivContainer.send :get_all_divs).shuffle!
    	set.each do |piece|
				random_index = rand(divs.size)    		
    		piece.merge!(divs[random_index])
				divs.slice!(random_index)
    	end
    end

  	def add_deviation_to set
      degrees = [-90, 0, 90, 180, 0]
      set.each do |piece|
        deviation = piece[:deviation] = degrees[rand(5)] 
        get(piece[:id]).update_attributes(deviation: deviation)
      end

      set
    end
  end

	# EXPLAIN: The method creates set of piece records based on some predefined parameters
	# def self.create_pieces
	# 	{
	# 		"piece0_0.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece0_1.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece0_2.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece0_3.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece0_4.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece0_5.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece0_6.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece0_7.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece0_8.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece0_9.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece0_10.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece0_11.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece0_12.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece150_0.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece150_1.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece150_2.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece150_3.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece150_4.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece150_5.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece150_6.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece150_7.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece150_8.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece150_9.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece150_10.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece150_11.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece150_12.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece300_0.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece300_1.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece300_2.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece300_3.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece300_4.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece300_5.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece300_6.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece300_7.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece300_8.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece300_9.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece300_10.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece300_11.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece300_12.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece450_0.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece450_1.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece450_2.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece450_3.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece450_4.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece450_5.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece450_6.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece450_7.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece450_8.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece450_9.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece450_10.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece450_11.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece450_12.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece600_0.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece600_1.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece600_2.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece600_3.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece600_4.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece600_5.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece600_6.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece600_7.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece600_8.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece600_9.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece600_10.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece600_11.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece600_12.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece750_0.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece750_1.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece750_2.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece750_3.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece750_4.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece750_5.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece750_6.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece750_7.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece750_8.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece750_9.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece750_10.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece750_11.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece750_12.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece900_0.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece900_1.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece900_2.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece900_3.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece900_4.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece900_5.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece900_6.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece900_7.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece900_8.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece900_9.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece900_10.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece900_11.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86',
	# 		"piece900_12.jpg"=>'ba546f2e47d2a915c3ffff08503e5b86'
	# 	}
	# 	 .map do |ttl,id|
	# 		create!(title: ttl, imagen_id: id)
	# 	end
	# end
end	