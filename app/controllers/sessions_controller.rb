class SessionsController < ApplicationController
  respond_to :json

  def index
    respond_with Session.get_pieces()
  end

  def destroy
    Session.destroy_record()
    Session.garbage_collect()
    render json: []
  end

  def update
    returned_value = Session.update_record(params)

    response = 
      if params[:deviated]
        {current_deviation: returned_value,
         location: 'piece'}
      else
        {}
      end
    
    render json: response
  end

  def create
    Session.remote_ip = request.remote_ip
    Session.session = session[:session_id]

    Session.destroy_current_puzzle_if_any()
    Session.create_image_reference(params[:imagen_id])

    pieces = Piece.get_and_transform_set(params[:imagen_id])
    Session.create_puzzle(pieces)
    render json: { pieces: pieces, location: 'imagen' }
  end
end
