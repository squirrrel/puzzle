class PiecesController < ApplicationController
  respond_to :json

  def index
    respond_with State.get_pieces_for(session[:session_id], 'pieces')
  end
end
