#!r6rs
(library (te conditions assertions)

  (export assert-true assert-false
          assert-eq assert-eqv assert-equal)

  (import (except (rnrs base) error)
          (te conditions define-assertion))

  (begin

    (define-assertion (assert-true value)
      (if (not (eq? #f value))
          (assert-success value)
          (assert-failure) ) )

    (define-assertion (assert-false value)
      (if (eq? #f value)
          (assert-success value)
          (assert-failure) ) )

    (define-assertion (assert-eq expected actual)
      (if (eq? expected actual)
          (assert-success actual)
          (assert-failure) ) )

    (define-assertion (assert-eqv expected actual)
      (if (eqv? expected actual)
          (assert-success actual)
          (assert-failure) ) )

    (define-assertion (assert-equal expected actual)
      (if (equal? expected actual)
          (assert-success actual)
          (assert-failure) ) )

) )
