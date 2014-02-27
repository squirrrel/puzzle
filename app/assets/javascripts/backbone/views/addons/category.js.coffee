Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.Category extends Backbone.View
  tagName: 'div'

  initialize: () ->
   console.log @options.category.toJSON().category
   @options.category.bind('reset', @render)

  render: =>
   $(@el).attr('id', "#{@options.category.get('category')}")
   $(@el).css('margin-left','auto')
   $(@el).css('margin-right','auto')
   $(@el).css('height','auto')
   $(@el).css('width','auto')
   return this