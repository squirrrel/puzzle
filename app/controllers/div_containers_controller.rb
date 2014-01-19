class DivContainersController < ApplicationController
		respond_to :json

	def index
		respond_with DivContainer.get_all
	end	
end
