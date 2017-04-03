
class ResetRulesView extends Mn.LayoutView
  template: require './templates/reset_rules'
  className: 'row'

  behaviors:
    CancelButton: {}
    SubmitButton: {}

  onCancel: ->
    @trigger 'cancel'

  onSubmit: ->
    console.log 'ON SUBMIT'
    console.log @model
    @model.fetchDatapoints().then (datapoints) =>
      console.log 'FETCHED'

      datapoints.resetDataFromRaw().then () =>
        console.log 'RESET ALL'

# # # # #

module.exports = ResetRulesView
