#!r6rs
(library (te conditions assertions)

  (export assert-eq   assert-equal
          assert-true assert-false)

  (import (except (rnrs base) error)
          (te conditions builtin-conditions))

  (begin

    (define (assert-true value)
      (if (not (eq? #f value)) value
          (fail "Assertion failed"
            `(assert-true ,value) ) ) )

    (define (assert-false value)
      (if (eq? #f value) value
          (fail "Assertion failed"
            `(assert-false ,value) ) ) )

    (define (assert-eq expected actual)
      (if (eq? expected actual) actual
          (fail "Assertion failed"
            `(assert-eq ,expected ,actual) ) ) )

    (define (assert-equal expected actual)
      (if (equal? expected actual) actual
          (fail "Assertion failed"
            `(assert-equal ,expected ,actual) ) ) )

) )
