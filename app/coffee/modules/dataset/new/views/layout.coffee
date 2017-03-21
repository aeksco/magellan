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
  className: 'container-fluid'

  behaviors:
    SubmitButton: {}

  regions:
    uploadRegion: '[data-region=upload]'

  onRender: ->
    uploadWidget = new UploadWidget()
    uploadWidget.on 'parse', @onJsonUpload # TODO
    @uploadRegion.show uploadWidget
    @disableSubmit()

  onJsonUpload: (parsedJson) =>
    # Sets context and graph attributes on dataset model
    @model.set('context', parsedJson['@context'])
    # @model.set('graph', parsedJson['@graph'])

    # TODO - best way to manage this?
    @uploadedGraph = parsedJson['@graph']

    @enableSubmit()

  onSubmit: ->
    data    = Backbone.Syphon.serialize(@)
    data.id = data.label.toLowerCase().replace(' ', '_') # TODO - not replacing all? Use Underscore.String
    # @model.set(data)

    console.log @model.toJSON()
    console.log @uploadedGraph
    # @saveToDexie()

    @model.save(data, @uploadedGraph)

  # TODO - abstract into DexieService
  # TODO - should this be abstracted into a Dexie model?
  # Or should the DexieService fire the required events
  # on the Backbone.Model?
  saveToDexie: ->
    window.db['datasets'].add(@model.toJSON())
    .then (model_id) => Backbone.Radio.channel('app').trigger('redirect', '#datasets')

    .catch (err) => console.log 'ERROR CAUGHT'

# # # # #

module.exports = NewDatasetLayout
