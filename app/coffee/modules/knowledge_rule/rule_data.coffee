# Defines rules leveraged by the utility
# TODO - this hard-coded file should be removed.

# TODO - ordered rules
# TODO - ordered conditions
# TODO - rule validations (which rules are predicated on others?)
# TODO - rename to Attribute (source), Contraint (operation), and Query (value)?
module.exports = [

  # LastName rule definition
  {
    targetAttr: 'lastName'
    conditions: [ # TODO - should conditions be models as well?
      { source: 'firstName', operation: 'exact_match', value: 'Alex', result: 'Schwartzberg' } # TODO - *required* attribute
      { source: 'firstName', operation: 'exact_match', value: 'Johnson', result: 'Samuel' }
      { source: '@id', operation: 'exact_match', value: 1, result: 'Erickson' }
      { source: '@id', operation: 'exact_match', value: 4, result: 'Hynes' }
    ]
  }

  # TESTING REPLACE OPERATION
  {
    targetAttr: 'employer'
    conditions: [{ source: 'employer', operation: 'replace', value: 'RPI', result: 'Rensselaer Polytechnic Institute' }]
  }

  # TESTING FORMAT OPERATION
  {
    targetAttr: 'upper_employer'
    conditions: [{ source: 'employer', operation: 'format_uppercase' }]
  }

  # # # # # # # # # #
  # LastName
  # TODO - this is going the be the preferred format going forward
  # {
  #   targetAttr: 'lastName'
  #   formatters: [{ source: 'employer', operation: 'format_lowercase' }]
  #   definitions: [
  #     {
  #       conditions: [{ source: 'firstName', operation: 'exact_match', value: 'Alex' }]
  #       result: 'Schwartzberg'
  #     },
  #     {
  #       conditions: [{ source: 'firstName', operation: 'exact_match', value: 'Johnson' }]
  #       result: 'Samuel'
  #     }
  #   ]
  # }
  # # # # # # # # # #

  # TESTING FORMAT OPERATION
  {
    targetAttr: 'lower_employer'
    conditions: [{ source: 'employer', operation: 'format_lowercase' }]
  }

  # TESTING FORMAT OPERATION
  {
    targetAttr: 'last_regex'
    conditions: [{ source: 'firstName', operation: 'regex_match', value: /alex/ig, result: 'ALEX MATCHED' }]
  }

  # OPERATION TYPES
  # - [ ] fuzzy_match
  # - [ ] is_substring_of
  # - [ ] regex_capture (?)
  # - [X] regex_match
  # - [X] exact_match
  # - [X] format_lowercase
  # - [X] format_uppercase
  # - [X] replace

]
