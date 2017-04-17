
class ApplyRulesView extends Mn.LayoutView
  template: require './templates/analysis'
  className: 'card card-block'

  behaviors:
    DownloadFile: {}

    Confirmations:
      message:      'Are you sure you want to export this dataset?'
      confirmIcon:  'fa-cloud-download'
      confirmText:  'Export'
      confirmCss:   'btn-success'

    Flashes:
      success:
        message:  'Successfully exported dataset for analysis.'

  ui:
    confirmationTrigger:  '[data-click=export]'

  # Generates unique filename for the KnowledgeRule export
  generateFilename: ->
    label = @model.get('label')
    label = label.toLowerCase().replace(/\s/g, '_')
    date  = new Date().toJSON().slice(0,10).replace(/-/g, '_')
    filename = [label, '_magellan_analysis_export_', date, '.json' ]
    return filename.join('')

  onConfirmed: ->

    # TODO - disable Submit button
    # @disableSubmit()

    # Shows 'Exporting' message
    Backbone.Radio.channel('loading').trigger('show', "Exporting #{@model.get('label')}...")

    # Fetches datapoints
    # TODO - datapoints should be sorted by some arbitrary attribute, @id?
    @model.fetchDatapoints().then (datapoints) =>

      # Knowledge-Enhanced Export
      jsonExport = datapoints.pluck('data')

      # Raw Export
      # TODO - option to export 'raw' archive
      # jsonExport = datapoints.pluck('raw')

      # Filename and filetype
      filename  = @generateFilename()
      filetype  = 'applicaton/json'

      # Downloads File
      @downloadFile({ content: JSON.stringify(jsonExport, null, 2), type: filetype, filename: filename })

      # Hides loading element
      Backbone.Radio.channel('loading').trigger('hide')

      # Shows success message
      @flashSuccess()

# # # # #

module.exports = ApplyRulesView
