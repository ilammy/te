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
             (let-values (((passed? msg obj) (let () body1 body2 ...)))
               (if passed? (values passed? msg obj)
                   (if obj (values passed? msg (cons #t obj))
                       (values passed? msg (cons #f `(name ,@args))) ) ) ) ) ) ) ) )
) )
