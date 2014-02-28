Puzzle.Views.Cells ||= {}

class Puzzle.Views.Cells.Cell extends Backbone.View
  tagName: 'div'

  initialize: () ->
   @options.pieces.bind('reset', @render)

  render: =>
   if @options.pieces.length isnt 0
    $('#board').show()
    $(@el).attr('id', "#{@options.id}")
    $(@el).attr('class', 'cell')
    $(@el).css('float','left')
    $(@el).css('border-left','1px solid #DBDBDB')
    $(@el).css('border-bottom','1px solid #DBDBDB')
    $(@el).css('width',"#{40 - 1}px")
    $(@el).css('height',"#{40 - 1}px")
   else
    []
   return this