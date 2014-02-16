Puzzle.Views.Pieces ||= {}

class Puzzle.Views.Pieces.Piece extends Backbone.View
  tagName: "img"

  initialize: () ->
   $(@el).bind('click', @rotatePieceOnClick)
    .bind('draginit', @dragInit)
    .bind('dragstart', @dragStart)
    .bind('drag', @dragPiece)
    .bind('dragend', @dragEnd)
   @piece = @options.piece.toJSON() 

  render: =>
   $(@el).attr('id', @piece.id)
    .attr('class', 'piece-of-puzzle')
    .attr('src', "/assets/#{@piece.title}")
    .attr('height', '40')
    .attr('width', '40')
    .css('transform', "rotate(#{@piece.deviation}deg)")
    .css('-webkit-transform', "rotate(#{@piece.deviation}deg)")
    .css('-moz-transform', "rotate(#{@piece.deviation}deg)")
    .css('position', "absolute")
    .css('left', "#{@piece.x}px")
    .css('top', "#{@piece.y}px")
   return this

  rotatePieceOnClick: (event) =>
   piece = new Puzzle.Models.Piece(piece_id: $(@el).attr('id'))

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

  dragStart: (event, dragdrop) =>
   $(@el).css('cursor', 'move')
   false if !$(dragdrop.target).is('.handle')
   $(@el).css('opacity', .5).clone().insertAfter(@el)
  
  dragPiece: (event, dragdrop) =>
   $(dragdrop.proxy).css({ top: dragdrop.offsetY, left: dragdrop.offsetX })
  
  dragEnd: (event, dragdrop) =>
   console.log $(window).width()
   $(@el).css('cursor', 'default')
   $(dragdrop.proxy).remove()
   container = new Array

   $('.cell').each(()->
    delta_x = dragdrop.offsetX - $(@).offset().left
    delta_y = dragdrop.offsetY - $(@).offset().top
    if delta_x >= -20 && delta_x <= 20 && delta_y >= -20 && delta_y <= 20
     container.push(left_x: $(@).offset().left, top_y: $(@).offset().top)
    else
     true
    )

   end_point = 
    if container.length is 0
     if dragdrop.offsetY < 0 || dragdrop.offsetY > $(window).height() || dragdrop.offsetX < 0 || dragdrop.offsetX > $(window).width()
      top_y: dragdrop.originalY, left_x: dragdrop.originalX
     else
      top_y: dragdrop.offsetY, left_x: dragdrop.offsetX
    else
     top_y: container[0].top_y, left_x: container[0].left_x

   $(@el).animate({ 
    top: end_point.top_y, 
    left: end_point.left_x, opacity: 1 
   })

   piece = new Puzzle.Models.Piece(
    piece_id: $(@el).attr('id'), 
    offset: { x: end_point.left_x, y: end_point.top_y }
   )

   @options.piece.save(piece, { silent: true, wait: true })