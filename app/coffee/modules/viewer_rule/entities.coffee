
# ConditionModel class definition
class ConditionModel extends Backbone.RelationalModel

  # Default attributes
  # TODO - should these be NULL?
  defaults:
    source:     ''
    operation:  ''
    value:      ''
    result:     ''

# # # # #

class ConditionCollection extends Backbone.Collection
  model: ConditionModel
  comparator: 'order'

# # # # #

class ViewerRuleModel extends Backbone.RelationalModel

  # Model defaults
  defaults:
    order:            0
    enabled:          true
    target_property:  'UNDEFINED' # TODO - this will be defined in the form
    conditions:       []

  # Backbone.Relational - @relations definition
  relations: [
      type:           Backbone.HasMany
      key:            'conditions'
      relatedModel:   ConditionModel
      collectionType: ConditionCollection
  ]

  # Overwritten save method
  save: ->
    Backbone.Radio.channel('viewer:rule').request('save', @)

  # Overwritten destroy method
  destroy: ->
    Backbone.Radio.channel('viewer:rule').request('destroy', @)

# # # # #

# ViewerRuleCollection definition
class ViewerRuleCollection extends Backbone.Collection
  model: ViewerRuleModel

  # Sort by order attribute
  comparator: 'order'

# # # # #

module.exports =
  Model:      ViewerRuleModel
  Collection: ViewerRuleCollection
