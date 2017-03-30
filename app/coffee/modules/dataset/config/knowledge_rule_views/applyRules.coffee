
class ApplyRulesView extends Mn.LayoutView
  template: require './templates/apply_rules'
  className: 'row'

  behaviors:
    CancelButton: {}
    SubmitButton: {}

  onCancel: ->
    @trigger 'cancel'

# # # # #

module.exports = ApplyRulesView
