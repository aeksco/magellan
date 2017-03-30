

# TODO - this form requires validations
# Validations should be defined on the Backbone.Model
class ConditionForm extends Mn.LayoutView
  className: 'row'
  template: require './templates/condition_form'

  behaviors:
    CancelButton: {}
    SubmitButton: {}

  templateHelpers: ->
    return { isNew: @options.isNew }

  onRender: ->

    # TODO - FormSerialize Behavior
    Backbone.Syphon.deserialize( @, @model.attributes )

  onCancel: (e) ->
    e.stopPropagation()
    @trigger 'cancel', @

  onSubmit: (e) ->
    e.stopPropagation()

    # TODO - FormSerialize Behavior
    data = Backbone.Syphon.serialize(@)

    @model.set(data)
    @trigger 'submit', @

# # # # #

module.exports = ConditionForm
