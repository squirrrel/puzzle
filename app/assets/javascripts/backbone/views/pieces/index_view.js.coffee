Puzzle.Views.Pieces ||= {}

class Puzzle.Views.Pieces.IndexView extends Backbone.View
  template: JST["backbone/templates/pieces/index"]

  events:
    'click .piece-of-puzzle': 'rotatePieceOnClick'

  initialize: () ->
    @options.pieces.bind('reset', @render)
    @options.div_containers.bind('reset', @render)

  render: =>
   pieces = @options.pieces.toJSON()
   divs = @options.div_containers.toJSON()
   $(@el).html(
    @template(
     pieces: @shuffleAndRotate(pieces), 
     divs: @getRandomDivsForPieces(pieces, divs), 
     size: 40
    )
   )
   return this

  rotatePieceOnClick: (event) ->
    img_id = event.currentTarget.id
    
    total_ = 
      if Number($("##{img_id}").attr('alt')) is 360 
        90      
      else if $("##{img_id}").attr('alt') is undefined
        90
      else
        Number($("##{img_id}").attr('alt')) + 90  
    $("##{img_id}").css('-webkit-transform',"rotate(#{total_}deg)")
     .css('transform',"rotate(#{total_}deg)")
     .css('-moz-transform', "rotate(#{total_}deg)")
    $("##{img_id}").removeAttr('alt')
    $("##{img_id}").attr('alt', total_)

  shuffleAndRotate: (pieces) ->
   _.each(
    pieces, (value, key)-> 
     value.angle = _.sample([-90, 0, 90, 180, 0]) 
   )
   _.shuffle(pieces)

  getRandomDivsForPieces: (pieces, divs) ->
   console.log divs
   result_set = new Array
   for piece in pieces
    selected_div = divs[_.random(divs.length)]
    result_set.push(selected_div)
    divs.splice(divs.indexOf(selected_div),1)
   _.shuffle(result_set)

  drawCanvas: ->
    canvas = document.getElementById('testCanvas')
    ctx = canvas.getContext('2d')
    img = document.getElementById('30')
    ctx.rotate((Math.PI/4))
    ctx.drawImage(img, 200, 200)