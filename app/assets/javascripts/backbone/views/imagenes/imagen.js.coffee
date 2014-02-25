Puzzle.Views.Imagenes ||= {}

class Puzzle.Views.Imagenes.Imagen extends Backbone.View
  tagName: 'img'

  initialize: () ->
   @options.imagen.bind('reset', @render)
   @options.pieces.bind('reset', @render)
   $(@el).bind('click', @servePuzzle)

  render: =>
   $(@el).attr('src', "/assets/#{@options.imagen.toJSON().title}")
    .attr('id',"#{@options.imagen.toJSON().id}")
    .attr('class','imagenes')
    .css('height','200')
    .css('width','400')
    .css('cursor', 'pointer')
   return this

  servePuzzle: (event) =>
   imagen_id = $(@el).attr('id')
   imagen = new Puzzle.Models.Imagen(imagen_id: imagen_id)
   imagen.save(imagen, { 
    silent: true, 
    wait: true, 
    success: @display_puzzle, 
    error: @display_error 
   })

  display_puzzle: (model, response) =>
   @options.pieces.fetch()

  display_error: (model, response) =>
   console.log response