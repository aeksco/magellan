
class ConditionViewer extends Mn.LayoutView
  className: 'row'
  template: require './templates/condition_viewer'

  behaviors:
    Confirmations:
      message:      'Are you sure you want to discard this condition?'
      confirmIcon:  'fa-trash'
      confirmText:  'DISCARD'
      confirmCss:   'btn-danger'

  ui:
    edit:                 '[data-click=edit]'
    confirmationTrigger:  '[data-click=discard]'

  triggers:
    'click @ui.edit': 'edit'

  # TODO - is there a better way to manage this?
  onConfirmed: ->
    @model.collection.remove(@model)

# # # # #

module.exports = ConditionViewer
