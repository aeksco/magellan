
# SortableList Behavior definition
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

    # Sets the order on the view's models
    order = 0
    for id, view of @view.children._views
      view.model.set('order', order)

    # Triggers onReorderedCollection method on view class
    @view.triggerMethod('collection:reordered', e)

# # # # #

module.exports = SortableList
