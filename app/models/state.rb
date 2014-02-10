class State
  class << self
    def create_record session, pieces, divs
      i = 0
      pieces.each do |piece|
        $redis.hmset("#{session}.pieces.#{i}", 
                     :title, piece[:title], 
                     :id, piece[:id], 
                     :deviation, piece[:deviation])  
        i = i + 1
      end
      $redis.set("#{session}.size", pieces.size)
      # This will be removed when keys and values added to piece and divs sending deprecated
      i = 0
      divs.each do |div|
        $redis.hmset("#{session}.divs.#{i}",
                  :key, div['key'],
                  :value, div['value'])
        i = i + 1  
      end
    end

    [:get_divs_for, :get_pieces_for].each do |method|
      define_method method do |session, index|
        number_of_items = $redis.get("#{session}.size").to_i 
        result_set = []

        number_of_items.times do |i|
          result_set << $redis.hgetall("#{session}.#{index}.#{i}")
        end

        result_set
      end
    end
  end
end
# require 'couchrest_model'

# # TODO: Move this model to REDIS if appropriate.
# class State < CouchRest::Model::Base
#   property :pieces, array: true
#   property :divs, array: true
#   property :created_at,  String, default: Time.now.strftime('%d-%m-%Y,%l:%M %p')

#   design do
#     view :states,
#       map:
#         "function(doc) {
#           if(doc['type'] == 'State' && doc.pieces && doc.divs) {
#             emit(doc.pieces, doc.divs);
#           }
#         }"
#   end

#   class << self
#     def create_record session, pieces, divs
#      p create!( id: session, pieces: pieces, divs: divs)
#     end

#     [:get_divs_for, :get_pieces_for].each do |method|
#       define_method method do |session, index|
#         states.rows.map! { |row| row.send index if row.id == session }.compact[0]      
#       end
#     end
#   end
# end
