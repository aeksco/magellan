require './factory'

SettingsRoute = require './settings/route'
SandboxRoute = require './sandbox/route'
AboutRoute = require './about/route'

# # # # #

# HomeRouter class definition
class HomeRouter extends require 'hn_routing/lib/router'

  routes:
    'rdf(/)':       'rdfViewer'
    'settings(/)':  'settings'
    'sandbox(/)':   'sandbox'
    'about(/)':     'about'

  rdfViewer: ->
    new RDFRoute({ container: @container })

  settings: ->
    new SettingsRoute({ container: @container })

  sandbox: ->
    new SandboxRoute({ container: @container })

  about: ->
    new AboutRoute({ container: @container })

# # # # #

module.exports = HomeRouter
