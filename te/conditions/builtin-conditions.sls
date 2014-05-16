#!r6rs
(library (te conditions builtin-conditions)

  (export error fail notify pass pend omit)

  (import (except (rnrs base) error)
          (rnrs control)
          (rnrs exceptions)
          (te internal test-conditions))

  (begin

    (define-syntax define-builtin-condition
      (syntax-rules ()
        ((_ (binding) (elevator type))
         (define binding
           (case-lambda
             ((msg)     (elevator (make-test-condition type #f  msg)))
             ((msg obj) (elevator (make-test-condition type obj msg))) ) ) ) ) )

    (define-builtin-condition (error)  (raise 'error))
    (define-builtin-condition (fail)   (raise 'failed))
    (define-builtin-condition (notify) (raise-continuable 'notification))
    (define-builtin-condition (pass)   (raise 'passes))
    (define-builtin-condition (pend)   (raise 'pending))
    (define-builtin-condition (omit)   (raise 'omitted))

) )
