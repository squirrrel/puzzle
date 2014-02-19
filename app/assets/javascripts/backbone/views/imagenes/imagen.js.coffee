Puzzle.Views.Imagenes ||= {}

class Puzzle.Views.Imagenes.Imagen extends Backbone.View
  tagName: 'img'

  initialize: () ->
   @options.imagen.bind('reset', @render)
   @options.pieces.bind('reset', @render)
   $(@el).bind('click', @servePuzzle)

  render: =>
   if @options.pieces.length is 0
    $(@el).attr('src', "/assets/#{@options.imagen.toJSON().title}")
    $(@el).css('height','200')
    $(@el).css('width','400')
    $(@el).attr('class','imagenes')
    $(@el).attr('id',"#{@options.imagen.toJSON().id}")
   else
    []
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