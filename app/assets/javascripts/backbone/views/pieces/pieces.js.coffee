Puzzle.Views.Pieces ||= {}

class Puzzle.Views.Pieces.Pieces extends Backbone.View
  template: JST["backbone/templates/pieces/pieces"]

  initialize: () ->

  render: =>
   $(@el).html( @template( pieces: @options.pieces, divs: @options.divs, size: 40 ))
   return this
