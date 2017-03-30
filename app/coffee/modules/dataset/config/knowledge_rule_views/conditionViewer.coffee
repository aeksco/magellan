
class ConditionViewer extends Mn.LayoutView
  className: 'row'
  template: require './templates/condition_viewer'

  ui:
    edit: '[data-click=edit]'

  triggers:
    'click @ui.edit': 'edit'

# # # # #

module.exports = ConditionViewer
