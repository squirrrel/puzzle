Puzzle.Views.Imagenes ||= {}

class Puzzle.Views.Imagenes.Imagen extends Backbone.View
  tagName: 'img'

  initialize: () ->
   @options.imagen.bind('reset', @render)
   @options.pieces.bind('reset', @render)
   @options.imagenes.bind('reset', @render)

   image_height = @options.imagen.get('height')
   image_width = @options.imagen.get('width')
   if Number(image_height) < Number(image_width)
    @gi_width = 400
    @gi_height = @getActualImageHeight(image_height, image_width)
   else
    @gi_height = 290
    @gi_width = @getActualImageWidth(image_height, image_width)

   $(@el).bind('click', @servePuzzle)
   $(@el).bind('mouseover', @highlightImage)
   $(@el).bind('mouseout', @shadowImages)
   if @options.imagen.get('id') is "6cd874de2ea6aca248e693dcbb1b1ff6"
    $(@el).bind('load', @fadeOutCover)

  render: =>
   $(@el).attr('src', "/assets/#{@options.imagen.get('title')}")
    .attr('id',"#{@options.imagen.toJSON().id}")
    .attr('class','imagenes')
    .css('height', @gi_height)
    .css('width', @gi_width)
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
   $('#categories').fadeOut()
   @appendCover()

  appendCover: () ->
   cover_view = new Puzzle.Views.Addons.Cover()
   $('body').append(cover_view.render().el)

  display_puzzle: (model, response) =>
   @options.pieces.fetch()
   $('body').css('background', "url('assets/skulls.png') repeat left top")
   $('body, html').css('overflow', 'hidden')

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

  getActualImageHeight: (height, width) =>
   percentage = @gi_width*100/Number(width)

   Number(height)*percentage/100

  getActualImageWidth: (height, width) =>
   percentage = @gi_height*100/Number(height)

   Number(width)*percentage/100

  fadeOutCover: () =>
   console.log 'DONE'
   $("#cover").fadeOut().remove()