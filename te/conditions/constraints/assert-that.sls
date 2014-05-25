#!r6rs
(library (te conditions constraints assert-that)

  (export assert-that)

  (import (rnrs base)
          (te conditions define-assertion))

  (begin

    (define-assertion (assert-that value constraint) (constraint value))

) )
