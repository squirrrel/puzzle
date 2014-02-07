Puzzle.Views.Pieces ||= {}

class Puzzle.Views.Pieces.IndexView extends Backbone.View
  template: JST["backbone/templates/pieces/index"]

  events:
    'click .piece-of-puzzle': 'rotatePieceOnClick'
    'change #imagenes': 'servePuzzle'

  initialize: () ->
    @options.pieces.bind('reset', @render)
    @options.div_containers.bind('reset', @render)
    @options.imagenes.bind('reset', @render)

  render: =>
   $(@el).html(
    @template(
     pieces: @options.pieces.toJSON(), 
     divs: @options.div_containers.toJSON(),
     imagenes: @options.imagenes.toJSON(), 
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

  servePuzzle: (event) ->
   imagen_id = $('#imagenes').find('option:selected').attr('value')
   imagen = new Puzzle.Models.Imagen(imagen_id: imagen_id)
   @options.imagenes.create(imagen, { 
    silent: true, 
    wait: true, 
    success: @display_puzzle, 
    error: @display_error 
   })

  display_puzzle: (model, response) =>
   @options.pieces.fetch()
   @options.div_containers.fetch()

  display_error: (model, response) =>
   console.log response

  drawCanvas: ->
    canvas = document.getElementById('testCanvas')
    ctx = canvas.getContext('2d')
    img = document.getElementById('30')
    ctx.rotate((Math.PI/4))
    ctx.drawImage(img, 200, 200)