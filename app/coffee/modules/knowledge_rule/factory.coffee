Entities = require './entities'
RuleData = require './rule_data'

# # # # #

# TODO - abstract patterns here into DexieFactory?
class KnowledgeRuleFactory extends Marionette.Service

  # Defines radioRequests
  radioRequests:
    'knowledge:rule collection':  'getCollection'
    'knowledge:rule save':        'saveModel'
    'knowledge:rule destroy':     'destroyModel'

  initialize: ->
    @cachedCollection = new Entities.Collection()

  # TODO - perhaps this should be abstracted into a
  # more generic implementation
  getCollection: (dataset_id) ->
    return new Promise (resolve, reject) =>

      # DexieDB dependency injection
      # TODO - you should rethink this pattern right hurr (used twice in this file)
      db = Backbone.Radio.channel('db').request('db')

      # Queries DB
      db['knowledge_rules'].where('dataset_id').equals(dataset_id).toArray()

      # Resets the collection and resolves the promise
      .then (models) =>

        # Resets the collection of models
        @cachedCollection.reset(models)

        # Resolves the Promise and returns the FacetCollection
        return resolve(@cachedCollection)

      # Error handling
      .catch (err) => return reject(err)

  # TODO - perhaps this should be abstracted into a
  # more generic implementation
  saveModel: (model) ->
    return new Promise (resolve, reject) =>

      # Triggers 'request' event on model
      model.trigger('request')

      # Inserts item into Dexie table
      table = 'knowledge_rules'
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
      .catch (err) =>
        model.trigger('error', err)
        return reject(err)

  # DestroyModel
  # TODO - abstract into a more generalized method
  destroyModel: (model) ->
    return new Promise (resolve, reject) =>

      # Triggers 'request' event on model
      model.trigger('request')

      # Inserts item into Dexie table
      table       = 'knowledge_rules'
      primary_key = model.id

      # DexieDB dependency injection
      # TODO - you should rethink this pattern right hurr (used twice in this file)
      db = Backbone.Radio.channel('db').request('db')

      # Deletes the record from the table via primary key
      db[table].delete(primary_key)
      .then (model_id) =>
        model.trigger('sync')
        return resolve()

      # Error handling
      .catch (err) =>
        model.trigger('error', err)
        return reject(err)

# # # # #

module.exports = new KnowledgeRuleFactory()
