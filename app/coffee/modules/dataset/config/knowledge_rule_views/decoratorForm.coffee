
class DecoratorForm extends Mn.LayoutView
  className: 'row'
  template: require './templates/decorator_form'

  behaviors:
    CancelButton: {}
    SubmitButton: {}
    ModelEvents: {}

  onRender: ->
    Backbone.Syphon.deserialize(@, @model.attributes)

  onCancel: ->
    @trigger 'cancel'

  onSubmit: ->

    # Gets data from form
    data = Backbone.Syphon.serialize(@)

    # Sets target_property
    @model.set('target_property', data.target_property)

    # Sets single Decorator condition
    conditions = @model.get('conditions')
    conditions.reset([{ source: data.source, operation: data.operation }])

    # Saves the model
    @model.save()

  onRequest: ->
    @disableSubmit()
    @disableCancel()

  onSync: ->
    @trigger 'sync', @model

  onError: ->
    console.log 'onError'

# # # # #

module.exports = DecoratorForm
