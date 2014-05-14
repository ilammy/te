#!r6rs

(import (rnrs base)
        (only (racket base) define-values)
        (only (srfi :1) every)
        (te)
        (te utils verify-test-case)
        (te macros parse-test-case-body)
        (te internal data)
        (te sr ck)
        (te sr ck-lists))

(define (valid-test-case-body? test-case-body test-count)
  (and (list? test-case-body)
       (= 3 (length test-case-body))
       (procedure?  (list-ref test-case-body 0))
       (procedure?  (list-ref test-case-body 1))
       (let ((tests (list-ref test-case-body 2)))
         (and (list? tests)
              (= test-count (length tests))
              (every test? tests) ) ) ) )

(define (all-test-pass? test-case-body)
  (let ((run   (list-ref test-case-body 1))
        (tests (list-ref test-case-body 2)))
    (define (test-passed? test)
      (define (data-okay? data)
        (run (apply (test-body test) data)) )
      (every data-okay? ((test-data test))) )
    (every test-passed? tests) ) )

(define-syntax $define-case-body
  (syntax-rules (quote)
    ((_ s 'binding '((args ...) (defs ...)))
     ($ s '(define binding
             (let ()
               defs ...
               (list args ...) ) )) ) ) )

(define-syntax define-case-body
  (syntax-rules ()
    ((_ binding expression)
     ($ ($define-case-body 'binding ($parse-test-case-body expression))) ) ) )

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$parse-test-case-body:syntax)

  (define-test ("define-test only")
    (define-case-body processed
      '((define-test () 1) (define-test () 2)) )

    (valid-test-case-body? processed 2) )

  (define-test ("define-test + case wrapper")
    (define-case-body processed
      '((define-case-wrapper (run) (cons 1 2) (run))
        (define-test (Named with parameters) #(9) 1)
        (define-test () 2)) )

    (valid-test-case-body? processed 2) )

  (define-test ("define-test + test wrapper")
    (define-case-body processed
      '((define-test-wrapper (run) (cons 1 2) (run))
        (define-test ("Named") 1)) )

    (valid-test-case-body? processed 1) )

  (define-test ("define-test + both wrappers")
    (define-case-body processed
      '((define-case-wrapper (run) (cons 1 2) (run))
        (define-test-wrapper (run) (cons 3 4) (run))
        (define-test () 1) (define-test () 2)
        (define-test () 3) (define-test () 4)) )

    (valid-test-case-body? processed 4) )

  (define-test ("define-test + fixture")
    (define-case-body processed
      '((define-fixture (define some 'x))
        (define-test ("Named" with parameters) #(9) 1)
        (define-test () 2)) )

    (valid-test-case-body? processed 2) )

  (define-test ("define-test + fixture + wrappers 1")
    (define-case-body processed
      '((define-case-wrapper (run) (cons 1 2) (run))
        (define-fixture (define some 'x))
        (define-test-wrapper (run) (cons 3 4) (run))
        (define-test () 1) (define-test () 2)) )

    (valid-test-case-body? processed 2) )

  (define-test ("define-test + fixture + wrappers 2")
    (define-case-body processed
      '((define-fixture (define some 'x))
        (define-test-wrapper (run) (cons 3 4) (run))
        (define-case-wrapper (run) (cons 1 2) (run))
        (define-test ("Named") 1)) )

    (valid-test-case-body? processed 1) )

  (define-test ("define-test + fixture + wrappers + internal defs")
    (define-case-body processed
      '((define a 'foo)
        (define-fixture (define some 'x))
        (define b 'bar) (set! a b)
        (define-test-wrapper (run) (cons 3 4) (run))
        (define c 'baz)
        (define-case-wrapper (run) (cons 1 2) (run))
        (define d 'hux)
        (define-test () 1)
        (define e 'qux)) )

    (valid-test-case-body? processed 1) )
)
(verify-test-case! test-$parse-test-case-body:syntax)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$parse-test-case-body:wrapper-handling)

  (define-test ("normal wrapper order")
    (define-case-body processed
      '((define-case-wrapper (run) (run) 'CASE-HIJACK!)
        (define-test-wrapper (run) (run) 'TEST-HIJACK!)
        (define-test () #t)) )

    (let ((case-wrapper (list-ref processed 0))
          (test-wrapper (list-ref processed 1)))
      (and (equal? (case-wrapper (lambda () #t)) 'CASE-HIJACK!)
           (equal? (test-wrapper (lambda () #t)) 'TEST-HIJACK!) ) ) )

  (define-test ("inverted wrapper order")
    (define-case-body processed
      '((define-test-wrapper (run) (run) 'TEST-HIJACK!)
        (define-case-wrapper (run) (run) 'CASE-HIJACK!)
        (define-test () #t)) )

    (let ((case-wrapper (list-ref processed 0))
          (test-wrapper (list-ref processed 1)))
      (and (equal? (case-wrapper (lambda () #t)) 'CASE-HIJACK!)
           (equal? (test-wrapper (lambda () #t)) 'TEST-HIJACK!) ) ) )

  (define-test ("test wrapper argument extraction")
    (define-case-body processed
      '((define-test-wrapper (run woobley wobbley) (run 'zog 'bork))
        (define-test ("product = 42")
          (= 42 (* woobley wobbley)) )) )

    (let* ((tests (list-ref processed 2))
           (test  (list-ref tests     0)))
      (((test-body test)) 6 7) ) )
)
(verify-test-case! test-$parse-test-case-body:wrapper-handling)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$parse-test-case-body:fixture-handling)

  (define-test ("fixture normal definitions")
    (define-case-body processed
      '((define-fixture
          (define a 10)
          (define b 20)
          (define (dup x) (* 2 x)) )
        (define-test () (= 60 (dup (+ a b))))
        (define-test () (= a (- b a)))) )

    (all-test-pass? processed) )

  (define-test ("fixture mutation")
    (define-case-body processed
      '((define-fixture (define a 10))
        (define-test () (= a 10))
        (define-test () (set! a 20) (= a 20))
        (define-test () (= a 10))) )

    (all-test-pass? processed) )

  (define-test ("fixture macro definitions")
    (define-case-body processed
      '((define-fixture
          (define-syntax dup
            (syntax-rules ()
              ((_ x) (* 2 x)) ) ) )
        (define-test () (= 40 (dup 20)))) )

    (all-test-pass? processed) )

  (define-test ("fixture + parameters bindings")
    (define-case-body processed
      '((define-test-wrapper (run foo) (run 20))
        (define-fixture (define bar 10))
        (define-test () (= 30 (+ foo bar)))) )

    (all-test-pass? processed) )

  (define-test ("fixture binding priority over parameters")
    (define-case-body processed
      '((define-test-wrapper (run foo) (run 20))
        (define-fixture (define foo 10))
        (define-test () (= 10 foo))) )

    (all-test-pass? processed) )
)
(verify-test-case! test-$parse-test-case-body:fixture-handling)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$parse-test-case-body:internal-defs-handling)

  (define-test ("simple definitions")
    (define-case-body processed
      '((define x 1)
        (define-test () (= x 1))
        (define y 2)
        (define-test () (= (* 2 x) y))) )

    (all-test-pass? processed) )

  (define-test ("macro definitions")
    (define-case-body processed
      '((define-syntax duplicate
          (syntax-rules ()
            ((_ x) (* 2 x)) ) )
        (define-test () (= (duplicate 4) 8))) )

    (all-test-pass? processed) )

  (define-test ("forward definitions")
    (define-case-body processed
      '((define-test () (= y 3))
        (define x 1)
        (define y (* 3 x))) )

    (all-test-pass? processed) )

  (define-test ("visibility")
    (define-case-body processed
      '((define-test-wrapper (run foo) (run (* 2 base)))
        (define-fixture (define bar (* 3 base)))
        (define-test () (= (* 5 base) (+ foo bar)))
        (define base 9)) )

    (all-test-pass? processed) )

  (define-test ("binding priority")
    (define-case-body processed
      '((define-values (a b c) (values 10 11 12))

        (define-test-wrapper (run a b)
          (run 20 21) )

        (define-fixture
          (define a 30) )

        (define-test ("lexical structure")
          (and (= a 30)
               (= b 21)
               (= c 12) ) )) )

    (all-test-pass? processed) )
)
(verify-test-case! test-$parse-test-case-body:internal-defs-handling)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$parse-test-case-body:data-handling)

  (define-test ("visibility")
    (define-case-body processed
      '((define a 10)
        (define-test-wrapper (run a) (run 20))
        (define-fixture (define a 30))

        (define-test ("visibility in data lambda" data) #(`((,a)))
          (= data 10) )) )

    (all-test-pass? processed) )

  (define-test ("binding priority")
    (define-case-body processed
      '((define-values (a b c d) (values 10 11 12 13))

        (define-test-wrapper (run a b c)
          (run 20 21 22) )

        (define-fixture
          (define a 30)
          (define b 31) )

        (define-test ("lexical structure" a) #('((40)))
          (and (= a 40)
               (= b 31)
               (= c 22)
               (= d 13) ) )) )

    (all-test-pass? processed) )
)
(verify-test-case! test-$parse-test-case-body:internal-defs-handling)
