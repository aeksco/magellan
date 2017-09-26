
# HeaderView class definition
# Defines a simbple view for displaying the
# header of the application. The header displays
# the authenticated user and
# manages toggling the SidebarComponent's view
class HeaderView extends Marionette.LayoutView
  template: require './templates/header'
  tagName: 'nav'
  className: 'nav navbar navbar-static-top navbar-light'

# # # # #

module.exports = HeaderView
