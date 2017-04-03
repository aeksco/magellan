
class FacetChild extends Mn.LayoutView
  template: require './templates/facet_child'
  className: 'list-group-item' # TODO - context class based off 'enabled' attribute

  behaviors:
    ModelEvents: {}
    SelectableChild: {}
    SortableChild: {}

  modelEvents:
    'change:order': 'onReordered'

  onReordered: ->
    @model.save()

# # # # #

class FacetList extends Mn.CompositeView
  className: 'list-group'
  template: require './templates/facet_list'
  childView: FacetChild

  behaviors:
    SortableList: {}

# # # # #

module.exports = FacetList
