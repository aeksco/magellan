FacetList = require './facetList'
FacetViewer = require './facetViewer'
FacetForm = require './facetForm'

# # # # #

class FacetListLayout extends Mn.LayoutView
  className: 'row'
  template: require './templates/facet_list_layout'

  regions:
    listRegion:   '[data-region=list]'
    viewerRegion: '[data-region=viewer]'

  onRender: ->
    listView = new FacetList({ collection: @collection })
    listView.on 'childview:selected', (view) => @showFacetViewer(view.model)
    @listRegion.show(listView)
    @collection.at(0)?.trigger('selected')

  showFacetViewer: (facetModel) =>

    # Instantiates new FacetViewer view
    facetViewer = new FacetViewer({ model: facetModel })

    # Defines 'edit' event handler
    facetViewer.on 'edit', (view) => @showFacetEditor(view.model)

    # Shows the FacetViewer in @viewerRegion
    @viewerRegion.show facetViewer

  showFacetEditor: (facetModel) =>

    # Instantiates new FacetForm view
    facetForm = new FacetForm({ model: facetModel })

    # Defines 'cancel' event handler
    facetForm.on 'cancel', (view) => @showFacetViewer(view.model)

    # Defines 'sync' event handler
    facetForm.on 'sync', (view) => @showFacetViewer(view.model)

    # Shows the FacetForm in @viewerRegion
    @viewerRegion.show facetForm

# # # # #

module.exports = FacetListLayout
