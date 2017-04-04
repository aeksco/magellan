
class DatapointModel extends Backbone.Model
  urlRoot: 'datapoints'

  # TODO - model defaults

  save: ->
    Backbone.Radio.channel('datapoint').request('save', @)

# # # # #

class DatapointCollection extends Backbone.Collection
  model: DatapointModel

  # resetDataFromRaw
  # Resets the collection of datapoints to their default attributes
  resetDataFromRaw: ->

    # Index and count variables for Loading component updates
    index = 0
    count = _s.numberFormat(@length)

    # Resets data attribute from raw, and saves
    resetDatapoint = (dp) ->

      # Loading component update message
      index = index + 1
      Backbone.Radio.channel('loading').trigger('show', "Processing #{_s.numberFormat(index)} of #{count}")

      # Deep-copy
      # Ensures objects don't represent the same space in memory
      raw = JSON.parse(JSON.stringify(dp.get('raw')))
      dp.set('data', raw)
      return dp.save()

    # Iterates over each model and invokes resetDatapoint
    return Promise.each(@models, resetDatapoint)

# # # # #

module.exports =
  Model:      DatapointModel
  Collection: DatapointCollection
