
# DefinitionModel class definition
class DefinitionModel extends Backbone.RelationalModel

  # Default attributes
  # TODO - should these be NULL?
  # TODO - should 'source', 'operation', and 'value' be renamed?
  defaults:
    order:      null

    # Condition
    source:     ''
    operation:  ''
    value:      ''

    # Action
    action:     ''

    # TODO - de-comission this approach
    result:     ''

# # # # #

class DefinitionCollection extends Backbone.Collection
  model: DefinitionModel
  comparator: 'order'

  evaluate: (target, target_object, target_property) =>

    # EvaluateAction Helper
    # TODO - this should be abstracted elsewhere - perhaps an ActionEvaluator class?
    evaluateAction = (target, target_object, target_property, data, definition) =>

      # TODO - should be a switch statement here

      # Static
      if definition.get('action') == 'static'
        data[target_property] = definition.get('static_result')
        target.set(target_object, data)
        return

      # Replace
      if definition.get('action') == 'replace'

        # Replace operation
        replace_source = data[replace_source]
        replace_with = definition.get('replace_with')
        result = replace_source.replace(replace_with)

        # Sets value
        data[target_property] = result
        target.set(target_object, data)
        return

    # Condition matched flag
    # Target model is saved IF true
    conditionMatched = false

    # Iterates over each condition
    # TODO - abstract into DefinitionCollection prototype?
    for definition in @models

      # Isolates pertinant variables
      # TODO - not all of these are used by every operation
      # This should be simplified to cache ONLY what's used.
      data = target.get(target_object)

      # Constraint
      source    = data[definition.get('source')] # TODO - we must find a way to handle non-string datatypes here (Array, Object, Collection, etc.)
      operation = definition.get('operation')
      value     = definition.get('value')

      # Action
      result    = definition.get('result') # TODO - decomission this

      # # # # # # # # # # # # # # # # # # # #
      # TODO - this operation should be abstracted into RuleModel & Condition Model
      # @target_object may be accessed via @collection, or passed by reference
      # TODO - this operation must manage values that are arrays, objects, etc.

      # Skip undefined
      # continue unless source

      # EXACT MATCH
      if operation == 'exact_match'
        if source == value
          conditionMatched = true
          data[target_property] = result
          target.set(target_object, data)

      # STARTS WITH
      # TODO - STARTS_WITH_CASE_SENSITIVE
      if operation == 'starts_with'
        if _s.startsWith(source, value)
          conditionMatched = true
          data[target_property] = result
          target.set(target_object, data)

      # CONTAINS
      if operation == 'contains'
        if _s.include(source, value)
          conditionMatched = true
          data[target_property] = result
          target.set(target_object, data)

      # CONTAINS (Case-sensitive)
      if operation == 'contains_case_sensitive'
        if _s.startsWith(source.toLowerCase(), value.toLowerCase())
          conditionMatched = true
          data[target_property] = result
          target.set(target_object, data)

      # ENDS WITH
      # TODO - ENDS_WITH_CASE_SENSITIVE
      if operation == 'ends_with'
        if _s.endsWith(source, value)
          conditionMatched = true
          evaluateAction(target, target_object, target_property, data, definition)

          # data[target_property] = result
          # target.set(target_object, data)

      # # # # #
      # REPLACE
      # TODO - this is an ACTION
      # if operation == 'replace'

      #   # Ensures presence of substring
      #   isSubstring = isSubstringOf(source, value)
      #   if isSubstring
      #     conditionMatched = true
      #     data[target_property] = source.replace(value, result)
      #     target.set(target_object, data)

      # FORMAT UPPERCASE
      # TODO - this is an ACTION
      # if operation == 'format_uppercase'
      #   continue unless source
      #   formatted = source.toUpperCase()
      #   if formatted
      #     conditionMatched = true
      #     data[target_property] = formatted
      #     target.set(target_object, data)

      # FORMAT LOWERCASE
      # TODO - this is an ACTION
      # if operation == 'format_lowercase'
      #   continue unless source
      #   formatted = source.toLowerCase()
      #   if formatted
      #     conditionMatched = true
      #     data[target_property] = formatted
      #     target.set(target_object, data)

      # REGEX MATCH
      # TODO - MUST PICK WHICH ARRAY INDEX IN MATCHED REGEX
      # TODO - this is an ACTION?
      # if operation == 'regex_match'
      #   matched = value.exec(source)
      #   if matched
      #     conditionMatched = true
      #     data[target_property] = matched
      #     target.set(target_object, data)

      # TODO - SPLIT_AT_CHAR
      # TODO - this is an action -> inputs = 'char', 'index'


# # # # #

# TODO - this class probably needs some apply/evaluate-against method?
# TODO - should the applyRule method belong here?
# The AbstractRuleCollection should just ITERATE over each rule, invoking the method defined here.
class AbstractRuleModel extends Backbone.RelationalModel

  # RadioChannel
  # Determines the channel used by save and destroy methods
  # This should be overwritten when subclassed
  radioChannel: null

  # Model defaults
  defaults:
    order:            0
    enabled:          true
    target_property:  ''
    conditions:       []

  # Backbone.Relational - @relations definition
  relations: [
      type:           Backbone.HasMany
      key:            'conditions' # TODO - rename to 'definitions'
      relatedModel:   DefinitionModel
      collectionType: DefinitionCollection
  ]

  # Overwritten save method
  save: ->
    Backbone.Radio.channel(@radioChannel).request('save', @)

  # Overwritten destroy method
  destroy: ->
    Backbone.Radio.channel(@radioChannel).request('destroy', @)

# # # # #

# Substring helper function
# TODO - phase this out w/ Underscore.String
isSubstringOf = (str, sub) ->
  return str.indexOf(sub) > -1

# # # # #

# AbstractRuleCollection definition
class AbstractRuleCollection extends Backbone.Collection

  # @model definition
  # This should be overwritten when subclassed
  model: AbstractRuleModel

  # Object attribute to which the rules are applied
  # This should be overwritten when subclassed
  target_object: null

  # Sort by order attribute
  comparator: 'order'

  # applyRules
  # Applies the defined KnowledgeRules to the TargetCollection
  applyRules: (targetCollection) ->

    # Index and count variables for Loading component updates
    index = 0
    count = _s.numberFormat(targetCollection.length)

    # Iterates over each model in targetCollection and applies rule to each model
    # TODO - should this be a function belonging to the KnowledgeRule model?
    # ^^^ Yes, definitely.
    applyRuleToTarget = (target) =>

      # Loading component update message
      index = index + 1
      Backbone.Radio.channel('loading').trigger('show', "Processing #{_s.numberFormat(index)} of #{count}")

      # # # # #
      # Condition-checking starts

      # Iterates over each rule...
      # TODO - this should be isolated to the rule model?
      for rule in @models

        # Isolates target_property and conditions from Rule
        target_property = rule.get('target_property')
        definitionCollection = rule.get('conditions') # TODO - rename to definitions

        # Evaluates the definitions againt the target, returns boolean
        conditionMatched = definitionCollection.evaluate(target, @target_object, target_property)

      # Condition-checking finished
      # # # # #

      # Saves the target model ONLY if a condition has been matched
      return target.save() if conditionMatched

      # Returns an empty Promise :(
      return new Promise (resolve, reject) => resolve(true)

    # Returns as a Promise
    return Promise.each(targetCollection.models, applyRuleToTarget)

# # # # #

module.exports =
  Model:      AbstractRuleModel
  Collection: AbstractRuleCollection
