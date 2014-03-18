Puzzle.Views.Boards ||= {}

class Puzzle.Views.Boards.Board extends Backbone.View
  tagName: 'div'

  initialize: () ->
   @options.pieces.bind('reset', @render)
   $(@el).bind('mouseover', @registerButton)
    .bind('mouseout', @unregisterButton)
   columns_number = $('body').attr('id')
   @piece_size = @options.pieces.first().defaults.size
   @width = Number(columns_number)*Number(@piece_size)
   rows_number = @options.pieces.length/columns_number
   @maring_top =
    if rows_number <= 4
     17.5
    else if rows_number > 4 && rows_number <= 7
     15
    else if rows_number > 7 && rows_number <= 10
     10
    else if rows_number > 10 && rows_number <= 12
     5
    else if rows_number > 12
     1


  render: =>
   $(@el).attr('id', 'board')
    .css('position','fixed')
    .css('margin-left', '30%')
    .css('margin-right', '30%')
    .css('margin-top', "#{@maring_top}%")
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
