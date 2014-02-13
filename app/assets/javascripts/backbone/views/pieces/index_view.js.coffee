Puzzle.Views.Pieces ||= {}

class Puzzle.Views.Pieces.IndexView extends Backbone.View
  template: JST["backbone/templates/pieces/index"]

  events:
    'click .imagenes':             'servePuzzle'
    'click .piece-of-puzzle':      'rotatePieceOnClick'

  initialize: () ->
    @options.pieces.bind('reset', @render)
    @options.imagenes.bind('reset', @render)

  render: =>
   pieces = @options.pieces.toJSON()
   imagenes = @options.imagenes.toJSON()
   $(@el).html(
    @template(
     pieces: pieces,
     imagenes: @toggleImages(pieces, imagenes), 
     size: 40,
     rows: 7,
     columns: 13
    )
   )
   return this

  toggleImages: (pieces, imagenes) ->
    if pieces.length is 0 then imagenes else []

  rotatePieceOnClick: (event) ->
   img_id = event.currentTarget.id
   piece = new Puzzle.Models.Piece(piece_id: img_id)

   @options.pieces.models[0].save(piece, { 
    silent: true, 
    wait: true, 
    success: @reflect_rotation, 
    error: @get_error 
   })

  reflect_rotation: (model, response) =>
   console.log response
   $("##{response.id}").css('-webkit-transform',"rotate(#{response.current_deviation}deg)")
    .css('transform',"rotate(#{response.current_deviation}deg)")
    .css('-moz-transform', "rotate(#{response.current_deviation}deg)")

  get_error: (model, response) =>
   console.log response

  servePuzzle: (event) ->
   imagen_id = $('.imagenes').attr('id')
   imagen = new Puzzle.Models.Imagen(imagen_id: imagen_id)
   @options.imagenes.create(imagen, { 
    silent: true, 
    wait: true, 
    success: @display_puzzle, 
    error: @display_error 
   })

  display_puzzle: (model, response) =>
   @options.pieces.fetch()

  display_error: (model, response) =>
   console.log response


  dragInit: (event, dradrop) ->
   console.log 'init'
   target_id = event.currentTarget.id
   $("##{target_id}").css('cursor', 'move')

  dragStart: (event, dragdrop) ->
   console.log 'start'
   false if !$(event.target).is('.handle')
   target_id = event.currentTarget.id
   $("##{target_id}").css('opacity', .5).clone().insertAfter("##{target_id}")
  
  dragPiece: (event, dragdrop) ->
   console.log 'drag'
   $(dragdrop.proxy).css({ top: dragdrop.offsetY, left: dragdrop.offsetX })
  
  dragEnd: (event, dragdrop) ->
   console.log 'end'
   target_id = event.currentTarget.id
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
    .animate({ top: end_point.top_y, left: end_point.left_x, opacity: 1 })



  drawCanvas: ->
    canvas = document.getElementById('testCanvas')
    ctx = canvas.getContext('2d')
    img = document.getElementById('30')
    ctx.rotate((Math.PI/4))
    ctx.drawImage(img, 200, 200)