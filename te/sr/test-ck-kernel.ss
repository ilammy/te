(import (scheme base)
        (te base)
        (te conditions assertions)
        (te utils verify-test-case)
        (te sr ck)
        (te sr ck-kernel)
        (te sr ck-predicates))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-kernel:quote "Kernel CK functions: $quote")

  (define-test ("$quote simple value")
    (assert-equal 'foobar
      ($ ($quote 'foobar)) ) )

  (define-test ("$quote special forms")
    (assert-equal '(begin failing)
      ($ ($quote '(begin failing))) ) )

  (define-test ("$quote $quote")
    (assert-equal '$quote
      ($ ($quote '$quote)) ) )
)
(verify-test-case! ck-kernel:quote)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-kernel:if "Kernel CK functions: $if")

  (define-test ("$if <- #t")
    (assert-equal 1
      ($ ($if '#t ''1 ''2)) ) )

  (define-test ("$if <- #f")
    (assert-equal 'foo
      ($ ($if '#f ''1 '($quote 'foo))) ) )

  (define-test ("$if <- expr")
    (assert-equal 1
      ($ ($if ($symbol? 'foo) ''1 ''2)) ) )

  (define-test ("$if <- $if")
    (assert-equal #f
      ($ ($if ($if '#t ''#f ''#t) ''#t ''#f)) ) )
)
(verify-test-case! ck-kernel:if)
