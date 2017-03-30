
class ResetRulesView extends Mn.LayoutView
  template: require './templates/reset_rules'
  className: 'row'

  behaviors:
    CancelButton: {}
    SubmitButton: {}

# # # # #

module.exports = ResetRulesView
