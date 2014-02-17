class Puzzle.Models.Piece extends Backbone.Model
  urlRoot: 'api/pieces'  

class Puzzle.Collections.PiecesCollection extends Backbone.Collection
  model: Puzzle.Models.Piece
  url: '/api/pieces'
