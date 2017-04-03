
RuleList = require './ruleList'
RuleFormSelector = require './ruleFormSelector'

ApplyRulesView = require './applyRules'
ResetRulesView = require './resetRules'

DefinerForm = require './definerForm'
DecoratorForm = require './decoratorForm'

# # # # #

class RuleLayout extends Mn.LayoutView
  className: 'row'
  template: require './templates/layout'

  ui:
    newRule:  '[data-click=new]'
    apply:    '[data-click=apply]'
    reset:    '[data-click=reset]'

  events:
    'click @ui.newRule':  'showRuleFormSelector'
    'click @ui.apply':    'applyRules'
    'click @ui.reset':    'resetDataset'

  regions:
    contentRegion: '[data-region=content]'

  onRender: ->
    @showRuleList()

  # fetchSourceOptions
  # Fetches the available facet IDs and Labels
  # Used in the 'source' dropdown in the Decorator and Definer Forms
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
    console.log @collection
    ruleList = new RuleList({ collection: @collection })
    ruleList.on 'edit', (ruleModel) => @editRule(ruleModel)
    @contentRegion.show ruleList

  # editRule
  # Shows the correct form to edit the ruleModel parameter
  editRule: (ruleModel) =>
    return @showDefinerForm(ruleModel) if ruleModel.get('type') == 'definer'
    return @showDecoratorForm(ruleModel)

  # showRuleFormSelector
  # Shows the form to select which type of rule
  # the user would like to create
  showRuleFormSelector: ->

    # Instantiates new RuleFormSelector
    ruleForm = new RuleFormSelector()

    # Cancel event callback
    ruleForm.on 'cancel', => @showRuleList()

    # Definer event callback
    ruleForm.on 'new:definer', => @showDefinerForm()

    # Decorator event callback
    ruleForm.on 'new:decorator', => @showDecoratorForm()

    # Shows the RuleForm in @contentRegion
    @contentRegion.show(ruleForm)

  # TODO - this method should live on the collection, rather than in this view.
  # TODO - this should REALLY be abstracted into a factory method that accepts TYPE and DATASET_ID attributes
  buildNewRule: (type) ->
    params =
      id:         window.buildUniqueId('kn_')
      order:      @collection.length + 1
      type:       type
      dataset_id: @model.id

    return new @collection.model(params)

  # showDecoratorForm
  # Shows the form to create or edit a Decorator rule instance
  showDecoratorForm: (model) ->

    # Gets model to pass into DecoratorForm
    formModel = model || @buildNewRule('decorator')

    # Fetches SourceOptions
    @fetchSourceOptions().then (sourceOptions) =>

      # Instantiates new FormView instance
      formView = new DecoratorForm({ model: formModel, sourceOptions: sourceOptions })

      # Shows the DecoratorForm
      @showRuleForm(formView)

  # showDefinerForm
  # Shows the form to create or edit a Definer rule instance
  showDefinerForm: (model) ->

    # Gets model to pass into DefinerForm
    formModel = model || @buildNewRule('definer')

    # Fetches SourceOptions
    @fetchSourceOptions().then (sourceOptions) =>

      # Instantiates new DefinerForm instance
      formView = new DefinerForm({ model: formModel, collection: formModel.get('conditions'), sourceOptions: sourceOptions })

      # Shows the DefinerForm
      @showRuleForm(formView)

  # showRuleForm
  # Shows either a Definer or Decorator form view
  # Defines event listeners and callbacks shared between both forms
  showRuleForm: (formView) ->

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
    applyView = new ApplyRulesView({ model: @model })
    applyView.on 'cancel', => @showRuleList()
    @contentRegion.show(applyView)

  # resetDataset
  # Shows the view to reset the dataset to it's default raw values
  resetDataset: ->
    resetView = new ResetRulesView({ model: @model })
    resetView.on 'cancel', => @showRuleList()
    @contentRegion.show(resetView)

# # # # #

module.exports = RuleLayout
