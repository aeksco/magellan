ConditionViewer = require './conditionViewer'

# # # # #

class ConditionEmpty extends Mn.LayoutView
  template: require './templates/condition_empty'
  className: 'list-group-item list-group-item-warning'

# # # # #

class ConditionChild extends Mn.LayoutView
  template: require './templates/condition_child'
  className: 'list-group-item'

  behaviors:
    SortableChild: {}
    SelectableChild: {}

  modelEvents:
    'change:order': 'onReordered'

  onReordered: ->
    @render()

# # # # #

# TODO - collection add and remove events
class ConditionList extends Mn.CollectionView
  className: 'list-group'
  childView: ConditionChild
  emptyView: ConditionEmpty

  behaviors:
    SortableList: {}

  collectionEvents:
    'remove': 'onCollectionRemove'
    'add':    'onCollectionRemove'

  # Resets the selected model in the list
  # When a selected rule has been removed
  onCollectionRemove: ->
    console.log 'COLLECTION CHANGE'
    setTimeout( @reorderCollection, 250 )
    @collection.at(0)?.trigger('selected')

# # # # #

class ConditionLayout extends Mn.LayoutView
  className: 'row'
  template: require './templates/condition_list_layout'

  collectionEvents:
    'add':    'render'
    'remove': 'render'

  regions:
    listRegion:   '[data-region=list]'
    detailRegion: '[data-region=detail]'

  onRender: ->
    @showConditionList()

  showConditionList: ->
    listView = new ConditionList({ collection: @collection })
    listView.on 'childview:selected', (view) => @showConditionViewer(view.model)
    @listRegion.show(listView)
    @collection.at(0)?.trigger('selected')

  showConditionViewer: (model) ->
    conditionViewer = new ConditionViewer({ model: model })
    conditionViewer.on 'edit', (view) => @trigger('edit:condition', view.model)
    @detailRegion.show conditionViewer

# # # # #

module.exports = ConditionLayout
