

# # # # #

class KnowledgeRuleDecorator extends Mn.Decorator

  icon: ->
    return 'fa-magic' if @get('type') == 'decorator'
    return 'fa-plus-square-o'

# # # # #

# TODO - this class probably needs some apply/evaluate-against method?
# TODO - should the applyRule method belong here?
# The KnowledgeRuleCollection should just ITERATE over each rule, invoking the method defined here.
class KnowledgeRuleModel extends Backbone.Model
  # TODO - do we want to manage nested conditions as a Backbone.Relational Collection?

  decorator: KnowledgeRuleDecorator

  # Model defaults
  defaults:
    order:      0
    enabled:    true
    targetAttr: 'UNDEFINED'
    conditions: []

# # # # #

class KnowledgeRuleCollection extends Backbone.Collection
  model: KnowledgeRuleModel

  # applyRules
  # Applies the defined KnowledgeRules to the TargetCollection
  applyRules: (targetCollection) ->

    # Iterates over each rule...
    for rule in @models
      # console.log rule.attributes

      # Iterates over each model in targetCollection and applies rule to each model
      for target in targetCollection.models

        # Isolates targetAttr and conditions from Rule
        targetAttr = rule.get('targetAttr')
        conditions = rule.get('conditions')

        # Iterates over each condition
        # TODO - continue to next target if condition is matched
        # i.e., short-circuit conditions loop if match is found
        for condition in conditions

          # Isolates pertinant variables
          # TODO - not all of these are used by every operation
          # This should be simplified to cache ONLY what's used.
          data      = target.get('data')
          source    = data[condition.source]
          operation = condition.operation
          value     = condition.value
          result    = condition.result

          # # # # # # # # # # # # # # # # # # # #
          # TODO - this operation should be abstracted into RuleModel

          # EXACT MATCH
          if operation == 'exact_match'
            if source == value
              data[targetAttr] = result
              target.set('data', data)

          # REPLACE
          if operation == 'replace'
            replaced = source.replace(value, result)
            if replaced
              data[targetAttr] = replaced
              target.set('data', data)

          # FORMAT UPPERCASE
          if operation == 'format_uppercase'
            formatted = source.toUpperCase()
            if formatted
              data[targetAttr] = formatted
              target.set('data', data)

          # FORMAT UPPERCASE
          if operation == 'format_lowercase'
            formatted = source.toLowerCase()
            if formatted
              data[targetAttr] = formatted
              target.set('data', data)

          # REGEX MATCH
          # TODO - MUST PICK WHICH ARRAY INDEX IN MATCHED REGEX
          if operation == 'regex_match'
            matched = value.exec(source)
            if matched
              data[targetAttr] = matched
              target.set('data', data)

          # TODO - save EACH dataset model after setting the data
          # THIS Save method should return a promise.
          # So that logic should be abstracted into the KnowledgeRuleModel class.
          # And this method should return a Promise.each()

# # # # #

module.exports =
  Model:      KnowledgeRuleModel
  Collection: KnowledgeRuleCollection
