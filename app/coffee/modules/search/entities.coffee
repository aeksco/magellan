
class SearchResultModel extends Backbone.Model

  # Returns a stringified, indented copy of the record's JSON
  # Used as a helper for copy-and-paste view Behavior
  stringifyJson: -> return JSON.stringify(@toJSON(), null, 2)

# # # # #

class SearchResultCollection extends Backbone.Collection
  model: SearchResultModel

# # # # #

module.exports =
  Model:      SearchResultModel
  Collection: SearchResultCollection
