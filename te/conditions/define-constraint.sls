#!r6rs
(library (te conditions define-constraint)

  (export define-constraint
          assert-success
          assert-failure)

  (import (rnrs base)
          (te conditions common assertion-results))

  (begin

    (define-syntax define-constraint
      (syntax-rules ()
        ((_ (actual name . args) body1 body2 ...)
         (define (name . args)
           (lambda (actual)
             body1 body2 ... ) ) ) ) )
) )
