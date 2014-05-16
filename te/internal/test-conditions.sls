#!r6rs
(library (te internal test-conditions)

  (export make-test-condition test-condition?
            condition-type
            condition-object
            condition-message)

  (import (rnrs base)
          (rnrs records syntactic))

  (begin

    (define-record-type (test-condition make-test-condition test-condition?)
      (fields
        (immutable type    condition-type)
        (immutable object  condition-object)
        (immutable message condition-message) ) )

) )
