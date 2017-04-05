JsonViewer  = require 'hn_views/lib/json_viewer'
JsonGraph   = require './graph'
TableView   = require './table'
CsvViewer   = require './csvViewer'

# # # # #

class ResultViewer extends require 'hn_views/lib/nav'

  navItems: ->
    items = [
      { icon: 'fa-table',   text: 'Table',  trigger: 'table', default: true }
      { icon: 'fa-code',    text: 'JSON',   trigger: 'json' } # TODO - disable for DEMO
      { icon: 'fa-sitemap', text: 'Graph',  trigger: 'graph' }
    ]

    # CSV Viewer
    csvViewer = { icon: 'fa-file-excel-o', text: 'CSV',  trigger: 'csv' }
    items.push(csvViewer) if @model.get('views').csv

    return items

  navEvents:
    'table':    'showTable'
    'json':     'showJson'
    'graph':    'showGraph'
    'csv':      'showCsv'

  showTable: ->
    @contentRegion.show new TableView({ model: @model })

  showJson: ->
    @contentRegion.show new JsonViewer({ model: @model })

  showGraph: ->
    @contentRegion.show new JsonGraph({ json: @model.toJSON()['data'] })

  showCsv: ->
    @contentRegion.show new CsvViewer({ model: @model })

# # # # #

class RecordChild extends Mn.LayoutView
  template: require './templates/record_child'
  tagName:    'li'
  className:  'list-group-item'

  regions:
    viewerRegion: '[data-region=viewer]'

  behaviors: ->
    return obj =
      Tooltips: {}
      ClickableRelations: {}
      # CopyToClipboard: { text: @options.model.stringifyJson() }
      Flashes:
        success:
          message:  'Copied JSON to clipboard.'
          timeout:  1000
        error:
          message:  'Error copying JSON to clipboard.'
          timeout:  1000

  # CopyToClipboard behavior callbacks
  onClipboardSuccess: -> @flashSuccess()
  onClipboardError: -> @flashError()

  onRender: ->
    @viewerRegion.show new ResultViewer({ model: @model })

# # # # #

class RecordListView extends Mn.CollectionView
  tagName:    'ul'
  className:  'list-group record-list-group'
  childView:  RecordChild

# # # # #

module.exports = RecordListView
