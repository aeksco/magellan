
###*
# Please note that when passing in custom templates for
# listItemTemplate and orderByTemplate to keep the classes as
# they are used in the code at other locations as well.
###

# TODO - these should be abstracted or removed
defaults =
  items: [{a:2,b:1,c:2},{a:2,b:2,c:1},{a:1,b:1,c:1},{a:3,b:3,c:1}],
  facets: {'a': 'Title A', 'b': 'Title B', 'c': 'Title C'},
  facetElement: '#facets'
  listItemTemplate: '<div class="facetitem" id="<%= id %>"><%= name %> <span class="facetitemcount">(<%= count %>)</span></div>'
  countTemplate: '<div class=facettotalcount>Results</div>'
  resultTemplateBypass: null
  orderByOptions:
    'a': 'by A'
    'b': 'by B'
    'RANDOM': 'by random'
  state:
    orderBy: false
    filters: {}
  enablePagination: true
  paginationCount: 20

###*
# This is the first function / variable that gets exported into the
# jQuery namespace. Pass in your own settings (see above) to initialize
# the faceted search
###

settings = {}

###*
# The following section contains the logic of the faceted search
###

###*
# initializes all facets and their individual filters
###

# Iterate over each facet
# Instantiates empty facet object in facetCollection registry
# TODO - this can be phased out once facetCollection IS a Backbone.Collection
createEmptyFacetCollection = ->
  for facet in settings.facets
    settings.facetCollection[facet.attribute] = {}

# Sets zero count for all settings.items?
# TODO - rename settings.items
setZeroCounts = ->

  # Iterate over each item
  for item in settings.items

    # Aliases item
    item = item.data

    # intialize the count to be zero
    for facet in settings.facets

      # Item[facet] is an array...
      if $.isArray(item[facet.attribute])

        for facetitem in item[facet.attribute]

          if typeof facetitem == 'object'
            settings.facetCollection[facet.attribute][facetitem['@id']] = settings.facetCollection[facet.attribute][facetitem['@id']] ||
              count: 0
              id: _.uniqueId('facet_')

          else
            settings.facetCollection[facet.attribute][facetitem] = settings.facetCollection[facet.attribute][facetitem] or
              count: 0
              id: _.uniqueId('facet_')

      # IF OBJECT OR @ID
      else if typeof(item[facet.attribute]) == 'object' && (item[facet.attribute]['@id'] || item[facet.attribute]['@value'])

        # Sets attrKey
        attrKey = if item[facet.attribute]['@id'] then '@id' else '@value'

        settings.facetCollection[facet.attribute][item[facet.attribute][attrKey]] = settings.facetCollection[facet.attribute][item[facet.attribute][attrKey]] ||
          count: 0
          id: _.uniqueId('facet_')

      # Not an array or object...
      else
        if item[facet.attribute] != undefined
          settings.facetCollection[facet.attribute][item[facet.attribute]] = settings.facetCollection[facet.attribute][item[facet.attribute]] or
            count: 0
            id: _.uniqueId('facet_')

# SORTS FACET COLLECTION
# TODO - rename?
sortFacetCollection = ->
  # sort it:
  for facettitle, facet of settings.facetCollection

    sorted = _.keys(settings.facetCollection[facettitle]).sort()

    if settings.facet_SortOption and settings.facet_SortOption[facettitle]
      sorted = _.union(settings.facet_SortOption[facettitle], sorted)

    sortedstore = {}

    for el in sorted
      sortedstore[el] = settings.facetCollection[facettitle][el]

    settings.facetCollection[facettitle] = sortedstore

# Sets initial facet counts
initFacetCount = ->

  # TODO - phase this out.
  createEmptyFacetCollection()

  # Set ZERO counts on all settings.items?
  setZeroCounts()

  # Sorts
  sortFacetCollection()

###*
# resets the facet count
###

resetFacetCount = ->
  for facetname, items of settings.facetCollection
    for itemname, value of items
      settings.facetCollection[facetname][itemname].count = 0

###*
# Filters all items from the settings according to the currently
# set filters and stores the results in the settings.currentResults.
# The number of items in each filter from each facet is also updated
###

