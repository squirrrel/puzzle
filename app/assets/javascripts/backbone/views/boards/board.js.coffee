Puzzle.Views.Boards ||= {}

class Puzzle.Views.Boards.Board extends Backbone.View
  tagName: 'div'

  initialize: () ->
   @options.pieces.bind('reset', @render)
   $(@el).bind('mouseover', @registerButton)
    .bind('mouseout', @unregisterButton)

  render: =>
   $(@el).attr('id', 'board')
    .css('position','relative')
    .css('margin','200px auto')
    .css('border-left','none')
    .css('border-bottom','none')
    .css('border-top','1px solid #DBDBDB')
    .css('border-right', '1px solid #DBDBDB')
    .css('width', '520px')
    .css('height', '280px')
    @addCellsView()
   return this

  addCellsView: () =>
   cells_views = new Puzzle.Views.Cells.Cells(pieces: @options.pieces)
   $(@el).append(cells_views.render().el)
