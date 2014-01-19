#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Puzzle =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  init: ->
    new Puzzle.Routers.PiecesRouter 
    Backbone.history.start()

$(document).ready ->
  Puzzle.init()  