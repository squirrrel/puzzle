Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.CurrentPuzzle extends Backbone.View
  tagName: 'div'

  initialize: () ->
   @height = 80
   @options.pieces.bind('reset', @render)
   @options.imagenes.bind('reset', @render)
   $(@el).bind('mouseover', @highlight)
    .bind('mouseout', @shadow)
    .bind('click', @getCurrentPuzzle)
  
  render: =>
   $(@el).attr('id',"current_puzzle")
    .attr('class','imagenes')
    .css('height',"#{@height}px")
    .css('width','130px')
    .css('cursor', 'pointer')
    .css('position','fixed')
    .css('top', '0%')
    .css('right', '1.5%')
    .css('background', "url('assets/#{@options.image_title}')")
    .css('background-size', '100% 100%')
    .css('opacity', '0.6')
    .css('z-index', '1000')
    .css('box-shadow', '0px 0px 12px 5px rgba(255, 255, 255, 0.40)')
    .css('-moz-box-shadow','0px 0px 12px 5px rgba(255, 255, 255, 0.40)')
    .css('-webkit-box-shadow','0px 0px 12px 5px rgba(255, 255, 255, 0.40)')
   @appendCloseButton()
   return this

  highlight: () =>
   $(@el).css('opacity', '1.1')

  shadow: () =>
   $(@el).css('opacity', '0.6')

  appendCloseButton: () =>
   @close_button_view = 
    new Puzzle.Views.Addons.CloseButton(
     height: @height, 
     parent_id: $(@el).attr('id')
    )
   $(@el).append($(@close_button_view.render().el))


  getCurrentPuzzle: () =>
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