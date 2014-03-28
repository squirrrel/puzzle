class ImagenesController < ApplicationController
  respond_to :json

  def index
    respond_with Session.get_all_images()
  end
end