filterSingleItem = (item) ->
  # Bool for _.select / _.filter
  filtersApply = true

  # Aliases item.data
  item = item.data

  # Iterates over each filter
  for facet, filter of settings.state.filters

    # TODO - abstract this elsewhere, repeated
    # TODO - document what's happening here
    if $.isArray(item[facet])

      if item[facet][0] && typeof(item[facet][0]) == 'object'
        for f in item[facet]

          if filter.length and _.indexOf(filter, f['@id']) == -1
            filtersApply = false

      else
        inters = _.intersection(item[facet], filter)
        if inters.length == 0
          filtersApply = false

    else if typeof(item[facet]) == 'object' && (item[facet]['@id'] || item[facet]['@value'])

      # Sets attrKey
      attrKey = if item[facet]['@id'] then '@id' else '@value'

      if filter.length and _.indexOf(filter, item[facet][attrKey]) == -1
        filtersApply = false

    else
      if filter.length and _.indexOf(filter, item[facet]) == -1
        filtersApply = false


  return filtersApply

# # # # #

# first apply the filters to the items
applyFilters = ->
  settings.currentResults = _.select(settings.items, filterSingleItem)

# # # # #

updateFacetCollection = ->
  # then reduce the items to get the current count for each facet

  for facet in settings.facets

    # Iterates over each currentResult

    for item in settings.currentResults

      item = item.data

      # TODO - abstract this logic elswhere
      # TODO - document what's happening here...
      if $.isArray(item[facet.attribute])
        _.each item[facet.attribute], (facetitem) ->

          if typeof(facetitem) == 'object'
            settings.facetCollection[facet.attribute][facetitem['@id']].count += 1

          else
            settings.facetCollection[facet.attribute][facetitem].count += 1
            return

      else if typeof(item[facet.attribute]) == 'object' && (item[facet.attribute]['@id'] || item[facet.attribute]['@value'])

        attrKey = if item[facet.attribute]['@id'] then '@id' else '@value'

        if item[facet.attribute][attrKey] != undefined
          settings.facetCollection[facet.attribute][item[facet.attribute][attrKey]].count += 1

      else
        if item[facet.attribute] != undefined
          settings.facetCollection[facet.attribute][item[facet.attribute]].count += 1

# # # # #

filter = ->

  # Applies filters
  applyFilters()

  # DEXIE DATABASE CALL
  # if (window.global){
  #   window.dexiePromise = window.global.queryDexie(appliedFilters)
  # }

  # Update the count for each facet and item:
  # intialize the count to be zero
  resetFacetCount()

  # Updates the facet collection with the results
  updateFacetCollection()

  # Updates state???
  settings.state.shownResults = 0
  return

###*
# Orders the currentResults according to the settings.state.orderBy variable
###

order = ->
  if settings.state.orderBy

    # TODO - abstract into Backbone.View
    $('.activeorderby').removeClass 'activeorderby'
    $('#orderby_' + settings.state.orderBy).addClass 'activeorderby'

    # Applies sort settings
    settings.currentResults = _.sortBy settings.currentResults, (item) ->
      if settings.state.orderBy == 'RANDOM'
        Math.random() * 10000
      else
        item[settings.state.orderBy]

###*
# The given facetname and filtername are activated or deactivated
# depending on what they were beforehand. This causes the items to
# be filtered again and the UI is updated accordingly.
###

toggleFilter = (key, value) ->
  settings.state.filters[key] = settings.state.filters[key] or []

  if _.indexOf(settings.state.filters[key], value) == -1
    settings.state.filters[key].push value

  else
    settings.state.filters[key] = _.without(settings.state.filters[key], value)
    if settings.state.filters[key].length == 0
      delete settings.state.filters[key]

  filter()
  return

###*
# The following section contains the presentation of the faceted search
###

###*
# This function is only called once, it creates the facets ui.
###

