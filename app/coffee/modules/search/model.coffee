
# # TODO - this needs to be decomissioned
# # in favor of a configuration-based approach.
# class RecordDecorator extends Mn.Decorator

#   icon: ->
#     ft = @get('dmoa:FileType')

#     if ft == 'Image'
#       return 'fa-file-image-o'

#     if ft == 'CSV'
#       return 'fa-file-excel-o'

#     # TODO - needs to support additional icons
#     if @get('arkType') == 'Directory'
#       return 'fa-folder-open-o'

#     # Default
#     return 'fa-globe'

#   imageSrc: ->

#     # Returns false for non *.png files
#     fileType = @get('@id').split('.').pop()
#     return unless fileType == 'png'

#     # Swap with resolvable uri
#     instanceUri = 'http://dmo.org/instance/manufacturing/'
#     archiveUri = 'http://dmo.org/archive/manufacturing/'
#     newUri  = 'https://manufacturing.xdataproxy.com/data/'
#     return @get('@id').replace(instanceUri, newUri).replace(archiveUri, newUri)

# TODO - this will be abstracted into a rule-managed process
# csvSrc: ->
#   instanceUri = 'http://dmo.org/instance/manufacturing/'
#   archiveUri = 'http://dmo.org/archive/manufacturing/'
#   newUri  = 'https://manufacturing.xdataproxy.com/data/'
#   return @get('@id').replace(instanceUri, newUri).replace(archiveUri, newUri)

# # # # # #

class RecordModel extends Backbone.Model
  url: 'record'
  idAttribute: 'id'

  # Returns a stringified, indented copy of the record's JSON
  # Used as a helper for copy-and-paste view Behavior
  stringifyJson: -> return JSON.stringify(@toJSON(), null, 2)

# # # # #

module.exports = RecordModel
