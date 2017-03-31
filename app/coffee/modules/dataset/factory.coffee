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

  getCollection: ->
    @ensureDb()
    return new Promise (resolve, reject) =>
      @db[@tableName].toArray()

      # Fetches successfully
      .then (models) =>
        @cachedCollection.reset(models)
        return resolve(@cached)

      # Error handling
      .catch (err) => return reject(err)

# # # # #

module.exports = new DatasetFactory()
