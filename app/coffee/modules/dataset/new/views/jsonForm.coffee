UploadWidget = require '../../../base/views/upload/upload'

# # # # #

# TODO - this view should ONLY manage JSON-LD imports
# There should be another view that selects what type of dataset to import (JSON-LD, RDF, Upload)
class NewDatasetLayout extends Mn.LayoutView
  template: require './templates/json_form'
  className: 'row'

  behaviors:
    ModelEvents: {}
    SubmitButton: {}

  regions:
    uploadRegion: '[data-region=upload]'

  onRender: ->
    uploadWidget = new UploadWidget()
    uploadWidget.on 'file:loaded', @onJsonUpload # TODO
    @uploadRegion.show uploadWidget
    @disableSubmit()

  # # # # #

  # onJsonUpload
  # Invoked as a callback when a JSON file has
  onJsonUpload: (uploadedText) =>

    # Parses JSON from upload
    @parsedJson = JSON.parse(uploadedText)

    # Enables submitButton
    # TODO - validations
    @enableSubmit()

  # onSubmit (from SubmitButton behavior)
  onSubmit: ->

    # Serializes form data
    data = Backbone.Syphon.serialize(@)

    # Sets context
    @model.set('context', @parsedJson['@context'])

    # Saves Dataset model to Dexie
    @model.set(data)
    @options.creator.deploy(@model, @parsedJson['@graph'])

  onSync: ->
    Radio.channel('app').trigger('redirect', '#datasets')

  # TODO - handle error event callbacks
  onError: (err) ->
    console.log 'ERROR'
    console.log err

# # # # #

module.exports = NewDatasetLayout
