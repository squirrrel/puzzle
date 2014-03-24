class Session
  class << self
    def session=(session_id)
      @@session = session_id
    end

    def session
      @@session ||= nil
    end

    def remote_ip=(remote_ip)
      @@remote_ip = remote_ip
    end

    def remote_ip
      @@remote_ip ||= nil
    end

    def create_puzzle pieces
      pieces.each do |piece|
        $redis.hmset("#{remote_ip}.#{session}.pieces.#{piece[:id]}",
                     :title, piece[:title],
                     :id, piece[:id], 
                     :deviation, piece[:deviation],
                     :x, piece[:key],
                     :y, piece[:value],
                     :order, piece[:order],
                     :imagen_id, piece[:imagen_id])

        $redis.sadd("#{remote_ip}.#{session}.ids", piece[:id])

        if piece[:apriori]
          $redis.hmset("#{remote_ip}.#{session}.pieces.#{piece[:id]}",
                       :matched, piece[:matched],
                       :apriori, piece[:apriori])
        end
      end
    end

    def get_pieces
      result_set = []
      item_ids = $redis.smembers("#{remote_ip}.#{session}.ids") 

      return result_set unless item_ids

      item_ids.each do |id|
        result_set << $redis.hgetall("#{remote_ip}.#{session}.pieces.#{id}")
      end
      result_set
    end

    def create_image_reference image_id
      $redis.hset("#{remote_ip}.#{session}.image_reference", :image_id, image_id)
    end

    # TODO: think if it can be refactored, the final row
    def get_image_reference
      image_id = $redis.hget("#{remote_ip}.#{session}.image_reference", :image_id)
      [{ image_id: image_id }] if image_id
    end

    def create_images_collection images
      images.each do |image|
        $redis.hmset("images_collection.#{image[:id]}",
                      :id, image[:id],
                      :title, image[:title],
                      :category, image[:category],
                      :width, image[:width],
                      :height, image[:height],
                      :columns, image[:columns])

        if image[:subcategory]
          $redis.hset("images_collection.#{image[:id]}", 
                       :subcategory, 
                       image[:subcategory])
        end
      end
    end

    def get_images_collection
      all_image_keys = $redis.keys("images_collection.*")

      return [] unless all_image_keys

      result_set = []

      all_image_keys.each do |key|
        result_set << $redis.hgetall(key).with_indifferent_access

      end

      result_set.sort_by { |hsh| hsh[:title] }
    end

    # delete only remote_ip.session.pieces.id/remote_ip.session.ids/remote_ip.session.image_reference
    #  that are different from the current remote_ip.session and are garbage in their nature
    #  AS A BACKGROUND JOB
    def garbage_collect
      $redis.keys("#{remote_ip}.*").each do |key|
        $redis.del(key) unless key =~ /#{session}/ || key =~ /hidden/
      end
    end

    def destroy_record
      destroy_current_puzzle_if_any()
      destroy_session_records_if_any()
    end

    # TODO: refactor, for they are pretty similar
    def destroy_session_records_if_any
      item_ids = $redis.smembers("#{remote_ip}.#{session}.ids")

      true unless item_ids
      
      item_ids.each do |id|
        $redis.del("#{remote_ip}.#{session}.pieces.#{id}")
      end
      
      $redis.del("#{remote_ip}.#{session}.ids")
      $redis.del("#{remote_ip}.#{session}.image_reference")
    end

    # delete hidden.ids/all hidden pieces: hidden.pieces.*
    def destroy_current_puzzle_if_any
      true if $redis.keys("#{remote_ip}.hidden.ids").empty?
      
      $redis.keys("#{remote_ip}.hidden.*").each do |key|
        $redis.del(key)
      end

      $redis.del("#{remote_ip}.#{session}.image_reference")
    end

    def update_record params
      if params[:restore_current]
        show_current_puzzle()

      elsif params[:hidden]
        hide_current_puzzle()

      elsif params[:matched]
        update_match(params[:id], params[:matched])

      elsif params[:marked] && params[:top] && params[:left]
        update_marks(params[:id],
                     params[:marked],
                     params[:top],
                     params[:left])

      elsif params[:offset]
        update_offset(params[:id], params[:offset])

      elsif params[:deviated]
        update_deviation(params[:id])
      end
    end

    private

    def update_deviation id
      initial_deviation = $redis.hget("#{remote_ip}.#{session}.pieces.#{id}",
                                      :deviation).to_i
      initial_deviation = initial_deviation == 360 ? 0 : initial_deviation

      current_deviation = initial_deviation + 90
      $redis.hset("#{remote_ip}.#{session}.pieces.#{id}",
                  :deviation, current_deviation)

      current_deviation
    end

    def update_offset id, offset
      $redis.hmset("#{remote_ip}.#{session}.pieces.#{id}",
                   :x, offset[:x],
                   :y, offset[:y])
    end

    def update_match id, match_info
      $redis.hset("#{remote_ip}.#{session}.pieces.#{id}", :matched, match_info)
    end

    def update_marks id, mark_info, top, left
      $redis.hmset("#{remote_ip}.#{session}.pieces.#{id}",
                   :marked, mark_info, 
                   :top, top, :left, left)
    end

    def hide_current_puzzle
      item_ids = $redis.smembers("#{remote_ip}.#{session}.ids")
      
      item_ids.each do |id|
        $redis.rename("#{remote_ip}.#{session}.pieces.#{id}",
                      "#{remote_ip}.hidden.pieces.#{id}")
      end

      $redis.rename("#{remote_ip}.#{session}.ids",
                      "#{remote_ip}.hidden.ids")
    end

    def show_current_puzzle
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
