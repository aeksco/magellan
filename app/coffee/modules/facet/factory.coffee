
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
      # TODO - you should rethink this pattern right hurr (used twice in this file)
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

  # TODO - perhaps this should be abstracted into a
  # more generic implementation
  saveFacet: (model) ->
    return new Promise (resolve, reject) =>

      # Triggers 'request' event on model
      model.trigger('request')

      # Inserts item into Dexie table
      table = 'facets'
      item = model.toJSON()

      # DexieDB dependency injection
      # TODO - you should rethink this pattern right hurr (used twice in this file)
      db = Backbone.Radio.channel('db').request('db')

      # Updates the record in the table (or saves a new)
      db[table].put(item)
      .then (model_id) =>
        model.trigger('sync')
        return resolve()

      # Error handling
      .catch (err) => model.trigger('error', err)

# # # # #

module.exports = new FacetFactory()
