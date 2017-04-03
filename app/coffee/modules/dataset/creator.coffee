
# TODO - abstract into a separate service?
# Perhaps abstract into Application?
# This will likely need to be used elsewhere
buildUniqueId = (prefix='')->
  return prefix + Math.random().toString(36).substr(2, 10)

# TODO - decomission this
window.buildUniqueId = buildUniqueId

# # # # #

class DatasetCreator extends Backbone.Model

  # They may be re-generated, though stateful
  # properties will be lost in the process
  # TODO - we will need a process to UPDATE or RE-GENERATE facets
  # TODO - this should be abstracted into the Dataset model as a generateFacets method
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
        data:       JSON.parse(JSON.stringify(datapoint))

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
