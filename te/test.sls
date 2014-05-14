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
