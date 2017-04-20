require './factory'
require './creator'

ListRoute     = require './list/route'
SearchRoute   = require './search/route'
ConfigRoute   = require './config/route'
NewRoute      = require './new/route'
EditRoute     = require './edit/route'
ExportRoute   = require './export/route'

# # # # #

class DatasetRouter extends require 'hn_routing/lib/router'

  routes:
    '(/)':                      'list' # ROOT
    'datasets(/)':              'list'
    'datasets/:id/search(/)':   'search'
    'datasets/:id/config(/)':   'config'
    'datasets/:id/export(/)':   'export'
    'datasets/:id/edit(/)':     'edit'
    'datasets/new(/)':          'new'

  list: ->
    new ListRoute({ container: @container })

  search: (id) ->
    new SearchRoute({ container: @container, id: id })

  config: (id) ->
    new ConfigRoute({ container: @container, id: id })

  export: (id) ->
    new ExportRoute({ container: @container, id: id })

  edit: (id) ->
    new EditRoute({ container: @container, id: id })

  new: ->
    new NewRoute({ container: @container })

# # # # #

module.exports = DatasetRouter
