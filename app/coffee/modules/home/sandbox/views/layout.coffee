JsonViewer = require 'hn_views/lib/json_viewer'

# # # # #

class TargetChild extends Mn.LayoutView
  className: 'list-group-item'
  template: require './templates/target_child'

  regions:
    jsonRegion: '[data-region=json]'

  onRender: ->
    if @model.get('data')

      if @options.processed
        model = new Backbone.Model(@model.toJSON().data)

      else
        model = new Backbone.Model(@model.toJSON().raw)

    else
      model = @model

    @jsonRegion.show new JsonViewer({ model: model })

class TargetCollectionView extends Mn.CollectionView
  className: 'list-group'
  childView: TargetChild

  childViewOptions: ->
    return { processed: @options.processed }

# # # # #

class RuleLayout extends Marionette.LayoutView
  template: require './templates/layout'
  className: 'row'

  regions:
    listRegion: '[data-region=list]'

  templateHelpers: ->
    return { title: @options.title }

  onRender: ->
    @listRegion.show new TargetCollectionView({ collection: @collection, processed: @options.processed })

# # # # #

class RuleDemoLayout extends require 'hn_views/lib/nav'
  className: 'container-fluid'

  navItems: [
    { icon: 'fa-database',    text: 'Raw Archive',  trigger: 'dataset', default: true }
    { icon: 'fa-university',  text: 'Knowledge Capture',   trigger: 'rules' }
    { icon: 'fa-table',       text: 'Processed Archive',  trigger: 'processed' }
  ]

  navEvents:
    'dataset':    'showDataset'
    'rules':      'showRules'
    'processed':  'showProcessed'

  # navOptions:
  #   stacked: true

  showDataset: ->
    @contentRegion.show new RuleLayout({ collection: @collection, title: 'Raw Archive' })

  showRules: ->
    @contentRegion.show new RuleLayout({ collection: @options.ruleCollection, title: 'Knowledge Capture' })

  showProcessed: ->
    @contentRegion.show new RuleLayout({ collection: @collection, title: 'Processed Archive', processed: true })



# # # # #

module.exports = RuleDemoLayout
