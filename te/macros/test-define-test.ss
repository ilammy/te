(import (scheme base)
        (te base)
        (te conditions assertions)
        (te utils verify-test-case)
        (te macros define-test)
        (te internal data)
        (sr ck))

(define-test-case (test-$define-test-form?)

  (define-test ("accepts anonymous define-test")
    (assert-eq #t
      ($ ($define-test-form? '(define-test () #t))) ) )

  (define-test ("accepts named define-test")
    (assert-eq #t
      ($ ($define-test-form? '(define-test (with-name) (= 4 (+ 2 2))))) ) )

  (define-test ("accepts define-test with data args")
    (assert-eq #t
      ($ ($define-test-form? '(define-test (with-name and data) #(9) #t))) ) )

  (define-test ("rejects random shit")
    (assert-eq #f
      ($ ($define-test-form? '(omg lol))) ) )
)
(verify-test-case! test-$define-test-form?)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$define-test-names)

  (define-test ("Anonymous")
    (define test
      ($ ($define-test '() '() '(define-test () #t))) )
    (assert-equal #f (test-name test)) )

  (define-test ("String name")
    (define test
      ($ ($define-test '() '() '(define-test ("A name")
                                  (= 4 (+ 2 2)) ))) )
    (assert-equal "A name" (test-name test)) )

  (define-test ("Identifier name")
    (define test
      ($ ($define-test '() '() '(define-test (identifier name) #(9)
                                  (eq? 'foo 'bar) ))) )
    (assert-equal "identifier" (test-name test)) )

  (define-test ("Symbolic name")
    (define test
      ($ ($define-test '() '() '(define-test ('test)
                                  (eq? '() '()) ))) )
    (assert-equal 'test (test-name test)) )

  (define-test ("Numeric name")
    (define test
      ($ ($define-test '() '() '(define-test (42)
                                  (= 42 (* 1 1)) ))) )
    (assert-equal 42 (test-name test)) )
)
(verify-test-case! test-$define-test-names)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$define-test-bodies)

  (define-test ("body transfer 1")
    (define test ($ ($define-test '() '() '(define-test () 42))))
    (assert-equal 42 (((test-body test)))) )

  (define-test ("body transfer 2")
    (define test ($ ($define-test '() '() '(define-test (Named) #f))))
    (assert-equal #f (((test-body test)))) )

  (define-test ("parameterized body 1")
    (define test ($ ($define-test '(x) '() '(define-test ("id") x))))
    (assert-equal 1   (((test-body test)) 1))
    (assert-equal #f  (((test-body test)) #f))
    (assert-equal 'uu (((test-body test)) 'uu)) )

  (define-test ("parameterized body 2")
    (define test ($ ($define-test '(a b) '() '(define-test () (+ a b)))))

    (assert-=  0 (((test-body test)) -1 +1))
    (assert-= 42 (((test-body test)) 21 21))
    (assert-=  3 (((test-body test))  1  2)) )
)
(verify-test-case! test-$define-test-bodies)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$define-test-fixtures)

  (define-test ("fixture defs transfer")
    (define test
      ($ ($define-test '()
           '((define a 10) (define b 20))
           '(define-test () (+ a b)) )) )

    (assert-= 30 (((test-body test)))) )
)
(verify-test-case! test-$define-test-fixtures)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$define-test-data)

  (define-test ("data defs syntax")
    (define test
      ($ ($define-test '() '()
           '(define-test ("Named" a b) #(9)
              (= 10 (+ a b)) ) )) )

    (assert-equal #t (((test-body test) 3 7))) )

  (define-test ("data def transfer 1")
    (define test
      ($ ($define-test '() '()
           '(define-test ("Named" a b) #('(data of the test))
              #t ) )) )

    (assert-equal '(data of the test) ((test-data test))) )

  (define-test ("data def transfer 2")
    (define test
      ($ ($define-test '() '()
           '(define-test ("Named" a b) #((* (+ 3 9) (- 11 4)))
              #t ) )) )

    (assert-equal 84 ((test-data test))) )
)
(verify-test-case! test-$define-test-data)
