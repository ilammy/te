(define-library (te conditions assertions constraints)

  (export assert-that)

  (import (scheme base)
          (te conditions define-assertion))

  (begin

    (define-assertion (assert-that value constraint)
      (assert-failure) )

) )
