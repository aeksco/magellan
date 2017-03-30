
RuleList = require './ruleList'
RuleFormSelector = require './ruleFormSelector'

ApplyRulesView = require './applyRules'
ResetRulesView = require './resetRules'

DefinerForm = require './definerForm'
DecoratorForm = require './decoratorForm'

# # # # #

class RuleLayout extends Mn.LayoutView
  className: 'card card-block'
  template: require './templates/layout'

  ui:
    newRule:  '[data-click=new]'
    apply:    '[data-click=apply]'
    reset:    '[data-click=reset]'

  events:
    'click @ui.newRule':  'newRule'
    'click @ui.apply':    'applyRules'
    'click @ui.reset':    'resetDataset'

  regions:
    contentRegion: '[data-region=content]'

  onRender: ->
    @showRuleList()

  showRuleList: ->
    # TODO - add 'EDIT' event for RuleList
    ruleList = new RuleList({ collection: @collection })
    @contentRegion.show ruleList

  newRule: ->

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
  buildNewRule: (type) ->
    return new @collection.model({ order: @collection.length + 1, type: type })

  # TODO - these two methods have a lot of repetition
  # This should be simplified as a helper method
  showDecoratorForm: ->
    model = @buildNewRule('decorator')
    formView = new DecoratorForm({ model: model })
    formView.on 'cancel', => @showRuleList()
    formView.on 'submit', => console.log 'SUBMIT RULE FORM'
    @contentRegion.show formView

  # TODO - these two methods have a lot of repetition
  # This should be simplified as a helper method
  showDefinerForm: ->
    model = @buildNewRule('definer')
    formView = new DefinerForm({ model: model })
    formView.on 'cancel', => @showRuleList()
    formView.on 'submit', => console.log 'SUBMIT RULE FORM'
    @contentRegion.show formView

  applyRules: ->
    applyView = new ApplyRulesView()
    applyView.on 'cancel', => @showRuleList()
    @contentRegion.show(applyView)

  resetDataset: ->
    resetView = new ResetRulesView()
    resetView.on 'cancel', => @showRuleList()
    @contentRegion.show(resetView)

# # # # #

module.exports = RuleLayout
