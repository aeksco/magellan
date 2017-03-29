
class FacetModel extends Backbone.Model
  urlRoot: 'facet'

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
