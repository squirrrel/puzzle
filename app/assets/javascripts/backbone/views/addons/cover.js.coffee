Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.Cover extends Backbone.View
  tagName: 'div'

  initialize: () ->
   @options.pieces.bind('reset', @render)
   $(@el).bind('mouseover', @showCover)
    .bind('mouseout', @hideCover)
    .bind('click', @solvePuzzle)

  render: =>
   $(@el).attr('id', 'cover')
    .css('position','relative')
    .css('margin','200px auto')
    .css('width', '520px')
    .css('height', '280px')
    .css('background-color','none')
    .css('font-weight', 'normal')
    .css('font-size', '12px')
    .css('color', 'rgba(0, 0, 0, 0.5)')
    .css('letter-spacing','1px')
    .css('word-spacing','2px')
    .css('text-align','center')
    .css('line-height', '30px')
    .css('font-family',"'Courier New', Courier, monospace")
   return this

  showCover: () =>
   $(@el).html('<p>You solved this puzzle. Click here to finish</p>') 
    .css('background-color','rgba(0, 0, 0, 0.05)')
    .css('cursor','pointer')

  hideCover: () =>
   $(@el).css('background-color','rgba(0, 0, 0, 0.00)') 
    .find('p').remove()

  solvePuzzle: () =>
   session = new Puzzle.Models.Session(id: 'id')
   session.destroy()
   @options.pieces.reset()
