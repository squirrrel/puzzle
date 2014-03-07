Puzzle.Views.Imagenes ||= {}

class Puzzle.Views.Imagenes.Imagen extends Backbone.View
  tagName: 'img'

  initialize: () ->
   @options.imagen.bind('reset', @render)
   @options.pieces.bind('reset', @render)
   $(@el).bind('click', @servePuzzle)
   $(@el).bind('mouseover', @highlightImage)
   $(@el).bind('mouseout', @shadowImages)

  render: =>
   $(@el).attr('src', "/assets/#{@options.imagen.get('title')}")
    .attr('id',"#{@options.imagen.toJSON().id}")
    .attr('class','imagenes')
    .css('height','200')
    .css('width','400')
    .css('cursor', 'pointer')
    .css('margin', '14px 14px 14px')
    .css('opacity', '0.8')
   return this

  servePuzzle: (event) =>
   imagen_id = $(@el).attr('id')
   imagen = new Puzzle.Models.Session(imagen_id: imagen_id)
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

  highlightImage: () =>
   $(@el).css('opacity','1.5')
    .css('box-shadow', '0px 0px 12px 5px rgba(255, 255, 255, 0.17)')
    .css('-moz-box-shadow','0px 0px 12px 5px rgba(255, 255, 255, 0.17)')
    .css('-webkit-box-shadow','0px 0px 12px 5px rgba(255, 255, 255, 0.17)')

  shadowImages: () =>
   $(@el).css('opacity','0.8')
    .css('box-shadow', '')
    .css('-moz-box-shadow','')
    .css('-webkit-box-shadow','') 