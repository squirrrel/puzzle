class Puzzle.Models.Imagen extends Backbone.Model
  urlRoot: 'api/imagenes'

class Puzzle.Collections.ImagensCollection extends Backbone.Collection
  model: Puzzle.Models.Imagen
  url: '/api/imagenes'
