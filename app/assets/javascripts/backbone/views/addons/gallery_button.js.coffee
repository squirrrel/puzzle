Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.GalleryButton extends Backbone.View
  tagName: 'div'

  initialize: () -> 
   @options.pieces.bind('reset', @render)
   @options.image_reference.bind('reset', @render)
   $(@el).bind('click', @goToGallery)

  render: =>
   if @options.pieces.length is @options.matched.length
    $(@el).css('display', 'inline')
   else
    $(@el).css('display', 'none')
   $(@el).attr('id', 'button')
   $(@el).css('width', '160px')
   $(@el).css('height', '40px')
   $(@el).css('background-color', 'rgba(255,255,255,0.8)')
   $(@el).css('border', '1px solid rgba(255,255,255,0.4)')
   $(@el).css('border-radius','12px 12px 0 0')
   $(@el).css('font-size', '20px')
   $(@el).css('font-family',"'Oregano', cursive")
   $(@el).css('font-weight','normal')
   $(@el).css('font-style','normal')
   $(@el).text('Back to Gallery')
   $(@el).css('position', 'absolute')
   $(@el).css('left', '40%')
   $(@el).css('top', "95%")
   $(@el).css('cursor', 'pointer')
   $(@el).css('color','rgba(0,0,0,0.8)')
    .css('letter-spacing','2px')
    .css('word-spacing','3px')
    .css('text-align','center')
    .css('line-height', '30px')
    .css('background-color', 'rgba(255,255,255,0.3)')
    .css('box-shadow', '0px 0px 12px 4px rgba(34, 2, 0, 0.30)')
    .css('-moz-box-shadow','0px 0px 12px 4px rgba(34, 2, 0, 0.30)')
    .css('-webkit-box-shadow','0px 0px 12px 4px rgba(34, 2, 0, 0.30)')
   return this

  goToGallery: () =>
   @appendCover()
   @addProgressBar()
   session = new Puzzle.Models.Session(id: 'id')
   session.destroy()
   @options.pieces.reset()
   @options.image_reference.reset()

  appendCover: () ->
   cover_view = new Puzzle.Views.Addons.Cover()
   $('body').append(cover_view.render().el)

  addProgressBar: () ->
    clock = new Sonic(
      width: 100,
      height: 100,
      stepsPerFrame: 1,
      trailLength: 1,
      pointDistance: .05,
      strokeColor: '#FF2E82',
      fps: 20,

      path: [
       ['arc', 50, 50, 40, 0, 360]
      ],

      setup: () -> this._.lineWidth = 4,

      step: (point, index) ->
       cx = this.padding + 50
       cy = this.padding + 50
       _ = this._
       angle = (Math.PI/180) * (point.progress * 360)
       innerRadius = if index is 1 then 10 else 25
       _.beginPath()
       _.moveTo(point.x, point.y)
       _.lineTo((Math.cos(angle) * innerRadius) + cx, (Math.sin(angle) * innerRadius) + cy)
       _.closePath()
       _.stroke()
    )

    cover = document.getElementById('cover')
    cover.appendChild(clock.canvas)
    clock.canvas.style.marginTop = '20%'
    clock.canvas.style.marginBottom = '20%'
    clock.canvas.style.marginLeft = '45%'
    clock.play()