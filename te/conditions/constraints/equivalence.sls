#!r6rs
(library (te conditions constraints equivalence)

  (export is-eq     is-not-eq
          is-eqv    is-not-eqv
          is-equal  is-not-equal)

  (import (except (rnrs base) error)
          (te conditions define-constraint))

  (begin

    (define-constraint (actual is-eq expected)
      (if (eq? expected actual)
          (assert-success actual)
          (assert-failure) ) )

    (define-constraint (actual is-not-eq expected)
      (if (not (eq? expected actual))
          (assert-success actual)
          (assert-failure) ) )

    (define-constraint (actual is-eqv expected)
      (if (eqv? expected actual)
          (assert-success actual)
          (assert-failure) ) )

    (define-constraint (actual is-not-eqv expected)
      (if (not (eqv? expected actual))
          (assert-success actual)
          (assert-failure) ) )

    (define-constraint (actual is-equal expected)
      (if (equal? expected actual)
          (assert-success actual)
          (assert-failure) ) )

    (define-constraint (actual is-not-equal expected)
      (if (not (equal? expected actual))
          (assert-success actual)
          (assert-failure) ) )

) )
