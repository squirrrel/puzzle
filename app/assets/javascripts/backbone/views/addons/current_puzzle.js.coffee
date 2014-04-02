Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.CurrentPuzzle extends Backbone.View
  tagName: 'div'

  initialize: () ->
   @options.pieces.bind('reset', @render)
   @options.imagenes.bind('reset', @render)

   image_height = @options.imagen.get('height')
   image_width = @options.imagen.get('width')
   @cp_width = 130
   @cp_height = @getActualImageHeight(image_height, image_width)

   if @options.pieces.length is 0
    $(@el).bind('mouseover', @highlight)
     .bind('mouseout', @shadow)
     .bind('click', @getCurrentPuzzle)
  
  render: =>
   $(@el).attr('id',"current_puzzle")
    .attr('class','imagenes')
    .css('height',"#{@cp_height}px")
    .css('width',"#{@cp_width}px")
    .css('position','fixed')
    .css('top', '0%')
    .css('right', '1.5%')
    .css('background', "url('assets/#{@options.imagen.get("title")}')")
    .css('background-size', '100% 100%')
    .css('z-index', '1000')
   if @options.pieces.length is 0
    opacity = '0.6'
    cursor = 'pointer'
    rgba_value = '255, 255, 255, 0.40'
    @appendCloseButton()
   else
    opacity = '0.8'
    cursor = 'default'
    rgba_value = '0, 0, 0, 0.35'

   $(@el).css('box-shadow', "0px 0px 12px 5px rgba(#{rgba_value})")
    .css('-moz-box-shadow',"0px 0px 12px 5px rgba(#{rgba_value})")
    .css('-webkit-box-shadow',"0px 0px 12px 5px rgba(#{rgba_value})")
    .css('opacity', opacity)
    .css('cursor', cursor)
   return this

  highlight: () =>
   $(@el).css('opacity', '1.1')

  shadow: () =>
   $(@el).css('opacity', '0.6')

  appendCloseButton: () =>
   @close_button_view = 
    new Puzzle.Views.Addons.CloseButton(
     height: @cp_height, 
     parent_id: $(@el).attr('id')
    )
   $(@el).append($(@close_button_view.render().el))


  getCurrentPuzzle: () =>
   Puzzle.Views.Imagenes.IndexView.prototype.addProgressBar()
   imagen = new Puzzle.Models.Session(
    id: 'id', 
    restore_current: 'restore_current'
   )
   imagen.save(imagen, { 
    silent: true, 
    wait: true, 
    success: @display_puzzle, 
    error: @display_error 
   })

  display_puzzle: (model, response) =>
   ###@options.imagenes.reset()###   
   @options.pieces.fetch()

  getActualImageHeight: (height, width) =>
   percentage = @cp_width*100/Number(width)

   Number(height)*percentage/100
