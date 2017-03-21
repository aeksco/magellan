
# TODO - abstract this into a different class?
class DatasetModel extends Backbone.Model
  urlRoot: 'datasets'

  # Default attributes
  # TODO - validations
  defaults:
    id:       ''
    label:    ''
    context:  {}
    # facets:   []  # TODO - GENERATE AFTER SAVE

  getFacet: (ont_id, ont_attr, id, index) ->
    return new Promise (resolve, reject) =>
      Backbone.Radio.channel('ontology').request('attribute', ont_id, ont_attr)
      .then (attribute) =>

        # In ontology attribute is defined (i.e. FOUND)
        if attribute
          label   = attribute['rdfs:label']
          tooltip = attribute['rdfs:comment']

        # Ontology attribute was not found
        # We define placeholder label and tooltip
        else
          label   = id
          tooltip = ''

        # Assembles individual facet object
        facet =
          id:       id
          label:    label
          order:    index
          enabled:  true
          tooltip:  tooltip

        # Returns the generated facet
        return resolve(facet)

  # TODO - must ensure that graph elements have been loaded
  # TODO - facets should be stored client-side once they are generated.
  # They may be re-generated, though stateful
  # properties will be lost in the process
  # TODO - much of this should be abstracted into the FacetModel class definition
  # TODO - ALOT OF THIS needs to be cleaned up.
  # TODO - this must be refactored to be done AFTER the datapoints have been saved to the database
  ensureFacets: (graph) ->
    return new Promise (resolve, reject) =>

      return resolve(@facetCollection) if @facetCollection

      # Gets unique keys from the graph data
      allKeys = []
      for el in graph
        allKeys = _.union(allKeys, _.keys(el.data) )

      # TODO - must getch facet data from Ontologies
      # TODO - this is likely going to need to be a Promise.all() or Promise.each()
      facets = []

      # Generates facets from Ontology queries
      index = 0
      Promise.map(allKeys, (id) =>

        # Gets Ontology data for each facet
        ont_id   = id.split(':')[0]
        ont_attr = id

        facetPromise = @getFacet(ont_id, ont_attr, id, index)
        index = index + 1
        return facetPromise
      ).then (all) =>

        console.log 'ENSURED FACETS????'
        console.log all

        # Assigns facets to facet collection
        @facetCollection = Backbone.Radio.channel('facet').request('collection', all)
        return resolve(@facetCollection)

  fetchDatapoints: ->
    return Backbone.Radio.channel('dataset').request('datapoints', @id)

  # Overwritten save method
  # TODO - abstract into DexieModel?
  save: (attrs={}, graph=[]) ->

    # Sets count attribute defined from
    # length of graph parameter
    attrs.count = graph.length

    # Sets attributes before save
    @set(attrs)

    # Triggers 'request' event (important for views to function correctly)
    @trigger('request')

    # Adds the record to Dexie
    Backbone.Radio.channel('db').request('add', @urlRoot, @toJSON())
    .then (model_id) =>

      # Iterate over each datapoint, return a promise
      # TODO - abstract into @populateDatapoints method?
      Promise.each(graph, (datapoint) ->

        # Assemble a new datapoint
        attrs =
          id:         _.uniqueId('dp_')
          raw:        datapoint
          data:       datapoint
          dataset_id: model_id

        # Returns 'add' Promise from DB service
        return Backbone.Radio.channel('db').request('add', 'datapoints', attrs)

      )

      # After all datapoints have been addded...
      .then () =>

        # TODO - ENSURES FACETS
        # TODO - this is turning into callback/promise hell
        @trigger('sync')

      .catch (err) => @trigger('error', err)
    .catch (err) => @trigger('error', err)

# # # # #

class DatasetCollection extends Backbone.Collection
  urlRoot: 'datasets'
  model: DatasetModel

# # # # #

module.exports =
  Model:      DatasetModel
  Collection: DatasetCollection
