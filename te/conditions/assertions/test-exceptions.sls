#!r6rs

(import (rnrs base)
        (rnrs exceptions)
        (te)
        (te utils verify-test-case)
        (te conditions assertions exceptions)
        (te conditions assertions equivalence)
        (te conditions common test-utils))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-assert-raises)

  (define-test ("assert-raises fails if no exception")
    (assert-fails
      (assert-raises (lambda (condition) #f)
        (lambda ()
          (+ 1 2) ) ) ) )

  (define-test ("assert-raises returns the caught condition")
    (let ((unique-object (list 'unique)))
      (assert-eq unique-object
        (assert-raises list?
          (lambda ()
            (raise unique-object) ) ) ) ) )

  (define-test ("assert-raises fails on unexpected exception")
    (assert-fails
      (assert-raises list?
        (lambda ()
          (raise 42) ) ) ) )
)
(verify-test-case! test-assert-raises)
