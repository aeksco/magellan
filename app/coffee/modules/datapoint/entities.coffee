
class DatapointModel extends Backbone.Model
  urlRoot: 'datapoints'

  # Returns a stringified, indented copy of the record's JSON
  # Used as a helper for copy-and-paste view Behavior
  stringifyJson: -> return JSON.stringify(@toJSON(), null, 2)

# # # # #

class DatapointCollection extends Backbone.Collection
  model: DatapointModel

# # # # #

module.exports =
  Model:      DatapointModel
  Collection: DatapointCollection
