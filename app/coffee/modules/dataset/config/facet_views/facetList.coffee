
class FacetChild extends Mn.LayoutView
  template: require './templates/facet_child'

  className: ->
    css = ['list-group-item']
    css.push('list-group-item-success') if @model.get('enabled')
    css.push('list-group-item-warning') if not @model.get('enabled')
    return css.join(' ')

  behaviors:
    ModelEvents: {}
    SelectableChild: {}
    SortableChild: {}

  modelEvents:
    'change:order': 'onReordered'
    'sync':         'render'

  onReordered: ->
    @model.save()

# # # # #

class FacetList extends Mn.CollectionView
  className: 'list-group'
  childView: FacetChild

  behaviors:
    SortableList: {}

# # # # #

module.exports = FacetList
