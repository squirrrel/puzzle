class PiecesController < ApplicationController
  respond_to :json

  def index
    respond_with State.get_pieces_for(session[:session_id])
  end

  def update
    current_deviation = State.update_record(session[:session_id], params[:piece_id])
    render json: { current_deviation: current_deviation, 
                   id: params[:piece_id], location: "piece" }
  end
end
