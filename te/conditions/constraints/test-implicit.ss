(import (scheme base)
        (scheme inexact)
        (te base)
        (te utils verify-test-case)
        (te conditions constraints assert-that)
        (te conditions constraints implicit)
        (te conditions assertions comparison)
        (te conditions assertions implicit)
        (te conditions assertions equivalence)
        (te conditions common test-utils))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-general-constraints)

  (define-test ("is-true accepts non-#f" value)
    #((list '(42) '(#t) '(()) '("string") '(symbol)))
    (assert-eq value (assert-that value (is-true))) )

  (define-test ("is-true rejects #f")
    (assert-fails (assert-that #f (is-true))) )

  (define-test ("is-false accepts #f")
    (assert-eq #f (assert-that #f (is-false))) )

  (define-test ("is-false rejects non-#f" value)
    #((list '(42) '(#t) '(()) '("string") '(symbol)))
    (assert-fails (assert-that value (is-false))) )
)
(verify-test-case! test-general-constraints)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-special-constraints)

  (define-test ("is-null accepts empty list")
    (assert-eq '() (assert-that '() (is-null))) )

  (define-test ("is-null rejects anything else except the empty list" obj)
    #((list '(#()) '(#f) '("") `(,(lambda () #f)) '(0) '(#\0)))
    (assert-fails (assert-that obj (is-null))) )
)
(verify-test-case! test-special-constraints)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-nan-constraints)

  (define-test ("is-nan accepts NaN values")
    (assert-true (nan? (assert-that +nan.0 (is-nan))))
    (assert-true (nan? (assert-that -nan.0 (is-nan)))) )

  (define-test ("is-not-nan rejects NaN values")
    (assert-fails (assert-that +nan.0 (is-not-nan)))
    (assert-fails (assert-that -nan.0 (is-not-nan))) )

  (define not-nan-values '((1) (0) (+inf.0) (-inf.0)))

  (define-test ("is-nan rejects not-NaN values" value)
    #(not-nan-values)
    (assert-fails (assert-that value (is-nan))) )

  (define-test ("is-not-nan accepts not-NaN values" value)
    #(not-nan-values)
    (assert-eqv value (assert-that value (is-not-nan))) )
)
(verify-test-case! test-nan-constraints)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-finiteness-constraints)

  ;; Unfortunately, these tests are pretty implementation-specific,
  ;; so we keep the figures as low and explicit as possible.

  (define finite-numbers '((1) (2) (0.0) (900000.0)))
  (define infinite-numbers '((+inf.0) (-inf.0)))

  (define-test ("is-finite accepts finite numbers" number)
    #(finite-numbers)
    (assert-= number (assert-that number (is-finite))) )

  (define-test ("is-finite rejects infinite numbers" number)
    #(infinite-numbers)
    (assert-fails (assert-that number (is-finite))) )

  (define-test ("is-infinite accepts infinite numbers" number)
    #(infinite-numbers)
    (assert-= number (assert-that number (is-infinite))) )

  (define-test ("is-infinite rejects finite numbers" number)
    #(finite-numbers)
    (assert-fails (assert-that number (is-infinite))) )
)
(verify-test-case! test-finiteness-constraints)
