UploadWidget = require '../../../base/views/upload/upload'

# # # # #

class DestroyDatasetLayout extends Mn.LayoutView
  template: require './templates/layout'
  className: 'container'

  behaviors:
    ModelEvents: {}

    Confirmations:
      message:      'Are you sure you want to destroy this dataset?'
      confirmIcon:  'fa-trash'
      confirmText:  'DESTROY'
      confirmCss:   'btn-danger'

    Flashes:
      success:
        message:  'Successfully reset dataset.'

  ui:
    confirmationTrigger:  '[data-click=confirm]'


  # onConfirmed (from Confirmations behavior)
  # TODO - implement DatasetDestructor class
  # Destroy datapoints, facets, knowledge_rules, viewer_rules, and the dataset.
  onConfirmed: ->
    console.log 'ON CONFIRMED'
    console.log @model
    console.log @options.destructor
    console.log @options.destructor.deploy
    @options.destructor.deploy(@model)

  # TODO - disable submit and cancel buttons
  onRequest: ->
    console.log 'ON REQUEST'

  onSync: ->
    Radio.channel('app').trigger('redirect', '#datasets')

  # TODO - handle error event callbacks
  onError: (err) ->
    console.log 'ERROR'
    console.log err

# # # # #

module.exports = DestroyDatasetLayout
