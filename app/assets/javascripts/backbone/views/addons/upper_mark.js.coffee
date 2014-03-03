Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.UpperMark extends Backbone.View
  tagName: 'div'

  initialize: () ->

  render: =>
    
   $(@el).attr('class','mark-right-top')
   actual_mark_offset = @options.piece_bottom + @options.pieces_width - 7
   $(@el).css('position','absolute')
   $(@el).css('left',"#{actual_mark_offset }px")
   $(@el).css('top',"#{@options.piece_top}px")
   $(@el).css('z-index', '20')
   return this