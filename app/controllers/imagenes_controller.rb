class ImagenesController < ApplicationController
  respond_to :json

  def index
    #$redis.flushdb
    respond_with Imagen.get_all
    #p $redis.keys('*')
  end
end
