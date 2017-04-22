
class ResultDetailView extends Mn.LayoutView
  template: require './templates/detail'
  className: 'card card-block rdf-viewer-detail'

  events:
    'click [data-click=close]': 'closeView'
    'mouseover img': 'onImageIn'
    'mouseout img': 'onImageOut'

  onImageIn: (e) =>
    @trigger 'show:underlay'
    return @drift.enable() if @drift
    @drift = new Drift(document.querySelector('img'), {
      containInline: true
      inlinePane: 200
      paneContainer: $('.drift-content')[0] # TODO - overlay should be a region, perhaps?
      zoomFactor: 5
      hoverBoundingBox: true
    })

  onImageOut: (e) =>
    @trigger 'hide:underlay'
    @drift.disable()

  closeView: ->
    $('.drift-content').html('') # TODO - overlay MUST be a region
    @trigger 'hide:underlay'
    @trigger 'hide'

  onRender: ->
    # TODO - abstract this elsewhere.
    # TODO - overlay should be a region
    # TODO - this should be fully decomissioned
    # if @model.get('views').csv

    #   # TODO - fetch CSV file from Background App.
    #   @trigger 'show:underlay'
    #   @loadCsv(@model.get('views').csv)

  # TODO - this needs to be abstracted into the CsvViewer class
  loadCsv: (url) ->

    # XHR Configuration
    # TODO - will jQuery get work just as well here?
    xhr = new XMLHttpRequest
    xhr.open('GET', url, true)
    xhr.responseType = 'text'

    # XHR Callbacks, Backbone flavored events
    xhr.onload = (e) =>
      status = if xhr.status == 200 then 'success' else 'error'

      # Renders CSV
      return @renderCsv(xhr.response) if status == 'success'

    # Sends XHR, triggers request event
    xhr.send()

  renderCsv: (text) ->
    console.log 'RENDER CSV'
    console.log text

    parsedCSV = d3.csvParseRows(text)
    container = d3.select('.drift-content')
    .append('table')
    .selectAll('tr')
    .data(parsedCSV)
    .enter()
    .append('tr')
    .selectAll('td')
    .data((d) -> d)
    .enter().append('td').text((d) -> d)

# # # # #

module.exports = ResultDetailView
