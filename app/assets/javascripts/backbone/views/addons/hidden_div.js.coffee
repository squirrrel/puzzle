Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.HiddenDiv extends Backbone.View
  tagName: 'div'

  initialize: () ->
   @options.pieces.bind('reset', @render)
   $(@el).bind('mouseover', @showButton)
    .bind('mouseout', @hideButton)
    .bind('click', @goToGallery)

  render: =>
   $(@el).attr('id', 'hover_fake')
    .css('width','270px')
    .css('height','260px')
    .css('position','absolute')
    .css('left','35%')
    .css('top','93%')
    .css('cursor','pointer')
    .css('display','inline')
    .css('z-index','100')
   return this

  hideButton: () =>
   $('#button').fadeOut()

  showButton: () =>
   $('#button').fadeIn()

  goToGallery: () =>
   @appendCover()
   @addProgressBar()
   session = new Puzzle.Models.Session(id: 'id', hidden: 'hidden')
   session.save(session, { silent: true, wait: true })
   @options.image_reference.fetch()
   @options.pieces.reset()

  appendCover: () ->
   console.log 'Worked'
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
