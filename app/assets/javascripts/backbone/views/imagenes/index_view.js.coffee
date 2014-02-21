Puzzle.Views.Imagenes ||= {}

class Puzzle.Views.Imagenes.IndexView extends Backbone.View
  template: JST["backbone/templates/imagenes/index"]

  initialize: () ->
   @options.imagenes.bind('reset', @render)
   @options.pieces.bind('reset', @render)

  render: =>
   pieces = @options.pieces.toJSON()
   imagenes = @options.imagenes.toJSON()
   $(@el).html(@template(size: 40, rows: 7, columns: 13 ) )  
   @addImagenesView()
   @addPiecesView()
   @addFinalCover()    
   @addBoardView()
   return this

  addPiecesView: () =>
   pieces_views = new Puzzle.Views.Pieces.Pieces(pieces: @options.pieces)
   $(@el).append(pieces_views.render().el)

  addImagenesView: () =>
   if @options.pieces.length is 0
    imagenes_views = new Puzzle.Views.Imagenes.Imagenes(
     imagenes: @options.imagenes, 
     pieces: @options.pieces
    )
    $(@el).append(imagenes_views.render().el)

  addBoardView: () =>
   unless @options.pieces.length is 0
    board_views = new Puzzle.Views.Boards.Board(pieces: @options.pieces)
    $(@el).append(board_views.render().el)

  addFinalCover: () =>
   cover_view = new Puzzle.Views.Addons.Cover(pieces: @options.pieces)
   $(@el).append(cover_view.render().el)

  drawCanvas: ->
    canvas = document.getElementById('testCanvas')
    ctx = canvas.getContext('2d')
    img = document.getElementById('30')
    ctx.rotate((Math.PI/4))
    ctx.drawImage(img, 200, 200)