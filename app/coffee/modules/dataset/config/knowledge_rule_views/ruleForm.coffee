
DefinitionForm = require './definitionForm'
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

# TODO - this form should be renamed to RuleForm
# And RuleFormSelector should be decomissioned
class RuleForm extends Mn.LayoutView
  className: 'row'
  template: require './templates/rule_form'

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
    newCondition = new @collection.model({ id: buildUniqueId('cn_'), order: @collection.length + 1 })

    # Instantiates new DefinitionForm instance
    definitionForm = new DefinitionForm({ model: newCondition, isNew: true, sourceOptions: @options.sourceOptions })

    # Cancel event callback
    definitionForm.on 'cancel', => @showConditionList()

    # Submit event callback
    definitionForm.on 'submit', (view) => @addToCollection(view.model)

    # Shows the form in region
    @conditionsRegion.show definitionForm

  editCondition: (conditionModel) ->

    # Instantiates new DefinitionForm instance
    definitionForm = new DefinitionForm({ model: conditionModel, sourceOptions: @options.sourceOptions })

    # Cancel event callback
    definitionForm.on 'cancel', => @showConditionList()

    # Submit event callback
    definitionForm.on 'submit', (view) => @showConditionList()

    # Shows the form in region
    @conditionsRegion.show definitionForm

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
    @collection.sort()
    @model.set(data)
    @model.save()

  onRequest: ->
    console.log 'onRequest'

  onSync: ->
    @trigger 'sync', @model

  onError: ->
    console.log 'onError'

# # # # #

module.exports = RuleForm
