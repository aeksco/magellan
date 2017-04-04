
# ConditionModel class definition
class ConditionModel extends Backbone.RelationalModel

  # Default attributes
  # TODO - should these be NULL?
  # TODO - should 'source', 'operation', and 'value' be renamed?
  defaults:
    order:      null
    blocking:   false
    source:     ''
    operation:  ''
    value:      ''
    result:     '' # TODO - re-think 'result' approach

# # # # #

class ConditionCollection extends Backbone.Collection
  model: ConditionModel
  comparator: 'order'

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
    target_property:  'UNDEFINED'
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
  target_attribute: null

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

        # Rule represented soley as JSON
        rule = rule.toJSON()

        # Isolates target_property and conditions from Rule
        target_property = rule.target_property
        conditions = rule.conditions

        # Condition matched flag
        # Target model is saved IF true
        conditionMatched = false

        # Iterates over each condition
        # TODO - continue to next target if condition is matched
        # i.e., short-circuit conditions loop if match is found
        for condition in conditions

          # console.log condition.source
          # console.log target.get('data')

          # Isolates pertinant variables
          # TODO - not all of these are used by every operation
          # This should be simplified to cache ONLY what's used.
          data      = target.get(@target_attribute)
          source    = data[condition.source] # TODO - we must find a way to handle non-string datatypes here (Array, Object, Collection, etc.)
          operation = condition.operation
          value     = condition.value
          blocking  = condition.blocking # 'blocking' will short-circuit the conditions loop if a condition isn't met (used instead of 'result')
          result    = condition.result

          # # # # # # # # # # # # # # # # # # # #
          # TODO - this operation should be abstracted into RuleModel & Condition Model
          # @target_attribute may be accessed via @collection, or passed by reference
          # TODO - this operation must manage values that are arrays, objects, etc.

          # Skip undefined
          # continue unless source

          # EXACT MATCH
          if operation == 'exact_match'
            if source == value
              conditionMatched = true
              data[target_property] = result
              target.set(@target_attribute, data)
            else if blocking
              conditionMatched = false
              break

          # STARTS WITH
          # TODO - STARTS_WITH_CASE_SENSITIVE
          if operation == 'starts_with'
            if _s.startsWith(source, value)
              conditionMatched = true
              data[target_property] = result
              target.set(@target_attribute, data)
            else if blocking
              conditionMatched = false
              break

          # CONTAINS
          if operation == 'contains'
            if _s.include(source, value)
              conditionMatched = true
              data[target_property] = result
              target.set(@target_attribute, data)
            else if blocking
              conditionMatched = false
              break

          # CONTAINS (Case-sensitive)
          if operation == 'contains_case_sensitive'
            if _s.startsWith(source.toLowerCase(), value.toLowerCase())
              conditionMatched = true
              data[target_property] = result
              target.set(@target_attribute, data)
            else if blocking
              conditionMatched = false
              break

          # ENDS WITH
          # TODO - ENDS_WITH_CASE_SENSITIVE
          if operation == 'ends_with'
            if _s.endsWith(source, value)
              conditionMatched = true
              data[target_property] = result
              target.set(@target_attribute, data)
            else if blocking
              conditionMatched = false
              break

          # # # # #
          # REPLACE
          # TODO - this is an ACTION
          if operation == 'replace'

            # Ensures presence of substring
            isSubstring = isSubstringOf(source, value)
            if isSubstring
              conditionMatched = true
              data[target_property] = source.replace(value, result)
              target.set(@target_attribute, data)
            else if blocking
              conditionMatched = false
              break

          # FORMAT UPPERCASE
          # TODO - this is an ACTION
          if operation == 'format_uppercase'
            continue unless source
            formatted = source.toUpperCase()
            if formatted
              conditionMatched = true
              data[target_property] = formatted
              target.set(@target_attribute, data)
            else if blocking
              conditionMatched = false
              break

          # FORMAT LOWERCASE
          # TODO - this is an ACTION
          if operation == 'format_lowercase'
            continue unless source
            formatted = source.toLowerCase()
            if formatted
              conditionMatched = true
              data[target_property] = formatted
              target.set(@target_attribute, data)
            else if blocking
              conditionMatched = false
              break

          # REGEX MATCH
          # TODO - MUST PICK WHICH ARRAY INDEX IN MATCHED REGEX
          # TODO - this is an ACTION
          if operation == 'regex_match'
            matched = value.exec(source)
            if matched
              conditionMatched = true
              data[target_property] = matched
              target.set(@target_attribute, data)
            else if blocking
              conditionMatched = false
              break

          # TODO - SPLIT_AT_CHAR
          # TODO - this is an action -> inputs = 'char', 'index'

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
