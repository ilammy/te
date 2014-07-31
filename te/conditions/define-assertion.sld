(define-library (te conditions define-assertion)

  (export define-assertion
          assert-success
          assert-failure)

  (import (scheme base)
          (te conditions common assertion-results)
          (only (te conditions builtin-conditions) fail))

  (begin

    (define-syntax ?empty
      (syntax-rules ()
        ((_ () kt kf) kt)
        ((_ :: kt kf) kf) ) )

    (define-syntax define-assertion
      (syntax-rules ()
        ((_ (name args ... . rest) body1 body2 ...)
         (define (name args ... . rest)
           (let-values (((passed? msg obj) (let () body1 body2 ...)))
             (if passed? obj
                 (fail msg (if obj obj
                               (?empty rest
                                 `(name ,args ...)
                                 `(name ,args ... ,@rest) ))) ) ) ) ) ) )

) )
