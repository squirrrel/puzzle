Puzzle.Views.Pieces ||= {}

class Puzzle.Views.Pieces.IndexView extends Backbone.View
  template: JST["backbone/templates/pieces/index"]

  events:
    'click .piece-of-puzzle': 'rotatePiece'

  initialize: () ->
    @options.pieces.bind('reset', @render)

  render: =>
    $(@el).html(@template(pieces: _.shuffle(@options.pieces.toJSON()), size: 40 ))
    return this

  rotatePiece: (event) ->
    img_id = event.currentTarget.id
    
    total_ = 
      if Number($("##{img_id}").attr('alt')) is 360 
        90      
      else if $("##{img_id}").attr('alt') is undefined
        90
      else
        Number($("##{img_id}").attr('alt')) + 90  
    console.log total_
    $("##{img_id}").css('-webkit-transform',"(#{total_}deg)")
     .css('transform',"rotate(#{total_}deg)")
     .css('-moz-transform', "rotate(#{total_}deg)")
    $("##{img_id}").removeAttr('alt')
    $("##{img_id}").attr('alt', total_)

  drawCanvas: =>
    canvas = document.getElementById('testCanvas')
    ctx = canvas.getContext('2d')
    img = document.getElementById('30')
    ctx.rotate((Math.PI/4))
    ctx.drawImage(img, 200, 200)