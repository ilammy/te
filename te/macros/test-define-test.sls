#!r6rs

(import (rnrs base)
        (te)
        (te utils verify-test-case)
        (te macros define-test)
        (te internal data)
        (te sr ck))

(define-test-case (test-$define-test2:names)

  (define-test ("Anonymous")
    (define test
      ($ ($define-test2 '() '() '() '(define-test () #t))) )
    (equal? #f (test-name test)) )

  (define-test ("String name")
    (define test
      ($ ($define-test2 '() '() '() '(define-test ("A name")
                                      (= 4 (+ 2 2)) ))) )
    (equal? "A name" (test-name test)) )

  (define-test ("Identifier name")
    (define test
      ($ ($define-test2 '() '() '() '(define-test (identifier)
                                      (eq? 'foo 'bar) ))) )
    (equal? "identifier" (test-name test)) )

  (define-test ("Symbolic name")
    (define test
      ($ ($define-test2 '() '() '() '(define-test ('test)
                                      (eq? '() '()) ))) )
    (equal? 'test (test-name test)) )

  (define-test ("Numeric name")
    (define test
      ($ ($define-test2 '() '() '() '(define-test (42)
                                      (= 42 (* 1 1)) ))) )
    (equal? 42 (test-name test)) )
)
(verify-test-case! test-$define-test2:names)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$define-test2:bodies)

  (define-test ("body transfer 1")
    (define test ($ ($define-test2 '() '() '() '(define-test () 42))))
    (equal? 42 (((test-body test)))) )

  (define-test ("body transfer 2")
    (define test ($ ($define-test2 '() '() '() '(define-test (Named) #f))))
    (equal? #f (((test-body test)))) )

  (define-test ("parameterized body 1")
    (define test ($ ($define-test2 '() '(x) '()
                      '(define-test ("id") x) )))
    (and (equal? 1   (((test-body test)) 1))
         (equal? #f  (((test-body test)) #f))
         (equal? 'uu (((test-body test)) 'uu)) ) )

  (define-test ("parameterized body 2")
    (define test ($ ($define-test2 '() '(a b) '()
                      '(define-test () (+ a b)) )))
    (and (=  0 (((test-body test)) -1 +1))
         (= 42 (((test-body test)) 21 21))
         (=  3 (((test-body test))  1  2)) ) )
)
(verify-test-case! test-$define-test2:bodies)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$define-test2:fixtures)

  (define-test ("fixture defs transfer")
    (define test
      ($ ($define-test2 '() '()
           '((define a 10) (define b 20))
           '(define-test () (+ a b)) )) )

    (= 30 (((test-body test)))) )
)
(verify-test-case! test-$define-test2:fixtures)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$define-test2:data-thunks)

  (define-test ("data thunk transfer")
    (define test
      ($ ($define-test2 '((list (list 1 2)))
           '() '()
           '(define-test ("Sum" a b) (+ a b)) )) )
    (equal? '((1 2))
      ((test-data test)) ) )

  (define-test ("no data special case: anonymous")
    (define test
      ($ ($define-test2 '() '() '()
           '(define-test () #t) )) )
    (equal? '(())
      ((test-data test)) ) )

  (define-test ("no data special case: named")
    (define test
      ($ ($define-test2 '() '() '()
           '(define-test (T) #t) )) )
    (equal? '(())
      ((test-data test)) ) )
)
(verify-test-case! test-$define-test2:data-thunks)
