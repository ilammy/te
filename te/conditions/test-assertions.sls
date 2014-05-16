#!r6rs

(import (except (rnrs base) error assert)
        (rnrs control)
        (rnrs exceptions)
        (te)
        (te utils verify-test-case)
        (te conditions assertions)
        (te internal test-conditions))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (general-assertion-tests)

  (define (call form) (apply (car form) (cdr form)))

  (define-test ("Condition type when failed" form)
    #((list `((,assert-true #f))
            `((,assert-false 42))
            `((,assert-eq #t #f))
            `((,assert-equal (a b c) (1 2 3))) ))
    (guard (condition
            ((test-condition? condition)
             (assert-true (eq? 'failed (condition-type condition))) ) )
      (call form)
      (raise "Should not return") ) )

  (define-test ("Condition object when failed" form object)
    #((list `((,assert-true #f)  (assert-true #f))
            `((,assert-false 42) (assert-false 42))
            `((,assert-eq ,(list 1) ,(list 1)) (assert-eq (1) (1)))
            `((,assert-equal (a) (1)) (assert-equal (a) (1))) ))
    (guard (condition
            ((test-condition? condition)
             (assert-equal object (condition-object condition)) ) )
      (call form)
      (raise "Should not return") ) )

  (define-test ("Return value when successful (implicit equivalence)" form value)
    #((list `((,assert-true 42) 42)
            `((,assert-false #f) #f) ))
    (assert-true (eq? value (call form))) )

  (define-test ("Return value when successful (explicit equivalence)" form value)
    #((list (let ((list (list 1 2 3))) `((,assert-equal (1 2 3) ,list) ,list))
            (let ((list (list 1 2 3))) `((,assert-eq    ,list   ,list) ,list)) ))
    (assert-true (eq? value (call form))) )
)
(verify-test-case! general-assertion-tests)
