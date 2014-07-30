(import (scheme base)
        (te)
        (te conditions assertions)
        (te utils verify-test-case)
        (te sr ck)
        (te sr ck-kernel)
        (te sr ck-lists)
        (te sr ck-predicates))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-lists:cons "CK functions for lists: $cons")

  (define-test ("$cons pair")
    (assert-equal '(1 . 2)
      ($ ($quote ($cons '1 '2))) ) )

  (define-test ("$cons list")
    (assert-equal '(a b c)
      ($ ($quote ($cons 'a ($cons 'b ($cons 'c '()))))) ) )
)
(verify-test-case! ck-lists:cons)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-lists:map "CK functions for lists: $map")

  (define-test ("$map empty")
    (assert-equal '()
      ($ ($quote ($map '$symbol? '()))) ) )

  (define-test ("$map non-empty")
    (assert-equal '((1 2) (x y) (r))
      ($ ($quote ($map '$reverse '((2 1) (y x) (r))))) ) )

  (define-test ("$map partial")
    (assert-equal '((x 1) (x 2) (x 3))
      ($ ($quote ($map '($cons 'x) '((1) (2) (3))))) ) )
)
(verify-test-case! ck-lists:map)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-lists:reverse "CK functions for lists: $reverse")

  (define-test ("$reverse empty")
    (assert-equal '()
      ($ ($quote ($reverse '()))) ) )

  (define-test ("$reverse one")
    (assert-equal '(1)
      ($ ($quote ($reverse '(1)))) ) )

  (define-test ("$reverse")
    (assert-equal '(x y z)
      ($ ($quote ($reverse '(z y x)))) ) )
)
(verify-test-case! ck-lists:reverse)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-lists:span "CK functions for lists: $span")

  (define-test ("$span empty")
    (assert-equal '(() ())
      ($ ($quote ($span '$symbol? '()))) ) )

  (define-test ("$span normal")
    (assert-equal '((a b c) (1 2 d e))
      ($ ($quote ($span '$symbol? '(a b c 1 2 d e)))) ) )

  (define-test ("$span no first")
    (assert-equal '(() (1 2 3 4))
      ($ ($quote ($span '$symbol? '(1 2 3 4)))) ) )

  (define-test ("$span no second")
    (assert-equal '((a b c) ())
      ($ ($quote ($span '$symbol? '(a b c)))) ) )
)
(verify-test-case! ck-lists:span)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-lists:filter "CK functions for lists: $filter")

  (define-test ("$filter empty")
    (assert-equal '()
      ($ ($quote ($filter '$symbol? '()))) ) )

  (define-test ("$filter 1")
    (assert-equal '((1) (2) (3))
      ($ ($quote ($filter '$list? '((1) a (2) #f (3) "9")))) ) )

  (define-test ("$filter 2")
    (assert-equal '(#t #f)
      ($ ($quote ($filter '$bool? '(#t a (#t) #f)))) ) )

  (define-test ("$filter 3")
    (assert-equal '(1 1 1)
      ($ ($quote ($filter '($same? '1) '(1 2 3 2 1 2 3 4 1)))) ) )
)
(verify-test-case! ck-lists:filter)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-lists:partition "CK functions for lists: partition")

  (define-test ("empty list")
    (assert-equal '(()())
      ($ ($quote ($partition '$bool? '()))) ) )

  (define-test ("only true")
    (assert-equal '((#t #t #f) ())
      ($ ($quote ($partition '$bool? '(#t #t #f)))) ) )

  (define-test ("only false")
    (assert-equal '(() (3 8 x #t))
      ($ ($quote ($partition '$list? '(3 8 x #t)))) ) )

  (define-test ("partial")
    (assert-equal '((1 1 1) (a b c d))
      ($ ($quote ($partition '($same? '1) '(a 1 b 1 c 1 d)))) ) )
)
(verify-test-case! ck-lists:partition)
