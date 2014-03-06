class Puzzle.Routers.PiecesRouter extends Backbone.Router
  routes:
    ""        : "index"

  index: ->
    console.log @pieces = new Puzzle.Collections.SessionsCollection()
    console.log @imagenes = new Puzzle.Collections.ImagensCollection()
    console.log @image_reference = new Puzzle.Collections.ImageReferencesCollection()
    @categories = new Puzzle.Collections.CategoriesCollection()
    @image_reference.fetch()    
    @categories.fetch()
    @pieces.fetch()
    @imagenes.fetch()
    @view = new Puzzle.Views.Imagenes.IndexView(
     pieces: @pieces,
     imagenes: @imagenes,
     categories: @categories,
     image_reference: @image_reference
    )
    $("body").html(@view.render().el)
