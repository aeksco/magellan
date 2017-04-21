
# ArchiveImporter class definition
class ArchiveImporter extends Backbone.Model

  # import
  # Imports a list of files from a file upload form
  import: (files) ->

    console.log 'IMPORT FILES'
    console.log files

# # # # #

module.exports = new ArchiveImporter()
