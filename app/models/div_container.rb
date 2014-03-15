require 'couchrest_model'

# TODO: Move this model to REDIS if appropriate.
class DivContainer < CouchRest::Model::Base
	extend CouchSeed

	property :offset_left, String
	property :offset_top,  String
	property :created_at,  String, default: Time.now.strftime('%d-%m-%Y,%l:%M %p')

	design do
		view :divs,
			map:
				"function(doc) {
					if(doc['type'] == 'DivContainer' && doc.offset_left && doc.offset_top) {
						emit(doc.offset_left, doc.offset_top);
					}
				}"
	end

	class << self
		def get_all_divs
			divs.rows.map do |row|
				row.delete_if {|key, value| key == "id" }
			end
		end

		def create_divs
			divs_list().map do |_,value|
 				create!(offset_left: value[0],offset_top: value[1])		
			end
  	end
	end
end
