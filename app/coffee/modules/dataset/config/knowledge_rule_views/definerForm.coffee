
ConditionForm = require './conditionForm'
ConditionList = require './conditionList'

# # # # #

# OntologySelector class definition
# TODO - this should be abstracted into a component that can be used elsewhere
class OntologySelector extends Mn.LayoutView
  className: 'row'
  template: require './templates/ontology_attribute_selector'

  ui:
    attributeSelector: '[name=target_property]'

  templateHelpers: ->
    return { dropdown: @options.dropdown }

  onRender: ->
    Backbone.Syphon.deserialize(@, @model.attributes)
    setTimeout(@initAttributeSelector, 200)

  initAttributeSelector: =>
    @ui.attributeSelector.select2({ placeholder: 'Target Attribute' })

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
    ontologySelector: '[data-region=ontology-selector]'
    conditionsRegion: '[data-region=conditions]'

  addToCollection: (condition) ->
    @collection.add(condition)
    @showConditionList()

  showOntologyAttributeSelector: ->
    Backbone.Radio.channel('ontology').request('attribute:dropdown').then (dropdown) =>
      @ontologySelector.show new OntologySelector({ model: @model, dropdown: dropdown })

  addCondition: ->

    # Instantiates new ConditionModel from the collection
    # TODO - THIS NEEDS AN ORDER ATTRIBUTE
    newCondition = new @collection.model({ id: buildUniqueId('cn_'), order: @collection.length + 1 })

    # Instantiates new ConditionForm instance
    conditionForm = new ConditionForm({ model: newCondition, isNew: true, sourceOptions: @options.sourceOptions })

    # Cancel event callback
    conditionForm.on 'cancel', => @showConditionList()

    # Submit event callback
    conditionForm.on 'submit', (view) => @addToCollection(view.model)

    # Shows the form in region
    @conditionsRegion.show conditionForm

  editCondition: (conditionModel) ->

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
    @showOntologyAttributeSelector()

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
