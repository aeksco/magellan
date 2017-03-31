
Entities = require './entities'

# # # # #

# TODO - abstract patterns here into DexieFactory
class DatasetFactory extends Marionette.Service

  # Defines radioRequests
  radioRequests:
    'dataset model':      'getModel'
    'dataset collection': 'getCollection'

  initialize: ->
    @cached = new Entities.Collection()

  getModel: (id) ->
    return new Promise (resolve, reject) =>

      # Resolves if ID is undefined
      return resolve(new Entities.Model()) unless id

      # Returns from @cached if synced
      return resolve(@cached.get(id)) if @cached._synced

      # Gets @cached and returns
      return @getCollection().then () => resolve(@cached.get(id))

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

# # # # #

module.exports = new DatasetFactory()
