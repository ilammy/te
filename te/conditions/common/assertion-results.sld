(define-library (te conditions common assertion-results)

  (export assert-success
          assert-failure)

  (import (scheme base)
          (scheme case-lambda))

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
