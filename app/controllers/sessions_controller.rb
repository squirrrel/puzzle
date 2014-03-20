class SessionsController < ApplicationController
  respond_to :json

  def index
    p '--------------------'
    p session[:session_id]
    respond_with Session.get_pieces_for(session[:session_id],
                                        request.remote_ip)
  end

  def destroy
    #p $redis.keys('*')
    Session.destroy_record(session[:session_id],
                           request.remote_ip)
    #Session.garbage_collect(session[:session_id],
     #                       request.remote_ip)
    render json: []
  end

  def update
    returned_value = Session.update_record(params,
                                           session[:session_id],
                                           request.remote_ip)

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
    p '--------------------'
    p session[:session_id]
    Session.destroy_current_puzzle_if_any(nil, request.remote_ip)
    Session.create_image_reference(session[:session_id],
                                   params[:imagen_id],
                                   request.remote_ip)

    pieces = Piece.get_and_transform_set(params[:imagen_id])
    Session.create_puzzle(session[:session_id], pieces,
                          request.remote_ip)
    render json: { pieces: pieces, location: 'imagen' }
  end
end
