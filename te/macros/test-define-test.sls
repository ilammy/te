#!r6rs

(import (rnrs base)
        (te)
        (te utils verify-test-case)
        (te macros define-test)
        (te internal data)
        (te sr ck))

(define-test-case (parse-define-test "$define-test")
  (lambda (run) (run))
  (lambda (run) (run))

  (define-test ("Anonymous")
    (define test ($ ($define-test '() '(#t))))
    (and (equal? #f (test-name test))
         ((test-body test)) ) )

  (define-test ("String name")
    (define test ($ ($define-test '("A name")
                      '((= 4 (+ 2 2))) )))
    (and (equal? "A name" (test-name test))
         ((test-body test)) ) )

  (define-test ("Identifier name")
    (define test ($ ($define-test '(identifier)
                      '((eq? 'foo 'bar)) )))
    (and (equal? "identifier" (test-name test))
         (not ((test-body test))) ) )

  (define-test ("Symbolic name")
    (define test ($ ($define-test '('test)
                      '((eq? '() '())) )))
    (and (equal? 'test (test-name test))
         ((test-body test)) ) )

  (define-test ("Numeric name")
    (define test ($ ($define-test '(42)
                      '((= 42 (* 1 1))) )))
    (and (equal? 42 (test-name test))
         (not ((test-body test))) ) ) )

(verify-test-case! parse-define-test)
