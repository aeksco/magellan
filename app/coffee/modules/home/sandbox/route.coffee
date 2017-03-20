LayoutView  = require './views/layout'

# # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # #

# TODO - this is JUST placeholder
# These could be ANY Backbone models
class TargetModel extends Backbone.Model

class TargetCollection extends Backbone.Collection
  model: TargetModel

targetData = [
  { '@id': 1, '@type': 'Person', firstName: 'John', employer: 'RPI' }
  { '@id': 2, '@type': 'Person', firstName: 'Alex', employer: 'RPI' }
  { '@id': 3, '@type': 'Person', firstName: 'Johnson', employer: 'RPI' }
  { '@id': 4, '@type': 'Person', firstName: 'Anne', employer: 'RPI' }
]

targetCollection = new TargetCollection(targetData)

# # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # #

class RuleModel extends Backbone.Model
  # TODO - this class probably needs some apply/evaluate-against method?

class RuleCollection extends Backbone.Collection
  model: RuleModel

  # TODO - this class needs an applyToTargets method, methinks

# # # # #

# Defines rules leveraged by the utility

# TODO - ordered rules
# TODO - ordered conditions
# TODO - rule validations (which rules are predicated on others?)
# TODO - rename to Attribute (source), Contraint (operation), and Query (value)?
ruleData = [

  # LastName rule definition
  {
    targetAttr: 'lastName'
    conditions: [ # TODO - should conditions be models as well?
      { source: 'firstName', operation: 'exact_match', value: 'Alex', result: 'Schwartzberg' } # TODO - *required* attribute
      { source: 'firstName', operation: 'exact_match', value: 'Johnson', result: 'Samuel' }
      { source: '@id', operation: 'exact_match', value: 1, result: 'Erickson' }
      { source: '@id', operation: 'exact_match', value: 4, result: 'Hynes' }
    ]
  }

  # TESTING REPLACE OPERATION
  {
    targetAttr: 'employer'
    conditions: [{ source: 'employer', operation: 'replace', value: 'RPI', result: 'Rensselaer Polytechnic Institute' }]
  }

  # TESTING FORMAT OPERATION
  {
    targetAttr: 'upper_employer'
    conditions: [{ source: 'employer', operation: 'format_uppercase' }]
  }

  # # # # # # # # # #
  # LastName
  # TODO - this is going the be the preferred format going forward
  # {
  #   targetAttr: 'lastName'
  #   formatters: [{ source: 'employer', operation: 'format_lowercase' }]
  #   definitions: [
  #     {
  #       conditions: [{ source: 'firstName', operation: 'exact_match', value: 'Alex' }]
  #       result: 'Schwartzberg'
  #     },
  #     {
  #       conditions: [{ source: 'firstName', operation: 'exact_match', value: 'Johnson' }]
  #       result: 'Samuel'
  #     }
  #   ]
  # }
  # # # # # # # # # #

  # TESTING FORMAT OPERATION
  {
    targetAttr: 'lower_employer'
    conditions: [{ source: 'employer', operation: 'format_lowercase' }]
  }

  # TESTING FORMAT OPERATION
  {
    targetAttr: 'last_regex'
    conditions: [{ source: 'firstName', operation: 'regex_match', value: /alex/ig, result: 'ALEX MATCHED' }]
  }

  # OPERATION TYPES
  # - [ ] fuzzy_match
  # - [ ] is_substring_of
  # - [ ] regex_capture (?)
  # - [X] regex_match
  # - [X] exact_match
  # - [X] format_lowercase
  # - [X] format_uppercase
  # - [X] replace

]

rulesCollection = new RuleCollection(ruleData)

# # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # #

class SearchSettingsRoute extends require 'hn_routing/lib/route'

  title: 'Sandbox'

  breadcrumbs: [
    { href: '#', text: 'Home' }
    { text: 'Sandbox' }
  ]

  # TODO - abstract elsewhere - into rules collection, maybe?
  applyRules: ->

    # Iterates over each rule...
    for rule in rulesCollection.models
      # console.log rule.attributes

      # Iterates over each model in targetCollection and applies rule to each model
      for target in targetCollection.models
        # console.log target.attributes

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

          #
          # # # # # # # # # # # # # # # # # # # #

  render: ->
    @applyRules()
    @container.show new LayoutView({ collection: targetCollection })


# # # # #

module.exports = SearchSettingsRoute
