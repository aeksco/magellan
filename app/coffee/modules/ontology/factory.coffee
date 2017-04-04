Entities = require './entities'

# # # # #

# TODO - integrate DexieFactory
class OntologyFactory extends Marionette.Service

  # Defines radioRequests
  radioRequests:
    'ontology model':               'getModel'
    'ontology collection':          'getCollection'
    'ontology attribute':           'attribute'
    'ontology attribute:dropdown':  'getAttributeDropdown'

  initialize: ->
    @cached = new Entities.Collection()

  # getCollection: ->
  #   return @cached if @cached._synced
  #   @cached.reset(window.ontologies)
  #   @cached._synced = true
  #   return @cached

  # TODO - this should accept a query
  getCollection: ->
    return new Promise (resolve, reject) =>

      # TODO - catch statement
      table = 'ontologies' # MODEL.urlRoot
      window.db[table].toArray().then (models) =>
        @cached.reset(models)
        return resolve(@cached)

  getModel: (id) ->
    return new Promise (resolve, reject) =>

      # Resolves if ID is undefined
      return resolve(new Entities.Model()) unless id

      # Returns from @cached if synced
      return resolve(@cached.get(id)) if @cached._synced

      # Gets @cached and returns
      return @getCollection().then () => resolve(@cached.get(id))

  attribute: (prefix, attribute) ->
    return new Promise (resolve, reject) =>

      # Fetchs the full collection of ontologies
      @getCollection().then (ontologyCollection) =>

        # Finds the ontology by prefix
        ontology = ontologyCollection.findWhere({ prefix: prefix })

        # Resolves false unless the ontology exists
        return resolve(false) unless ontology

        # Isolates the graph attribute from the ontology model
        graph = ontology.get('graph')

        # Re-assigns correct attribute @id
        attribute = prefix + ':' + attribute

        # Finds and returns the attribute
        return resolve(_.find(graph, (attr) -> attr['@id'] == attribute))

  # getAttributeDropdown
  # Used to create a grouped dropdown menu to select an ontology attribute
  getAttributeDropdown: ->

    # Returns Promise to manage async operation
    return new Promise (resolve, reject) =>

      # Variable to store the dropdown data
      dropdown = []

      # Fetches ontology collection
      @getCollection().then (ontologyCollection) =>

        # Iterates over each ontology in the collection
        for ontology in ontologyCollection.models

          # Constructs an object to maintain the <optgroup> label
          # and the associated <option> elements
          item = {}
          item.label = ontology.get('label')
          item.items = _.pluck(ontology.get('graph'), '@id')

          # Appends the item to the dropdown return variable
          dropdown.push item

        # Resolves and returns the constructed dropdown data
        return resolve(dropdown)

# # # # #

module.exports = new OntologyFactory()
