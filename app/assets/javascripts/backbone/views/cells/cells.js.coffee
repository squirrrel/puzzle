Puzzle.Views.Cells ||= {}

class Puzzle.Views.Cells.Cells extends Backbone.View

  initialize: () ->
   @options.pieces.bind('reset', @render)

  render: =>
   @addAll()
   return this

  addAll: () =>
   iterator = _.range(1, @options.pieces.length + 1 ,1)
   for id in iterator
    @addOne(id)

  addOne: (id) =>
   cell_view = 
    new Puzzle.Views.Cells.Cell(
     pieces: @options.pieces,
     piece_size: @options.piece_size, 
     id: id
    )
   $(@el).append(cell_view.render().el)