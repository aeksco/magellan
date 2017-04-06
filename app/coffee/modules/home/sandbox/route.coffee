# WIZE NRG
LayoutView  = require './views/layout'

# # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # #

class SandboxRoute extends require 'hn_routing/lib/route'

  title: 'Sandbox'

  breadcrumbs: [
    { href: '#', text: 'Home' }
    { text: 'Sandbox' }
  ]

  render: ->
    @container.show new LayoutView()

# # # # #

module.exports = SandboxRoute
