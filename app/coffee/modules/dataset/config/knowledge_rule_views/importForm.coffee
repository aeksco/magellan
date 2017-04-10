
class ImportForm extends Mn.LayoutView
  template: require './templates/import_form'
  className: 'card card-block'

  behaviors:
    CancelButton: {}
    SubmitButton: {}
    DownloadFile: {}
    Flashes:
      success:
        message:  'Successfully imported Knowledge Rules.'

  onCancel: ->
    @trigger 'cancel'

  onSubmit: ->
    console.log 'ON SUBMIT'

    @model.fetchKnowledgeRules().then (knowledgeRuleCollection) =>

      #
      console.log 'FETCHED EXISTING KNOWLEDGE RULES'

      # # Content and filename
      # content   = JSON.stringify(knowledgeRuleCollection.toJSON(), null, 2)
      # filename  = @generateFilename()
      # filetype  = 'applicaton/json'

      # # Downloads file (DownloadFile behavior)
      # @downloadFile({ content: content, type: filetype, filename: filename })

      # # Shows success message
      # @flashSuccess()

      # # Triggers 'success' event
      # @trigger('success')

# # # # #

module.exports = ImportForm
