Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.CloseButton extends Backbone.View
  tagName: 'div'

  initialize: () ->
   $(@el).bind('click', @removeParent)

  render: =>
   width = 15
   $(@el).attr('id','close_button')
   $(@el).css('width', "#{width}px")
    .css('height', "#{width}px")
    .css('background-color','rgba(255,255,255,0.8)')
    .text('✘')
    .css('text-align','center')
    .css('line-height', '15px')
    .css('color', 'rgba(0,0,0,0.9)')
    .css('font-family','Arial')
    .css('font-size','14px')
    .css('font-weight','normal')
    .css('position','absolute')
    .css('top',"#{@options.height + 2}px")
    .css('left', "-#{width + 2}px")
    .css('z-index','3000')
    .css('border-radius','50%')
   return this

  removeParent: () =>
   $("##{@options.parent_id}").remove()

   session = new Puzzle.Models.Session(id: 'id')
   session.destroy()