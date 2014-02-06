class ImagenesController < ApplicationController
	respond_to :json

	def index
    respond_with Imagen.get_all
	end

  # TODO: Ideally, this action should be at a separate, isolated controller
  def create
    pieces = Piece.get_and_transform_set(params[:imagen_id])
    divs = DivContainer.get_and_transform_set(params[:imagen_id])
    State.create_record(session[:session_id], pieces, divs)
    render json: { pieces: pieces, divs: divs, location: "imagen" }
  end
end
