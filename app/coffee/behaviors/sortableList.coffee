
# SortableList Behavior definition
# Works with SortableChild Behavior
class SortableList extends Mn.Behavior

  onRender: ->

    # Initializes Sortable container
    Sortable.create @view.el,
      handle:       @options.handle || '.sortable'
      animation:    @options.animation || 250
      onEnd: (e) => @onSortableEnd(e)

  # onSortableEnd callback
  # Invoked after sorting has completed
  onSortableEnd: (e) ->

    # Triggers order events on CollectionView childView $els
    order = 1
    for el in @view.$el[0].children
      $(el).trigger('sorted',order)
      order++

    # Triggers onReorderedCollection method on view class
    @view.triggerMethod('collection:reordered', e)

# # # # #

module.exports = SortableList
