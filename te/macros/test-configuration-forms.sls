#!r6rs

(import (rnrs base)
        (only (racket base) define-values)
        (te)
        (te utils verify-test-case)
        (te macros configuration-forms)
        (te sr ck)
        (te sr ck-kernel))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$configuration-form?)

  (define-test ("accepts define-fixture")
    (equal? #t
      ($ ($configuration-form?
           '(define-fixture
              (define (dup) (* 2 x)) ) )) ) )

  (define-test ("accepts define-case-wrapper")
    (equal? #t
      ($ ($configuration-form?
           '(define-case-wrapper (run)
              (run) ) )) ) )

  (define-test ("accepts define-test-wrapper")
    (equal? #t
      ($ ($configuration-form?
           '(define-test-wrapper (run)
              (run) ) )) ) )

  (define-test ("accepts define-test-wrapper with params")
    (equal? #t
      ($ ($configuration-form?
           '(define-test-wrapper (run a b c)
              (run 1 2 3) ) )) ) )

  (define-test ("rejects define-test")
    (equal? #f
      ($ ($configuration-form?
           '(define-test ("Sum = 6" a b c)
              (= 6 (+ a b c)) ) )) ) )
)
(verify-test-case! test-$configuration-form?)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$define-fixture)

  (define-test ("$define-fixture with forms")
    (define quoted-fixture-defs
      ($ ($quote ($define-fixture
                   '(define-fixture
                      'over 9000 (fixture contents) ) ))) )

    (equal? quoted-fixture-defs '('over 9000 (fixture contents))) )

  (define-test ("$define-fixture empty")
    (define quoted-fixture-defs
      ($ ($quote ($define-fixture '(define-fixture)))) )

    (equal? quoted-fixture-defs '()) )
)
(verify-test-case! test-$define-fixture)

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

(define-test-case (test-$extract-param-args)

  (define-test ("$extract-param-args nullary")
    (equal? '()
      ($ ($quote ($extract-param-args
                   '(define-test-wrapper (run)
                      (run) ) ))) ) )

  (define-test ("$extract-param-args nary")
    (equal? '(a b c)
      ($ ($quote ($extract-param-args
                   '(define-test-wrapper (run a b c)
                      (run 1 2 3) ) ))) ) )
)
(verify-test-case! test-$extract-param-args)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$normalize-configuration-forms)

  (define-test ("[case, test] -> [case, test, #f]")
    (equal? '((define-case-wrapper case-wrapper-contents)
              (define-test-wrapper test-wrapper-contents)
              #f)
      ($ ($quote ($normalize-configuration-forms
                   '((define-case-wrapper case-wrapper-contents)
                     (define-test-wrapper test-wrapper-contents)) ))) ) )

  (define-test ("[test, case] -> [case, test, #f]")
    (equal? '((define-case-wrapper case-wrapper-contents)
              (define-test-wrapper test-wrapper-contents)
              #f)
      ($ ($quote ($normalize-configuration-forms
                   '((define-test-wrapper test-wrapper-contents)
                     (define-case-wrapper case-wrapper-contents)) ))) ) )

  (define-test ("[test, defs, case] -> [case, test, defs]")
    (equal? '((define-case-wrapper case-wrapper-contents)
              (define-test-wrapper test-wrapper-contents)
              (define-fixture      fixture-contents))
      ($ ($quote ($normalize-configuration-forms
                   '((define-test-wrapper test-wrapper-contents)
                     (define-fixture      fixture-contents)
                     (define-case-wrapper case-wrapper-contents)) ))) ) )

  (define-test ("[case] -> [case, #f, #f]")
    (equal? '((define-case-wrapper case-wrapper-contents) #f #f)
      ($ ($quote ($normalize-configuration-forms
                   '((define-case-wrapper case-wrapper-contents)) ))) ) )

  (define-test ("[test] -> [#f, test, #f]")
    (equal? '(#f (define-test-wrapper test-wrapper-contents) #f)
      ($ ($quote ($normalize-configuration-forms
                   '((define-test-wrapper test-wrapper-contents)) ))) ) )

  (define-test ("[defs] -> [#f, #f, defs]")
    (equal? '(#f #f (define-fixture fixture-contents))
      ($ ($quote ($normalize-configuration-forms
                   '((define-fixture fixture-contents)) ))) ) )

  (define-test ("[] -> [#f, #f, #f]")
    (equal? '(#f #f #f)
      ($ ($quote ($normalize-configuration-forms '()))) ) )
)
(verify-test-case! test-$normalize-configuration-forms)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$ensure-default-configuration)

  (define-syntax $define-only-case-wrapper
    (syntax-rules (quote)
      ((_ s '(case test defs))
       ($ s ($define-case-wrapper 'case)) ) ) )

  (define-syntax $define-only-test-wrapper
    (syntax-rules (quote)
      ((_ s '(case test defs))
       ($ s ($define-test-wrapper 'test)) ) ) )

  (define-syntax $quote-only-fixture-defs
    (syntax-rules (quote)
      ((_ s '(case test defs))
       ($ s ($quote ($define-fixture 'defs))) ) ) )

  (define-test ("[case, #f, #f]")
    (define test-wrapper
      ($ ($define-only-test-wrapper
           ($ensure-default-configuration
             '((define-case-wrapper case-wrapper-contents) #f #f) ) )) )

    (and (procedure? test-wrapper) (test-wrapper (lambda () #t))) )

  (define-test ("[#f, test, #f]")
    (define case-wrapper
      ($ ($define-only-case-wrapper
           ($ensure-default-configuration
             '(#f (define-test-wrapper test-wrapper-contents) #f) ) )) )

    (and (procedure? case-wrapper) (case-wrapper (lambda () #t))) )

  (define-test ("[#f, #f, defs]")
    (define quoted-fixture
      ($ ($quote-only-fixture-defs
           ($ensure-default-configuration
             '(#f #f (define-fixture 'over 9000 (fixture contents))) ) )) )

    (equal? quoted-fixture '('over 9000 (fixture contents))) )

  (define-test ("[#f, #f, #f]")
    (define-values (test-wrapper case-wrapper quoted-fixture)
      (values
        ($ ($define-only-test-wrapper ($ensure-default-configuration '(#f #f #f))))
        ($ ($define-only-case-wrapper ($ensure-default-configuration '(#f #f #f))))
        ($ ($quote-only-fixture-defs  ($ensure-default-configuration '(#f #f #f)))) ) )

    (and (procedure? case-wrapper) (case-wrapper (lambda () #t))
         (procedure? test-wrapper) (test-wrapper (lambda () #t))
         (equal? '() quoted-fixture) ) )
)
(verify-test-case! test-$ensure-default-configuration)
