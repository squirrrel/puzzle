Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.Category extends Backbone.View
  tagName: 'div'

  initialize: () ->
   @category = @options.category.get('category')
   @options.category.bind('reset', @render)
   @options.imagenes.bind('reset', @render)
   @options.pieces.bind('reset', @render)

  render: =>
   $(@el).attr('id', @category)
   $(@el).attr('class', 'categories')
    .css('position','relative')
    .css('margin','70px auto')
   div_width = $(window).width() - 15
   $(@el).css('width',"#{div_width}")

   dots = '·····················································' 
   $(@el).text("#{dots}  #{@category}  #{dots}")

   $(@el).css('color','#fff')
    .css('font-size', '25px')
    .css('font-family',"'Codystar', cursive")
    .css('font-weight','normal')
    .css('font-style','normal')
    .css('letter-spacing','3px')
    .css('word-spacing','4px')
    .css('text-align','center')
   ###'Oregano' 'Poiret One' 'Codystar'###
   @addImagenesView()
   return this

  addImagenesView: () =>
   if @options.pieces.length is 0
    category_images = 
     @options.imagenes.where({ category: "#{@category}" })
    
    collection = new Puzzle.Collections.ImagensCollection(category_images)
    
    imagenes_view = new Puzzle.Views.Imagenes.Imagenes(
     imagenes: collection,
     pieces: @options.pieces
    )
    $(@el).append(imagenes_view.render().el)