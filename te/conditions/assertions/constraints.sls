#!r6rs
(library (te conditions assertions constraints)

  (export assert-that)

  (import (except (rnrs base) error)
          (te conditions define-assertion))

  (begin

    (define-assertion (assert-that value constraint)
      (assert-failure) )

) )
