RuleList        = require './ruleList'
RuleForm        = require './ruleForm'
ApplyRulesView  = require './applyRules'
ResetRulesView  = require './resetRules'

# # # # #

class RuleLayout extends Mn.LayoutView
  className: 'row'
  template: require './templates/layout'

  ui:
    newRule:  '[data-click=new]'
    apply:    '[data-click=apply]'
    reset:    '[data-click=reset]'

  events:
    'click @ui.newRule':  'showRuleForm'
    'click @ui.apply':    'applyRules'
    'click @ui.reset':    'resetDataset'

  regions:
    contentRegion: '[data-region=content]'

  onRender: ->
    @showRuleList()

  # fetchSourceOptions
  # Fetches the available facet IDs and Labels
  # Used in the 'source' dropdown in the RuleForm
  fetchSourceOptions: ->

    # Returns Promise to manage async operation
    return new Promise (resolve, reject) =>

      # Fetches Facets - used to populate the 'source' dropdown
      @model.fetchFacets().then (facetCollection) =>

        # facets = facetCollection.toJSON()
        # Plucks attributes and labels,
        attrs = facetCollection.pluck('attribute')
        labels = facetCollection.pluck('label')

        # Zips into a two-dimensional array
        sourceOptions = _.zip(attrs, labels)

        # Resolves Promise with sourceOptions
        return resolve(sourceOptions)

  # showRuleList
  # Shows the list of defined rules
  showRuleList: ->
    ruleList = new RuleList({ collection: @collection })
    ruleList.on 'edit', (ruleModel) => @showRuleForm(ruleModel)
    @contentRegion.show ruleList

  # TODO - this method should live on the collection, rather than in this view.
  # TODO - this should REALLY be abstracted into a factory method that accepts TYPE and DATASET_ID attributes
  buildNewRule: ->
    params =
      id:         window.buildUniqueId('kn_')
      order:      @collection.length + 1
      dataset_id: @model.id

    return new @collection.model(params)

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

  # applyRules
  # Shows the view to apply the rules to the dataset
  applyRules: ->
    applyView = new ApplyRulesView({ model: @model, collection: @collection })
    applyView.on 'cancel', => @showRuleList()
    applyView.on 'success', => @showRuleList()
    @contentRegion.show(applyView)

  # resetDataset
  # Shows the view to reset the dataset to it's default raw values
  resetDataset: ->
    resetView = new ResetRulesView({ model: @model, target_object: @collection.target_object })
    resetView.on 'cancel', => @showRuleList()
    resetView.on 'success', => @showRuleList()
    @contentRegion.show(resetView)

# # # # #

module.exports = RuleLayout
