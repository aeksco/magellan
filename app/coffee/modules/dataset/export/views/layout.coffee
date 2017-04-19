
class ApplyRulesView extends Mn.LayoutView
  template: require './templates/export'
  className: 'container'

  behaviors:
    DownloadFile: {}
    Flashes:
      success:
        message:  'Successfully exported dataset for analysis.'

  ui:
    exportJSON: '[data-export=json]'
    exportCSV:  '[data-export=csv]'

  events:
    'click @ui.exportJSON': 'exportJSON'
    'click @ui.exportCSV':  'exportCSV'

  # Generates unique filename for the KnowledgeRule export
  generateFilename: (extension) ->
    label = @model.get('label')
    label = label.toLowerCase().replace(/\s/g, '_')
    date  = new Date().toJSON().slice(0,10).replace(/-/g, '_')
    filename = [label, '_magellan_analysis_export_', date, '.', extension ]
    return filename.join('')

  preExport: ->

    # Shows 'Exporting' message
    Backbone.Radio.channel('loading').trigger('show', "Exporting #{@model.get('label')}...")

  postExport: ->

    # Hides loading element
    Backbone.Radio.channel('loading').trigger('hide')

    # Shows success message
    @flashSuccess()

  exportJSON: ->
    @preExport()

    # Fetches datapoints
    # TODO - datapoints should be sorted by some arbitrary attribute, @id?
    @model.fetchDatapoints().then (datapoints) =>

      # Filename and filetype
      filename  = @generateFilename('json')
      filetype  = 'application/json'

      # Downloads File
      @downloadFile({ content: JSON.stringify(datapoints.pluck('data'), null, 2), type: filetype, filename: filename })
      @postExport()

  # TODO - this should be mostly be contained inside a model method
  exportCSV: ->

    # Shows 'Exporting' message
    Backbone.Radio.channel('loading').trigger('show', "Exporting #{@model.get('label')}...")

    # Fetches datapoints
    # TODO - datapoints should be sorted by some arbitrary attribute, @id?
    @model.fetchDatapoints().then (datapoints) =>

      # Knowledge-Enhanced Export
      jsonExport = datapoints.pluck('data')

      # Gathers keys for CSV
      allKeys = []
      allKeys = _.union(allKeys, _.keys(el) ) for el in jsonExport
      allKeys = _.uniq(allKeys)

      # CSV Out
      csvOut = []

      # CSV Header
      csvOut.push(allKeys.join(', '))

      # CSV Rows
      for el in jsonExport
        row = []
        row.push(el[header]|| ' ') for header in allKeys
        csvOut.push(row.join(', '))

      # Filename and filetype
      filename  = @generateFilename('csv')
      filetype  = 'text/csv'

      # Downloads File
      @downloadFile({ content: csvOut.join('\n'), type: filetype, filename: filename })
      @postExport()

# # # # #

module.exports = ApplyRulesView
