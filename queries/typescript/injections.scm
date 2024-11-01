; extends

(call_expression
  function: (identifier) @_type
  (#eq? @_type "type")
  (arguments
    (object
      (pair
        value: (string
                 (string_fragment) @injection.content)
        (#set! injection.self)
      )
    )
  )
)
