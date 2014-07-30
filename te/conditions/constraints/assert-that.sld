(define-library (te conditions constraints assert-that)

  (export assert-that)

  (import (scheme base)
          (only (te conditions builtin-conditions) fail))

  (begin

    (define (assert-that value constraint)
      (let-values (((passed? msg obj) (constraint value)))
        (if passed? obj
            (fail msg
              (if (car obj) (cdr obj)
                  `(assert-that ,value ,(cdr obj)) ) ) ) ) )

) )
