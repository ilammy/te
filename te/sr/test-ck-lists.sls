#!r6rs

(import (rnrs base)
        (te)
        (te utils verify-test-case)
        (te sr ck)
        (te sr ck-kernel)
        (te sr ck-lists)
        (te sr ck-predicates))

(define-test-case (ck-lists "CK functions for lists")
  (lambda (run) (run))
  (lambda (run) (run))

  ;; $cons
  ;;
  (define-test ("$cons pair")
    (equal? '(1 . 2)
      ($ ($quote ($cons '1 '2))) ) )

  (define-test ("$cons list")
    (equal? '(a b c)
      ($ ($quote ($cons 'a ($cons 'b ($cons 'c '()))))) ) )

  ;; $map
  ;;
  (define-test ("$map empty")
    (equal? '()
      ($ ($quote ($map '$symbol? '()))) ) )

  (define-test ("$map non-empty")
    (equal? '((1 2) (x y) (r))
      ($ ($quote ($map '$reverse '((2 1) (y x) (r))))) ) )

  ;; $reverse
  ;;
  (define-test ("$reverse empty")
    (equal? '()
      ($ ($quote ($reverse '()))) ) )

  (define-test ("$reverse one")
    (equal? '(1)
      ($ ($quote ($reverse '(1)))) ) )

  (define-test ("$reverse")
    (equal? '(x y z)
      ($ ($quote ($reverse '(z y x)))) ) )

  ;; $span
  ;;
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
      ($ ($quote ($span '$symbol? '(a b c)))) ) ) )

(verify-test-case! ck-lists)
