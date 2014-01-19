class ImagenesController < ApplicationController
	respond_to :json

	def index
		respond_with Imagen.get_pieces_and_metadata
	end	
end
