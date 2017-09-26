
class BreadcrumbChild extends Mn.LayoutView
  tagName: 'li'
  template: require './templates/breadcrumb_child'

  className: ->
    return 'active' unless @model.get('href')

# # # # #

class BreadcrumbList extends Mn.CollectionView
  className: 'breadcrumb'
  tagName: 'ol'
  childView: BreadcrumbChild

  attributes:
    role: 'navigation'

# # # # #

module.exports = BreadcrumbList
