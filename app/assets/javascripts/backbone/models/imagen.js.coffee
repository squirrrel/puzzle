class Puzzle.Models.Imagen extends Backbone.Model
  defaults:
    card: null

class Puzzle.Collections.ImagensCollection extends Backbone.Collection
  model: Puzzle.Models.Imagen
  url: '/api/imagenes'
