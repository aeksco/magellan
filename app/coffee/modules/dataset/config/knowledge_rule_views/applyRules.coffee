
class ApplyRulesView extends Mn.LayoutView
  template: require './templates/apply_rules'
  className: 'row'

  behaviors:
    CancelButton: {}
    SubmitButton: {}

  onCancel: ->
    @trigger 'cancel'

  onSubmit: ->
    @disableSubmit()
    @disableCancel()

    @model.fetchDatapoints().then (datapoints) =>
      console.log 'FETCHED DATAPOINTS'
      console.log datapoints

      @model.fetchKnowledgeRules().then (rules) =>
        console.log 'FETCHED RULES'
        console.log rules

        rules.applyRules(datapoints)

# # # # #

module.exports = ApplyRulesView
