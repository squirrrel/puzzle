require 'couchrest_model'

# TODO: Move this model to REDIS if appropriate.
class State < CouchRest::Model::Base
  property :pieces, array: true
  property :divs, array: true
  property :created_at,  String, default: Time.now.strftime('%d-%m-%Y,%l:%M %p')

  design do
    view :states,
      map:
        "function(doc) {
          if(doc['type'] == 'State' && doc.pieces && doc.divs) {
            emit(doc.pieces, doc.divs);
          }
        }"
  end

  class << self
    def create_record session, pieces, divs
      create!( id: session, pieces: pieces, divs: divs)
    end

    [:get_divs_for, :get_pieces_for].each do |method|
      define_method method do |session, index|
        states.rows.map! { |row| row.send index if row.id == session }.compact      
      end
    end
  end
end
