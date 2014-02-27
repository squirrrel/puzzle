Puzzle.Views.Pieces ||= {}

class Puzzle.Views.Pieces.Piece extends Backbone.View
  tagName: "img"

  initialize: () ->
   @piece = @options.piece.toJSON()
   unless @piece.matched
    $(@el).bind('click', @rotatePieceOnClick)
     .bind('draginit', @dragInit)
     .bind('dragstart', @dragStart)
     .bind('drag', @dragPiece)
     .bind('dragend', @dragEnd)

  render: =>
   unless @options.pieces is 0
    $('body, html').css('overflow', 'hidden')
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
   if @piece.matched is 'matched'
    $(@el).addClass('matched')
   else if @piece.matched is 'half-matched'
    $(@el).addClass('half-matched')
   return this

  rotatePieceOnClick: (event) =>
   session = new Puzzle.Models.Session(id: $(@el).attr('id'))

   session.save(session, { 
    silent: true, 
    wait: true, 
    success: @reflect_rotation, 
    error: @get_error 
   })

  reflect_rotation: (model, response) =>
   ### Rotate piece ###
   $(@el).css('-webkit-transform',"rotate(#{response.current_deviation}deg)")
    .css('transform',"rotate(#{response.current_deviation}deg)")
    .css('-moz-transform', "rotate(#{response.current_deviation}deg)")

   ### Given the piece matched a corresponding cell ###
   if $(@el).hasClass('half-matched') is true && 
      response.current_deviation is 360   
    ### Unbind all handlers to freeze the piece ###
    $(@el).unbind('click')
     .unbind('draginit')
     .unbind('dragstart')
     .unbind('drag')
     .unbind('dragend')

    ### Modify piece's property accordingly and add the 'matched' class ###
    $(@el).removeClass('half-matched')
    $(@el).addClass('matched')
    $(@el).css('cursor', 'default')

    ### Save matched property to back-end ###
    session = new Puzzle.Models.Session(id: $(@el).attr('id'), matched: 'matched')
    session.save(session, { silent: true, wait: true })
    
    ### Verify if puzzle is solved and render the cover view if appropriate ###
    console.log $('.matched').length
    if $('.matched').length is @options.pieces.length
     console.log 'matched all'
     cover_view = new Puzzle.Views.Addons.Cover(pieces: @options.pieces)
     $('body').append(cover_view.render().el)

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
   ### Minor modifications ###
   $(@el).css('cursor', 'pointer')
   $(dragdrop.proxy).remove()

   ### Initialize containers ###
   matched_cells_container = new Array
   matched_cell_pieces_container = new Array
   matched_pieces_container = new Array

   ### Get auxiliary data for restricting 'drag-and-drop' zone ###
   w_percentage = 3*$(window).width()/100
   h_percentage = 6*$(window).height()/100

   ### Auxiliary data ###
   $('.cell').each(()->
    delta_x = dragdrop.offsetX - $(@).offset().left
    delta_y = dragdrop.offsetY - $(@).offset().top
    if delta_x >= -20 && delta_x <= 20 && delta_y >= -20 && delta_y <= 20
     matched_cells_container.push(
      left_x: $(@).offset().left, 
      top_y: $(@).offset().top, 
      id: $(@).attr('id')
     )
   )
   
   ### Auxiliary data ###
   $('.piece-of-puzzle').each(()->
    unless $(@).attr('id') is $(dragdrop.target).attr('id')
     if $(@).offset().left >= dragdrop.offsetX - 39 && 
        $(@).offset().left <= dragdrop.offsetX + 39 && 
        $(@).offset().top >= dragdrop.offsetY - 39 && 
        $(@).offset().top <= dragdrop.offsetY + 39
      matched_pieces_container.push('overlapped')
   )

   ### Auxiliary data ###
   $('.piece-of-puzzle').each(()->
    unless matched_cells_container.length is 0
     if $(@).offset().left is matched_cells_container[0].left_x && 
        $(@).offset().top is matched_cells_container[0].top_y
      matched_cell_pieces_container.push('overlapped')
   )

   ### GET END-POINT FOR THE TARGET PIECE: ###
   end_point =
    if matched_cells_container.length is 0
     if dragdrop.offsetY < 0 || dragdrop.offsetY > $(window).height() - h_percentage || 
        dragdrop.offsetX < 0 || dragdrop.offsetX > $(window).width() - w_percentage || 
        matched_pieces_container.length is 1
      top_y: dragdrop.originalY, left_x: dragdrop.originalX
     else
      top_y: dragdrop.offsetY, left_x: dragdrop.offsetX
    else
     if matched_cell_pieces_container.length is 1 || matched_pieces_container is 1
      top_y: dragdrop.originalY, left_x: dragdrop.originalX
     else
      top_y: matched_cells_container[0].top_y, left_x: matched_cells_container[0].left_x

   ### USE END-POINT RESULT TO MOVE THE PIECE ### 
   $(@el).css('z-index', '10')
    .animate({ 
     top: end_point.top_y, 
     left: end_point.left_x, opacity: 1 
    })

   ### Save new piece's coordinates to backend ###
   session = new Puzzle.Models.Session(
    id: $(@el).attr('id'), 
    offset: { x: end_point.left_x, y: end_point.top_y }
   )
   session.save(session, { silent: true, wait: true })

   ### FREEZE THE PIECE GIVEN IT MATCHED 100% ###
   ### MARK PIECE AS HALF-MATCHED for future clicks GIVEN IT IS 50% MATCHED ###   
   if matched_cells_container.length is 1 && 
      $(dragdrop.target).attr('alt') is matched_cells_container[0].id && 
      $(dragdrop.target).attr('style').match(/\(360deg\)/)
    $(@el).unbind('click')
     .unbind('draginit')
     .unbind('dragstart')
     .unbind('drag')
     .unbind('dragend')
    
    $(@el).addClass('matched')
    $(@el).css('cursor', 'default')
    
    session = new Puzzle.Models.Session(id: $(@el).attr('id'), matched: 'matched')
    session.save(session, { silent: true, wait: true })
    
    console.log $('.matched').length
    if $('.matched').length is @options.pieces.length
     console.log 'all matched'
     cover_view = new Puzzle.Views.Addons.Cover(pieces: @options.pieces)
     $('body').append(cover_view.render().el)
   
   else if matched_cells_container.length is 1 && 
           $(dragdrop.target).attr('alt') is matched_cells_container[0].id
    $(dragdrop.target).addClass('half-matched')

    session = new Puzzle.Models.Session(id: $(@el).attr('id'), matched: 'half-matched')
    session.save(session, { silent: true, wait: true })
