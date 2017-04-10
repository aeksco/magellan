JsonViewer  = require 'hn_views/lib/json_viewer'
JsonGraph   = require './graph'
TableView   = require './table'
CsvViewer   = require './csvViewer'

# # # # #

class ResultViewer extends require 'hn_views/lib/nav'

  navItems: ->
    items = [
      { icon: 'fa-table',   text: 'Table',  trigger: 'table', default: true }
      { icon: 'fa-code',    text: 'JSON',   trigger: 'json' }
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

  events:
    'mouseover img': 'onImageIn'
    'mouseout img': 'onImageOut'

  onImageIn: (e) =>
    @trigger 'show:underlay'
    return @drift.enable() if @drift
    @drift = new Drift(document.querySelector('img'), {
      containInline: true
      inlinePane: 200
      paneContainer: $('.drift-content')[0] # TODO - overlay should be a region, perhaps?
      zoomFactor: 5
      hoverBoundingBox: true
    })

  onImageOut: (e) =>
    @trigger 'hide:underlay'
    @drift.disable()

# # # # #

class RecordListChild extends Mn.LayoutView
  tagName:    'a'
  className:  'list-group-item'
  template: require './templates/record_list_child'

  behaviors:
    SelectableChild: {}

# # # # #

class RecordListView extends Mn.CollectionView
  tagName:    'ul'
  className:  'list-group record-list-group'
  childView:  RecordListChild

  behaviors:
    KeyboardControls:
      keyEvents:
        37: 'key:left'
        38: 'key:left'
        39: 'key:right'
        40: 'key:right'

  counter: 0
  onKeyLeft: =>
    @counter = @counter - 1
    @counter = 0 if @counter < 0
    console.log @collection
    console.log @counter
    @collection.at(@counter)?.trigger('selected')
    console.log 'onKeyLeft'

  onKeyRight: ->
    console.log 'onKeyRight'
    @counter = @counter + 1
    @counter = @collection.length if @counter > @collection.length
    @collection.at(@counter)?.trigger('selected')

# # # # #

class RecordListLayout extends Mn.LayoutView
  template: require './templates/record_list_layout'
  className: 'row'

  regions:
    listRegion:   '[data-region=list]'
    detailRegion: '[data-region=detail]'

  onRender: -> # TODO - abstract into SelectableList helper?
    listView = new RecordListView({ collection: @collection })
    listView.on 'childview:selected', (view) => @showDataset(view.model)
    @listRegion.show(listView)
    @collection.at(0)?.trigger('selected')

  showDataset: (dataset) ->

    detailView = new RecordChild({ model: dataset })
    @detailRegion.show detailView
    detailView.on 'show:underlay', => $('.drift-underlay').addClass('active')
    detailView.on 'hide:underlay', => $('.drift-underlay').removeClass('active')

# # # # #

module.exports = RecordListLayout
