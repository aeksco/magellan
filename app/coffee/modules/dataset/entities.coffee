
# TODO - abstract this into a different class?
class DatasetModel extends Backbone.Model
  urlRoot: 'datasets'

  # Default attributes
  # TODO - validations
  # TODO - uploaded_at timestamp
  defaults:
    id:       ''
    label:    ''
    context:  {}

  # fetchFacets
  # Fetches a FacetCollection instance populated with the facets associated
  # with this dataset. Returns a Promise.
  fetchFacets: ->
    return Backbone.Radio.channel('facet').request('collection', @id)

  # TODO - should return the Datapoint collection
  fetchDatapoints: ->
    return Backbone.Radio.channel('dataset').request('datapoints', @id)

  fetchKnowledgeRules: ->
    return Backbone.Radio.channel('knowledge:rule').request('collection', @id)

# # # # #

class DatasetCollection extends Backbone.Collection
  urlRoot: 'datasets'
  model: DatasetModel

# # # # #

module.exports =
  Model:      DatasetModel
  Collection: DatasetCollection
