
class RuleForm extends Mn.LayoutView
  className: 'col-xs-12'
  template: require './templates/rule_form'

  behaviors:
    SubmitButton: {}

  onSubmit: ->
    console.log 'ON SUBMIT'
    data = Backbone.Syphon.serialize(@)
    console.log data
    # @model.set(data)
    # @trigger 'submitted'
    # @trigger 'hide'

  onRender: ->
    Backbone.Syphon.deserialize(@, @model.toJSON())

# # # # #

module.exports = RuleForm
