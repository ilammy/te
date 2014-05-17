#!r6rs
(library (te conditions define-assertion)

  (export define-assertion
          assert-success
          assert-failure)

  (import (rnrs base)
          (rnrs control)
          (rnrs exceptions)
          (only (te conditions builtin-conditions) fail))

  (begin

    (define-syntax define-assertion
      (syntax-rules ()
        ((_ (name args ... . rest) body1 body2 ...)
         (define (name args ... . rest)
           (let-values (((passed? obj/msg) (let () body1 body2 ...)))
             (if passed? obj/msg
                 (fail obj/msg `(name ,args ... ,@rest)) ) ) ) ) ) )

    (define assert-success
      (case-lambda
        (()    (values #t #f))
        ((obj) (values #t obj)) ) )

    (define assert-failure
      (case-lambda
        (()    (values #f "Assertion failed"))
        ((msg) (values #f msg)) ) )

) )
