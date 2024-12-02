(const_item
  name: (identifier) @_name
  value: (raw_string_literal (string_content) @injection.content)
  (#lua-match? @_name "QUERY$")
  (#set! injection.language "query"))

(call_expression
  function: (scoped_identifier
    path: (identifier) @_query
    (#eq? @_query "Query")
    name: (identifier) @_new
    (#eq? @_new "new"))
  arguments: (arguments
    (_)
    .
    [
      (string_literal
        (string_content) @injection.content)
      (raw_string_literal
        (string_content) @injection.content)
    ])
  (#set! injection.language "query"))
