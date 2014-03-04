Puzzle.Views.Pieces ||= {}

class Puzzle.Views.Pieces.Piece extends Backbone.View
  tagName: "img"

  initialize: () ->
   @piece = @options.piece.toJSON()
   unless @piece.matched is 'matched'
    $(@el).bind('click', @rotatePieceOnClick)
     .bind('draginit', @dragInit)
     .bind('dragstart', @dragStart)
     .bind('drag', @dragPiece)
     .bind('dragend', @dragEnd)

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
   if @piece.matched is 'matched'
    $(@el).addClass('matched')
    $(@el).css('cursor','default')
   else if @piece.matched is 'half-matched'
    $(@el).addClass('half-matched')
   else
    $(@el).css('cursor','pointer')
   @appendMarksIfNeeded()
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
    @unbindAllHandlers(@el)

    @removeMarks()

    ### Modify piece's property accordingly and add the 'matched' class ###
    @changePieceProperties(@el)

    ### Save matched property to back-end ###
    @saveMatchToBackend(@el)

    ### Verify if puzzle is solved and render the cover view if appropriate ###
    if $('.matched').length is @options.pieces.length
     console.log 'matched all'
     @appendCover()

  get_error: (model, response) =>
   console.log response

  
  dragInit: (event, dragdrop) =>

  dragStart: (event, dragdrop) =>
   @removeMarks() if @lower_mark_view && @upper_mark_view 

   $(@el).css('cursor', 'move')
   false if !$(dragdrop.target).is('.handle')
   $(@el).css('opacity', .5).clone().insertAfter(@el)

  dragPiece: (event, dragdrop) =>
   matched_cells_container = [] 
   $('.cell').each(()->
    delta_x = dragdrop.offsetX - $(@).offset().left
    delta_y = dragdrop.offsetY - $(@).offset().top
    if delta_x >= -20 && delta_x <= 20 && delta_y >= -20 && delta_y <= 20
     matched_cells_container.push(id: $(@).attr('id'))
   )

   unless matched_cells_container.length is 0
    id = matched_cells_container[0].id
    $(".cell").css('background-color', 'rgba(255,255,255,0.0')
    $("##{id}").css('background-color','rgba(255,195,122,0.5)')

   $(dragdrop.proxy).css('z-index', '10')
    .css({ top: dragdrop.offsetY, left: dragdrop.offsetX })

  dragEnd: (event, dragdrop) =>
   ### Minor modifications ###
   $(@el).css('cursor', 'pointer')
   $(dragdrop.proxy).remove()

   ### Initialize containers ###
   matched_cells_container = []
   matched_cell_pieces_container = []
   matched_pieces_container = []

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

   ### GET END-POINT FOR THE TARGET PIECE: REVIEW!!!### 
   end_point =
    if matched_cells_container.length is 0
     $(".cell").css('background-color', 'rgba(255,255,255,0.0')
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

    @unbindAllHandlers(@el)

    @removeMarks()

    @changePieceProperties(@el)

    @saveMatchToBackend(@el)

    console.log $('.matched').length
    if $('.matched').length is @options.pieces.length
     console.log 'all matched'
     @appendCover()

   else if matched_cells_container.length is 1 && 
           $(dragdrop.target).attr('alt') is matched_cells_container[0].id

    @appendMarks(end_point.top_y, end_point.left_x, $(@el).width())

    $(dragdrop.target).addClass('half-matched')
    session = new Puzzle.Models.Session(id: $(@el).attr('id'), matched: 'half-matched')
    session.save(session, { silent: true, wait: true })

   else if matched_cells_container.length is 1
    @appendMarks(end_point.top_y, end_point.left_x, $(@el).width())

   else if matched_cells_container.length is 0
    if $(@el).hasClass('half-matched') 
     $(@el).removeClass('half-matched')
     session = new Puzzle.Models.Session(id: $(@el).attr('id'), matched: 'n_a')
     session.save(session, { silent: true, wait: true })


  unbindAllHandlers: (obj) =>
   $(obj).unbind('click')
    .unbind('draginit')
    .unbind('dragstart')
    .unbind('drag')
    .unbind('dragend')

  appendMarks: (top, left, pieces_width) =>
   @upper_mark_view = 
    new Puzzle.Views.Addons.UpperMark(
     piece_top: top,
     piece_bottom: left,
     pieces_width: pieces_width,
     pieces_id: @piece.id
    )
   @lower_mark_view =
    new Puzzle.Views.Addons.LowerMark(
     piece_top: top,
     piece_bottom: left,
     pieces_width: pieces_width,
     pieces_id: @piece.id
    )

   $('body').append(@lower_mark_view.render().el)
   $('body').append(@upper_mark_view.render().el)

   session = 
    new Puzzle.Models.Session(
     id: $(@el).attr('id'), 
     marked: 'marked', 
     top: top, left: left)
   session.save(session, { silent: true, wait: true })

  appendMarksIfNeeded: () =>
   if @piece.marked is 'marked' && 
      $("#u_#{@piece.id}").length is 0 && 
      $("#l_#{@piece.id}").length is 0
    @appendMarks(@piece.top, @piece.left, $(@el).width())

  removeMarks: () ->
   @lower_mark_view.remove()
   @upper_mark_view.remove()

   session = 
    new Puzzle.Models.Session(
     id: $(@el).attr('id'), 
     marked: 'unmarked', 
     top: '', left: ''
    )
   session.save(session, { silent: true, wait: true })

  appendCover: () =>
   cover_view = new Puzzle.Views.Addons.Cover(pieces: @options.pieces)
   $(cover_view.render().el).insertAfter('#board')
   ###$('body').append(cover_view.render().el)###

  saveMatchToBackend: (obj) =>
   session = new Puzzle.Models.Session(id: $(obj).attr('id'), matched: 'matched')
   session.save(session, { silent: true, wait: true })

  changePieceProperties: (obj) =>
   $(obj).addClass('matched')
   $(obj).css('cursor', 'default')
   $(obj).removeClass('half-matched')
