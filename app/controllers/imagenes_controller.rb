class ImagenesController < ApplicationController
  respond_to :json

  def index
    respond_with Imagen.get_all
  end

  # TODO: Ideally, this action should be at a separate, isolated controller
  def create
    pieces = Piece.get_and_transform_set(params[:imagen_id])
    Session.create_record(session[:session_id], pieces)
    render json: { pieces: pieces, location: "imagen" }
  end
end
