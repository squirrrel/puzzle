Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.Cover extends Backbone.View
  tagName: 'div'

  initialize: () ->

  render: =>
   $(@el).attr('id', 'cover')
   $(@el).css('background-color', 'rgba(0,0,0,0.9)')
    .css('z-index', '4000')
    .css('position','fixed')
    .css('left', '0px')
    .css('right', '0px')
    .css('top', '0px')
    .css('bottom', '0px')
    .css('display', 'block') 
   return this
