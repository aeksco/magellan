
RuleViewer = require './ruleViewer'

# # # # #

# Swaps models at supplied indicies & resets collection
# TODO - rather than swapping indicies we should just PUSH the list accordingly.
swapIndicies = (collection, oldIndex, newIndex) ->

  # Swaps model indicies
  collection.at(oldIndex).set('order', newIndex)
  collection.at(newIndex).set('order', oldIndex)

# # # # #

class RuleEmpty extends Mn.LayoutView
  template: require './templates/rule_empty'
  className: 'list-group-item list-group-item-warning'

# # # # #

class RuleChild extends Mn.LayoutView
  template: require './templates/rule_child'
  className: 'list-group-item'

  behaviors:
    SelectableChild: {}
    Tooltips: {}

  events:
    'sortable:end': 'onSortableEnd'

  modelEvents:
    'change:order': 'onOrderChange'

  onSortableEnd: (e, ev) ->
    # TODO - return if ev.oldIndex / newIndex == undefined
    # TODO - don't SWAP indicies. Rather, we should INSERT AT INDEX
    swapIndicies(@model.collection, ev.oldIndex, ev.newIndex)

  onOrderChange: ->
    # @model.save()

# # # # #

class RuleList extends Mn.CompositeView
  className: 'list-group'
  template: require './templates/rule_list'
  childView: RuleChild
  emptyView: RuleEmpty

  behaviors:
    SortableList: {}

  onCollectionReordered: =>
    console.log 'ON REORDERED'

# # # # #

class RuleLayout extends Mn.LayoutView
  className: 'row'
  template: require './templates/rule_list_layout'

  # TODO - do we need these events?
  collectionEvents:
    'add':    'render'
    'remove': 'render'

  regions:
    listRegion:   '[data-region=list]'
    detailRegion: '[data-region=detail]'

  onRender: ->
    listView = new RuleList({ collection: @collection })
    window.listView = listView
    listView.on 'childview:selected', (view) => @showDetail(view.model)
    @listRegion.show(listView)
    @collection.at(0)?.trigger('selected')

  showDetail: (model) ->
    ruleViewer = new RuleViewer({ model: model })
    ruleViewer.on 'edit', (view) => @trigger('edit', view.model)
    @detailRegion.show ruleViewer

# # # # #

module.exports = RuleLayout
