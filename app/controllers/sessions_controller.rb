class SessionsController < ApplicationController
  respond_to :json

  def index
    p '--------------------'
    p session[:session_id]
    respond_with Session.get_pieces_for(session[:session_id])
  end

  def destroy
    Session.destroy_record(session[:session_id])
    render json: []
  end

  def update
    if params[:restore_current]
      Session.show_current_puzzle(session[:session_id])
      render json: {}

    elsif params[:hidden]
      Session.hide_current_puzzle(session[:session_id])
      render json: {}

    elsif params[:matched]
      Session.update_match(session[:session_id], 
                           params[:id], 
                           params[:matched])
      render json: {}

    elsif params[:marked] && params[:top] && params[:left]
      Session.update_marks(session[:session_id], 
                           params[:id], 
                           params[:marked],
                           params[:top],
                           params[:left])
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
    p '--------------------'
    p session[:session_id]
    Session.destroy_current_puzzle_if_any()
    Session.create_image_reference(session[:session_id], params[:imagen_id])

    pieces = Piece.get_and_transform_set(params[:imagen_id])
    Session.create_puzzle(session[:session_id], pieces)
    render json: { pieces: pieces, location: 'imagen' }
  end
end
