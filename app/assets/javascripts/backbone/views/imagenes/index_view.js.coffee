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
   @appendButton()
   @appendHiddenDiv()
   @addCover()
   @addBoardView()
   @addPiecesView()
   @addCategoriesView()
   ###@addLowerMarks()###
   return this

  addPiecesView: () =>
   unless @options.pieces.length is 0
    $('html').css('background', "url('assets/skulls.png') repeat left top")
    $('body, html').css('overflow', 'hidden')
    pieces_view = new Puzzle.Views.Pieces.Pieces(pieces: @options.pieces)
    $(@el).append(pieces_view.render().el)

  addCategoriesView: () =>
   if @options.pieces.length is 0
    $('html').css('background', "url('assets/dark_exa.png') repeat left top")
    $('body, html').css('overflow', 'auto')
    categories_view = 
     new Puzzle.Views.Addons.Categories(
      categories: @options.categories, 
      imagenes: @options.imagenes,
      pieces: @options.pieces
     )
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

  appendButton: () =>
   unless @options.pieces.length is 0
    button_view = new Puzzle.Views.Addons.Button(pieces: @options.pieces, matched: @matched_pieces_number())
    $(@el).append(button_view.render().el)

  appendHiddenDiv: () =>
   unless @options.pieces.length is 0 && @matched_pieces_number().length is @options.pieces.length
    hidden_div_view = new Puzzle.Views.Addons.HiddenDiv(pieces: @options.pieces)
    $(@el).append(hidden_div_view.render().el)  

  addLowerMarks: () =>
   marks_view = new Puzzle.Views.Addons.LowerMarks(pieces: @options.pieces)
   $('body').append(marks_view.render().el)  

  matched_pieces_number: () =>
   matched_pieces = []
   _.map(@options.pieces.toJSON(),
         (piece)-> matched_pieces.push(piece.matched) if piece.matched isnt undefined && piece.matched is 'matched' )
   matched_pieces

  ###drawCanvas: ->
    canvas = document.getElementById('testCanvas')
    ctx = canvas.getContext('2d')
    img = document.getElementById('30')
    ctx.rotate((Math.PI/4))
    ctx.drawImage(img, 200, 200) ###