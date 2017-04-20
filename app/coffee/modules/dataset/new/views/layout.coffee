UploadWidget = require '../../../base/views/upload/upload'

# # # # #

class NewDatasetLayout extends Mn.LayoutView
  template: require './templates/layout'
  className: 'container'

  behaviors:
    ModelEvents: {}
    SubmitButton: {}

  regions:
    uploadRegion: '[data-region=upload]'

  ui:
    dirInput: '[name=dir]'

  events:
    'change @ui.dirInput': 'onDirChange'

  onRender: ->
    uploadWidget = new UploadWidget()
    uploadWidget.on 'file:loaded', @onJsonUpload # TODO
    @uploadRegion.show uploadWidget
    @disableSubmit()

  # # # # #

  # TODO - this should be abstracted into a separate view
  # TODO - this should leverage the same code present in the crawl script
  onDirChange: (e) ->
    # console.log e
    # console.log e.target
    # console.log e.target.files

    graph = []

    for f in e.target.files

      # console.log f

      el = {
        '@id':              f.webkitRelativePath
        'nfo:size':         f.size
        'rdf:label':        f.name
        'nfo:type':         f.type || 'nfo:Document'
        'nfo:lastModified': f.lastModified
      }

      graph.push(el)

    console.log graph

  # # # # #

  # onJsonUpload
  # Invoked as a callback when a JSON file has
  onJsonUpload: (uploadedText) =>

    # Parses JSON from upload
    parsedJson = JSON.parse(uploadedText)

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
