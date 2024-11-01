(const_item
  name: (identifier) @_name
  value: (raw_string_literal (string_content) @injection.content)
  (#lua-match? @_name "QUERY$")
  (#set! injection.language "query"))
