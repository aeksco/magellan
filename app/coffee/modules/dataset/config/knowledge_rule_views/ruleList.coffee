
RuleForm = require './ruleForm'

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
  childView: RuleEmpty

  onRender: ->

    # Initializes Sortable container
    Sortable.create @el,
      handle: '.handle'
      animation: 250
      onEnd: (e) => $(e.item).trigger('sortable:end', e)

# # # # #

module.exports = RuleList
