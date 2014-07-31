(define-library (te conditions assertions implicit)

  (export assert-true   assert-false
          assert-null
          assert-nan    assert-not-nan
          assert-finite assert-infinite)

  (import (scheme base)
          (scheme inexact)
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

    (define-assertion (assert-null value)
      (if (null? value)
          (assert-success value)
          (assert-failure) ) )

    (define-assertion (assert-nan value)
      (if (nan? value)
          (assert-success value)
          (assert-failure) ) )

    (define-assertion (assert-not-nan value)
      (if (not (nan? value))
          (assert-success value)
          (assert-failure) ) )

    (define-assertion (assert-finite value)
      (if (finite? value)
          (assert-success value)
          (assert-failure) ) )

    (define-assertion (assert-infinite value)
      (if (infinite? value)
          (assert-success value)
          (assert-failure) ) )

) )
