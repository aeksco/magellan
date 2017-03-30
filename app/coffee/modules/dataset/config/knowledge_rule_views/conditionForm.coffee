
class ConditionForm extends Mn.LayoutView
  className: 'row'
  template: require './templates/condition_form'

  behaviors:
    CancelButton: {}
    SubmitButton: {}

  ui:
    discard: '[data-click=discard]'

  events:
    'click @ui.discard': 'confirmDiscard'

  confirmDiscard: ->
    console.log 'CONFIRM DISCARD'
    console.log @model
    console.log @model.collection

    @model.collection.remove(@model)

# # # # #

module.exports = ConditionForm
