Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.Cover extends Backbone.View
  tagName: 'div'

  initialize: () ->

  render: =>
   $(@el).attr('id', 'cover')
   $(@el).css('z-index', '4000')
    .css('position','fixed')
    .css('left', '0px')
    .css('right', '0px')
    .css('top', '0px')
    .css('bottom', '0px')
    .css('width', '100%')
    .css('height', '100%')
    .css('display', 'inline-block')
   if @options.flag is 'black_cover'
    $(@el).css('background-color', 'rgba(0,0,0,0.8)')
   else
    $(@el).css('background', "url('assets/#{@options.background}')")
     .css('background-repeat', 'no-repeat')
     .css('background-position', 'center')
     .css('background-size', '100% 100%')
     .css('opacity', '0.8')
   return this