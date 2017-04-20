require './factory'

SettingsRoute = require './settings/route'
SandboxRoute = require './sandbox/route'
AboutRoute = require './about/route'

# # # # #

# MainRouter class definition
class MainRouter extends require 'hn_routing/lib/router'

  routes:
    'settings(/)':  'settings'
    'sandbox(/)':   'sandbox'
    'about(/)':     'about'

  settings: ->
    new SettingsRoute({ container: @container })

  sandbox: ->
    new SandboxRoute({ container: @container })

  about: ->
    new AboutRoute({ container: @container })

# # # # #

module.exports = MainRouter
