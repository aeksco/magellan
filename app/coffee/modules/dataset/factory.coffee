
Entities = require './entities'

# # # # #

# TODO - abstract patterns here into DexieFactory?
class DatasetFactory extends Marionette.Service

  # Defines radioRequests
  radioRequests:
    'dataset model':      'getModel'
    'dataset collection': 'getCollection'
    'dataset datapoints': 'getDatapoints'

  initialize: ->
    @cached = new Entities.Collection()

  # TODO - this should accept a query?
  getCollection: ->
    return new Promise (resolve, reject) =>

      # TODO - abstract into:
      # Backbone.Radio.channel('db').request('all')
      table = 'datasets' # MODEL.urlRoot
      window.db[table].toArray().then (models) =>
        @cached.reset(models)
        @cached._synced = true
        return resolve(@cached)
      # TODO - catch statement

  getModel: (id) ->
    return new Promise (resolve, reject) =>

      # Resolves if ID is undefined
      return resolve(new Entities.Model()) unless id

      # Returns from @cached if synced
      return resolve(@cached.get(id)) if @cached._synced

      # Gets @cached and returns
      return @getCollection().then () => resolve(@cached.get(id))

  # getDatapoints
  # Returns a collection of Datapoints belonging to this dataset
  # TODO - should this be abstracted into the Datapoint factory?
  getDatapoints: (id) ->
    return new Promise (resolve, reject) =>

      # DexieDB dependency injection
      db = Backbone.Radio.channel('db').request('db')

      # Queries DB
      db.datapoints.where('dataset_id').equals(id).toArray()
      # TODO - should return a collection of datapoints, rather than the RAW json
      .then (datapoints) -> return resolve(datapoints)
      # TODO - catch statement

# # # # #

module.exports = new DatasetFactory()
