FacetCollection = require './facetEntities'

# # # # #

# TODO - this should be abstracted into its own module
class FacetFactory extends Marionette.Service

  radioRequests:
    'facet collection':  'getCollection'

  initialize: ->
    @facetCollection = new FacetCollection()

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

# # # # #

module.exports = new FacetFactory()
