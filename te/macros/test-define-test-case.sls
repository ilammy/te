#!r6rs

(import (rnrs base)
        (te)
        (te utils verify-test-case)
        (te internal data))

(define-test-case (define-test-case-macro "define-test-case")
  (lambda (run) (run))
  (lambda (run) (run))

  (define-test ("Anonymous")
    (define-test-case (anonymous)
      (lambda (run) (run))
      (lambda (run) (run))
      (define-test () #t) )

    (equal? (case-name anonymous) "anonymous") )

  (define-test ("String name")
    (define-test-case (named "String name")
      (lambda (run) (run))
      (lambda (run) (run))
      (define-test () #t) )

    (equal? (case-name named) "String name") )

  (define-test ("Symbol name")
    (define-test-case (named-symbolic 'symbolic-name)
      (lambda (run) (run))
      (lambda (run) (run))
      (define-test () #t) )

    (equal? (case-name named-symbolic) 'symbolic-name) )

  (define-test ("Other name (number)")
    (define-test-case (named-number 1)
      (lambda (run) (run))
      (lambda (run) (run))
      (define-test () #t) )

    (equal? (case-name named-number) 1) )

  (define-test ("Other name (boolean)")
    (define-test-case (named-bool #t)
      (lambda (run) (run))
      (lambda (run) (run))
      (define-test () #t) )

    (equal? (case-name named-bool) #t) ) )

(verify-test-case! define-test-case-macro)
