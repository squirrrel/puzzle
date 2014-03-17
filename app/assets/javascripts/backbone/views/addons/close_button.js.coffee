Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.CloseButton extends Backbone.View
  tagName: 'div'

  initialize: () ->
   $(@el).bind('click', @removeParent)

  render: =>
   size = 15
   $(@el).attr('id','close_button')
   $(@el).css('size', "#{size}px")
    .css('height', "#{size}px")
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
    .css('left', "-#{size + 2}px")
    .css('z-index','3000')
    .css('border-radius','50%')
   return this

  removeParent: () =>
   $("##{@options.parent_id}, #close_button").remove()

   session = new Puzzle.Models.Session(id: 'id')
   session.destroy()