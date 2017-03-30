
class ApplyRulesView extends Mn.LayoutView
  template: require './templates/apply_rules'
  className: 'row'

  behaviors:
    CancelButton: {}
    SubmitButton: {}

# # # # #

module.exports = ApplyRulesView
