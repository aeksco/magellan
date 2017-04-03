
class FacetViewer extends Mn.LayoutView
  template: require './templates/facet_viewer'
  className: 'card card-block'

  ui:
    edit: '[data-click=edit]'
    link: '[data-click=link]'

  triggers:
    'click @ui.edit': 'edit'

  events:
    'click @ui.link': 'linkToOntology'

  linkToOntology: ->
    console.log 'LINK TO ONTOLOGY'
    console.log @model

# # # # #

module.exports = FacetViewer
