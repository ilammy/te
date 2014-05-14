#!r6rs

(import (rnrs base)
        (te)
        (te utils verify-test-case)
        (te sr ck)
        (te sr ck-kernel)
        (te sr ck-predicates))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-kernel:quote "Kernel CK functions: $quote")

  (define-test ("$quote simple value")
    (equal? 'foobar
      ($ ($quote 'foobar)) ) )

  (define-test ("$quote special forms")
    (equal? '(begin failing)
      ($ ($quote '(begin failing))) ) )

  (define-test ("$quote $quote")
    (equal? '$quote
      ($ ($quote '$quote)) ) )
)
(verify-test-case! ck-kernel:quote)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-kernel:if "Kernel CK functions: $if")

  (define-test ("$if <- #t")
    (equal? 1
      ($ ($if '#t ''1 ''2)) ) )

  (define-test ("$if <- #f")
    (equal? 'foo
      ($ ($if '#f ''1 '($quote 'foo))) ) )

  (define-test ("$if <- expr")
    (equal? 1
      ($ ($if ($symbol? 'foo) ''1 ''2)) ) )

  (define-test ("$if <- $if")
    (equal? #f
      ($ ($if ($if '#t ''#f ''#t) ''#t ''#f)) ) )
)
(verify-test-case! ck-kernel:if)
