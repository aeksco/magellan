FacetLayout = require '../facet_views/layout'
RuleLayout  = require '../knowledge_rule_views/layout'

# # # # #

class ConfigLayoutView extends require 'hn_views/lib/nav'
  className: 'container-fluid'
  # template: require './templates/layout'

  navItems: [
    { icon: 'fa-table',   text: 'Facets',  trigger: 'facets', default: true }
    { icon: 'fa-university',    text: 'Knowledge Rules',   trigger: 'knowledge' }
  ]

  navEvents:
    'facets':     'facetConfig'
    'knowledge':  'knowledgeConfig'

  # navOptions:
  #   stacked: true

  facetConfig: ->
    @model.fetchFacets().then (facetCollection) =>
      @contentRegion.show new FacetLayout({ collection: facetCollection })

  knowledgeConfig: ->
    @model.fetchKnowledgeRules().then (ruleCollection) =>
      @contentRegion.show new RuleLayout({ collection: ruleCollection })

# # # # #

module.exports = ConfigLayoutView
