
ConditionForm = require './conditionForm'
ConditionList = require './conditionList'

# # # # #

class DefinerForm extends Mn.LayoutView
  className: 'row'
  template: require './templates/definer_form'

  behaviors:
    CancelButton: {}
    SubmitButton: {}
    ModelEvents: {}

  ui:
    addCondition: '[data-click=add]'

  events:
    'click @ui.addCondition': 'addCondition'

  regions:
    conditionsRegion: '[data-region=conditions]'

  addToCollection: (condition) ->
    @collection.add(condition)
    @showConditionList()

  addCondition: ->

    # Instantiates new ConditionModel from the collection
    # TODO - THIS NEEDS AN ORDER ATTRIBUTE
    newCondition = new @collection.model()

    # Instantiates new ConditionForm instance
    conditionForm = new ConditionForm({ model: newCondition, isNew: true, sourceOptions: @options.sourceOptions })

    # Cancel event callback
    conditionForm.on 'cancel', => @showConditionList()

    # Submit event callback
    conditionForm.on 'submit', (view) => @addToCollection(view.model)

    # Shows the form in region
    @conditionsRegion.show conditionForm

  editCondition: (conditionModel) ->

    console.log @

    # Instantiates new ConditionForm instance
    conditionForm = new ConditionForm({ model: conditionModel, sourceOptions: @options.sourceOptions })

    # Cancel event callback
    conditionForm.on 'cancel', => @showConditionList()

    # Submit event callback
    conditionForm.on 'submit', (view) => @showConditionList()

    # Shows the form in region
    @conditionsRegion.show conditionForm

  showConditionList: ->
    conditionList = new ConditionList({ collection: @collection })
    conditionList.on 'edit:condition', (conditionModel) => return @editCondition(conditionModel)

    # Shows the list view in region
    @conditionsRegion.show conditionList

  onRender: ->
    Backbone.Syphon.deserialize( @, @model.attributes )
    @showConditionList()

  onCancel: ->
    @trigger 'cancel'

  onSubmit: ->
    data = Backbone.Syphon.serialize(@)
    @model.set(data)
    @model.save()

  onRequest: ->
    console.log 'onRequest'

  onSync: ->
    @trigger 'sync', @model

  onError: ->
    console.log 'onError'

# # # # #

module.exports = DefinerForm
