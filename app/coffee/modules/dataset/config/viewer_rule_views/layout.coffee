Marionette = require 'backbone.marionette'

# # # # #

class ViewerRuleLayout extends Marionette.LayoutView
  template: require './templates/layout'
  className: 'container-fluid'

  # regions:
  #   fooRegion: '[data-region=foo]'
  #   barRegion: '[data-region=bar]'

  # onShow: ->
  #   # @fooRegion.show
  #   # @barRegion.show

# # # # #

module.exports = ViewerRuleLayout
