#!r6rs

(import (rnrs base)
        (te)
        (te utils verify-test-case)
        (te conditions assertions equivalence)
        (te conditions assertions implicit)
        (te conditions assertions test-utils))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-general-assertions)

  (define-test ("assert-true accepts non-#f" value)
    #((list '(42) '(#t) '(()) '("string") '(symbol)))
    (assert-eq value (assert-true value)) )

  (define-test ("assert-true rejects #f")
    (assert-fails (assert-true #f)) )

  (define-test ("assert-false accepts #f")
    (assert-eq #f (assert-false #f)) )

  (define-test ("assert-false rejects non-#f" value)
    #((list '(42) '(#t) '(()) '("string") '(symbol)))
    (assert-fails (assert-false value)) )
)
(verify-test-case! test-general-assertions)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-special-assertions)

  (define-test ("assert-null accepts empty list")
    (assert-eq '() (assert-null '())) )

  (define-test ("assert-null rejects anything else except the empty list" obj)
    #((list '(#()) '(#f) '("") `(,(lambda () #f)) '(0) '(#\0)))
    (assert-fails (assert-null obj)) )
)
(verify-test-case! test-special-assertions)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-nan-assertions)

  (define-test ("assert-nan accepts NaN values")
    (assert-true (nan? (assert-nan +nan.0)))
    (assert-true (nan? (assert-nan -nan.0))) )

  (define-test ("assert-not-nan rejects NaN values")
    (assert-fails (assert-not-nan +nan.0))
    (assert-fails (assert-not-nan -nan.0)) )

  (define not-nan-values '((1) (0) (+inf.0) (-inf.0)))

  (define-test ("assert-nan rejects not-NaN values" value)
    #(not-nan-values)
    (assert-fails (assert-nan value)) )

  (define-test ("assert-not-nan accepts not-NaN values" value)
    #(not-nan-values)
    (assert-eqv value (assert-not-nan value)) )
)
(verify-test-case! test-nan-assertions)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-finiteness-assertions)

  ;; Unfortunately, these tests are pretty implementation-specific,
  ;; so we keep the figures as low and explicit as possible.

  (define finite-numbers '((1) (2) (0.0) (900000.0)))
  (define infinite-numbers '((+inf.0) (-inf.0)))

  (define-test ("assert-finite accepts finite numbers" number)
    #(finite-numbers)
    (assert-true (= number (assert-finite number))) )

  (define-test ("assert-finite rejects infinite numbers" number)
    #(infinite-numbers)
    (assert-fails (assert-finite number)) )

  (define-test ("assert-infinite accepts infinite numbers" number)
    #(infinite-numbers)
    (assert-true (= number (assert-infinite number))) )

  (define-test ("assert-infinite rejects finite numbers" number)
    #(finite-numbers)
    (assert-fails (assert-infinite number)) )
)
(verify-test-case! test-finiteness-assertions)
