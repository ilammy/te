#!r6rs

(import (except (rnrs base) error assert)
        (rnrs control)
        (rnrs exceptions)
        (only (srfi :1) any)
        (te)
        (te conditions assertions)
        (te conditions define-constraint)
        (te conditions constraints assert-that)
        (te utils verify-test-case)
        (te internal test-conditions))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-define-constraint)

  (define-constraint (number is-odd)
    (if (odd? number)
        (assert-success number)
        (assert-failure "Number is not odd") ) )

  (define-test ("Condition type when failed")
    (guard (condition
            ((test-condition? condition)
             (assert-eq 'failed (condition-type condition)) ) )
      (assert-that 42 (is-odd))
      (raise "Should not return") ) )

  (define-test ("Condition object when failed")
    (guard (condition
            ((test-condition? condition)
             (assert-equal '(assert-that 0 (is-odd)) (condition-object condition)) ) )
      (assert-that 0 (is-odd))
      (raise "Should not return") ) )

  (define-test ("Return value when successful")
    (assert-true (= 13 (assert-that 13 (is-odd)))) )

  (define-constraint (number is-one-of . numbers)
    (let ((equal-number (any (lambda (x) (= x number)) numbers)))
      (if equal-number
          (assert-success equal-number)
          (assert-failure "Not equal to any") ) ) )

  (define-test ("Condition object when failed (variadic)")
    (guard (condition
            ((test-condition? condition)
             (assert-equal '(assert-that 9 (is-one-of 1 2 3)) (condition-object condition)) ) )
      (assert-that 9 (is-one-of 1 2 3))
      (raise "Should not return") ) )

  (define-constraint (number is-even)
    (if (even? number)
        (assert-success)
        (assert-failure) ) )

  (define-test ("Default return value when successful")
    (assert-eq #f (assert-that 8 (is-even))) )
)
(verify-test-case! test-define-constraint)
