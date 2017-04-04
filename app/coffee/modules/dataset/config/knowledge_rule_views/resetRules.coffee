
class ResetRulesView extends Mn.LayoutView
  template: require './templates/reset_rules'
  className: 'card card-block'

  behaviors:
    CancelButton: {}

    Confirmations:
      message:      'Are you sure you want to reset this dataset?'
      confirmIcon:  'fa-refresh'
      confirmText:  'RESET'
      confirmCss:   'btn-danger'

    Flashes:
      success:
        message:  'Successfully reset dataset.'

  ui:
    confirmationTrigger:  '[data-click=submit]'

  onCancel: ->
    @trigger 'cancel'

  onConfirmed: ->
    @model.fetchDatapoints().then (datapoints) =>

      datapoints.resetDataFromRaw().then () =>

        @model.regenerateFacets().then () =>

          # Shows success message
          @flashSuccess()

          # Triggers 'success' event
          @trigger('success')

# # # # #

module.exports = ResetRulesView
