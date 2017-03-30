
class RuleFormSelector extends Mn.LayoutView
  className: 'row'
  template: require './templates/rule_form_selector'

  behaviors:
    CancelButton: {}

  ui:
    typeSelector: '[data-click=type-selector]'

  events:
    'click @ui.typeSelector': 'onTypeSelected'

  # TODO - this should be an event that is handled in this view's parent
  onTypeSelected: (e) ->
    el = $(e.currentTarget)
    type = el.data('type')

    # Sets the type attribute on the new rule
    @model.set('type', type)

    # Decides the form to be rendered
    return @trigger('new:definer') if type == 'definer'
    return @trigger('new:decorator')

  onCancel: ->
    @trigger 'cancel'

# # # # #

module.exports = RuleFormSelector
