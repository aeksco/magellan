# Defines rules leveraged by the utility
# TODO - this hard-coded file should be removed.

# TODO - ordered conditions <- THIS IS A BIG ONE.
# TODO - rule validations (which rules are predicated on others?) <- THIS ISN'T AS IMPORTANT
# TODO - rename to Attribute (source), Contraint (operation), and Query (value)?
module.exports = [

  # LastName rule definition
  {
    order:      1
    enabled:    true
    targetAttr: 'lastName'
    type:       'definer'
    conditions: [ # TODO - should conditions be models as well?
      { source: 'firstName', operation: 'exact_match', value: 'Alex', result: 'Schwartzberg' } # TODO - *required* attribute
      { source: 'firstName', operation: 'exact_match', value: 'Johnson', result: 'Samuel' }
      { source: '@id', operation: 'exact_match', value: 1, result: 'Erickson' }
      { source: '@id', operation: 'exact_match', value: 4, result: 'Hynes' }
    ]
  }

  # TESTING REPLACE OPERATION
  {
    order:      2
    enabled:    true
    type:       'definer'
    targetAttr: 'employer'
    conditions: [{ source: 'employer', operation: 'replace', value: 'RPI', result: 'Rensselaer Polytechnic Institute' }]
  }

  # TESTING FORMAT OPERATION
  # {
  #   order: 3
  #   enabled: true
  #   targetAttr: 'upper_employer'
  #   conditions: [{ source: 'employer', operation: 'format_uppercase' }]
  # }

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
    order:      3
    enabled:    true
    type:       'decorator'
    targetAttr: 'lower_employer'
    conditions: [{ source: 'employer', operation: 'format_lowercase' }]
  }

  # TESTING FORMAT OPERATION
  # TODO - this MUST be reworked.
  # {
  #   order: 5
  #   enabled: true
  #   targetAttr: 'last_regex'
  #   conditions: [{ source: 'firstName', operation: 'regex_match', value: /alex/ig, result: 'ALEX MATCHED' }]
  # }

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
