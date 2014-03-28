do completed_tasks = ->
 $(document).ready(()->
  $('body').append("<div id='cover' 
                   style='background-color:rgba(0,0,0,0.8);position:fixed; 
                   left:0px;right:0px;top:0px;bottom:0px;z-index:2000;
                   display:block;'></div>")

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
 )