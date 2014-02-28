Puzzle.Views.Pieces ||= {}

class Puzzle.Views.Pieces.Pieces extends Backbone.View

  initialize: () ->
   @options.pieces.bind('reset', @render)

  render: =>
   $('html').css('background', "url('assets/skulls.png') repeat left top")
   $('body, html').css('overflow', 'hidden')
   @addAll()
   return this

  addAll: () =>
   @options.pieces.each(@addOne)

  addOne: (piece) =>
   piece_view = new Puzzle.Views.Pieces.Piece({ piece: piece, pieces: @options.pieces })
   $(@el).append(piece_view.render().el)