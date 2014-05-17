#!r6rs

(import (except (rnrs base) error assert)
        (rnrs control)
        (rnrs exceptions)
        (te)
        (te utils verify-test-case)
        (te conditions assertions)
        (te conditions define-assertion)
        (te internal test-conditions))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-assertion (assert-thunk-fails thunk)
  (let ((unique-object (list 'unique)))
    (guard (condition
            ((test-condition? condition)
             (if (eq? 'failed (condition-type condition))
                 (assert-success)
                 (assert-failure "Invalid condition type") ))
            ((eq? unique-object condition)
             (assert-failure "Should not return") ) )
      (thunk)
      (raise unique-object) ) ) )

(define-syntax assert-fails
  (syntax-rules ()
    ((_ form) (assert-thunk-fails (lambda () form))) ) )

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-general-assertions)

  (define-test ("assert-true accepts non-#f" value)
    #((list '(42) '(#t) '(()) '("string") '(symbol)))
    (assert-eq value (assert-true value)) )

  (define-test ("assert-true rejects #f")
    (assert-fails (assert-true #f)) )

  (define-test ("assert-false accepts #f")
    (assert-eq #f (assert-false #f)) )

  (define-test ("assert-false rejects non-#f" value)
    #((list '(42) '(#t) '(()) '("string") '(symbol)))
    (assert-fails (assert-false value)) )
)
(verify-test-case! test-general-assertions)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-equivalence-assertions)

  (define-test ("assert-eq accepts identical objects" object)
    #((list '(#t) '(#f) '(()) `(,(list 1)) '(a) `(,car)))
    (assert-eq object (assert-eq object object)) )

  (define-test ("assert-eq rejects distinct objects" obj1 obj2)
    #((list '(#t #f) '(#f ()) `(,(list 1) ,(list 1))))
    (assert-fails (assert-eq obj1 obj2)) )

  ; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - ;

  (define-test ("assert-eqv accepts equivalent objects" expected actual)
    #((list '(#t #t) '(#f #f) '(() ()) '(foo foo) '(#\X #\X) `(,car ,car)
            (let ((list (list 1))) `(,list ,list)) ))
    (assert-eq actual (assert-eqv expected actual)) )

  (define-test ("assert-eqv rejects inequivalent objects" obj1 obj2)
    #((list '(1 "1") '(2 3) '(1 1.0) `(,(list 1) ,(list 1)) `(,cons ,car)))
    (assert-fails (assert-eqv obj1 obj2)) )

  ; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - ;

  (define-test ("assert-equal accepts equal objects" expected actual)
    #((list '(a a) '(1 1) '(#(foo) #(foo)) '(() ()) `(,(list 1) ,(list 1))))
    (assert-eq actual (assert-equal expected actual)) )

  (define-test ("assert-equal rejects unequal objects" obj1 obj2)
    #((list '(a b) '(1 6) '((foo) #(bar))))
    (assert-fails (assert-equal obj1 obj2)) )
)
(verify-test-case! test-equivalence-assertions)
