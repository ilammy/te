#!r6rs
(library (te conditions assertions)

  (export assert-true   assert-false

          assert-eq     assert-not-eq
          assert-eqv    assert-not-eqv
          assert-equal  assert-not-equal

          assert-null
          assert-nan    assert-not-nan
          assert-finite assert-infinite)

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

    (define-assertion (assert-not-eq expected actual)
      (if (not (eq? expected actual))
          (assert-success actual)
          (assert-failure) ) )

    (define-assertion (assert-eqv expected actual)
      (if (eqv? expected actual)
          (assert-success actual)
          (assert-failure) ) )

    (define-assertion (assert-not-eqv expected actual)
      (if (not (eqv? expected actual))
          (assert-success actual)
          (assert-failure) ) )

    (define-assertion (assert-equal expected actual)
      (if (equal? expected actual)
          (assert-success actual)
          (assert-failure) ) )

    (define-assertion (assert-not-equal expected actual)
      (if (not (equal? expected actual))
          (assert-success actual)
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
