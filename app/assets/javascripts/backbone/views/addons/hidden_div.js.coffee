Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.HiddenDiv extends Backbone.View
  tagName: 'div'

  initialize: () ->
   @options.pieces.bind('reset', @render)
   $(@el).bind('mouseover', @showButton)
    .bind('mouseout', @hideButton)
    .bind('click', @goToGallery)

  render: =>
   $(@el).attr('id', 'hover_fake')
    .css('width','300px')
    .css('height','220px')
    .css('position','absolute')
    .css('left','35%')
    .css('top','90%')
    .css('z-index','100')
    .css('cursor','pointer')
    .css('display','inline')
   return this

  hideButton: () =>
   $('#button').fadeOut()

  showButton: () =>
   $('#button').fadeIn()

  goToGallery: () =>
   session = new Puzzle.Models.Session(id: 'id')
   session.destroy()
   @options.pieces.reset()