KnowledgeRuleLayout = require '../knowledge_rule_views/layout'
KnowledgeRuleForm = require '../knowledge_rule_views/ruleForm'

# # # # #

class RuleForm extends KnowledgeRuleForm
  template: require './templates/rule_form'

  onRender: ->
    Backbone.Syphon.deserialize( @, @model.attributes )
    @showDefinitionList()

# # # # #

class RuleLayout extends KnowledgeRuleLayout
  template: require './templates/layout'

  # showRuleForm
  # Shows the form to create or edit a Definer rule instance
  # RENAME TO - SHOW RULE FORM
  showRuleForm: (model) ->

    # HACK - assigns null if showRuleForm was invoked via jQuery event
    model = null if model.currentTarget

    # Gets model to pass into RuleForm
    formModel = model || @buildNewRule()

    # Fetches SourceOptions
    @fetchSourceOptions().then (sourceOptions) =>

      # Instantiates new RuleForm instance
      formView = new RuleForm({ model: formModel, collection: formModel.get('definitions'), sourceOptions: sourceOptions })

      # Form 'cancel' event handler
      formView.on 'cancel', => @showRuleList()

      # Form 'sync' event handler
      formView.on 'sync', (model) =>

        # Adds new model to the collection
        @collection.add(model)

        # Renders the rule list
        @showRuleList()

      # Shows the form inside the content region
      @contentRegion.show(formView)

# # # # #

module.exports = RuleLayout
