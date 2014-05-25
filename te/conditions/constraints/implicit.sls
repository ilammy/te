#!r6rs
(library (te conditions constraints implicit)

  (export is-true   is-false
          is-null
          is-nan    is-not-nan
          is-finite is-infinite)

  (import (except (rnrs base) error)
          (te conditions define-constraint))

  (begin

    (define-constraint (value is-true)
      (if (not (eq? #f value))
          (assert-success value)
          (assert-failure) ) )

    (define-constraint (value is-false)
      (if (eq? #f value)
          (assert-success value)
          (assert-failure) ) )

    (define-constraint (value is-null)
      (if (null? value)
          (assert-success value)
          (assert-failure) ) )

    (define-constraint (value is-nan)
      (if (nan? value)
          (assert-success value)
          (assert-failure) ) )

    (define-constraint (value is-not-nan)
      (if (not (nan? value))
          (assert-success value)
          (assert-failure) ) )

    (define-constraint (value is-finite)
      (if (finite? value)
          (assert-success value)
          (assert-failure) ) )

    (define-constraint (value is-infinite)
      (if (infinite? value)
          (assert-success value)
          (assert-failure) ) )

) )
