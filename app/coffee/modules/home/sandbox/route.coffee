LayoutView  = require './views/layout'
require '../../knowledge_rule/factory'

# # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # #

# TODO - this is JUST placeholder
# These could be ANY Backbone models
class TargetModel extends Backbone.Model

class TargetCollection extends Backbone.Collection
  model: TargetModel

targetData = [
  { '@id': 1, '@type': 'Person', firstName: 'John', employer: 'RPI' }
  { '@id': 2, '@type': 'Person', firstName: 'Alex', employer: 'RPI' }
  { '@id': 3, '@type': 'Person', firstName: 'Johnson', employer: 'RPI' }
  { '@id': 4, '@type': 'Person', firstName: 'Anne', employer: 'RPI' }
]

targetCollection = new TargetCollection(targetData)

# # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # #

class SearchSettingsRoute extends require 'hn_routing/lib/route'

  title: 'Sandbox'

  breadcrumbs: [
    { href: '#', text: 'Home' }
    { text: 'Sandbox' }
  ]

  render: ->
    @container.show new LayoutView({ collection: targetCollection })


# # # # #

module.exports = SearchSettingsRoute
