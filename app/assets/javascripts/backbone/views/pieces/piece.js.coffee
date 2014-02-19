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
    .attr('alt',"#{@piece.order}")
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
   piece = new Puzzle.Models.Piece(id: $(@el).attr('id'))

   piece.save(piece, { 
    silent: true, 
    wait: true, 
    success: @reflect_rotation, 
    error: @get_error 
   })

  reflect_rotation: (model, response) =>
   $(@el).css('-webkit-transform',"rotate(#{response.current_deviation}deg)")
    .css('transform',"rotate(#{response.current_deviation}deg)")
    .css('-moz-transform', "rotate(#{response.current_deviation}deg)")
   if $(@el).hasClass('ids_matched') is true && response.current_deviation is 360
    console.log 'matched'
   else
    console.log 'unmatched'

  get_error: (model, response) =>
   console.log response

  dragInit: (event, dragdrop) =>

  dragStart: (event, dragdrop) =>
   $(@el).css('cursor', 'move')
   false if !$(dragdrop.target).is('.handle')
   $(@el).css('opacity', .5).clone().insertAfter(@el)
  
  dragPiece: (event, dragdrop) =>
   $(dragdrop.proxy).css('z-index', '10')
    .css({ top: dragdrop.offsetY, left: dragdrop.offsetX })
  
  dragEnd: (event, dragdrop) =>
   $(@el).css('cursor', 'pointer')
   $(dragdrop.proxy).remove()
   matched_cells_container = new Array
   matched_cell_pieces_container = new Array
   matched_pieces_container = new Array

   $('.cell').each(()->
    delta_x = dragdrop.offsetX - $(@).offset().left
    delta_y = dragdrop.offsetY - $(@).offset().top
    if delta_x >= -20 && delta_x <= 20 && delta_y >= -20 && delta_y <= 20
     matched_cells_container.push(left_x: $(@).offset().left, top_y: $(@).offset().top, id: $(@).attr('id'))
    else
     true
    )

   w_percentage = 3*$(window).width()/100
   h_percentage = 6*$(window).height()/100
   end_point =
    if matched_cells_container.length is 0
     $('.piece-of-puzzle').each(()->
      if $(@).attr('id') isnt $(dragdrop.target).attr('id')
       if $(@).offset().left >= dragdrop.offsetX - 39 && $(@).offset().left <= dragdrop.offsetX + 39 &&
          $(@).offset().top >= dragdrop.offsetY - 39 && $(@).offset().top <= dragdrop.offsetY + 39
        matched_pieces_container.push('overlapped')
       else
        true
      else
       true
     )

     if dragdrop.offsetY < 0 || 
        dragdrop.offsetY > $(window).height() - h_percentage || 
        dragdrop.offsetX < 0 || 
        dragdrop.offsetX > $(window).width() - w_percentage ||
        matched_pieces_container.length is 1
      top_y: dragdrop.originalY, left_x: dragdrop.originalX
     else
      top_y: dragdrop.offsetY, left_x: dragdrop.offsetX
    else
     $('.piece-of-puzzle').each(()->
      if $(@).offset().left is matched_cells_container[0].left_x && 
         $(@).offset().top is matched_cells_container[0].top_y
       matched_cell_pieces_container.push('overlapped')
      else
       true
     )
     if matched_cell_pieces_container.length is 1 || matched_pieces_container is 1
      top_y: dragdrop.originalY, left_x: dragdrop.originalX
     else
      top_y: matched_cells_container[0].top_y, left_x: matched_cells_container[0].left_x

   $(@el).animate({ 
    top: end_point.top_y, 
    left: end_point.left_x, opacity: 1 
   })

   piece = new Puzzle.Models.Piece(
    id: $(@el).attr('id'), 
    offset: { x: end_point.left_x, y: end_point.top_y }
   )
   piece.save(piece, { silent: true, wait: true })
   console.log matched_cells_container.length
   if matched_cells_container.length is 1 && 
      $(dragdrop.target).attr('alt') is matched_cells_container[0].id &&
      ($(dragdrop.target).attr('style').match(/\(360deg\)/) || 
      $(dragdrop.target).attr('style').match(/\(0deg\)/))
    $(dragdrop.target).addClass('ids_matched')
    console.log 'matched'
   else if matched_cells_container.length is 1 && $(dragdrop.target).attr('alt') is matched_cells_container[0].id
    $(dragdrop.target).addClass('ids_matched')
   else 
    true
