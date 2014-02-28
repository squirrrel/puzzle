class SessionsController < ApplicationController
  respond_to :json

  def index
    respond_with Session.get_pieces_for(session[:session_id])
  end

  def destroy
    puts Session.destroy_record(session[:session_id])
    render json: []
  end

  def update
    if params[:matched]
      Session.update_match(session[:session_id], params[:id])
      render json: {}
    elsif params[:offset] 
      Session.update_offset(session[:session_id], 
                          params[:id], 
                          params[:offset])
      render json: {}
    else
      current_deviation = Session.update_deviation(session[:session_id], 
                                                 params[:id])
      render json: { current_deviation: current_deviation, location: 'piece' }
    end
  end

  def create
    pieces = Piece.get_and_transform_set(params[:imagen_id])
    Session.create_record(session[:session_id], pieces)
    render json: { pieces: pieces, location: 'imagen' }
  end
end
