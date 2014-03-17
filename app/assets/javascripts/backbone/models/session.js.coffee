class Puzzle.Models.Session extends Backbone.Model
  urlRoot: 'api/sessions'
  defaults:
   size: '45'

class Puzzle.Collections.SessionsCollection extends Backbone.Collection
  model: Puzzle.Models.Session
  url: '/api/sessions'
