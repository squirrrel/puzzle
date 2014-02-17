class PiecesController < ApplicationController
  respond_to :json

  def index
    respond_with State.get_pieces_for(session[:session_id])
  end

  def update
    p '-------------'
    p params
    if params[:offset] 
      State.update_offset(session[:session_id], 
                          params[:id], 
                          params[:offset])
      render json: {}
    else
      current_deviation = State.update_deviation(session[:session_id], 
                                                 params[:id])

      render json: { current_deviation: current_deviation, location: 'piece' }
    end
  end
end
