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
    .css('width','270px')
    .css('height','260px')
    .css('position','absolute')
    .css('left','35%')
    .css('top','93%')
    .css('z-index','100')
    .css('cursor','pointer')
    .css('display','inline')
   return this

  hideButton: () =>
   $('#button').fadeOut()

  showButton: () =>
   $('#button').fadeIn()

  goToGallery: () =>
   session = new Puzzle.Models.Session(id: 'id', hidden: 'hidden')
   session.save(session, { silent: true, wait: true })
   @options.image_reference.fetch()
   @options.pieces.reset()
