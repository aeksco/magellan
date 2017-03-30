
class ConditionForm extends Mn.LayoutView
  className: 'row'
  template: require './templates/condition_form'

  behaviors:
    SubmitButton: {}

  ui:
    cancel:   '[data-click=cancel]'
    discard:  '[data-click=discard]'

  events:
    'click @ui.cancel':   'cancelEditing'
    'click @ui.discard':  'confirmDiscard'

  confirmDiscard: ->
    console.log 'CONFIRM DISCARD'
    console.log @model
    console.log @model.collection
    @model.collection.remove(@model)

  cancelEditing: (e) ->
    e.stopPropagation()
    @trigger 'cancel', @

# # # # #

module.exports = ConditionForm
