
RuleList = require './ruleList'
RuleForm = require './ruleForm'

ApplyRulesView = require './applyRules'
ResetRulesView = require './resetRules'

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
    @contentRegion.show new RuleList({ collection: @collection })

  newRule: ->

    # TODO - this doesn't sit right - not a great pattern for
    # creating a new model in this collection
    newRuleModel = new @collection.model({ order: @collection.length + 1 })

    # Instantiates new RuleForm
    ruleForm = new RuleForm({ model: newRuleModel })

    # Shows the RuleForm in @contentRegion
    @contentRegion.show(ruleForm)

  applyRules: ->
    applyView = new ApplyRulesView()

    applyView.on 'cancel', =>
      console.log 'ON CANCEL'
      @showRuleList()

    @contentRegion.show(applyView)

  resetDataset: ->
    console.log 'resetDataset'
    resetView = new ResetRulesView()

    resetView.on 'cancel', =>
      console.log 'ON CANCEL'
      @showRuleList()

    @contentRegion.show(resetView)

# # # # #

module.exports = RuleLayout
