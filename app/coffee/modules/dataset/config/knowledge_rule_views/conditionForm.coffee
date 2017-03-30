
class ConditionForm extends Mn.LayoutView
  className: 'row'
  template: require './templates/condition_form'

  behaviors:
    CancelButton: {}
    SubmitButton: {}

# # # # #

module.exports = ConditionForm
