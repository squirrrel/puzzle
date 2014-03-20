Puzzle.Views.Boards ||= {}

class Puzzle.Views.Boards.Board extends Backbone.View
  tagName: 'div'

  initialize: () ->
   @options.pieces.bind('reset', @render)
   $(@el).bind('mouseover', @registerButton)
    .bind('mouseout', @unregisterButton)
   columns_number = Number(@options.columns)
   rows_number = @options.pieces.length/columns_number
   @piece_size = @options.pieces.first().defaults.size
   @width = columns_number*Number(@piece_size)
   @margin_top =
    if rows_number <= 5
     17.5
    else if rows_number > 5 && rows_number <= 8
     15
    else if rows_number > 8 && rows_number <= 10
     10
    else if rows_number > 10 && rows_number <= 12
     5
    else if rows_number > 12
     2
   @margin_left = if columns_number is 8 then 35 else 30

  render: =>
   $(@el).attr('id', 'board')
    .css('position','fixed')
    .css('margin-left', "#{@margin_left}%")
    .css('margin-right', "#{@marin_left}%")
    .css('margin-top', "#{@margin_top}%")
    .css('border-left','none')
    .css('border-bottom','none')
    .css('border-top','1px solid #DBDBDB')
    .css('border-right', '1px solid #DBDBDB')
    .css('width', "#{@width}px")
    .css('background-color', 'rgba(255,255,255,0.3)')
    .css('box-shadow', '0px 0px 12px 4px rgba(34, 2, 0, 0.30)')
    .css('-moz-box-shadow','0px 0px 12px 4px rgba(34, 2, 0, 0.30)')
    .css('-webkit-box-shadow','0px 0px 12px 4px rgba(34, 2, 0, 0.30)')
    @addCellsView()
   return this

  addCellsView: () =>
   cells_views = 
    new Puzzle.Views.Cells.Cells(
     pieces: @options.pieces,
     piece_size: @piece_size
    )
   $(@el).append(cells_views.render().el)