createFacetUI = ->

  facetContainer = '<div class=facetsearch id=<%= id %> ></div>'
  facetTitleTemplate = '<h3 class=facettitle><i class="icon"></i><%= title %><i class="fa fa-fw help" data-toggle="tooltip" data-placement="right" title="<%= tooltip %>"></i><br><span class="prefix <%= prefix %>"><%= prefix %> : <%= _id %></span></h3>'
  facetListContainer = '<div class=facetlist></div>'

  # Templates & HTML setup
  itemtemplate = _.template(settings.listItemTemplate)
  titletemplate = _.template(facetTitleTemplate)
  containertemplate = _.template(facetContainer)
  $(settings.facetElement).html('')

  # Iterates over each setting...
  # TODO - this will be replaced by the FACET_GROUP_COLLECTION_VIEW
  # Each facet will have pagination, filtering, etc.
  for facet in settings.facets
    facetHtml = $(containertemplate(id: facet.attribute))

    # Assembles facetItem
    facetItem =
      title:    facet.label
      tooltip:  facet.tooltip
      prefix:   facet.prefix
      _id:      facet._id

    # ABSTRACTION
    # This is where we should collect the GROUPS of facets
    # This MAY be accessible outside this little engine, passed in as settings.facets
    # console.log(facetItem);

    facetItemHtml = $(titletemplate(facetItem))
    facetHtml.append facetItemHtml
    facetlist = $(facetListContainer)

    # Iterates over each filter
    # TODO - this will be replaced by the FACET_ITEM_COLLECTION_VIEW
    _.each settings.facetCollection[facet.attribute], (filter, filtername) ->

      # Splits name, handles directories ending with '/'
      # TODO - abstract into function
      splitName   = filtername.trim().split('/')
      filtername  = splitName.pop()
      filtername ||= splitName.pop()

      item =
        id: filter.id
        name: filtername
        count: filter.count

      # ABSTRACTION - this is where the INITIAL facets are populated into the UI
      # FROM HERE, we start the collection of facet items
      # console.log(item);

      # Facet filter item CSS state
      filteritem = $(itemtemplate(item))
      if _.indexOf(settings.state.filters[facet.attribute], filtername) >= 0
        filteritem.addClass('activefacet')

      if item.count == 0
        filteritem.addClass('no-match')

      # Appends to list of facetItems
      facetlist.append filteritem
      return

    # Appends HTML
    facetHtml.append(facetlist)
    $(settings.facetElement).append(facetHtml)

    # Tooltips
    $('[data-toggle=tooltip]').tooltip()

  # # # # # # # # # # # # # # # # # # # #

  # TODO - abstract into Backbone.View
  # add the click event handler to each facet item:
  $('.facetitem').click (event) ->
    `var filter`
    filter = getFilterById(@id)
    toggleFilter(filter.facetname, filter.filtername)
    # $(settings.facetElement).trigger 'facetedsearchfacetclick', filter
    order()
    updateFacetUI()
    updateResults()
    return

  # # # # #

  # TODO - ABSTRACT INTO SEPARATE VIEW
  # FOR RESULT COUNTR AND ORDER CONTROLS
  # Append total result count
  bottomContainer = '<div class=bottomline></div>'
  bottom = $(bottomContainer)
  countHtml = _.template(settings.countTemplate, count: settings.currentResults.length or 0)
  $(bottom).append(countHtml)


  # generate the "order by" options:

  orderByTemplate = '<div class=orderby><span class="orderby-title">Sort by: </span><ul><% _.each(options, function(value, key) { %>' + '<li class=orderbyitem id=orderby_<%= key %>>' + '<%= value %> </li> <% }); %></ul></div>'

  ordertemplate = _.template(orderByTemplate)
  itemHtml = $(ordertemplate('options': settings.orderByOptions))
  $(bottom).append itemHtml
  $(settings.facetElement).append bottom
  $('.orderbyitem').each ->
    id = @id.substr(8)
    if settings.state.orderBy == id
      $(this).addClass 'activeorderby'
    return


  # add the click event handler to each "order by" item:
  # TODO - abstract into Backbone.View
  $('.orderbyitem').click (event) ->
    id = @id.substr(8)
    settings.state.orderBy = id
    # $(settings.facetElement).trigger 'facetedsearchorderby', id
    settings.state.shownResults = 0
    order()
    updateResults()
    return


  # Append deselect filters button
  # TODO - abstract into Backbone.View
  deselectTemplate = '<div class=deselectstartover>Deselect all filters</div>'
  deselect = $(deselectTemplate).click((event) ->
    settings.state.filters = {}
    jQuery.facetUpdate()
    return
  )

  # Append DESELECT button
  # TODO - abstract into Backbone.View
  $(bottom).append(deselect)
  # $(settings.facetElement).trigger 'facetuicreated'
  return

###*
# get a facetname and filtername by the unique id that is created in the beginning
###

getFilterById = (id) ->
  result = false
  _.each settings.facetCollection, (facet, facetname) ->
    _.each facet, (filter, filtername) ->
      if filter.id == id
        result =
          'facetname':  facetname
          'filtername': filtername
      return
    return
  result

###*
# This function is only called whenever a filter has been added or removed
# It adds a class to the active filters and shows the correct number for each
###

