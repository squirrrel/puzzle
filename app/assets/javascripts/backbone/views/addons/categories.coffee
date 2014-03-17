Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.Categories extends Backbone.View

  initialize: () ->
   @options.categories.bind('reset', @render)
   @options.imagenes.bind('reset', @render)
   @options.pieces.bind('reset', @render)

  render: =>
   $(@el).text('Gallery')
   $(@el).attr('id','categories')
   $(@el).css('color','rgba(255,255,255,0.7)')
    .css('font-size', '40px')
    .css('font-family',"'Oregano', cursive")
    .css('font-weight','normal')
    .css('font-style','italic')
    .css('letter-spacing','3px')
    .css('word-spacing','4px')
    .css('text-align','center')
    .css('margin-top', '40px')
    .css('margin-bottom', '40px')
   @addAll()
   return this

  addAll: () =>
   @options.categories.each(@addOne)

  addOne: (category) =>
   category_view = 
    new Puzzle.Views.Addons.Category(
     category: category, 
     imagenes: @options.imagenes,
     pieces: @options.pieces
    )
   $(@el).append(category_view.render().el)