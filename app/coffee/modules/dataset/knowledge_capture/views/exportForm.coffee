
class ExportForm extends Mn.LayoutView
  template: require './templates/export_form'
  className: 'card card-body'

  behaviors:
    CancelButton: {}
    SubmitButton: {}
    DownloadFile: {}
    Flashes:
      success:
        message:  'Successfully exported Knowledge Capture.'

  onCancel: ->
    @trigger 'cancel'

  # Generates unique filename for the KnowledgeRule export
  generateFilename: ->
    label = @model.get('label')
    label = label.toLowerCase().replace(/\s/g, '_')
    date  = new Date().toJSON().slice(0,10).replace(/-/g, '_')
    filename = [label, '_magellan_kn_rules_', date, '.json' ]
    return filename.join('')

  onSubmit: ->
    @model.fetchKnowledgeRules().then (knowledgeRuleCollection) =>

      # Content and filename
      content   = JSON.stringify(knowledgeRuleCollection.toJSON(), null, 2)
      filename  = @generateFilename()
      filetype  = 'applicaton/json'

      # Downloads file (DownloadFile behavior)
      @downloadFile({ content: content, type: filetype, filename: filename })

      # Shows success message
      @flashSuccess()

      # Triggers 'success' event
      @trigger('success')

# # # # #

module.exports = ExportForm
