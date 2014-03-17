Puzzle.Views.Cells ||= {}

class Puzzle.Views.Cells.Cell extends Backbone.View
  tagName: 'div'

  initialize: () ->
   @options.pieces.bind('reset', @render)
   @piece_size = @options.pieces.first().defaults.size

  render: =>
   if @options.pieces.length isnt 0
    $('#board').show()
    $(@el).attr('id', "#{@options.id}")
    $(@el).attr('class', 'cell')
    $(@el).css('float','left')
    $(@el).css('border-left','1px dotted rgba(105,105,105,0.65)')
    $(@el).css('border-bottom','1px dotted rgba(105,105,105,0.65)')
    $(@el).css('width',"#{@options.piece_size - 1}px")
    $(@el).css('height',"#{@options.piece_size - 1}px")
   else
    []
   return this