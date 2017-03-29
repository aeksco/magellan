
# TODO - facetModel
Entities = require './entities'

# # # # #

# TODO - this should be abstracted into its own module
class FacetFactory extends Marionette.Service

  radioRequests:
    'facet collection': 'getCollection'
    'facet save':       'saveFacet'

  initialize: ->
    @facetCollection = new Entities.Collection()

  getCollection: (dataset_id) ->
    return new Promise (resolve, reject) =>

      # DexieDB dependency injection
      db = Backbone.Radio.channel('db').request('db')

      # Queries DB
      db.facets.where('dataset_id').equals(dataset_id).toArray()

      # TODO - should return a collection of facets, rather than the RAW json
      .then (facets) =>

        console.log facets

        # Resets the collection of facets
        @facetCollection.reset(facets)

        # Resolves the Promise and returns the FacetCollection
        return resolve(@facetCollection)

      # Error handling
      .catch (err) => return reject(err)

  saveFacet: (facetModel) ->
    return new Promise (resolve, reject) =>
      console.log 'SAVING FACET'
      resolve()

# # # # #

module.exports = new FacetFactory()
