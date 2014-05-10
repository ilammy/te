#!r6rs

(import (rnrs base)
        (te)
        (te utils verify-test-case)
        (te sr ck)
        (te sr ck-kernel)
        (te sr ck-lists)
        (te sr ck-predicates))

(define-test-case (ck-lists:cons "CK functions for lists: $cons")

  (define-test ("$cons pair")
    (equal? '(1 . 2)
      ($ ($quote ($cons '1 '2))) ) )

  (define-test ("$cons list")
    (equal? '(a b c)
      ($ ($quote ($cons 'a ($cons 'b ($cons 'c '()))))) ) )
)
(verify-test-case! ck-lists:cons)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-lists:map "CK functions for lists: $map")

  (define-test ("$map empty")
    (equal? '()
      ($ ($quote ($map '$symbol? '()))) ) )

  (define-test ("$map non-empty")
    (equal? '((1 2) (x y) (r))
      ($ ($quote ($map '$reverse '((2 1) (y x) (r))))) ) )

  (define-test ("$map partial")
    (equal? '((x 1) (x 2) (x 3))
      ($ ($quote ($map '($cons 'x) '((1) (2) (3))))) ) )
)
(verify-test-case! ck-lists:map)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-lists:reverse "CK functions for lists: $reverse")

  (define-test ("$reverse empty")
    (equal? '()
      ($ ($quote ($reverse '()))) ) )

  (define-test ("$reverse one")
    (equal? '(1)
      ($ ($quote ($reverse '(1)))) ) )

  (define-test ("$reverse")
    (equal? '(x y z)
      ($ ($quote ($reverse '(z y x)))) ) )
)
(verify-test-case! ck-lists:reverse)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-lists:span "CK functions for lists: $span")

  (define-test ("$span empty")
    (equal? '(() ())
      ($ ($quote ($span '$symbol? '()))) ) )

  (define-test ("$span normal")
    (equal? '((a b c) (1 2 d e))
      ($ ($quote ($span '$symbol? '(a b c 1 2 d e)))) ) )

  (define-test ("$span no first")
    (equal? '(() (1 2 3 4))
      ($ ($quote ($span '$symbol? '(1 2 3 4)))) ) )

  (define-test ("$span no second")
    (equal? '((a b c) ())
      ($ ($quote ($span '$symbol? '(a b c)))) ) )
)
(verify-test-case! ck-lists:span)
