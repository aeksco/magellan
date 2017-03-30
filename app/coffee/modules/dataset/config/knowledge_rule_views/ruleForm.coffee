

# # # # #

class RuleForm extends Mn.LayoutView
  className: 'col-xs-12'
  template: require './templates/rule_form'

  behaviors:
    SubmitButton: {}

  regions:
    typeFormRegion: '[data-region=type-form]'

  ui:
    typeSelector: '[data-click=type-selector]'

  events:
    'click @ui.typeSelector': 'onTypeSelected'

  onTypeSelected: (e) ->
    console.log 'ON TYPE SELECTED'
    el = $(e.currentTarget)
    type = el.data('type')
    console.log type

  onSubmit: ->
    console.log 'ON SUBMIT'
    data = Backbone.Syphon.serialize(@)
    console.log data
    # @model.set(data)
    # @trigger 'submitted'
    # @trigger 'hide'

  # onRender: ->
  #   Backbone.Syphon.deserialize(@, @model.toJSON())

# # # # #

module.exports = RuleForm
