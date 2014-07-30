(define-library (te conditions assertions equivalence)

  (export assert-eq     assert-not-eq
          assert-eqv    assert-not-eqv
          assert-equal  assert-not-equal)

  (import (scheme base)
          (te conditions define-assertion))

  (begin

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

) )
