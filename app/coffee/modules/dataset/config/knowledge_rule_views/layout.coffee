
RuleList = require './ruleList'
RuleForm = require './ruleForm'

# # # # #

class RuleDetail extends Mn.LayoutView
  className: 'card card-block'
  template: require './templates/rule_detail'

# # # # #

class RuleEditor extends require 'hn_views/lib/nav'
  className: 'col-xs-12'

  navItems: [
    { icon: 'fa-cube',       text: 'Rule',       trigger: 'rule', default: true }
    { icon: 'fa-cubes',  text: 'Conditions', trigger: 'conditions' }
  ]

  navEvents:
    'rule':       'showRuleForm'
    'conditions': 'showConditionsForm'

  showRuleForm: ->
    @contentRegion.show new RuleDetail({ model: @model })

  showConditionsForm: ->
    console.log 'showConditionsForm'

# # # # #

class RuleLayout extends Mn.LayoutView
  className: 'card card-block'
  template: require './templates/layout'

  ui:
    newRule: '[data-click=new-rule]'

  events:
    'click @ui.newRule': 'newRule'

  # TODO - do we need these events?
  collectionEvents:
    'add':    'render'
    'remove': 'render'

  regions:
    listRegion:   '[data-region=list]'
    detailRegion: '[data-region=detail]'

  newRule: ->

    # TODO - this doesn't sit right - not a great pattern for
    # creating a new model in this collection
    newRuleModel = new @collection.model({ order: @collection.length + 1 })
    console.log newRuleModel

    # Instantiates new RuleForm
    ruleForm = new RuleForm({ model: newRuleModel })

    # Shows the RuleForm in @detailRegion
    @detailRegion.show(ruleForm)

  onRender: ->
    listView = new RuleList({ collection: @collection })
    listView.on 'childview:selected', (view) => @showDetail(view.model)
    @listRegion.show(listView)
    @collection.at(0)?.trigger('selected')

  showDetail: (model) ->
    @detailRegion.show new RuleEditor({ model: model })

# # # # #

module.exports = RuleLayout
