ArchiveForm = require './archiveForm'
JsonForm    = require './jsonForm'

# # # # #

class ImportSelectorView extends require 'hn_views/lib/nav'
  className: 'container'
  template: require './templates/layout'

  navItems: [
    { icon: 'fa-folder-open-o', text: 'Archive',    trigger: 'archive', default: true }
    { icon: 'fa-globe',    text: 'JSON-LD',   trigger: 'json' }
    { icon: 'fa-file', text: 'RDF/XML',    trigger: 'rdf' }
  ]

  navEvents:
    'archive':  'archive'
    'json':     'json'
    'rdf':      'rdf'

  navOptions:
    pills: true

  json: ->
    @contentRegion.show new JsonForm({ model: @model, creator: @options.creator })

  archive: -> # TODO - pass archive importer to this view
    @contentRegion.show new ArchiveForm({ model: @model, creator: @options.creator })

  rdf: ->
    console.log 'RDF'

# # # # #

module.exports = ImportSelectorView
