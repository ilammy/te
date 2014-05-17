#!r6rs
(library (te conditions assertions test-utils)

  (export assert-fails)

  (import (except (rnrs base) error)
          (rnrs control)
          (rnrs exceptions)
          (te conditions define-assertion)
          (te internal test-conditions))

  (begin

    (define-assertion (assert-thunk-fails thunk)
      (let ((unique-object (list 'unique)))
        (guard (condition
                ((test-condition? condition)
                 (if (eq? 'failed (condition-type condition))
                     (assert-success)
                     (assert-failure "Invalid condition type") ))
                ((eq? unique-object condition)
                 (assert-failure "Should not return") )
                (else (assert-success)) )
          (thunk)
          (raise unique-object) ) ) )

    (define-syntax assert-fails
      (syntax-rules ()
        ((_ form) (assert-thunk-fails (lambda () form))) ) )

) )
