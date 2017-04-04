

# TODO - this form requires validations
# Validations should be defined on the Backbone.Model
class ConditionForm extends Mn.LayoutView
  className: 'row'
  template: require './templates/condition_form'

  behaviors:
    CancelButton: {}
    SubmitButton: {}

  ui:
    checkbox: 'input[type=checkbox]'

  # Defines operationOptions
  operationOptions: [
    ['exact_match',             'Exact Match']
    ['starts_with',             'Starts With']
    ['ends_with',               'Ends With']
    ['replace',                 'Replace'] # TODO - replace is an action
    ['contains',                'Contains']
    ['contains_case_sensitive', 'Contains (case sensitive)']
  ]

  templateHelpers: ->
    return helpers =
      isNew:            @options.isNew
      sourceOptions:    @options.sourceOptions
      operationOptions: @operationOptions

  onRender: ->

    # TODO - FormSerialize Behavior
    Backbone.Syphon.deserialize( @, @model.attributes )

    # Init Bootstrap Switch
    @ui.checkbox.bootstrapSwitch({ wrapperClass: 'enable-facet', onText: 'Yes', offText: 'No' })

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
