Entities = require './entities'
DexieFactory  = require '../base/dexieFactory'

# # # # #

class DatasetFactory extends DexieFactory

  tableName: 'datasets'

  radioRequests:
    'dataset model':      'getModel'
    'dataset collection': 'getCollection'

  initialize: ->
    @cachedCollection = new Entities.Collection()

  getModel: (id) ->
    return new Promise (resolve, reject) =>

      # Resolves if ID is undefined
      return resolve(new Entities.Model()) unless id

      # Returns from @cached if synced
      return resolve(@cachedCollection.get(id)) if @cachedCollection.get(id)

      # Gets @cachedCollection and returns
      return @getCollection().then () => resolve(@cachedCollection.get(id))

  getCollection: ->
    @ensureDb()
    return new Promise (resolve, reject) =>
      @db[@tableName].toArray().then (models) =>
        @cachedCollection.reset(models)
        @cachedCollection._synced = true
        return resolve(@cached)
      # TODO - catch statement

# # # # #

module.exports = new DatasetFactory()
