FacetLayout = require '../facet_views/layout'
RuleLayout  = require '../knowledge_rule_views/layout'

# # # # #

class ConfigLayoutView extends require 'hn_views/lib/nav'
  className: 'container-fluid'

  navItems: [
    { icon: 'fa-list',            text: 'Facets',             trigger: 'facets', default: true }
    { icon: 'fa-university',      text: 'Knowledge Rules',    trigger: 'knowledge'}
    { icon: 'fa-window-maximize', text: 'Viewer Rules',       trigger: 'viewer' }
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
    @model.fetchKnowledgeRules().then (ruleCollection) =>
      @contentRegion.show new RuleLayout({ model: @model, collection: ruleCollection })

  viewerConfig: ->
    console.log @model
    @model.fetchViewerRules().then (viewerRuleCollection) =>
      console.log 'FETCHED'
      console.log viewerRuleCollection

# # # # #

module.exports = ConfigLayoutView
