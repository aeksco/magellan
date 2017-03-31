Entities = require './entities'

# # # # #

# TODO - abstract patterns into DexieFactory
class DatapointFactory extends Marionette.Service

  tableName: 'datapoints'

  # Defines radioRequests
  radioRequests:
    'datapoint collection': 'getCollection'

  initialize: ->
    @cachedCollection = new Entities.Collection()

  # getCollection
  # Returns a collection of Datapoints belonging to this dataset
  getCollection: (dataset_id) ->
    return new Promise (resolve, reject) =>

      # DexieDB dependency injection
      # TODO - you should rethink this pattern right hurr (used twice in this file)
      db = Backbone.Radio.channel('db').request('db')

      # Queries DB
      db[@tableName].where('dataset_id').equals(dataset_id).toArray()

      # Resets the collection and resolves the promise
      .then (models) =>

        # Resets the collection of models
        @cachedCollection.reset(models)

        # Resolves the Promise and returns the FacetCollection
        return resolve(@cachedCollection)

      # Error handling
      .catch (err) => return reject(err)

# # # # #

module.exports = new DatapointFactory()
