Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.LowerMark extends Backbone.View
  tagName: 'div'

  initialize: () ->

  render: =>
   mark_size = 7
   $(@el).attr('class','mark-left-bottom')
   $(@el).attr('id', "l_#{@options.pieces_id}")
   actual_mark_offset = @options.piece_top + @options.pieces_width - mark_size*2
   $(@el).css('position','absolute')
   $(@el).css('left',"#{@options.piece_bottom}px")
   $(@el).css('top',"#{actual_mark_offset}px")
   $(@el).css('z-index', '100')
   $(@el).css('border-top', "#{mark_size}px solid transparent")
   $(@el).css('border-bottom', "#{mark_size}px solid rgba(221,75,57,0.8)")
   $(@el).css('border-right', "#{mark_size}px solid transparent")
   return this