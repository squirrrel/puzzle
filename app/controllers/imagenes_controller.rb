class ImagenesController < ApplicationController
  respond_to :json

  def index
    respond_with Imagen.get_all()
  end
end
