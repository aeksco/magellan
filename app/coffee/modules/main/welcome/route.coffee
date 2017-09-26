LayoutView  = require './views/layout'

# # # # #

class WelcomeRoute extends require 'hn_routing/lib/route'

  title: 'Welcome'

  breadcrumbs: [
    { text: 'Home' }
  ]

  render: ->
    @container.show new LayoutView({ model: @model })

# # # # #

module.exports = WelcomeRoute
