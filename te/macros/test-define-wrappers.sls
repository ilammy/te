#!r6rs

(import (rnrs base)
        (only (racket base) define-values)
        (te)
        (te utils verify-test-case)
        (te macros define-wrappers)
        (te sr ck)
        (te sr ck-kernel))

(define-test-case (test-$define-wrapper?)

  (define-test ("accepts define-case-wrapper")
    (equal? #t
      ($ ($define-wrapper?
           '(define-case-wrapper (run)
              (run) ) )) ) )

  (define-test ("accepts define-test-wrapper")
    (equal? #t
      ($ ($define-wrapper?
           '(define-test-wrapper (run)
              (run) ) )) ) )

  (define-test ("accepts define-test-wrapper with params")
    (equal? #t
      ($ ($define-wrapper?
           '(define-test-wrapper (run a b c)
              (run 1 2 3) ) )) ) )

  (define-test ("rejects define-test")
    (equal? #f
      ($ ($define-wrapper?
           '(define-test ("Sum = 6" a b c)
              (= 6 (+ a b c)) ) )) ) )
)
(verify-test-case! test-$define-wrapper?)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$define-case-wrapper)

  (define-test ("$define-case-wrapper")
    (define wrapper
      ($ ($define-case-wrapper
           '(define-case-wrapper (run)
              (run) ) )) )

    (and (procedure? wrapper)
         (wrapper (lambda () #t)) ) )
)
(verify-test-case! test-$define-case-wrapper)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$define-test-wrapper)

  (define-test ("$define-test-wrapper nullary")
    (define wrapper
      ($ ($define-test-wrapper
           '(define-test-wrapper (run)
              (run) ) )) )

    (and (procedure? wrapper)
         (wrapper (lambda () #t)) ) )

  (define-test ("$define-test-wrapper nary")
    (define wrapper
      ($ ($define-test-wrapper
           '(define-test-wrapper (run a b c)
              (run 1 2 3) ) )) )

    (and (procedure? wrapper)
         (wrapper (lambda (a b c)
                    (and (= a 1) (= b 2) (= c 3)) )) ) )
)
(verify-test-case! test-$define-test-wrapper)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$extract-test-parameters)

  (define-test ("$extract-test-parameters nullary")
    (equal? '()
      ($ ($quote ($extract-test-parameters
                   '(define-test-wrapper (run)
                      (run) ) ))) ) )

  (define-test ("$extract-test-parameters nary")
    (equal? '(a b c)
      ($ ($quote ($extract-test-parameters
                   '(define-test-wrapper (run a b c)
                      (run 1 2 3) ) ))) ) )
)
(verify-test-case! test-$extract-test-parameters)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$reorder-and-treat-wrappers)

  (define-test ("[case, test] -> [case, test]")
    (equal? '((define-case-wrapper case-wrapper-contents)
              (define-test-wrapper test-wrapper-contents))
      ($ ($quote ($reorder-and-treat-wrappers
                   '((define-case-wrapper case-wrapper-contents)
                     (define-test-wrapper test-wrapper-contents)) ))) ) )

  (define-test ("[test, case] -> [case, test]")
    (equal? '((define-case-wrapper case-wrapper-contents)
              (define-test-wrapper test-wrapper-contents))
      ($ ($quote ($reorder-and-treat-wrappers
                   '((define-test-wrapper test-wrapper-contents)
                     (define-case-wrapper case-wrapper-contents)) ))) ) )

  (define-test ("[test] -> [#f, test]")
    (equal? '(#f (define-test-wrapper test-wrapper-contents))
      ($ ($quote ($reorder-and-treat-wrappers
                   '((define-test-wrapper test-wrapper-contents)) ))) ) )

  (define-test ("[case] -> [case, #f]")
    (equal? '((define-case-wrapper case-wrapper-contents) #f)
      ($ ($quote ($reorder-and-treat-wrappers
                   '((define-case-wrapper case-wrapper-contents)) ))) ) )

  (define-test ("[] -> [#f, #f]")
    (equal? '(#f #f)
      ($ ($quote ($reorder-and-treat-wrappers '()))) ) )
)
(verify-test-case! test-$reorder-and-treat-wrappers)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-syntax $define-only-case-wrapper
  (syntax-rules (quote)
    ((_ s '(case test))
     ($ s ($define-case-wrapper 'case)) ) ) )

(define-syntax $define-only-test-wrapper
  (syntax-rules (quote)
    ((_ s '(case test))
     ($ s ($define-test-wrapper 'test)) ) ) )

(define-test-case (test-$ensure-default-wrappers)

  (define-test ("[case, #f]")
    (define test-wrapper
      ($ ($define-only-test-wrapper
           ($ensure-default-wrappers
             '((define-case-wrapper case-wrapper-contents) #f) ) )) )

    (and (procedure? test-wrapper) (test-wrapper (lambda () #t))) )

  (define-test ("[#f, test]")
    (define case-wrapper
      ($ ($define-only-case-wrapper
           ($ensure-default-wrappers
             '(#f (define-test-wrapper test-wrapper-contents)) ) )) )

    (and (procedure? case-wrapper) (case-wrapper (lambda () #t))) )

  (define-test ("[#f, #f]")
    (define-values (test-wrapper case-wrapper)
      (values
        ($ ($define-only-test-wrapper ($ensure-default-wrappers '(#f #f))))
        ($ ($define-only-case-wrapper ($ensure-default-wrappers '(#f #f)))) ) )

    (and (procedure? case-wrapper) (case-wrapper (lambda () #t))
         (procedure? test-wrapper) (test-wrapper (lambda () #t)) ) )
)
(verify-test-case! test-$ensure-default-wrappers)
