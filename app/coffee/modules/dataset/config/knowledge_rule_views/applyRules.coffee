
class ApplyRulesView extends Mn.LayoutView
  template: require './templates/apply_rules'
  className: 'row'

  behaviors:
    CancelButton: {}
    SubmitButton: {}

  onCancel: ->
    @trigger 'cancel'

  onSubmit: ->
    console.log 'ON SUBMIT'
    @disableSubmit()
    @disableCancel()
    console.log @model

# # # # #

module.exports = ApplyRulesView
