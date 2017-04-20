LayoutView  = require './views/layout'

# # # # #

class AboutRoute extends require 'hn_routing/lib/route'

  title: 'Magellan - About'

  breadcrumbs: [{ text: 'About' }]

  render: ->
    @container.show new LayoutView()

# # # # #

module.exports = AboutRoute
