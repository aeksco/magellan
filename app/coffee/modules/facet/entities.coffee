
class FacetModel extends Backbone.Model
  urlRoot: 'facet'

  # Overwritten 'save' method
  save: ->
    return Backbone.Radio.channel('facet').request('save', @)

  # Overwritten 'destroy' method
  destroy: ->
    return Backbone.Radio.channel('facet').request('destroy', @)

  # linkToOntology
  # Populates a facte model with data from an ontology
  linkToOntology: ->
    return new Promise (resolve, reject) =>

      # Isolates attribute
      attr = @get('attribute')

      # Short-circuits erroneous attribute names
      return resolve(true) if attr in ['@id', '@type']
      return resolve(true) if attr.indexOf(':') < 0

      # Splits attribute to define ontology prefix and attribute
      attr        = attr.split(':')
      ont_prefix  = attr[0]
      ont_attr    = attr[1]

      console.log ont_prefix
      console.log ont_attr

      return resolve(true)

      # Backbone.Radio.channel('ontology').request('attribute', ont_id, ont_attr)
      # .then (attribute) =>

      #   # In ontology attribute is defined (i.e. FOUND)
      #   if attribute
      #     label   = attribute['rdfs:label']
      #     tooltip = attribute['rdfs:comment']

      #   # Ontology attribute was not found
      #   # We define placeholder label and tooltip
      #   else
      #     label   = id
      #     tooltip = ''

      #   # Assembles individual facet object
      #   facet =
      #     id:       id
      #     label:    label
      #     order:    index
      #     enabled:  true
      #     tooltip:  tooltip

      #   # Returns the generated facet
      #   return resolve(facet)

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
