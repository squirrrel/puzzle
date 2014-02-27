class Puzzle.Models.Category extends Backbone.Model
  urlRoot: 'api/categories'

class Puzzle.Collections.CategoriesCollection extends Backbone.Collection
  model: Puzzle.Models.Category
  url: '/api/categories'
