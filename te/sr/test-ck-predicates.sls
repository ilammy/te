#!r6rs

(import (rnrs base)
        (te)
        (te utils verify-test-case)
        (te sr ck)
        (te sr ck-predicates))

(define-test-case (ck-predicates:symbol? "CK predicate functions: $symbol?")

  (define-test ("$symbol? symbols")
    (equal? #t
      ($ ($symbol? 'foo)) ) )

  (define-test ("$symbol? list")
    (equal? #f
      ($ ($symbol? '(1 2 3))) ) )

  (define-test ("$symbol? empty list")
    (equal? #f
      ($ ($symbol? '())) ) )

  (define-test ("$symbol? number")
    (equal? #f
      ($ ($symbol? '42)) ) )

  (define-test ("$symbol? vector")
    (equal? #f
      ($ ($symbol? '#(4 5 6))) ) )

  (define-test ("$symbol? quoted symbol")
    (equal? #f
      ($ ($symbol? ''f)) ) )

  (define-test ("$symbol? bool")
    (equal? #f
      ($ ($symbol? '#f)) ) )
)
(verify-test-case! ck-predicates:symbol?)
