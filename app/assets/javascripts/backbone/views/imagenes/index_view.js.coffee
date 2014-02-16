Puzzle.Views.Imagenes ||= {}

class Puzzle.Views.Imagenes.IndexView extends Backbone.View
  template: JST["backbone/templates/imagenes/index"]

  events:
   'click .imagenes': 'servePuzzle'

  initialize: () ->
    @options.pieces.bind('reset', @render)
    @options.imagenes.bind('reset', @render)

  render: =>
   pieces = @options.pieces.toJSON()
   imagenes = @options.imagenes.toJSON()
   $(@el).html(
    @template(
     imagenes: @toggleImages(pieces, imagenes), 
     size: 40,
     rows: 7,
     columns: 13
    )
   )
   @addPiecesView()
   return this

  addPiecesView: () =>
   pieces_views = new Puzzle.Views.Pieces.Pieces(pieces: @options.pieces)
   $(@el).append(pieces_views.render().el) 

  toggleImages: (pieces, imagenes) ->
    if pieces.length is 0 then imagenes else []

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

  drawCanvas: ->
    canvas = document.getElementById('testCanvas')
    ctx = canvas.getContext('2d')
    img = document.getElementById('30')
    ctx.rotate((Math.PI/4))
    ctx.drawImage(img, 200, 200)