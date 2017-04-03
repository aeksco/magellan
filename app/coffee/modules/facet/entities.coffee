
class FacetModel extends Backbone.Model
  urlRoot: 'facet'

  # Overwritten save method
  # TODO - this may need to be refactored when new facets are defined
  save: ->
    Backbone.Radio.channel('facet').request('save', @)

  # TODO - this should be abstracted elsewhere.
  # This functionality is really geared towards 'linking' a
  # facet to an ontology attribute.
  # getFacet: (ont_id, ont_attr, id, index) ->
  #   return new Promise (resolve, reject) =>
  #     Backbone.Radio.channel('ontology').request('attribute', ont_id, ont_attr)
  #     .then (attribute) =>

  #       # In ontology attribute is defined (i.e. FOUND)
  #       if attribute
  #         label   = attribute['rdfs:label']
  #         tooltip = attribute['rdfs:comment']

  #       # Ontology attribute was not found
  #       # We define placeholder label and tooltip
  #       else
  #         label   = id
  #         tooltip = ''

  #       # Assembles individual facet object
  #       facet =
  #         id:       id
  #         label:    label
  #         order:    index
  #         enabled:  true
  #         tooltip:  tooltip

  #       # Returns the generated facet
  #       return resolve(facet)

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
