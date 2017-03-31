Entities = require './entities'
DexieFactory  = require '../base/dexieFactory'

# # # # #

class FacetFactory extends DexieFactory

  # Defines tableName
  tableName: 'facets'

  # Defines radioRequests
  radioRequests:
    'facet collection': 'getCollection'
    'facet save':       'saveModel'

  initialize: ->
    @cachedCollection = new Entities.Collection()

# # # # #

module.exports = new FacetFactory()
