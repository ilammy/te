#!r6rs

(import (rnrs base)
        (te)
        (te utils verify-test-case))

(define basic-features
  (make-test-case "Basic features"
    (lambda (run) (run))
    (lambda (run) (run))
    (list
      (make-test #f (lambda () #t))

      (make-test "Dummy test" (lambda () #t))

      (make-test "Anonymous tests"
        (lambda ()
          (define test-case
            (make-test-case "Anonymous tests"
              (lambda (run) (run))
              (lambda (run) (run))
              (list
                (make-test #f (lambda () (= 3 (+ 1 2))))
                (make-test #f (lambda () (= 42 (* 6 7)))) ) ) )

          (verify-test-case! test-case) ) )

      (make-test "Named tests"
        (lambda ()
          (define named-tests
            (make-test-case "named-tests"
              (lambda (run) (run))
              (lambda (run) (run))
              (list
                (make-test "Add" (lambda () (= 3 (+ 1 2))))
                (make-test "Mul" (lambda () (= 42 (* 6 7))))
                (make-test "eq?" (lambda () (eq? 'foo 'foo))) ) ) )

          (verify-test-case! named-tests) ) ) ) ) )

(verify-test-case! basic-features)

(define fixtures
  (make-test-case "Fixtures"
    (lambda (run) (run))
    (lambda (run) (run))
    (list
      (make-test "Test definitions"
        (lambda ()
          (define test-definitions
            (make-test-case "Test definitions"
              (lambda (run) (run))
              (lambda (run) (run))
              (list
                (make-test "Access"
                  (lambda ()
                    (define x 42)
                    (define y -6)
                    (= x 42) ) )

                (make-test "Modification"
                  (lambda ()
                    (define x 42)
                    (define y -6)
                    (set! x 56)
                    (= x 56) ) )

                (make-test "Access again"
                  (lambda ()
                    (define x 42)
                    (define y -6)
                    (= x (* y -7)) ) ) ) ) )

          (verify-test-case! test-definitions) ) )

      (make-test "Test wrappers"
        (lambda ()
          (define test-wrappers
            (make-test-case "Test wrappers"
              (lambda (run) (run))
              (lambda (run) (run 1 2 3))
              (list
                (make-test "Access"
                  (lambda (x y z)
                    (= 6 (+ x y z)) ) ) ) ) )

          (verify-test-case! test-wrappers) ) )

      (make-test "Fixture wrappers"
        (lambda ()
          (define outer-x 42)

          (define fixture-wrappers
            (make-test-case "Fixture wrappers"
              (lambda (run) (set! outer-x 56) (run))
              (lambda (run) (run))
              (list
                (make-test "access"
                  (lambda ()
                    (= outer-x 56) ) ) ) ) )

          (verify-test-case! fixture-wrappers) ) ) ) ) )

(verify-test-case! fixtures)
