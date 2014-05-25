#!r6rs

(import (rnrs base)
        (te)
        (te utils verify-test-case)
        (te conditions assertions equivalence)
        (te conditions common test-utils))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-assert-eq)

  (define identical-objects
    (list '(#t #t) '(#f #f) '(() ()) '(a a) `(,car ,car)
          (let ((list (list 1))) `(,list ,list)) ) )

  (define distinct-objects
    (list '(#t #f) '(#f ()) `(,(list 1) ,(list 1))) )

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
)
(verify-test-case! test-assert-eq)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-assert-eqv)

  (define equivalent-objects
    (list '(#t #t) '(#f #f) '(() ()) '(foo foo) '(#\X #\X) `(,car ,car)
          (let ((list (list 1))) `(,list ,list)) ) )

  (define inequivalent-objects
    (list '(1 "1") '(2 3) '(1 1.0) `(,(list 1) ,(list 1)) `(,cons ,car)) )

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
)
(verify-test-case! test-assert-eqv)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-assert-equal)
  (define equal-objects
    (list '(a a) '(1 1) '(#(foo) #(foo)) '(() ()) `(,(list 1) ,(list 1))) )

  (define unequal-objects
    (list '(a b) '(1 6) '((foo) #(bar)) '(() #())) )

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
(verify-test-case! test-assert-equal)