# Updates Facets after results are returned
updateFacetUI = ->

  # Compiles listItemTemplate function
  itemtemplate = _.template(settings.listItemTemplate)

  # Iterates over each facet in @facetCollection
  # TODO - abstract into Mn.CollectionView
  _.each settings.facetCollection, (facet, facetname) ->
    _.each facet, (filter, filtername) ->

      # Splits name, handles directories ending with '/'
      # TODO - abstract into function
      # TODO - abstract into Backbone - FacetChildView, or decorator
      splitName   = filtername.trim().split('/')
      filtername  = splitName.pop()
      filtername ||= splitName.pop()

      # Assembles each item for template compilation
      # TODO - remove when Backbone is implemented
      item =
        id: filter.id
        name: filtername
        count: filter.count

      # Compiles itemTemplate and sets HTML
      # TODO - abstract into Backbone - FacetChildView
      filteritem = $(itemtemplate(item)).html()
      $('#' + filter.id).html(filteritem)

      # Sets activeFacet CSS
      # TODO - abstract into Backbone - FacetChildView
      if settings.state.filters[facetname] and _.indexOf(settings.state.filters[facetname], filtername) >= 0
        $('#' + filter.id).addClass('activefacet')
      else
        $('#' + filter.id).removeClass('activefacet')

      # Sets filterCount CSS
      # TODO - abstract into Backbone - FacetChildView
      if filter.count == 0
        $('#' + filter.id).addClass('no-match')
      else
        $('#' + filter.id).removeClass('no-match')

      return
    return

  # Appends Result Count to page
  # TODO - abstract into Backbone View
  countHtml = _.template(settings.countTemplate, count: settings.currentResults.length)
  $(settings.facetElement + ' .facettotalcount').replaceWith(countHtml)
  return

###*
# Updates the the list of results according to the filters that have been set
###

# TODO - abstract into Backbone.View
updateResults = ->
  noResults = '<div class=results>Sorry, but no items match these criteria</div>'
  # $(settings.resultElement).html if settings.currentResults.length == 0 then noResults else ''
  showMoreResults()
  return

showMoreResults = ->
  `var itemHtml`

  # ???
  showNowCount = if settings.enablePagination then Math.min(settings.currentResults.length - (settings.state.shownResults), settings.paginationCount) else settings.currentResults.length
  itemHtml = ''

  # TODO - remove
  if settings.beforeResultRender
    settings.beforeResultRender()

  # Iterates over each shown result
  i = settings.state.shownResults
  while i < settings.state.shownResults + showNowCount

    item = settings.currentResults[i]

    # item = $.extend(settings.currentResults[i],
    #   totalItemNr: i
    #   batchItemNr: i - (settings.state.shownResults)
    #   batchItemCount: showNowCount)

    if settings.resultTemplateBypass
      settings.resultTemplateBypass(item)
    i++

  # Appends itemHTML
  # $(settings.resultElement).append itemHtml

  # Append "MoreButton"
  showMoreTemplate = '<a id=showmorebutton>Show more</a>'
  # TODO - we will _probably_ paginate using BB.Mn
  # TODO - pagination
  # if !moreButton
  #   moreButton = $(showMoreTemplate).click(showMoreResults)
  #   $(settings.resultElement).after moreButton
  # # ???/
  # if settings.state.shownResults == 0
  #   moreButton.show()
  # # ???
  # settings.state.shownResults += showNowCount
  # if settings.state.shownResults == settings.currentResults.length
  #   $(moreButton).hide()
  # # Remove
  # $(settings.resultElement).trigger 'facetedsearchresultupdate'
  # return

jQuery.facetelize =
$.facetelize = (usersettings) ->

  # Sets settings, defaults w/ user
  $.extend settings, defaults, usersettings

  # Stores results of current query
  settings.currentResults = []

  # Stores facetCollection?
  settings.facetCollection = {}

  # ????
  $(settings.facetElement).data 'settings', settings

  # Makes state globally accesssible (debug only)
  window.state = settings.state

  # Starts engine
  initFacetCount()
  filter()
  order()
  updateResults()
  createFacetUI()
  settings.state

###*
# This is the second function / variable that gets exported into the
# jQuery namespace. Use it to update everything if you messed with
# the settings object
###

jQuery.facetUpdate = ->
  filter()
  order()
  updateFacetUI()
  updateResults()
  return

# TODO - this must be implemented in a cleaner way
# The 'ENGINE' should operate as its own class with a clearFilters method
jQuery.clearFacets = ->
  settings.state.filters = {}
  jQuery.facetUpdate()
  return

# Shows more results
# moreButton = undefined
return
