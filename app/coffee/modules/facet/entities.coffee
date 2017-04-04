
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

    # Returns Promise to manage async operations
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

      # Fetches the ontology attribute from the Ontology factory
      Backbone.Radio.channel('ontology').request('attribute', ont_prefix, ont_attr)
      .then (ontologyAttribute) =>

        # Resolves if no matching attribute has been found
        return resolve(true) unless ontologyAttribute

        # Assembles the attributes to be updated
        update =
          label:    ontologyAttribute['rdfs:label']
          tooltip:  ontologyAttribute['rdfs:comment']

        # Updates the facet model
        @set(update)

        # Persists the update to database
        @save()
        .then () => return resolve(true)
        .catch (err) => return reject(err)

# # # # #

class FacetCollection extends Backbone.Collection
  model: FacetModel
  comparator: 'order'

  getEnabled: ->
    @sort()
    facets = []
    facets.push(facet.toJSON()) for facet in @where({ enabled: true })
    return facets

# # # # #

module.exports =
  Model:      FacetModel
  Collection: FacetCollection
