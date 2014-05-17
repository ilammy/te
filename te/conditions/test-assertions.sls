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

  (define identical-objects
    (list '(#t #t) '(#f #f) '(() ()) '(a a) `(,car ,car)
          (let ((list (list 1))) `(,list ,list)) ) )

  (define distinct-objects
    (list '(#t #f) '(#f ()) `(,(list 1) ,(list 1))) )

  (define equivalent-objects
    (list '(#t #t) '(#f #f) '(() ()) '(foo foo) '(#\X #\X) `(,car ,car)
          (let ((list (list 1))) `(,list ,list)) ) )

  (define inequivalent-objects
    (list '(1 "1") '(2 3) '(1 1.0) `(,(list 1) ,(list 1)) `(,cons ,car)) )

  (define equal-objects
    (list '(a a) '(1 1) '(#(foo) #(foo)) '(() ()) `(,(list 1) ,(list 1))) )

  (define unequal-objects
    (list '(a b) '(1 6) '((foo) #(bar)) '(() #())) )

  ; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - ;

  (define-test ("assert-eq accepts identical objects" expected actual)
    #(identical-objects)
    (assert-eq actual (assert-eq expected actual)) )

  (define-test ("assert-eq rejects distinct objects" obj1 obj2)
    #(distinct-objects)
    (assert-fails (assert-eq obj1 obj2)) )

  (define-test ("assert-not-eq accepts distinct objects" expected actual)
    #(distinct-objects)
    (assert-eq actual (assert-not-eq expected actual)) )

  (define-test ("assert-not-eq rejects identical objects" obj1 obj2)
    #(identical-objects)
    (assert-fails (assert-not-eq obj1 obj2)) )

  ; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - ;

  (define-test ("assert-eqv accepts equivalent objects" expected actual)
    #(equivalent-objects)
    (assert-eq actual (assert-eqv expected actual)) )

  (define-test ("assert-eqv rejects inequivalent objects" obj1 obj2)
    #(inequivalent-objects)
    (assert-fails (assert-eqv obj1 obj2)) )

  (define-test ("assert-not-eqv accepts inequivalent objects" expected actual)
    #(inequivalent-objects)
    (assert-eq actual (assert-not-eqv expected actual)) )

  (define-test ("assert-not-eqv rejects equivalent objects" obj1 obj2)
    #(equivalent-objects)
    (assert-fails (assert-not-eqv obj1 obj2)) )

  ; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - ;

  (define-test ("assert-equal accepts equal objects" expected actual)
    #(equal-objects)
    (assert-eq actual (assert-equal expected actual)) )

  (define-test ("assert-equal rejects unequal objects" obj1 obj2)
    #(unequal-objects)
    (assert-fails (assert-equal obj1 obj2)) )

  (define-test ("assert-not-equal accepts unequal objects" expected actual)
    #(unequal-objects)
    (assert-eq actual (assert-not-equal expected actual)) )

  (define-test ("assert-not-equal rejects equal objects" obj1 obj2)
    #(equal-objects)
    (assert-fails (assert-not-equal obj1 obj2)) )
)
(verify-test-case! test-equivalence-assertions)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-special-assertions)

  (define-test ("assert-null accepts empty list")
    (assert-eq '() (assert-null '())) )

  (define-test ("assert-null rejects anything else except the empty list" obj)
    #((list '(#()) '(#f) '("") `(,(lambda () #f)) '(0) '(#\0)))
    (assert-fails (assert-null obj)) )

  ; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - ;

  (define-test ("assert-nan accepts NaN values")
    (assert-true (nan? (assert-nan +nan.0)))
    (assert-true (nan? (assert-nan -nan.0))) )

  (define-test ("assert-not-nan rejects NaN values")
    (assert-fails (assert-not-nan +nan.0))
    (assert-fails (assert-not-nan -nan.0)) )

  (define not-nan-values '((1) (0) (+inf.0) (-inf.0)))

  (define-test ("assert-nan rejects not-NaN values" value)
    #(not-nan-values)
    (assert-fails (assert-nan value)) )

  (define-test ("assert-not-nan accepts not-NaN values" value)
    #(not-nan-values)
    (assert-eqv value (assert-not-nan value)) )

  ; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - ;

  ;; Unfortunately, these tests are pretty implementation-specific,
  ;; so we keep the figures as low and explicit as possible.

  (define finite-numbers '((1) (2) (0.0) (900000.0)))
  (define infinite-numbers '((+inf.0) (-inf.0)))

  (define-test ("assert-finite accepts finite numbers" number)
    #(finite-numbers)
    (assert-true (= number (assert-finite number))) )

  (define-test ("assert-finite rejects infinite numbers" number)
    #(infinite-numbers)
    (assert-fails (assert-finite number)) )

  (define-test ("assert-infinite accepts infinite numbers" number)
    #(infinite-numbers)
    (assert-true (= number (assert-infinite number))) )

  (define-test ("assert-infinite rejects finite numbers" number)
    #(finite-numbers)
    (assert-fails (assert-infinite number)) )
)
(verify-test-case! test-special-assertions)
