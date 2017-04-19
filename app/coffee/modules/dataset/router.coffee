require './factory'
require './creator'

ListRoute     = require './list/route'
SearchRoute   = require './search/route'
ConfigRoute   = require './config/route'
NewRoute      = require './new/route'
ExportRoute   = require './export/route'

# # # # #

# TODO - edit route
# TODO - knowledge graph for each dataset?
class DatasetRouter extends require 'hn_routing/lib/router'

  routes:
    '(/)':                      'list' # ROOT
    'datasets(/)':              'list'
    'datasets/:id/search(/)':   'search'
    'datasets/:id/config(/)':   'config'
    'datasets/:id/analysis(/)': 'analysis'
    'datasets/new(/)':          'new'

  list: ->
    new ListRoute({ container: @container })

  search: (id) ->
    new SearchRoute({ container: @container, id: id })

  config: (id) ->
    new ConfigRoute({ container: @container, id: id })

  analysis: (id) ->
    new ExportRoute({ container: @container, id: id })

  new: ->
    new NewRoute({ container: @container })

# # # # #

module.exports = DatasetRouter
