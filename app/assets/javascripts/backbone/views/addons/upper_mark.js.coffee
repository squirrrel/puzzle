Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.UpperMark extends Backbone.View
  tagName: 'div'

  initialize: () ->

  render: =>
   mark_size = 7
   actual_mark_offset = @options.piece_bottom + @options.pieces_width - mark_size
   $(@el).attr('class','mark-right-top')
   $(@el).attr('id', "u_#{@options.pieces_id}")
   $(@el).css('position','absolute')
   $(@el).css('left',"#{actual_mark_offset }px")
   $(@el).css('top',"#{@options.piece_top}px")
   $(@el).css('z-index', '1000')
   $(@el).css('border-top', "#{mark_size}px solid rgba(221,75,57,0.8)")
   $(@el).css('border-bottom', "#{mark_size}px solid transparent")
   $(@el).css('border-left',"#{mark_size}px solid transparent")
   return this