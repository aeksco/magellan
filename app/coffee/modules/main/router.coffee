require './factory'

WelcomeRoute = require './welcome/route'
SettingsRoute = require './settings/route'
AboutRoute = require './about/route'

# # # # #

# MainRouter class definition
class MainRouter extends require 'hn_routing/lib/router'

  routes:
    '(/)':          'welcome'
    'settings(/)':  'settings'
    'about(/)':     'about'

  welcome: ->
    new WelcomeRoute({ container: @container })

  settings: ->
    new SettingsRoute({ container: @container })

  about: ->
    new AboutRoute({ container: @container })

# # # # #

module.exports = MainRouter
