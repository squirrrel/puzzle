Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.LowerMarks extends Backbone.View

  initialize: () ->
   @options.pieces.bind('reset', @render)

  render: =>
   @addAll()
   return this

  addAll: () =>
   @options.pieces.each(@addOne)

  addOne: (piece) =>
   console.log $("##{piece.get('id')}").width()
   lower_mark_view = new Puzzle.Views.Addons.LowerMark(
    piece_top: piece.get('top'),
    piece_bottom: piece.get('left'),
    pieces_width: $("##{piece.get('id')}").width(),
    pieces_id: piece.get('id')
   )
   $(@el).append(lower_mark_view.render().el)