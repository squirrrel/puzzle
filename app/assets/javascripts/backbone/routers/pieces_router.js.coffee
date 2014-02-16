class Puzzle.Routers.PiecesRouter extends Backbone.Router
  routes:
    ""        : "index"

  index: ->
    @pieces = new Puzzle.Collections.PiecesCollection()
    @imagenes = new Puzzle.Collections.ImagensCollection()
    @pieces.fetch()
    @imagenes.fetch()
    @view = new Puzzle.Views.Imagenes.IndexView(
     pieces: @pieces,
     imagenes: @imagenes
    )
    $("body").html(@view.render().el)
