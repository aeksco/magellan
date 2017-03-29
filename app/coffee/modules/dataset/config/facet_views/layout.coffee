
# Swaps models at supplied indicies & resets collection
# TODO - rather than swapping indicies we should just PUSH the list accordingly.
swapIndicies = (collection, oldIndex, newIndex) ->

  # Swaps model indicies
  collection.at(oldIndex).set('order', newIndex)
  collection.at(newIndex).set('order', oldIndex)

  # TODO - better way to handle this?
  # models = collection.models
  # collection.reset(models)

# # # # #

class FacetForm extends Mn.LayoutView
  className: 'modal-content'
  template: require './templates/facet_form'

  templateHelpers: { modalTitle: 'Edit Facet' }

  behaviors:
    SubmitButton: {}

  onSubmit: ->
    data = Backbone.Syphon.serialize(@)
    @model.set(data)
    @trigger 'submitted'
    @trigger 'hide'

  onRender: ->
    Backbone.Syphon.deserialize(@, @model.toJSON())

# # # # #

class FacetChild extends Mn.LayoutView
  template: require './templates/facet_child'
  className: 'list-group-item'

  behaviors:
    ModelEvents: {}

  ui:
    checkbox: 'input[type=checkbox]'
    edit:     '[data-click=edit]'

  events:
    'sortable:end': 'onSortableEnd'
    'switchChange.bootstrapSwitch @ui.checkbox':  'onEnabledChange'
    'click @ui.edit': 'showEditModal'

  modelEvents:
    'change:order': 'onOrderChange'

  onEnabledChange: ->
    @model.set(Backbone.Syphon.serialize(@))
    @model.save()

  onRender: ->
    Backbone.Syphon.deserialize( @, @model.attributes )
    @ui.checkbox.bootstrapSwitch({ size: 'small', onText: 'Enabled', offText: 'Disabled' })

  onSortableEnd: (e, ev) ->
    # TODO - return if ev.oldIndex / newIndex == undefined
    # TODO - don't SWAP indicies. Rather, we should INSERT AT INDEX
    swapIndicies(@model.collection, ev.oldIndex, ev.newIndex)

  onOrderChange: ->
    @model.save()

  showEditModal: ->
    formView = new FacetForm({ model: @model })
    formView.on 'submitted', => @model.save()
    Backbone.Radio.channel('modal').trigger('show', formView)

  # TODO - better
  onRequest: ->
    console.log 'onRequest'

  onSync: ->
    @render()

  onError: ->
    console.log 'onError'

# # # # #

class FacetList extends Mn.CompositeView
  className: 'list-group'
  template: require './templates/facet_list'
  childView: FacetChild

  onRender: ->

    # Initializes Sortable container
    Sortable.create @el,
      handle: '.handle'
      animation: 250
      onEnd: (e) => $(e.item).trigger('sortable:end', e)

# # # # #

module.exports = FacetList
