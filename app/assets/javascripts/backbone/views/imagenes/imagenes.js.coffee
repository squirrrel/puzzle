Puzzle.Views.Imagenes ||= {}

class Puzzle.Views.Imagenes.Imagenes extends Backbone.View

  initialize: () ->
   @options.imagenes.bind('reset', @render)
   @options.pieces.bind('reset', @render)

  render: =>
   @addAll()
   return this

  addAll: () =>
   @options.imagenes.each(@addOne)

  addOne: (imagen) =>
   imagen_view = new Puzzle.Views.Imagenes.Imagen(
    category: @options.category,
    imagen: imagen,
    imagenes: @options.imagenes,
    pieces: @options.pieces
   )
   $(@el).append(imagen_view.render().el)