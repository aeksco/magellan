LayoutView  = require './views/layout'

# # # # #

class DatasetConfigRoute extends require 'hn_routing/lib/route'

  title: ->
    return "Datasets - #{@model.get('label')} - Analysis"

  breadcrumbs: ->
    return [
      { href: "#datasets", text: 'Datasets' }
      { href: "#datasets/#{@model.id}/search", text: @model.get('label') }
      { text: 'Analysis' }
    ]

  fetch: (id) ->
    Backbone.Radio.channel('dataset').request('model', id)
    .then (model) => @model = model # Assigns dataset to @model

  render: ->
    @container.show new LayoutView({ model: @model })

# # # # #

module.exports = DatasetConfigRoute
