AbstractRuleEntities = require '../abstract_rule/entities'

# # # # #

# KnowledgeRuleDecorator class definition
class KnowledgeRuleDecorator extends Mn.Decorator

  icon: ->
    return 'fa-magic' if @get('type') == 'decorator'
    return 'fa-plus-square-o'

# # # # #

# KnowledgeRuleModel definition
class KnowledgeRuleModel extends AbstractRuleEntities.Model

  # Decorator assignment
  decorator: KnowledgeRuleDecorator

  # radioChannel Definition
  radioChannel: 'knowledge:rule'

# # # # #

# Backbone.RelationalModel.setup()
KnowledgeRuleModel.setup()

# # # # #

# KnowledgeRuleCollection definition
class KnowledgeRuleCollection extends AbstractRuleEntities.Collection
  model: KnowledgeRuleModel

  # Object attribute to which the rules are applied
  target_attribute: 'data'

# # # # #

module.exports =
  Model:      KnowledgeRuleModel
  Collection: KnowledgeRuleCollection
