class Puzzle.Models.DivContainer extends Backbone.Model
  defaults:
    card: null
    
class Puzzle.Collections.DivContainersCollection extends Backbone.Collection
  model: Puzzle.Models.DivContainer
  url: '/api/div_containers'
