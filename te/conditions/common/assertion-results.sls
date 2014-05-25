#!r6rs
(library (te conditions assertion-results)

  (export assert-success
          assert-failure)

  (import (rnrs base)
          (rnrs control))

  (begin

    (define assert-success
      (case-lambda
        (()    (values #t #f #f))
        ((obj) (values #t #f obj)) ) )

    (define assert-failure
      (case-lambda
        (()        (values #f "Assertion failed" #f))
        ((msg)     (values #f msg #f))
        ((msg obj) (values #f msg obj)) ) )

) )