Puzzle.Views.Imagenes ||= {}

class Puzzle.Views.Imagenes.IndexView extends Backbone.View
  template: JST["backbone/templates/imagenes/index"]

  initialize: () ->
   @options.imagenes.bind('reset', @render)
   @options.pieces.bind('reset', @render)
   @options.categories.bind('reset', @render)

  render: =>
   pieces = @options.pieces.toJSON()
   imagenes = @options.imagenes.toJSON()
   $(@el).html(@template(size: 40, rows: 7, columns: 13 ) )
   @addCover()
   @addImagenesView()
   @addBoardView()
   @addPiecesView()
   @addCategoriesView()
   return this

  addPiecesView: () =>
   pieces_view = new Puzzle.Views.Pieces.Pieces(pieces: @options.pieces)
   $(@el).append(pieces_view.render().el)

  addImagenesView: () =>
   if @options.pieces.length is 0
    imagenes_view = new Puzzle.Views.Imagenes.Imagenes(
     imagenes: @options.imagenes,
     pieces: @options.pieces
    )
    $(@el).append(imagenes_view.render().el)

  addCategoriesView: () =>
    categories_view = new Puzzle.Views.Addons.Categories(categories: @options.categories)
    $(@el).append(categories_view.render().el)

  addBoardView: () =>
   unless @options.pieces.length is 0
    board_view = new Puzzle.Views.Boards.Board(pieces: @options.pieces)
    $(@el).append(board_view.render().el)

  addCover: () =>
   unless @options.pieces.length is 0
    matched_pieces = []
    _.map(@options.pieces.toJSON(),
          (piece)-> matched_pieces.push(piece.matched) unless piece.matched is undefined )
    console.log matched_pieces.length
    if matched_pieces.length is @options.pieces.length
     cover_view = new Puzzle.Views.Addons.Cover(pieces: @options.pieces)
     $(@el).append(cover_view.render().el)

  drawCanvas: ->
    canvas = document.getElementById('testCanvas')
    ctx = canvas.getContext('2d')
    img = document.getElementById('30')
    ctx.rotate((Math.PI/4))
    ctx.drawImage(img, 200, 200)