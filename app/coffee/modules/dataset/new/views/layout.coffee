Marionette = require 'backbone.marionette'

# # # # #

# TODO - abstract into Henson
class UploadWidget extends Mn.LayoutView
  template: require './templates/upload'
  className: 'form-group'

  events:
    'change input[type=file]': 'onInputChange'

  onInputChange: (e) ->

    # Cache e.target
    file = e.target.files[0]

    # Return without a file
    return unless file

    # Parse text inside input file
    fileReader = new FileReader()
    fileReader.onload = => @onFileLoaded(fileReader.result)
    fileReader.readAsText(file)

  # On Uploaded callback
  # Parses JSON from text and sends to parent view
  onFileLoaded: (text) ->
    parsed = JSON.parse(text)
    @trigger 'parse', parsed

# # # # #

class NewDatasetLayout extends Mn.LayoutView
  template: require './templates/layout'
  className: 'container'

  behaviors:
    ModelEvents: {}
    SubmitButton: {}

  regions:
    uploadRegion: '[data-region=upload]'

  onRender: ->
    uploadWidget = new UploadWidget()
    uploadWidget.on 'parse', @onJsonUpload # TODO
    @uploadRegion.show uploadWidget
    @disableSubmit()

  # onJsonUpload
  # Invoked as a callback when a JSON file has
  onJsonUpload: (parsedJson) =>
    # Sets context and graph attributes on dataset model
    @model.set('context', parsedJson['@context'])

    # TODO - is there a better way to manage this?
    # We'll need some additional logic to manage the state of the uploaded dataset
    @uploadedGraph = parsedJson['@graph']

    # Enables submitButton
    # TODO - there should be a validate method that manages submitButton state
    @enableSubmit()

  # onSubmit (from SubmitButton behavior)
  onSubmit: ->

    # TODO - this should be abstracted into a behavior...or has it been at some point?
    data = Backbone.Syphon.serialize(@)

    # Saves Dataset model to Dexie
    @model.set(data)
    @options.creator.deploy(@model, @uploadedGraph)

  onSync: ->
    Radio.channel('app').trigger('redirect', '#datasets')

  # TODO - handle error event callbacks
  onError: (err) ->
    console.log 'ERROR'
    console.log err

# # # # #

module.exports = NewDatasetLayout
