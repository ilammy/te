#!r6rs
(library (te conditions assertion-results)

  (export assert-success
          assert-failure)

  (import (rnrs base)
          (rnrs control))

  (begin

    (define assert-success
      (case-lambda
        (()    (values #t #f))
        ((obj) (values #t obj)) ) )

    (define assert-failure
      (case-lambda
        (()    (values #f "Assertion failed"))
        ((msg) (values #f msg)) ) )

) )
