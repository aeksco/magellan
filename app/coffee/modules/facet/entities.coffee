
class FacetModel extends Backbone.Model
  urlRoot: 'facet'

  # Overwritten save method
  # TODO - this may need to be refactored when new facets are defined
  save: ->
    Backbone.Radio.channel('facet').request('save', @)

# # # # #

class FacetCollection extends Backbone.Collection
  model: FacetModel
  comparator: 'order' # TODO - sort by 'ORDER' attribute

  getEnabled: ->
    @sort()
    facets = []
    facets.push(facet.toJSON()) for facet in @where({ enabled: true })
    return facets

# # # # #

module.exports =
  Model:      FacetModel
  Collection: FacetCollection
