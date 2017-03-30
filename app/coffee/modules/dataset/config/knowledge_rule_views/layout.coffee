
# Swaps models at supplied indicies & resets collection
# TODO - rather than swapping indicies we should just PUSH the list accordingly.
swapIndicies = (collection, oldIndex, newIndex) ->

  # Swaps model indicies
  collection.at(oldIndex).set('order', newIndex)
  collection.at(newIndex).set('order', oldIndex)

# # # # #

class RuleForm extends Mn.LayoutView
  className: 'modal-content'
  template: require './templates/krule_form'

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

class RuleChild extends Mn.LayoutView
  template: require './templates/krule_child'
  className: 'list-group-item'

  behaviors:
    ModelEvents: {}
    SelectableChild: {}

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
    # @model.save()

  onRender: ->
    Backbone.Syphon.deserialize( @, @model.attributes )
    @ui.checkbox.bootstrapSwitch({ size: 'small', onText: 'Enabled', offText: 'Disabled' })

  onSortableEnd: (e, ev) ->
    # TODO - return if ev.oldIndex / newIndex == undefined
    # TODO - don't SWAP indicies. Rather, we should INSERT AT INDEX
    swapIndicies(@model.collection, ev.oldIndex, ev.newIndex)

  onOrderChange: ->
    # @model.save()

  showEditModal: ->
    formView = new RuleForm({ model: @model })
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

class RuleList extends Mn.CompositeView
  className: 'list-group'
  template: require './templates/krule_list'
  childView: RuleChild

  onRender: ->

    # Initializes Sortable container
    Sortable.create @el,
      handle: '.handle'
      animation: 250
      onEnd: (e) => $(e.item).trigger('sortable:end', e)

# # # # #

class RuleDetail extends Mn.LayoutView
  className: 'card card-block'
  template: require './templates/rule_detail'

# # # # #

class RuleEditor extends require 'hn_views/lib/nav'
  className: 'row'

  navItems: [
    { icon: 'fa-cube',       text: 'Rule',       trigger: 'rule', default: true }
    { icon: 'fa-cubes',  text: 'Conditions', trigger: 'conditions' }
  ]

  navEvents:
    'rule':       'showRuleForm'
    'conditions': 'showConditionsForm'

  showRuleForm: ->
    @contentRegion.show new RuleDetail({ model: @model })

  showConditionsForm: ->
    console.log 'showConditionsForm'

# # # # #

class RuleLayout extends Mn.LayoutView
  className: 'card card-block'
  template: require './templates/layout'

  ui:
    newModel: '[data-click=new-model]'

  events:
    'click @ui.newModel': 'newModel'

  collectionEvents:
    'add':    'render'
    'remove': 'render'

  regions:
    listRegion:   '[data-region=list]'
    detailRegion: '[data-region=detail]'

  newModel: ->
    newModelParams = { order: @collection.length + 1 }
    @collection.add({}, { parse: true })

  onRender: ->
    listView = new RuleList({ collection: @collection })
    listView.on 'childview:selected', (view) => @showDetail(view.model)
    @listRegion.show(listView)
    @collection.at(0)?.trigger('selected')

  showDetail: (model) ->
    @detailRegion.show new RuleEditor({ model: model })

# # # # #

module.exports = RuleLayout
