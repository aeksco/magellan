
class DatapointModel extends Backbone.Model
  urlRoot: 'datapoints'

  save: ->
    Backbone.Radio.channel('datapoint').request('save', @)

# # # # #

class DatapointCollection extends Backbone.Collection
  model: DatapointModel

# # # # #

module.exports =
  Model:      DatapointModel
  Collection: DatapointCollection
