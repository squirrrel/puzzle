class DivContainersController < ApplicationController
		respond_to :json

  # Rename State to Session?
	def index
    respond_with State.get_divs_for(session[:session_id], :value)
	end
end
