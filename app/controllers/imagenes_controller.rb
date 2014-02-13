class ImagenesController < ApplicationController
  respond_to :json

  def index
    respond_with Imagen.get_all
  end

  # TODO: Ideally, this action should be at a separate, isolated controller
  def create
    p session[:session_id]
    pieces = Piece.get_and_transform_set(params[:imagen_id])
    State.create_record(session[:session_id], pieces)
    render json: { pieces: pieces, location: "imagen" }
  end
end
