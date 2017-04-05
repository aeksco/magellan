ConstraintForm = require './constraintForm'
ActionForm = require './actionForm'

# # # # #

class DefinitionForm extends Mn.LayoutView
  className: 'row'
  template: require './templates/definition_form'

  behaviors:
    CancelButton: {}
    SubmitButton: {}

  regions:
    constraintRegion:  '[data-region=constraint]'
    actionRegion:     '[data-region=action]'

  templateHelpers: ->
    return { isNew: @options.isNew }
    # sourceOptions:    @options.sourceOptions
    # operationOptions: @operationOptions

  onRender: ->
    @constraintRegion.show new ConstraintForm({ model: @model, sourceOptions: @options.sourceOptions })
    @actionRegion.show new ActionForm({ model: @model, isNew: @options.isNew, sourceOptions: @options.sourceOptions })

  onCancel: (e) ->
    e.stopPropagation()
    @trigger 'cancel', @

  onSubmit: (e) ->
    e.stopPropagation()

    # TODO - FormSerialize Behavior
    data = Backbone.Syphon.serialize(@)
    console.log data
    # @model.set(data)

    # @trigger 'submit', @

# # # # #

module.exports = DefinitionForm
