#!r6rs
(library (te conditions define-assertion)

  (export define-assertion
          assert-success
          assert-failure)

  (import (rnrs base)
          (rnrs control)
          (rnrs exceptions)
          (te conditions common assertion-results)
          (only (te conditions builtin-conditions) fail))

  (begin

    (define-syntax define-assertion
      (syntax-rules ()
        ((_ (name args ... . rest) body1 body2 ...)
         (define (name args ... . rest)
           (let-values (((passed? msg obj) (let () body1 body2 ...)))
             (if passed? obj
                 (fail msg (if obj obj `(name ,args ... ,@rest))) ) ) ) ) ) )

) )
