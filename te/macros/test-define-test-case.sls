#!r6rs

(import (rnrs base)
        (te)
        (te conditions assertions)
        (te utils verify-test-case)
        (te internal data))

(define-test-case (define-test-case-macro "define-test-case")

  (define-test ("Anonymous")
    (define-test-case (anonymous)
      (define-test () #t) )

    (assert-equal "anonymous" (case-name anonymous)) )

  (define-test ("String name")
    (define-test-case (named "String name")
      (define-test () #t) )

    (assert-equal "String name" (case-name named)) )

  (define-test ("Symbol name")
    (define-test-case (named-symbolic 'symbolic-name)
      (define-test () #t) )

    (assert-equal 'symbolic-name (case-name named-symbolic)) )

  (define-test ("Other name (number)")
    (define-test-case (named-number 1)
      (define-test () #t) )

    (assert-equal 1 (case-name named-number)) )

  (define-test ("Other name (boolean)")
    (define-test-case (named-bool #t)
      (define-test () #t) )

    (assert-equal #t (case-name named-bool)) )
)
(verify-test-case! define-test-case-macro)
