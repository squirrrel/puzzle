# IT SHOULD BE PUT TO A JSON OR YAML FILE AND PARSED FROM HERE
# Try to extend only for a particular class
require 'json'

module CouchSeeds
  # module DivSeeds
  #   def divs_list
  #     json = File.read('db/divs_seeds.json')
  #     JSON.parse(json).with_indifferent_access[:divs]
  #   end
  # end

  # module ImageSeeds
  #   def images_list
  #     json = File.read('db/images_seeds.json')
  #     JSON.parse(json).with_indifferent_access[:images]
  #   end
  # end

  # module PieceSeeds
  #   def pieces_list
  #     json = File.read('db/pieces_seeds.json')
  #     JSON.parse(json).with_indifferent_access[:pieces]
  #   end
  # end
  ['divs', 'images', 'pieces'].each do |method|
    define_method "#{method}_list" do
      json = File.read("db/#{method}_seeds.json")
      JSON.parse(json).with_indifferent_access["#{method}"]
    end
  end
end