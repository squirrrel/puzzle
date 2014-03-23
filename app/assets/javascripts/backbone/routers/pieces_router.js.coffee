class Puzzle.Routers.PiecesRouter extends Backbone.Router
  routes:
    ""        : "index"

  index: ->
    @pieces = new Puzzle.Collections.SessionsCollection()
    @imagenes = new Puzzle.Collections.ImagensCollection()
    @image_reference = new Puzzle.Collections.ImageReferencesCollection()
    @categories = new Puzzle.Collections.CategoriesCollection()
    @pieces.fetch()   
    @imagenes.fetch()
    @image_reference.fetch()
    @categories.fetch()
    console.log @pieces
    console.log @imagenes
    console.log @categories
    @view = new Puzzle.Views.Imagenes.IndexView(
     pieces: @pieces,
     imagenes: @imagenes,
     categories: @categories,
     image_reference: @image_reference
    )
    $("body").html(@view.render().el)
