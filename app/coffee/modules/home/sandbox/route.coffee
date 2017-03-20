LayoutView  = require './views/layout'

# # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # #

# TODO - this is JUST placeholder
# These could be ANY Backbone models
class TargetModel extends Backbone.Model

class TargetCollection extends Backbone.Collection
  model: TargetModel

targetData = [
  { id: 1, firstName: 'John' }
  { id: 2, firstName: 'Alex' }
  { id: 3, firstName: 'Johnson' }
  { id: 4, firstName: 'Anne' }
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
ruleData = [

  # LastName rule definition
  # TODO - ordered rules?
  {
    targetAttr: 'lastName'
    conditions: [ # TODO - should conditions be models as well?
      { source: 'firstName', operation: 'match', value: 'Alex', result: 'Schwartzberg' } # TODO - order conditions?
      { source: 'firstName', operation: 'match', value: 'Johnson', result: 'Samuel' }
      { source: 'id', operation: 'match', value: 1, result: 'Erickson' }
      { source: 'id', operation: 'match', value: 4, result: 'Hynes' }
    ]
  }

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

  render: ->

    # Iterates over each rule...
    for rule in rulesCollection.models
      # console.log rule.attributes

      # Iterates over each model in targetCollection and applies rule to each model
      for target in targetCollection.models
        # console.log target.attributes

        # Isolates targetAttr and conditions from Rule
        targetAttr = rule.get('targetAttr')
        conditions = rule.get('conditions')

        # Iterates over each condition?
        for condition in conditions

          # console.log condition

          source    = target.get(condition.source)
          operation = condition.operation
          value     = condition.value
          result    = condition.result

          # console.log source
          # console.log operation
          # console.log value
          # console.log result

          if operation == 'match'

            if source == value
              target.set(targetAttr, result)
            else
              console.log 'NO MATCH'

        # var myString = "something format_abc";
        # var myRegexp = /(?:^|\s)format_(.*?)(?:\s|$)/g;
        # var match = myRegexp.exec(myString);
        # console.log(match[1]); // abc

    @container.show new LayoutView({ collection: targetCollection })


# # # # #

module.exports = SearchSettingsRoute
