Entities = require './entities'
RuleData = require './rule_data'

# # # # #

# TODO - abstract patterns here into DexieFactory?
class KnowledgeRuleFactory extends Marionette.Service

  # Defines radioRequests
  radioRequests:
    'knowledge:rule model':       'getModel'
    'knowledge:rule collection':  'getCollection'

  initialize: ->
    @cached = new Entities.Collection()

  getCollection: ->
    return new Promise (resolve, reject) =>
      # TODO - this should query rules from the database
      @cached.reset(RuleData)
      return resolve(@cached)

  # TODO - revisit this.
  getModel: (id) ->
    return new Promise (resolve, reject) =>

      # Resolves if ID is undefined
      return resolve(new Entities.Model()) unless id

      # Returns from @cached if synced
      return resolve(@cached.get(id)) if @cached._synced

      # Gets @cached and returns
      return @getCollection().then () => resolve(@cached.get(id))

# # # # #

module.exports = new KnowledgeRuleFactory()
