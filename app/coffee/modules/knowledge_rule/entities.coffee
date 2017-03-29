
class KnowledgeRuleModel extends Backbone.Model
  # TODO - this class probably needs some apply/evaluate-against method?

# # # # #

class KnowledgeRuleCollection extends Backbone.Collection
  model: RuleModel

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
          source    = target.get(condition.source)
          operation = condition.operation
          value     = condition.value
          result    = condition.result

          # # # # # # # # # # # # # # # # # # # #
          # TODO - this operation should be abstracted into RuleModel

          # EXACT MATCH
          if operation == 'exact_match'
            target.set(targetAttr, result) if source == value

          # REPLACE
          if operation == 'replace'
            replaced = source.replace(value, result)
            target.set(targetAttr, replaced) if replaced

          # FORMAT UPPERCASE
          if operation == 'format_uppercase'
            formatted = source.toUpperCase()
            target.set(targetAttr, formatted) if formatted

          # FORMAT UPPERCASE
          if operation == 'format_lowercase'
            formatted = source.toLowerCase()
            target.set(targetAttr, formatted) if formatted

          # REGEX MATCH
          if operation == 'regex_match'
            matched = value.exec(source)
            target.set(targetAttr, result) if matched

# # # # #

module.exports =
  Model:      KnowledgeRuleModel
  Collection: KnowledgeRuleCollection
