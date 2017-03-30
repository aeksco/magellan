
class DecoratorForm extends Mn.LayoutView
  className: 'row'
  template: require './templates/decorator_form'

  behaviors:
    CancelButton: {}
    SubmitButton: {}

  onRender: ->
    Backbone.Syphon.deserialize(@, @model.attributes)

  onCancel: ->
    @trigger 'cancel'

  onSubmit: ->
    data = Backbone.Syphon.serialize(@)
    console.log data
    console.log 'ON SUBMIT'

# # # # #

module.exports = DecoratorForm
