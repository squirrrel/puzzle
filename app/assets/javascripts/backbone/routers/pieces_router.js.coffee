class Puzzle.Routers.PiecesRouter extends Backbone.Router
  routes:
    ""        : "index"

  index: ->
    console.log @pieces = new Puzzle.Collections.PiecesCollection()
    @imagenes = new Puzzle.Collections.ImagensCollection()
    @pieces.fetch()
    @imagenes.fetch()
    @view = new Puzzle.Views.Pieces.IndexView(
     pieces: @pieces,
     imagenes: @imagenes
    )
    $("body").html(@view.render().el)
