
ConditionForm = require './conditionForm'
ConditionList = require './conditionList'

# # # # #

class DefinerForm extends Mn.LayoutView
  className: 'row'
  template: require './templates/definer_form'

  behaviors:
    CancelButton: {}
    SubmitButton: {}

  ui:
    addCondition: '[data-click=add]'

  events:
    'click @ui.addCondition': 'addCondition'

  regions:
    conditionsRegion: '[data-region=conditions]'

  # initialize: ->
  #   # TODO - this collection MUST come from Backbone.Relational
  #   console.log @model.get('conditions')
  #   # @collection = new Backbone.Collection(@model.get('conditions'))

  addToCollection: (condition) ->
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
    Backbone.Syphon.deserialize( @, @model.attributes )
    @showConditionList()

  onCancel: ->
    @trigger 'cancel'

  onSubmit: ->
    data = Backbone.Syphon.serialize(@)
    @model.set(data)
    console.log @model.toJSON()
    @trigger 'submit', @model

# # # # #

module.exports = DefinerForm
