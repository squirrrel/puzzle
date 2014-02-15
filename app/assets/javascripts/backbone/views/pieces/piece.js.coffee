Puzzle.Views.Pieces ||= {}

class Puzzle.Views.Pieces.Piece extends Backbone.View
  
  tagName: "img"

  initialize: () ->
   $(@el).bind('click', @rotatePieceOnClick)
   $(@el).bind('draginit', @dragInit)
   $(@el).bind('dragend', @dragEnd)
   @piece = @options.piece.toJSON() 

  render: =>
   $(@el).attr('id', @piece.id)
   $(@el).attr('class', 'piece-of-puzzle')
   $(@el).attr('src', "/assets/#{@piece.title}")
   $(@el).attr('height', '40')
   $(@el).attr('width', '40')
   $(@el).css('transform', "rotate(#{@piece.deviation}deg)")
   $(@el).css('-webkit-transform', "rotate(#{@piece.deviation}deg)")
   $(@el).css('-moz-transform', "rotate(#{@piece.deviation}deg)")
   $(@el).css('position', "absolute")
   $(@el).css('left', "#{@piece.x}px")
   $(@el).css('top', "#{@piece.y}px")
   return this

  rotatePieceOnClick: (event) =>
   img_id = event.currentTarget.id
   piece = new Puzzle.Models.Piece(piece_id: img_id)

   @options.piece.save(piece, { 
    silent: true, 
    wait: true, 
    success: @reflect_rotation, 
    error: @get_error 
   })

  reflect_rotation: (model, response) =>
   $("##{ response.id }")
    .css('-webkit-transform',"rotate(#{response.current_deviation}deg)")
    .css('transform',"rotate(#{response.current_deviation}deg)")
    .css('-moz-transform', "rotate(#{response.current_deviation}deg)")

  get_error: (model, response) =>
   console.log response

  dragInit: (event, dragdrop) =>
   console.log 'init'
   $(@el).css('cursor', 'move')
    .bind('drag', @dragPiece)

  dragStart: (event, dragdrop) =>
   console.log 'start'
   false if !$(event.target).is('.handle')
   target_id = event.currentTarget.id
   $("##{target_id}").css('opacity', .5).clone().insertAfter("##{target_id}")
  
  dragPiece: (event, dragdrop) =>
   console.log 'drag'
   $(@el).css({ top: dragdrop.offsetY, left: dragdrop.offsetX })
  
  dragEnd: (event, dragdrop) =>
   console.log 'end'
   $(@el).css('cursor', 'default')
   $(@el).unbind('drag')
   ### target_id = event.currentTarget.id
   $(dragdrop.proxy).remove()
   container = new Array

   $('.cell').each(()->
   delta_x = dragdrop.offsetX - $("##{target_id}").offset().left
   delta_y = dragdrop.offsetY - $("##{target_id}").offset().top
   if delta_x >= -30 && delta_x <= 30 && delta_y >= -30 && delta_y <= 30
    container.push(left_x: $("##{target_id}").offset().left, top_y: $("##{target_id}").offset().top)
   else
    true
   )

   end_point = 
    if container.length is 0
     top_y: dragdrop.offsetY, left_x: dragdrop.offsetX
    else
     top_y: container[0].top_y, left_x: container[0].left_x

   $("##{target_id}").css('cursor', 'default')
    .animate({ top: end_point.top_y, left: end_point.left_x, opacity: 1 }) ###
