Entities = require './entities'
RuleData = require './rule_data'

# # # # #

# TODO - abstract patterns here into DexieFactory?
class KnowledgeRuleFactory extends Marionette.Service

  # Defines radioRequests
  radioRequests:
    'knowledge:rule collection':  'getCollection'

  initialize: ->
    @cached = new Entities.Collection()

  getCollection: (dataset_id) ->
    return new Promise (resolve, reject) =>
      # TODO - this should query rules from the database
      @cached.reset(RuleData)
      return resolve(@cached)

# # # # #

module.exports = new KnowledgeRuleFactory()
