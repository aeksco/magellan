SearchView = require '../../search/facetsearch/views/layout'

# # # # #

class DatasetSearchRoute extends require 'hn_routing/lib/route'

  title: ->
    return "Magellan - #{@model.get('label')} - Search"

  breadcrumbs: ->
    return [
      { text: 'Datasets', href: '#datasets' }
      { text: "#{@model.get('label')}" }
    ]

  # TODO - this needs to be cleaned up. The promise chain here is all out of whack.
  # DatasetModel.ensureFacets() should be done inside the view
  # to gracefully load the collection in a non-blocking way
  fetch: (id) ->

    # Gets the Dataset
    return new Promise (resolve, reject) =>
      Backbone.Radio.channel('dataset').request('model', id)
      .then (model) =>

        # Assigns dataset to @model
        @model = model

        # Fetches datapoints contained within the dataset
        @model.fetchDatapoints().then (datapoints) =>

          # Assigns @datapoints
          @datapoints = datapoints

          # Gets FacetCollection from Dataset
          @model.fetchFacets().then (facetCollection) =>

            # Assigns @facetCollection
            @facetCollection = facetCollection

            # Gets SearchResultCollection
            Backbone.Radio.channel('search:result').request('collection').then (collection) =>

              # Assigns @collection
              @collection = collection

              # Resolves outter promise
              return resolve()

  render: ->
    @container.show new SearchView({ model: @model, collection: @collection, items: @datapoints, facetCollection: @facetCollection })

# # # # #

module.exports = DatasetSearchRoute
