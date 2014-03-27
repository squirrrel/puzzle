Puzzle.Views.Pieces ||= {}

class Puzzle.Views.Pieces.Piece extends Backbone.View
  tagName: "img"

  initialize: () ->
   @piece = @options.piece.toJSON()
   last_piece_id =  @options.pieces.last().get('id')
   unless @piece.matched is 'matched'
    $(@el).bind('click', @rotatePieceOnClick)
     .bind('draginit', @dragInit)
     .bind('dragstart', @dragStart)
     .bind('drag', @dragPiece)
     .bind('dragend', @dragEnd)
   if last_piece_id is @piece.id
    $(@el).bind('load', @fadeOutCover)

  render: =>
   $(@el).attr('id', @piece.id)
    .attr('class', 'piece-of-puzzle')
    .attr('alt',"#{@piece.order}")
    .attr('src', "/assets/#{@piece.title}")
    .attr('height', @piece.size)
    .attr('width', @piece.size)
    .css('transform', "rotate(#{@piece.deviation}deg)")
    .css('-webkit-transform', "rotate(#{@piece.deviation}deg)")
    .css('-moz-transform', "rotate(#{@piece.deviation}deg)")
    .css('position', "absolute")
    .css('left', "#{@piece.x}px")
    .css('top', "#{@piece.y}px")
    .css('z-index', '10')
    .css('cursor', 'pointer')
   if @piece.matched is 'matched'
    $(@el).addClass('matched')
    $(@el).css('cursor','default')
     .css('opacity', '1.5')
   else if @piece.matched is 'half-matched'
    $(@el).addClass('half-matched')
   return this

  rotatePieceOnClick: (event) =>
   session = new Puzzle.Models.Session(id: $(@el).attr('id'), deviated: 'deviated')

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

    ### @removeMarks() ###

    ### Modify piece's property accordingly and add the 'matched' class ###
    @changePieceProperties()

    ### Save matched property to back-end ###
    @saveMatchToBackend(@el)

    ### Verify if puzzle is solved and render the cover view if appropriate ###
    console.log $('.matched').length
    if $('.matched').length is @options.pieces.length 
     console.log 'matched all'
     @showGoToGalleryButton()

  get_error: (model, response) =>
   console.log response


  dragInit: (event, dragdrop) =>

  dragStart: (event, dragdrop) =>
   ### @removeMarks() if @lower_mark_view && @upper_mark_view ###

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

   $(dragdrop.proxy).css('z-index', '2000')
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
     if $(@).offset().left >= dragdrop.offsetX - 45 && 
        $(@).offset().left <= dragdrop.offsetX + 45 && 
        $(@).offset().top >= dragdrop.offsetY - 45 && 
        $(@).offset().top <= dragdrop.offsetY + 45
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
        matched_pieces_container.length > 0
      top_y: dragdrop.originalY, left_x: dragdrop.originalX
     else
      top_y: dragdrop.offsetY, left_x: dragdrop.offsetX
    else
     if matched_cell_pieces_container.length is 1 || matched_pieces_container > 0
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
    console.log 'Done'
    @unbindAllHandlers(@el)

    ### @removeMarks() ###

    @changePieceProperties()

    @saveMatchToBackend(@el)

    console.log $('.matched').length
    if $('.matched').length is @options.pieces.length
     console.log 'all matched'
     @showGoToGalleryButton()

   else if matched_cells_container.length is 1 && 
           $(dragdrop.target).attr('alt') is matched_cells_container[0].id

    ### @appendMarks(end_point.top_y, end_point.left_x, $(@el).width()) ###

    $(dragdrop.target).addClass('half-matched')
    session = new Puzzle.Models.Session(id: $(@el).attr('id'), matched: 'half-matched')
    session.save(session, { silent: true, wait: true })

   else if matched_cells_container.length is 1
    ### @appendMarks(end_point.top_y, end_point.left_x, $(@el).width()) ###

   else if matched_cells_container.length is 0
    ### @removeMarks() ###
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

  showGoToGalleryButton: () =>
   $('#hover_fake').remove()
   $('#button').delay(2000).css('display', 'inline')
   $('#button').delay(2000).show()

  saveMatchToBackend: (obj) =>
   session = new Puzzle.Models.Session(id: $(obj).attr('id'), matched: 'matched')
   session.save(session, { silent: true, wait: true })

  changePieceProperties: () =>
   $(@el).addClass('matched')
   ###$('.piece-of-puzzle').addClass('matched')###
   $(@el).css('cursor', 'default')
   $(@el).removeClass('half-matched')

  fadeOutCover: () ->
   $("#cover").fadeOut().remove()
