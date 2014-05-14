#!r6rs

(import (rnrs base)
        (te)
        (te utils verify-test-case))

(define-test-case (basic-features "Basic features")

  (define-test () #t)

  (define-test ("Dummy test") #t)

  (define-test ("Anonymous tests")
    (define-test-case (test-case "Anonymous tests")
      (define-test () (= 3 (+ 1 2)))
      (define-test () (= 42 (* 6 7))) )

    (verify-test-case! test-case) )

  (define-test ("Named tests")
    (define-test-case (named-tests)
      (define-test ("Add") (= 3 (+ 1 2)))
      (define-test ("Mul") (= 42 (* 6 7)))
      (define-test ("eq?") (eq? 'foo 'foo)) )

    (verify-test-case! named-tests) )
)
(verify-test-case! basic-features)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (fixtures "Fixtures")

  (define-test ("Test definitions")
    (define-test-case (test-definitions "Test definitions")
      (define-fixture
        (define x 42)
        (define y -6) )

      (define-test ("Access")
        (= x 42) )

      (define-test ("Modification")
        (set! x 56)
        (= x 56) )

      (define-test ("Access again")
        (= x (* y -7)) )
    )
    (verify-test-case! test-definitions) )

  ; -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   - ;

  (define-test ("Test wrappers")
    (define-test-case (test-wrappers "Test wrappers")
      (define-test-wrapper (run x y z)
        (run 1 2 3) )

      (define-test () (= 6 (+ x y z)))
    )
    (verify-test-case! test-wrappers) )

  ; -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   - ;

  (define-test ("Fixture wrappers")
    (define outer-x 42)

    (define-test-case (case-wrappers "Case wrappers")
      (define-case-wrapper (run)
        (set! outer-x 56) (run) )

      (define-test () (= 56 outer-x))
    )
    (verify-test-case! case-wrappers) )

  ; -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   - ;

  (define-test ("Test + case wrappers")
    (define outer-x 42)

    (define-test-case (both-wrappers "Test + case wrappers")
      (define-test-wrapper (run factor)
        (run 2) )

      (define-case-wrapper (run)
        (set! outer-x 56) (run) )

      (define-test () (= outer-x (* factor 28)))
    )
    (verify-test-case! both-wrappers) )

  ; -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   - ;

  (define-test ("Case + test wrappers")
    (define outer-x 42)

    (define-test-case (both-wrappers "Case + test wrappers")
      (define-case-wrapper (run)
        (set! outer-x 56) (run) )

      (define-test-wrapper (run factor)
        (run 2) )

      (define-test () (= outer-x (* factor 28)))
    )
    (verify-test-case! both-wrappers) )
)
(verify-test-case! fixtures)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (definitions "Internal definitions")

  (define-test ("Simple definitions")

    (define-test-case (simple-defs)
      (define-syntax add
        (syntax-rules ()
          ((_ x ...) (+ x ...)) ) )

      (define x (add 3 7))

      (define-test ("Reference")
        (= x 10) )
    )
    (verify-test-case! simple-defs) )

  (define-test ("internal define syntax")

    (define-test-case (internal-defs)
      (define-test ("Forward reference")
        (= x 10) )

      (define y 5)
      (define x (* 2 y))

      (define-test ("Modification") ; don't try this at home!
        (set! x 40)
        (= x 40) )
    )
    (verify-test-case! internal-defs) )

  (define-test ("Interaction with fixtures")

    (define-test-case (defs+fixtures)
      (define x 5)
      (define y 10)

      (define-fixture
        (define foo (+ x 1))
        (define y 88) )

      (define-test ("lexical structure")
        (and (= x 5)
             (= foo 6)
             (= y 88) ) )
    )
    (verify-test-case! defs+fixtures) )
)
(verify-test-case! definitions)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (data-driven "Data-driven testing")

  (define-test ("Simple data")
    (define-test-case (simple)
      (define-test ("Addition" a b sum)
        #('((0 1 1) (2 2 4)))
        (= (+ a b) sum) )
    )
    (verify-test-case! simple) )

  (define-test ("Generated data")
    (define (my-map proc list)
      (let loop ((result '())
                 (list list))
        (if (null? list) (reverse result)
            (loop (cons (proc (car list)) result)
                  (cdr list) ) ) ) )

    (define (map-combinatorial proc list1 list2)
      (apply append
        (map (lambda (elt1)
          (map (lambda (elt2)
            (proc elt1 elt2) )
            list2 ) )
          list1 ) ) )

    (define-test-case (test-my-map)
      (define-test ("Empty") (null? (my-map (lambda (x) x) '())))

      (define procs
        (list (lambda (x) x)
              (lambda (x) (equal? x 1))
              (lambda (x) (if (number? x) (* x 57) 'banana)) ) )

      (define lists
        (list '(1 2 3 4)
              '(foo bar)
              (list + * - /)
              '()
              '("a" 4 'bark '(42)) ) )

      (define-test ("Orig. map" proc list expected)
        #((map-combinatorial
            (lambda (proc list)
              `(,proc ,list ,(map proc list)) )
            procs lists ))
        (equal? (my-map proc list) expected) )
    )
    (verify-test-case! test-my-map) )
)
(verify-test-case! data-driven)
