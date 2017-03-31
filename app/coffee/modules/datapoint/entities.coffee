
class DatapointModel extends Backbone.Model
  urlRoot: 'datapoints'

# # # # #

class DatapointCollection extends Backbone.Collection
  model: DatapointModel

# # # # #

module.exports =
  Model:      DatapointModel
  Collection: DatapointCollection
