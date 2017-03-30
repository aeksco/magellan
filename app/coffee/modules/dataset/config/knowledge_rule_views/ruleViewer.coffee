
class RuleDetail extends Mn.LayoutView
  className: 'card card-block'
  template: require './templates/rule_detail'

# # # # #

class RuleViewer extends require 'hn_views/lib/nav'
  className: 'col-xs-12'

  navItems: [
    { icon: 'fa-cube',    text: 'Rule',       trigger: 'rule', default: true }
    { icon: 'fa-cubes',   text: 'Conditions', trigger: 'conditions' }
  ]

  navEvents:
    'rule':       'showRuleForm'
    'conditions': 'showConditionsForm'

  showRuleForm: ->
    @contentRegion.show new RuleDetail({ model: @model })

  showConditionsForm: ->
    console.log 'showConditionsForm'

# # # # #

# module.exports = RuleViewer
module.exports = RuleDetail
