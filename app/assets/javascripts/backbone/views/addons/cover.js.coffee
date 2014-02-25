Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.Cover extends Backbone.View
  tagName: 'div'

  initialize: () ->
   @options.pieces.bind('reset', @render)
   $(@el).bind('click', @solvePuzzle)
    .bind('mouseover', @registerButton)
    .bind('mouseout', @unregisterButton)

  render: =>
   $(@el).attr('id', 'final_cover')
    .css('position','absolute')
    .css('margin','200px auto')
    .css('width', '522px')
    .css('height', '282px')
    .css('color', '#1F1F1F')
    .css('letter-spacing','2px')
    .css('word-spacing','3px')
    .css('text-align','center')
    .css('line-height', '250px')
    .css('background-color','none')
    .css('font-weight', 'bold')
    .css('font-size', '13px')
    .css('font-family',"'Open Sans', sans-serif")
    .css('text-transform', 'uppercase')
    .css('cursor','pointer')
    .css('z-index', '20 !important')
   return this

  solvePuzzle: () =>
   session = new Puzzle.Models.Session(id: 'id')
   session.destroy()
   @options.pieces.reset()

  registerButton: () =>
   $(@el).css('background-color','rgba(255,255,255,0.5)')
    .text( 'Back to Gallery' ) 

  unregisterButton: () =>
   $(@el).css('background-color','')
    .text('')
    