FacetLayout         = require '../facet_views/layout'
KnowledgeRuleLayout = require '../knowledge_rule_views/layout'
ViewerRuleLayout    = require '../viewer_rule_views/layout'

# # # # #

# TODO - this should be broken up into more granular routes
class ConfigLayoutView extends require 'hn_views/lib/nav'
  className: 'container-fluid'

  navItems: [
    { icon: 'fa-list',            text: 'Facets',             trigger: 'facets', default: true }
    { icon: 'fa-paperclip',       text: 'Knowledge Capture',  trigger: 'knowledge' }
    { icon: 'fa-window-maximize', text: 'Smart Rendering',    trigger: 'viewer' }
  ]

  navEvents:
    'facets':     'facetConfig'
    'knowledge':  'knowledgeConfig'
    'viewer':     'viewerConfig'

  navOptions:
    pills: true

  facetConfig: ->
    @model.fetchFacets().then (facetCollection) =>
      @contentRegion.show new FacetLayout({ collection: facetCollection })

  knowledgeConfig: ->
    @model.fetchKnowledgeRules().then (knowledgeRuleCollection) =>
      @contentRegion.show new KnowledgeRuleLayout({ model: @model, collection: knowledgeRuleCollection })

  viewerConfig: ->
    @model.fetchViewerRules().then (viewerRuleCollection) =>
      @contentRegion.show new ViewerRuleLayout({ model: @model, collection: viewerRuleCollection })

# # # # #

module.exports = ConfigLayoutView
