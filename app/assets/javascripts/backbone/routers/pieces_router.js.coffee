class Puzzle.Routers.PiecesRouter extends Backbone.Router
  routes:
    ""        : "index"

  index: ->
    @pieces = new Puzzle.Collections.PiecesCollection()
    @div_containers = new Puzzle.Collections.DivContainersCollection()
    console.log @pieces.fetch() 
    @div_containers.fetch()
    console.log @div_containers
    @view = new Puzzle.Views.Pieces.IndexView(pieces: @pieces, div_containers: @div_containers)
    $("body").html(@view.render().el)
