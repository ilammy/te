#!r6rs

(import (rnrs base)
        (only (srfi :1) every)
        (te)
        (te utils verify-test-case)
        (te macros process-case-body)
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

(define-syntax define-case-body
  (syntax-rules ()
    ((_ binding expression)
     (define binding
       ($ ($cons 'list
            ($process-case-body expression) )) ) ) ) )

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$process-case-body:syntax:configuration)

  (define-test ("define-test only")
    (define-case-body processed
      '((define-test () 1) (define-test () 2)) )

    (valid-test-case-body? processed 2) )

  (define-test ("define-test + case wrapper")
    (define-case-body processed
      '((define-case-wrapper (run) (cons 1 2) (run))
        (define-test () 1) (define-test () 2)) )

    (valid-test-case-body? processed 2) )

  (define-test ("define-test + test wrapper")
    (define-case-body processed
      '((define-test-wrapper (run) (cons 1 2) (run))
        (define-test () 1)) )

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
        (define-test () 1) (define-test () 2)) )

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
        (define-test () 1)) )

    (valid-test-case-body? processed 1) )
)
(verify-test-case! test-$process-case-body:syntax:configuration)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$process-case-body:wrapper-handling)

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
(verify-test-case! test-$process-case-body:wrapper-handling)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$process-case-body:fixture-handling)

  (define-fixture
    (define (all-test-pass? processed-case-body)
      (let ((run   (list-ref processed-case-body 1))
            (tests (list-ref processed-case-body 2)))
        (define (test-passed? test)
          (run ((test-body test))) )
        (every test-passed? tests) ) ) )

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
(verify-test-case! test-$process-case-body:fixture-handling)
