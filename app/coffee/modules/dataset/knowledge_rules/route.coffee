LayoutView  = require './views/layout'

# # # # #

class KnowledgeRulesRoute extends require 'hn_routing/lib/route'

  # TODO
  title: ->
    return "Datasets - #{@model.get('label')} - Knowledge Rules"

  breadcrumbs: ->
    return [
      { href: "#datasets", text: 'Datasets' }
      { href: "#datasets/#{@model.id}/search", text: @model.get('label') }
      { text: 'Knowledge Rules' }
    ]

  # TODO - this needs to be cleaned up dramatically.
  # DatasetModel.ensureFacets() should be done inside the view
  # to gracefully load the collection in a non-blocking way
  fetch: (id) ->

    # Gets the Dataset
    return new Promise (resolve, reject) =>
      Backbone.Radio.channel('dataset').request('model', id)
      .then (model) =>

        # Assigns dataset to @model
        @model = model

        # TODO - all of this should be abstracted into the NavView
        # That manages all the configuration
        # Gets KnowledgeRuleCollection from Dataset
        @model.fetchKnowledgeRules().then (ruleCollection) =>

          # Assigns @ruleCollection
          @collection = ruleCollection

          # Resolves outter promise
          resolve()

  render: ->
    @container.show new LayoutView({ model: @model, collection: @collection })

# # # # #

module.exports = KnowledgeRulesRoute
