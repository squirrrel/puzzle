Puzzle.Views.Addons ||= {}

class Puzzle.Views.Addons.Categories extends Backbone.View

  initialize: () ->
   @options.categories.bind('reset', @render)

  render: =>
   @addAll()
   return this

  addAll: () =>
   @options.categories.each(@addOne)

  addOne: (category) =>
   category_view = new Puzzle.Views.Addons.Category(category: category)
   $(@el).append(category_view.render().el)