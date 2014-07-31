(import (scheme base)
        (te base)
        (te conditions assertions)
        (te conditions define-assertion)
        (te utils verify-test-case)
        (te internal test-conditions))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-define-assertion)

  (define-assertion (assert-odd number)
    (if (odd? number)
        (assert-success number)
        (assert-failure "Number is not odd") ) )

  (define-test ("Condition type when failed")
    (guard (condition
            ((test-condition? condition)
             (assert-eq 'failed (condition-type condition)) ) )
      (assert-odd 42)
      (raise "Should not return") ) )

  (define-test ("Condition object when failed")
    (guard (condition
            ((test-condition? condition)
             (assert-equal '(assert-odd 0) (condition-object condition)) ) )
      (assert-odd 0)
      (raise "Should not return") ) )

  (define-assertion (assert-zero number)
    (if (= 0 number)
        (assert-success number)
        (assert-failure "Number is not zero" number) ) )

  (define-test ("Override condition object when failed")
    (guard (condition
            ((test-condition? condition)
             (assert-equal 13 (condition-object condition)) ) )
      (assert-zero 13)
      (raise "Should not return") ) )

  (define-test ("Return value when successful")
    (assert-true (= 13 (assert-odd 13))) )

  (define-assertion (assert-less . numbers)
    (if (apply < numbers)
        (assert-success (apply max numbers))
        (assert-failure "Not ordered") ) )

  (define-test ("Condition object when failed (variadic)")
    (guard (condition
            ((test-condition? condition)
             (assert-equal '(assert-less 3 2 1) (condition-object condition)) ) )
      (assert-less 3 2 1)
      (raise "Should not return") ) )

  (define-assertion (assert-even number)
    (if (even? number)
        (assert-success)
        (assert-failure) ) )

  (define-test ("Default return value when successful")
    (assert-eq #f (assert-even 8)) )
)
(verify-test-case! test-define-assertion)
