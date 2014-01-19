class Puzzle.Models.Piece extends Backbone.Model
  defaults:
    card: null

class Puzzle.Collections.PiecesCollection extends Backbone.Collection
  model: Puzzle.Models.Piece
  url: '/api/imagenes'
