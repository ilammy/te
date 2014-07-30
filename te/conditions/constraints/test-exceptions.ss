(import (scheme base)
        (te)
        (te utils verify-test-case)
        (te conditions constraints assert-that)
        (te conditions constraints exceptions)
        (te conditions assertions equivalence)
        (te conditions common test-utils))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-raises)

  (define-test ("raises fails if no exception")
    (assert-fails
      (assert-that
        (lambda () (+ 1 2))
        (raises (lambda (condition) #f)) ) ) )

  (define-test ("raises returns the caught condition")
    (let ((unique-object (list 'unique)))
      (assert-eq unique-object
        (assert-that
          (lambda () (raise unique-object))
          (raises list?) ) ) ) )

  (define-test ("raises fails on unexpected exception")
    (assert-fails
      (assert-that
        (lambda () (raise 42))
        (raises list?) ) ) )
)
(verify-test-case! test-raises)
