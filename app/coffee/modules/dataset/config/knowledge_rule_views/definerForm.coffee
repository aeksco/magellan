
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

  addCondition: ->
    console.log 'ADD CONDITION'
    console.log @model
    console.log @collection

    # TODO - not like this :(
    # Integration of Backbone.Relational is a MUST.
    newCondition = new Backbone.Model()
    # @showConditionForm(newCondition)

  onRender: ->
    console.log 'RENDERD'

    # TODO - get this from the model?
    conditionsCollection = new Backbone.Collection()

    @conditionsRegion.show new ConditionList({ collection: conditionsCollection })

# # # # #

module.exports = DefinerForm
