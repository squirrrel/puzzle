class Puzzle.Routers.PiecesRouter extends Backbone.Router
  routes:
    ""        : "index"

  index: ->
    @pieces = new Puzzle.Collections.PiecesCollection()
    @div_containers = new Puzzle.Collections.DivContainersCollection()
    @imagenes = new Puzzle.Collections.ImagensCollection()
    console.log @pieces.fetch() 
    console.log @div_containers.fetch()
    @imagenes.fetch()
    @view = new Puzzle.Views.Pieces.IndexView(
     pieces: @pieces, 
     div_containers: @div_containers,
     imagenes: @imagenes
    )
    $("body").html(@view.render().el)
