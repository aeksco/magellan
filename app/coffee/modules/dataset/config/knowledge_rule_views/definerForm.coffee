
ConditionForm = require './conditionForm'
ConditionList = require './conditionList'

# # # # #

class DefinerForm extends Mn.LayoutView
  className: 'row'
  template: require './templates/definer_form'

  ui:
    addCondition: '[data-click=add]'

  events:
    'click @ui.addCondition': 'addCondition'

  regions:
    conditionsRegion: '[data-region=conditions]'

  initialize: ->
    # TODO - this collection MUST come from Backbone.Relational
    @collection = new Backbone.Collection()

  addToCollection: (condition) ->
    console.log 'ADD TO COLLECTION'
    console.log condition
    @collection.add(condition)
    @showConditionList()

  addCondition: ->

    # TODO - not like this :(
    # Integration of Backbone.Relational is a MUST.
    newCondition = new Backbone.Model()

    # Instantiates new ConditionForm instance
    conditionForm = new ConditionForm({ model: newCondition, isNew: true })

    # Cancel event callback
    conditionForm.on 'cancel', => @showConditionList()

    # Submit event callback
    conditionForm.on 'submit', (view) => @addToCollection(view.model)

    # Shows the form in region
    @conditionsRegion.show conditionForm

  showConditionList: ->
    @conditionsRegion.show new ConditionList({ collection: @collection })

  onRender: ->
    @showConditionList()

# # # # #

module.exports = DefinerForm
