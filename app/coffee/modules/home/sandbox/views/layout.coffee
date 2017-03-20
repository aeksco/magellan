JsonViewer = require 'hn_views/lib/json_viewer'

# # # # #

class TargetChild extends Mn.LayoutView
  className: 'list-group-item'
  template: require './templates/target_child'

  regions:
    jsonRegion: '[data-region=json]'

  onRender: ->
    @jsonRegion.show new JsonViewer({ model: @model })

class TargetCollectionView extends Mn.CollectionView
  className: 'list-group'
  childView: TargetChild

# # # # #

class RuleLayout extends Marionette.LayoutView
  template: require './templates/layout'
  className: 'container-fluid'

  regions:
    listRegion: '[data-region=list]'

  onRender: ->
    @listRegion.show new TargetCollectionView({ collection: @collection })

# # # # #

module.exports = RuleLayout
