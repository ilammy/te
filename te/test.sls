#!r6rs

(import (rnrs base)
        (te)
        (te utils verify-test-case))

(define-test-case (basic-features "Basic features")
  (lambda (run) (run))
  (lambda (run) (run))

  (define-test () #t)

  (define-test ("Dummy test") #t)

  (define-test ("Anonymous tests")
    (define-test-case (test-case "Anonymous tests")
      (lambda (run) (run))
      (lambda (run) (run))

      (define-test () (= 3 (+ 1 2)))
      (define-test () (= 42 (* 6 7))) )

    (verify-test-case! test-case) )

  (define-test ("Named tests")
    (define-test-case (named-tests)
      (lambda (run) (run))
      (lambda (run) (run))

      (define-test ("Add") (= 3 (+ 1 2)))
      (define-test ("Mul") (= 42 (* 6 7)))
      (define-test ("eq?") (eq? 'foo 'foo)) )

    (verify-test-case! named-tests) ) )

(verify-test-case! basic-features)

(define-test-case (fixtures "Fixtures")
  (lambda (run) (run))
  (lambda (run) (run))

  (define-test ("Test definitions")
    (define-test-case (test-definitions "Test definitions")
      (lambda (run) (run))
      (lambda (run) (run))

      (define-test ("Access")
        (define x 42)
        (define y -6)
        (= x 42) )

      (define-test ("Modification")
        (define x 42)
        (define y -6)
        (set! x 56)
        (= x 56) )

      (define-test ("Access again")
        (define x 42)
        (define y -6)
        (= x (* y -7)) ) )

    (verify-test-case! test-definitions) )

  (define-test ("Test wrappers")
    (define-test-case (test-wrappers "Test wrappers")
      (lambda (run) (run))
      (lambda (run) (run 1 2 3))

      (make-test "Access"
        (lambda (x y z)
          (= 6 (+ x y z)) ) ) )

    (verify-test-case! test-wrappers) )

  (define-test ("Fixture wrappers")
    (define outer-x 42)

    (define-test-case (fixture-wrappers "Fixture wrappers")
      (lambda (run) (set! outer-x 56) (run))
      (lambda (run) (run))

      (define-test ("access")
        (= outer-x 56) ) )

    (verify-test-case! fixture-wrappers) ) )

(verify-test-case! fixtures)
