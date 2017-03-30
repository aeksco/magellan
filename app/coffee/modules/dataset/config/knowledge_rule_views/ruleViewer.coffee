
class RuleViewer extends Mn.LayoutView
  className: 'card card-block'
  template: require './templates/rule_viewer'

  behaviors:
    Confirmations:
      message:      'Are you sure you want to destroy this Knowledge Rule?'
      confirmIcon:  'fa-trash'
      confirmText:  'DESTROY'
      confirmCss:   'btn-danger'

  ui:
    edit:                 '[data-click=edit]'
    confirmationTrigger:  '[data-click=discard]'

  triggers:
    'click @ui.edit': 'edit'

  # TODO - is there a better way to manage this?
  onConfirmed: ->
    console.log 'DESTROY KNOWLEDGE RULE HERE'

# # # # #

module.exports = RuleViewer
