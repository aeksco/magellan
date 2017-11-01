
class GraphDatasetLayout extends Mn.LayoutView
  template: require './templates/layout'
  className: 'container'

  # # # # #

  # TODO - abstract this into a separate view class
  onRender: ->
    elements = {
    	nodes: []
    	edges: []
    }

    @model.fetchDatapoints().then (datapoints) =>

      datapoints = datapoints.pluck('data')

      _.each(datapoints, (n) =>
        elements.nodes.push({ data: { id: n['@id'], label: n['rdfs:label'] } })
        for k, v of n
        	if _.isObject(v) && v['@id'] && v['@id'] != 'root'
        		elements.edges.push({ data: { source: n['@id'], target: v['@id'] } })
      )

      console.log elements

      # Renders the graph elements
      @renderGraph(elements)

  renderGraph: (elements) ->
    cy = window.cytoscape({
      container: document.getElementById('cy'),

      boxSelectionEnabled: false,
      autounselectify: true,

      layout: {
        name: 'dagre'
        nodeSep: 10, # the separation between adjacent nodes in the same rank
        edgeSep: 50, # the separation between adjacent edges in the same rank
        rankSep: 200, # the separation between adjacent nodes in the same rank
        rankDir: 'BT', # 'TB' for top to bottom flow, 'LR' for left to right,
      },

      style: [
        {
          selector: 'node',
          style: {
            'content': 'data(id)',
            'text-opacity': 0.5,
            'text-valign': 'center',
            'text-halign': 'right',
            'background-color': '#11479e'
          }
        },

        {
          selector: 'edge',
          style: {
            'curve-style': 'bezier',
            'width': 4,
            'target-arrow-shape': 'triangle',
            'line-color': '#9dbaea',
            'target-arrow-color': '#9dbaea'
          }
        }
      ],

      elements: elements
    })

# # # # #

module.exports = GraphDatasetLayout
