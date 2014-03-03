Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.LowerMark extends Backbone.View
  tagName: 'div'

  initialize: () ->

  render: => 
   $(@el).attr('class','mark-left-bottom')
   actual_mark_offset = @options.piece_top + @options.pieces_width - 14
   $(@el).css('position','absolute')
   $(@el).css('left',"#{@options.piece_bottom}px")
   $(@el).css('top',"#{actual_mark_offset}px")
   $(@el).css('z-index', '20')
   return this