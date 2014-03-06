Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.CurrentPuzzle extends Backbone.View
  tagName: 'div'

  initialize: () ->
   @options.pieces.bind('reset', @render)
   @options.imagenes.bind('reset', @render)
   $(@el).bind('mouseover', @highlight)
    .bind('mouseout', @shadow)
    .bind('click', @getCurrentPuzzle)
  
  render: =>
   $(@el).attr('id',"current_puzzle")
    .attr('class','imagenes')
    .css('height','80')
    .css('width','130')
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
   return this

  highlight: () =>
   $(@el).css('opacity', '1.1')

  shadow: () =>
   $(@el).css('opacity', '0.6')

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