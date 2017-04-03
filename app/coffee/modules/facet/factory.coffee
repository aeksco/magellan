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
    'facet destroy':    'destroyModel'

  initialize: ->
    @cachedCollection = new Entities.Collection()

# # # # #

module.exports = new FacetFactory()
