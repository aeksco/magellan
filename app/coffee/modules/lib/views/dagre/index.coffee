
class DagreGraph extends Mn.LayoutView
  template: require './templates/dagre'
  className: 'row'

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

module.exports = DagreGraph
