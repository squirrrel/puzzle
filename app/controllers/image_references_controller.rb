class ImageReferencesController < ApplicationController
  respond_to :json

  def index
    respond_with Session.get_image_reference(session[:session_id],
                                             request.remote_ip)
  end
end
