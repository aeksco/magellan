
# TODO - abstract into Henson
class UploadWidget extends Mn.LayoutView
  template: require './templates/upload'
  className: 'form-group'

  events:
    'change input[type=file]': 'onInputChange'

  onInputChange: (e) ->

    # Cache e.target
    file = e.target.files[0]

    # Return without a file
    return unless file

    # Parse text inside input file
    fileReader = new FileReader()
    fileReader.onload = => @trigger('file:loaded', fileReader.result)
    fileReader.readAsText(file)

  # On Uploaded callback
  # Parses JSON from text and sends to parent view
  onFileLoaded: (text) ->
    parsed = JSON.parse(text)
    @trigger 'parse', parsed

# # # # #

module.exports = UploadWidget
