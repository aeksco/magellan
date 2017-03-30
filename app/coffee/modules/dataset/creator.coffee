
# TODO - abstract into a separate service?
# Perhaps abstract into Application?
# This will likely need to be used elsewhere
buildUniqueId = (prefix='')->
  return prefix + Math.random().toString(36).substr(2, 10)

# TODO - decomission this
window.buildUniqueId = buildUniqueId

# # # # #

class DatasetCreator extends Backbone.Model

  # TODO - this should be abstracted elsewhere.
  # This functionality is really geared towards 'linking' a
  # facet to an ontology attribute.
  # getFacet: (ont_id, ont_attr, id, index) ->
  #   return new Promise (resolve, reject) =>
  #     Backbone.Radio.channel('ontology').request('attribute', ont_id, ont_attr)
  #     .then (attribute) =>

  #       # In ontology attribute is defined (i.e. FOUND)
  #       if attribute
  #         label   = attribute['rdfs:label']
  #         tooltip = attribute['rdfs:comment']

  #       # Ontology attribute was not found
  #       # We define placeholder label and tooltip
  #       else
  #         label   = id
  #         tooltip = ''

  #       # Assembles individual facet object
  #       facet =
  #         id:       id
  #         label:    label
  #         order:    index
  #         enabled:  true
  #         tooltip:  tooltip

  #       # Returns the generated facet
  #       return resolve(facet)

  # They may be re-generated, though stateful
  # properties will be lost in the process
  # TODO - we will need a process to UPDATE or RE-GENERATE facets
  ensureFacets: (dataset_id, datapoints) ->

    # Isolates unique keys from the datapoints
    # These unique keys will be used to generate facets
    allKeys = []
    for el in datapoints
      allKeys = _.union(allKeys, _.keys(el) )

    # Adds an index to each facet for correct ordering
    index = 0

    # Save Datapoint function
    # Passed to Bluebird's Promise.each method, returns a Promise
    saveFacet = (facet) ->

      # Assembles a new facet
      attrs =
        id:         buildUniqueId('fc_')
        dataset_id: dataset_id
        attribute:  facet
        label:      facet
        order:      index
        enabled:    true
        tooltip:    ''

      # Increments index
      index = index + 1

      # Returns 'add' Promise from DB service
      return Backbone.Radio.channel('db').request('add', 'facets', attrs)

    # Iterates over each id in allKeys returns a promise
    return Promise.each(allKeys, saveFacet)

  # ensureDatapoints
  # Populates Dexie with the datapoints from the uploaded JSON
  # Returns a Promise that resolves when all datapoints have been persisted to Dexie
  ensureDatapoints: (dataset_id, datapoints) ->

    # Save Datapoint function
    # Passed to Bluebird's Promise.each method, returns a Promise
    saveDatapoint = (datapoint) ->

      # Assembles a new datapoint
      attrs =
        id:         buildUniqueId('dp_')
        dataset_id: dataset_id
        raw:        datapoint
        data:       datapoint

      # Returns 'add' Promise from DB service
      return Backbone.Radio.channel('db').request('add', 'datapoints', attrs)

    # Iterate over each datapoint, return a promise
    return Promise.each(datapoints, saveDatapoint)

  # ensureDataset
  # Saves the Dataset model to Dexie
  ensureDataset: (dataset) ->
    return Backbone.Radio.channel('db').request('add', 'datasets', dataset.toJSON())

  # deploy
  # Used to persist Dataset, Datapoints, and Facets to the database
  deploy: (dataset, datapoints) ->

    # Sets count attribute defined from length of graph parameter
    # and unique ID for Dataset model
    dataset.set('count', datapoints.length)
    dataset.set('id', buildUniqueId('ds_'))

    # Triggers 'request' event on Dataset model
    # (important for views to function correctly)
    dataset.trigger('request')

    # Adds the Dataset record to Dexie
    @ensureDataset(dataset).then (dataset_id) =>

      # Triggers 'ensured:dataset' event on Dataset model  (UI related)
      dataset.trigger('ensured:dataset')

      # Iterate over all datapoints
      # Format and add each to database
      @ensureDatapoints(dataset_id, datapoints).then () =>

        # Triggers 'ensured:datapoints' event on Dataset model (UI related)
        dataset.trigger('ensured:datapoints')

        # Generate the facets from the datapoints
        # Formats and adds each to database
        @ensureFacets(dataset_id, datapoints).then () =>

          # Triggers 'ensured:facets' event on Dataset model (UI related)
          dataset.trigger('ensured:facets')

          # DONE.
          # Triggers 'sync' event on the Dataset model
          dataset.trigger('sync')

        # Error handling.
        .catch (err) => dataset.trigger('error', err)
      .catch (err) => dataset.trigger('error', err)
    .catch (err) => dataset.trigger('error', err)

# # # # #

module.exports = new DatasetCreator()
