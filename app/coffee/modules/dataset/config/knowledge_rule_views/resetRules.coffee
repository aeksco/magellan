
class ResetRulesView extends Mn.LayoutView
  template: require './templates/reset_rules'
  className: 'row'

  behaviors:
    CancelButton: {}
    SubmitButton: {}

  onCancel: ->
    @trigger 'cancel'

# # # # #

module.exports = ResetRulesView
