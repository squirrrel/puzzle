class Puzzle.Models.ImageReference extends Backbone.Model
  urlRoot: 'api/image_references'

class Puzzle.Collections.ImageReferencesCollection extends Backbone.Collection
  model: Puzzle.Models.ImageReference
  url: '/api/image_references'
