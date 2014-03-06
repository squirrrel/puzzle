class Session
  class << self
    def create_puzzle session, pieces
      pieces.each do |piece|
        $redis.hmset("#{session}.pieces.#{piece[:id]}", 
                     :title, piece[:title], 
                     :id, piece[:id], 
                     :deviation, piece[:deviation],
                     :x, piece[:key],
                     :y, piece[:value],
                     :order, piece[:order])
        $redis.sadd("#{session}.ids", piece[:id])
      end
    end

    def create_image_reference session, image_id
      p "#{session}.image_reference"
      $redis.hset("#{session}.image_reference", :image_id, image_id)
    end

    def get_image_reference session
      image_id = $redis.hget("#{session}.image_reference", :image_id)
      [{ image_id: image_id }] if image_id
    end

    def get_pieces_for session
      result_set = []
      item_ids = $redis.smembers("#{session}.ids") 

      if item_ids
        item_ids.each do |id|
          result_set << $redis.hgetall("#{session}.pieces.#{id}")
        end
      else
        []
      end

      result_set
    end

    def update_deviation session, id
      initial_deviation = $redis.hget("#{session}.pieces.#{id}", :deviation).to_i
      initial_deviation = initial_deviation == 360 ? 0 : initial_deviation
      current_deviation = initial_deviation + 90
      $redis.hset("#{session}.pieces.#{id}", :deviation, current_deviation)
      current_deviation
    end

    def update_offset session, id, offset
      $redis.hmset("#{session}.pieces.#{id}", 
                   :x, offset[:x], 
                   :y, offset[:y])       
    end

    def update_match session, id, match_info
      $redis.hset("#{session}.pieces.#{id}", :matched, match_info)      
    end

    def update_marks session, id, mark_info, top, left
      $redis.hmset("#{session}.pieces.#{id}", 
                   :marked, mark_info, 
                   :top, top, :left, left)      
    end

    def destroy_record session
      item_ids = $redis.smembers("#{session}.ids")
      item_ids.each do |id|
        $redis.del("#{session}.pieces.#{id}")
      end
      $redis.del("#{session}.ids")
      #$redis.del("#{session}.image_reference")
    end
    # TODO: refactor, for they are pretty similar
    def hide_current_puzzle session
      item_ids = $redis.smembers("#{session}.ids")
      item_ids.each do |id|
        $redis.rename("#{session}.pieces.#{id}", "hidden.pieces.#{id}")
      end
        $redis.rename("#{session}.ids", "hidden.ids")     
    end

    def show_current_puzzle session
      item_ids = $redis.smembers("hidden.ids")
      item_ids.each do |id|
        $redis.rename("hidden.pieces.#{id}", "#{session}.pieces.#{id}")
      end
      $redis.rename("hidden.ids", "#{session}.ids") 
    end

    def destroy_current_puzzle_if_any
      item_ids = $redis.smembers("hidden.ids")
      true unless item_ids
      item_ids.each do |id|
        $redis.del("hidden.pieces.#{id}")
      end
      $redis.del("hidden.ids")
    end
  end
end
