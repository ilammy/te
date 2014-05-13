#!r6rs

(import (rnrs base)
        (te)
        (te utils verify-test-case)
        (te macros define-test)
        (te internal data)
        (te sr ck))

(define-test-case (test-$define-test-form?)

  (define-test ("accepts anonymous define-test")
    (equal? #t
      ($ ($define-test-form? '(define-test () #t))) ) )

  (define-test ("accepts named define-test")
    (equal? #t
      ($ ($define-test-form? '(define-test (with-name) (= 4 (+ 2 2))))) ) )

  (define-test ("rejects random shit")
    (equal? #f
      ($ ($define-test-form? '(omg lol))) ) )
)
(verify-test-case! test-$define-test-form?)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$define-test?-names)

  (define-test ("Anonymous")
    (define test
      ($ ($define-test '() '() '(define-test () #t))) )
    (equal? #f (test-name test)) )

  (define-test ("String name")
    (define test
      ($ ($define-test '() '() '(define-test ("A name")
                                  (= 4 (+ 2 2)) ))) )
    (equal? "A name" (test-name test)) )

  (define-test ("Identifier name")
    (define test
      ($ ($define-test '() '() '(define-test (identifier)
                                  (eq? 'foo 'bar) ))) )
    (equal? "identifier" (test-name test)) )

  (define-test ("Symbolic name")
    (define test
      ($ ($define-test '() '() '(define-test ('test)
                                  (eq? '() '()) ))) )
    (equal? 'test (test-name test)) )

  (define-test ("Numeric name")
    (define test
      ($ ($define-test '() '() '(define-test (42)
                                  (= 42 (* 1 1)) ))) )
    (equal? 42 (test-name test)) )
)
(verify-test-case! test-$define-test?-names)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$define-test?-bodies)

  (define-test ("body transfer 1")
    (define test ($ ($define-test '() '() '(define-test () 42))))
    (equal? 42 (((test-body test)))) )

  (define-test ("body transfer 2")
    (define test ($ ($define-test '() '() '(define-test (Named) #f))))
    (equal? #f (((test-body test)))) )

  (define-test ("parameterized body 1")
    (define test ($ ($define-test '(x) '() '(define-test ("id") x))))
    (and (equal? 1   (((test-body test)) 1))
         (equal? #f  (((test-body test)) #f))
         (equal? 'uu (((test-body test)) 'uu)) ) )

  (define-test ("parameterized body 2")
    (define test ($ ($define-test '(a b) '() '(define-test () (+ a b)))))
    (and (=  0 (((test-body test)) -1 +1))
         (= 42 (((test-body test)) 21 21))
         (=  3 (((test-body test))  1  2)) ) )
)
(verify-test-case! test-$define-test?-bodies)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$define-test?-fixtures)

  (define-test ("fixture defs transfer")
    (define test
      ($ ($define-test '()
           '((define a 10) (define b 20))
           '(define-test () (+ a b)) )) )

    (= 30 (((test-body test)))) )
)
(verify-test-case! test-$define-test?-fixtures)
