
class DecoratorForm extends Mn.LayoutView
  className: 'row'
  template: require './templates/decorator_form'

  behaviors:
    CancelButton: {}
    SubmitButton: {}

  onCancel: ->
    @trigger 'cancel'

  onSubmit: ->
    console.log 'ON SUBMIT'

# # # # #

module.exports = DecoratorForm
