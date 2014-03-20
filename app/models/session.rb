class Session
  class << self
    def create_puzzle session, pieces, remote_ip
      pieces.each do |piece|
        $redis.hmset("#{remote_ip}.#{session}.pieces.#{piece[:id]}", 
                     :title, piece[:title], 
                     :id, piece[:id], 
                     :deviation, piece[:deviation],
                     :x, piece[:key],
                     :y, piece[:value],
                     :order, piece[:order])
        $redis.sadd("#{remote_ip}.#{session}.ids", piece[:id])
      end
    end

    def get_pieces_for session, remote_ip
      result_set = []
      item_ids = $redis.smembers("#{remote_ip}.#{session}.ids") 

      return result_set unless item_ids

      item_ids.each do |id|
        result_set << $redis.hgetall("#{remote_ip}.#{session}.pieces.#{id}")
      end
      result_set
    end

    def create_image_reference session, image_id, remote_ip
      p "#{remote_ip}.#{session}.image_reference"
      $redis.hset("#{remote_ip}.#{session}.image_reference", :image_id, image_id)
    end

    # TODO: think if it can be refactored, the final row
    def get_image_reference session, remote_ip
      image_id = $redis.hget("#{remote_ip}.#{session}.image_reference", :image_id)
      [{ image_id: image_id }] if image_id
    end

    def garbage_collect session, remote_ip
     p $redis.keys("#{remote_ip}.*.pieces.*")
     p $redis.keys("#{remote_ip}.*.ids")
     p $redis.keys("#{remote_ip}.*.image_reference")
    end

    def destroy_record session, remote_ip
      destroy_current_puzzle_if_any(session, remote_ip)
      destroy_session_records_if_any(session, remote_ip)
    end

    # TODO: refactor, for they are pretty similar
    def destroy_session_records_if_any session, remote_ip
      item_ids = $redis.smembers("#{remote_ip}.#{session}.ids")

      true unless item_ids
      
      item_ids.each do |id|
        $redis.del("#{remote_ip}.#{session}.pieces.#{id}")
      end
      
      $redis.del("#{remote_ip}.#{session}.ids")
      $redis.del("#{remote_ip}.#{session}.image_reference")
    end

    def destroy_current_puzzle_if_any session, remote_ip
      hidden_item_ids = $redis.smembers("#{remote_ip}.hidden.ids")
      
      true unless hidden_item_ids
      
      hidden_item_ids.each do |id|
        $redis.del("#{remote_ip}.hidden.pieces.#{id}")
      end
      
      $redis.del("#{remote_ip}.hidden.ids")
      session ? ($redis.del("#{remote_ip}.#{session}.image_reference")) : true
    end

    def update_record params, session, remote_ip
      if params[:restore_current]
        show_current_puzzle(session, remote_ip)

      elsif params[:hidden]
        hide_current_puzzle(session, remote_ip)

      elsif params[:matched]
        update_match(session, params[:id], params[:matched], remote_ip)

      elsif params[:marked] && params[:top] && params[:left]
        update_marks(session, 
                     params[:id],
                     params[:marked],
                     params[:top],
                     params[:left],
                     remote_ip)

      elsif params[:offset]
        update_offset(session,
                      params[:id],
                      params[:offset],
                      remote_ip)

      elsif params[:deviated]
        update_deviation(session, params[:id], remote_ip)
      end
    end

    private

    def update_deviation session, id, remote_ip
      initial_deviation = $redis.hget("#{remote_ip}.#{session}.pieces.#{id}",
                                      :deviation).to_i
      initial_deviation = initial_deviation == 360 ? 0 : initial_deviation

      current_deviation = initial_deviation + 90
      $redis.hset("#{remote_ip}.#{session}.pieces.#{id}",
                  :deviation, current_deviation)

      current_deviation
    end

    def update_offset session, id, offset, remote_ip
      $redis.hmset("#{remote_ip}.#{session}.pieces.#{id}",
                   :x, offset[:x],
                   :y, offset[:y])
    end

    def update_match session, id, match_info, remote_ip
      $redis.hset("#{remote_ip}.#{session}.pieces.#{id}", :matched, match_info)
    end

    def update_marks session, id, mark_info, top, left, remote_ip
      $redis.hmset("#{remote_ip}.#{session}.pieces.#{id}",
                   :marked, mark_info, 
                   :top, top, :left, left)
    end

    def hide_current_puzzle session, remote_ip
      item_ids = $redis.smembers("#{remote_ip}.#{session}.ids")
      
      item_ids.each do |id|
        $redis.rename("#{remote_ip}.#{session}.pieces.#{id}",
                      "#{remote_ip}.hidden.pieces.#{id}")
      end

      $redis.rename("#{remote_ip}.#{session}.ids",
                      "#{remote_ip}.hidden.ids")
    end

    def show_current_puzzle session, remote_ip
      hidden_item_ids = $redis.smembers("#{remote_ip}.hidden.ids")
      
      hidden_item_ids.each do |id|
        $redis.rename("#{remote_ip}.hidden.pieces.#{id}", 
                      "#{remote_ip}.#{session}.pieces.#{id}")
      end

      $redis.rename("#{remote_ip}.hidden.ids", 
                    "#{remote_ip}.#{session}.ids") 
    end    
  end
end
