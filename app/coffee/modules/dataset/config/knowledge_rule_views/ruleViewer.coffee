
class RuleViewer extends Mn.LayoutView
  className: 'card card-block'
  template: require './templates/rule_viewer'

  behaviors:
    ModelEvents: {}
    Confirmations:
      message:      'Are you sure you want to destroy this Knowledge Rule?'
      confirmIcon:  'fa-trash'
      confirmText:  'DESTROY'
      confirmCss:   'btn-danger'

  ui:
    edit:                 '[data-click=edit]'
    confirmationTrigger:  '[data-click=destroy]'

  triggers:
    'click @ui.edit': 'edit'

  onConfirmed: ->
    @model.destroy()

  onRequest: ->
    console.log 'onRequest'

  onSync: ->
    @model.collection.remove(@model)

  onError: ->
    console.log 'onError'

# # # # #

module.exports = RuleViewer
