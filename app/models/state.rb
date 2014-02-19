class State
  class << self
    def create_record session, pieces
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

    def get_pieces_for session
      item_ids = $redis.smembers("#{session}.ids") 
      result_set = []

      item_ids.each do |id|
        result_set << $redis.hgetall("#{session}.pieces.#{id}")
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
      $redis.hmset("#{session}.pieces.#{id}", :x, offset[:x], :y, offset[:y])       
    end
  end
end
