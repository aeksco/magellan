require './factory'

RDFRoute = require './rdf_new/route'
SettingsRoute = require './settings/route'
SandboxRoute = require './sandbox/route'

# # # # #

# HomeRouter class definition
class HomeRouter extends require 'hn_routing/lib/router'

  routes:
    'rdf(/)':       'rdfViewer'
    'settings(/)':  'settings'
    'sandbox(/)':   'sandbox'

  rdfViewer: ->
    new RDFRoute({ container: @container })

  settings: ->
    new SettingsRoute({ container: @container })

  sandbox: ->
    new SandboxRoute({ container: @container })

# # # # #

module.exports = HomeRouter
