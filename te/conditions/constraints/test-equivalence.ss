(import (scheme base)
        (te)
        (te utils verify-test-case)
        (te conditions constraints assert-that)
        (te conditions assertions equivalence)
        (te conditions constraints equivalence)
        (te conditions common test-utils))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-is-eq)

  (define identical-objects
    (list '(#t #t) '(#f #f) '(() ()) '(a a) `(,car ,car)
          (let ((list (list 1))) `(,list ,list)) ) )

  (define distinct-objects
    (list '(#t #f) '(#f ()) `(,(list 1) ,(list 1))) )

  (define-test ("is-eq accepts identical objects" expected actual)
    #(identical-objects)
    (assert-eq actual (assert-that actual (is-eq expected))) )

  (define-test ("is-eq rejects distinct objects" obj1 obj2)
    #(distinct-objects)
    (assert-fails (assert-that obj1 (is-eq obj2))) )

  (define-test ("is-not-eq accepts distinct objects" expected actual)
    #(distinct-objects)
    (assert-eq actual (assert-that actual (is-not-eq expected))) )

  (define-test ("is-not-eq rejects identical objects" obj1 obj2)
    #(identical-objects)
    (assert-fails (assert-that obj1 (is-not-eq obj2))) )
)
(verify-test-case! test-is-eq)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-is-eqv)

  (define equivalent-objects
    (list '(#t #t) '(#f #f) '(() ()) '(foo foo) '(#\X #\X) `(,car ,car)
          (let ((list (list 1))) `(,list ,list)) ) )

  (define inequivalent-objects
    (list '(1 "1") '(2 3) '(1 1.0) `(,(list 1) ,(list 1)) `(,cons ,car)) )

  (define-test ("is-eqv accepts equivalent objects" expected actual)
    #(equivalent-objects)
    (assert-eq actual (assert-that actual (is-eqv expected))) )

  (define-test ("is-eqv rejects inequivalent objects" obj1 obj2)
    #(inequivalent-objects)
    (assert-fails (assert-that obj1 (is-eqv obj2))) )

  (define-test ("is-not-eqv accepts inequivalent objects" expected actual)
    #(inequivalent-objects)
    (assert-eq actual (assert-that actual (is-not-eqv expected))) )

  (define-test ("is-not-eqv rejects equivalent objects" obj1 obj2)
    #(equivalent-objects)
    (assert-fails (assert-that obj1 (is-not-eqv obj2))) )
)
(verify-test-case! test-is-eqv)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-is-equal)
  (define equal-objects
    (list '(a a) '(1 1) '(#(foo) #(foo)) '(() ()) `(,(list 1) ,(list 1))) )

  (define unequal-objects
    (list '(a b) '(1 6) '((foo) #(bar)) '(() #())) )

  (define-test ("is-equal accepts equal objects" expected actual)
    #(equal-objects)
    (assert-eq actual (assert-that actual (is-equal expected))) )

  (define-test ("is-equal rejects unequal objects" obj1 obj2)
    #(unequal-objects)
    (assert-fails (assert-that obj1 (is-equal obj2))) )

  (define-test ("is-not-equal accepts unequal objects" expected actual)
    #(unequal-objects)
    (assert-eq actual (assert-that actual (is-not-equal expected))) )

  (define-test ("is-not-equal rejects equal objects" obj1 obj2)
    #(equal-objects)
    (assert-fails (assert-that obj1 (is-not-equal obj2))) )
)
(verify-test-case! test-is-equal)
