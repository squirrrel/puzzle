Puzzle.Views.Imagenes ||= {}

class Puzzle.Views.Imagenes.IndexView extends Backbone.View
  template: JST["backbone/templates/imagenes/index"]

  initialize: () ->
   @options.categories.bind('reset', @render)
   @options.image_reference.bind('reset', @render)
   @options.imagenes.bind('reset', @render)
   @options.pieces.bind('reset', @render)

  render: =>
   $(@el).html(@template())
   @decideOnBackground()
   @addBoardView()
   @appendGalleryButton()
   @appendHiddenDiv()
   @addPiecesView()
   @addCategoriesView()
   @appendCurrentPuzzle()
   ###@addLowerMarks()###
   return this

  addPiecesView: () =>
   unless @options.pieces.length is 0
    @setOffsetForAprioriMatched()
    pieces_view = new Puzzle.Views.Pieces.Pieces(pieces: @options.pieces)
    $(@el).append(pieces_view.render().el)

  decideOnBackground: () ->
   if @options.pieces.length is 0
    $('body').css('background', "url('assets/dark_exa.png') repeat left top")
    $('body, html').css('overflow', 'auto')
   else 
    $('body').css('background', "url('assets/skulls.png') repeat left top")
    $('body, html').css('overflow', 'hidden')

  addCategoriesView: () =>
   if @options.pieces.length is 0
    categories_view = 
     new Puzzle.Views.Addons.Categories(
      categories: @options.categories, 
      imagenes: @options.imagenes,
      pieces: @options.pieces,
      last_image_id: @getLastImageId()
     )
    $(@el).append(categories_view.render().el)

  addBoardView: () =>
   unless @options.pieces.length is 0
    board_view = 
     new Puzzle.Views.Boards.Board(
      pieces: @options.pieces,
      columns: @getColumnsNumber()
     )
    $(@el).append(board_view.render().el)

  appendGalleryButton: () =>
   unless @options.pieces.length is 0
    button_view = 
     new Puzzle.Views.Addons.GalleryButton(
      pieces: @options.pieces, 
      matched: @matched_pieces_number(),
      image_reference: @options.image_reference
     )
    $(@el).append(button_view.render().el)

  appendHiddenDiv: () =>
   unless @options.pieces.length is 0 && 
          @matched_pieces_number().length is @options.pieces.length
    hidden_div_view = 
     new Puzzle.Views.Addons.HiddenDiv(
      pieces: @options.pieces,
      image_reference: @options.image_reference,
      imagenes: @options.imagenes
     )
    $(@el).append(hidden_div_view.render().el)  

  addLowerMarks: () =>
   marks_view = new Puzzle.Views.Addons.LowerMarks(pieces: @options.pieces)
   $('body').append(marks_view.render().el)  

  appendCurrentPuzzle: () =>
   if @options.image_reference.length isnt 0 && @options.pieces.length is 0
    current_puzzle = 
     new Puzzle.Views.Addons.CurrentPuzzle(
      imagen: @getCurrentImage(),
      pieces: @options.pieces,
      imagenes: @options.imagenes
     )
    $(@el).append(current_puzzle.render().el)

  matched_pieces_number: () ->
   matched_pieces = []
   _.map(@options.pieces.toJSON(),
         (piece)-> matched_pieces.push(piece.matched) if piece.matched is 'matched' )
   matched_pieces

  getCurrentImage: () ->
   image_id = @options.image_reference.first().get('image_id')
   imagen = @options.imagenes.where({ id: "#{image_id}" })[0]

  getColumnsNumber: () ->
   image_id = @options.pieces.first().get('imagen_id')
   imagen = @options.imagenes.where({ id: "#{image_id}" })[0]
   imagen.get("columns")

  setOffsetForAprioriMatched: () ->
   pieces = @options.pieces.where({ apriori: 'apriori' })
   _.each(pieces, (apriori_matched_piece) -> 
    order = apriori_matched_piece.get('order')    
    cell_offset = $("div##{order}").offset()
    apriori_matched_piece.set({ x: cell_offset.left, y: cell_offset.top})
   )

  getLastImageId: () ->
   if @options.categories.last()
    last_category_name =  @options.categories.last().get('category')
    last_category_images = @options.imagenes.where({ category: last_category_name })
    last_category_length = last_category_images.length
    last_imagen_id = last_category_images[Number(last_category_length) - 1].id

  appendCover: () ->
   cover_view = new Puzzle.Views.Addons.Cover()
   $('body').append(cover_view.render().el)

  addProgressBar: () ->
    @appendCover()
    clock = new Sonic(
      width: 100,
      height: 100,
      stepsPerFrame: 1,
      trailLength: 1,
      pointDistance: .05,
      strokeColor: '#FF2E82',
      fps: 20,

      path: [
       ['arc', 50, 50, 40, 0, 360]
      ],

      setup: () -> this._.lineWidth = 4,

      step: (point, index) ->
       cx = this.padding + 50
       cy = this.padding + 50
       _ = this._
       angle = (Math.PI/180) * (point.progress * 360)
       innerRadius = if index is 1 then 10 else 25
       _.beginPath()
       _.moveTo(point.x, point.y)
       _.lineTo((Math.cos(angle) * innerRadius) + cx, (Math.sin(angle) * innerRadius) + cy)
       _.closePath()
       _.stroke()
    )

    cover = document.getElementById('cover')
    cover.appendChild(clock.canvas)
    clock.canvas.style.marginTop = '20%'
    clock.canvas.style.marginBottom = '20%'
    clock.canvas.style.marginLeft = '45%'
    clock.play()



  ###drawCanvas: ->
    canvas = document.getElementById('testCanvas')
    ctx = canvas.getContext('2d')
    img = document.getElementById('30')
    ctx.rotate((Math.PI/4))
    ctx.drawImage(img, 200, 200) ###