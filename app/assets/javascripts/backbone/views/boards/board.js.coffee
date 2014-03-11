Puzzle.Views.Boards ||= {}

class Puzzle.Views.Boards.Board extends Backbone.View
  tagName: 'div'

  initialize: () ->
   @options.pieces.bind('reset', @render)
   $(@el).bind('mouseover', @registerButton)
    .bind('mouseout', @unregisterButton)

  render: =>
   $(@el).attr('id', 'board')
    .css('position','fixed')
    .css('margin-top','220px')
    .css('margin-left', '30%')
    .css('margin-right', '30%')
    .css('border-left','none')
    .css('border-bottom','none')
    .css('border-top','1px solid #DBDBDB')
    .css('border-right', '1px solid #DBDBDB')
    .css('width', '520px')
    .css('height', '280px')
    .css('background-color', 'rgba(255,255,255,0.3)')
    .css('box-shadow', '0px 0px 12px 4px rgba(34, 2, 0, 0.30)')
    .css('-moz-box-shadow','0px 0px 12px 4px rgba(34, 2, 0, 0.30)')
    .css('-webkit-box-shadow','0px 0px 12px 4px rgba(34, 2, 0, 0.30)')
    @addCellsView()
   return this

  addCellsView: () =>
   cells_views = new Puzzle.Views.Cells.Cells(pieces: @options.pieces)
   $(@el).append(cells_views.render().el)
