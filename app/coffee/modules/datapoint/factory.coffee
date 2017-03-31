Entities = require './entities'

# # # # #

# TODO - abstract patterns into DexieFactory
class DatapointFactory extends Marionette.Service

  tableName: 'datapoints'

  # Defines radioRequests
  radioRequests:
    'datapoint collection': 'getCollection'
    'datapoint save':       'saveModel'

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

  # saveModel
  # Persists an individual model to Dexie
  saveModel: (model) ->
    return new Promise (resolve, reject) =>

      # Triggers 'request' event on model
      model.trigger('request')

      # Item JSON to insert into Dexie table
      item = model.toJSON()

      # DexieDB dependency injection
      # TODO - you should rethink this pattern right hurr (used twice in this file)
      db = Backbone.Radio.channel('db').request('db')

      # Updates the record in the table (or saves a new)
      db[@tableName].put(item)
      .then (model_id) =>
        model.trigger('sync')
        return resolve()

      # Error handling
      .catch (err) =>
        model.trigger('error', err)
        return reject(err)

# # # # #

module.exports = new DatapointFactory()
