#!r6rs
(library (te macros define-wrappers)

  (export $define-wrapper?
          $define-case-wrapper
          $define-test-wrapper
          $extract-test-parameters
          $reorder-and-treat-wrappers
          $ensure-default-wrappers)

  (import (rnrs base)
          (te sr ck))

  (begin

    (define-syntax $define-wrapper?
      (syntax-rules (quote define-case-wrapper define-test-wrapper)
        ((_ s '(define-case-wrapper ignore ...)) ($ s '#t))
        ((_ s '(define-test-wrapper ignore ...)) ($ s '#t))
        ((_ s 'anything-else)                    ($ s '#f)) ) )

    (define-syntax $define-case-wrapper
      (syntax-rules (quote define-case-wrapper)
        ((_ s '(define-case-wrapper (case-thunk) body1 body2 ...))
         ($ s '(lambda (case-thunk)
                 body1 body2 ... )) ) ) )

    (define-syntax $define-test-wrapper
      (syntax-rules (quote define-case-wrapper)
        ((_ s '(define-test-wrapper (test-thunk args ...) body1 body2 ...))
         ($ s '(lambda (test-thunk)
                 body1 body2 ... )) ) ) )

    (define-syntax $extract-test-parameters
      (syntax-rules (quote define-case-wrapper)
        ((_ s '(define-test-wrapper (test-thunk args ...) body1 body2 ...))
         ($ s '(args ...)) ) ) )

    (define-syntax $reorder-and-treat-wrappers
      (syntax-rules (quote define-case-wrapper define-test-wrapper)
        ((_ s 'specs) ($ s ($reorder-and-treat-wrappers '#f '#f 'specs)))

        ((_ s 'case 'test '()) ($ s '(case test)))

        ((_ s '#f   'test '((define-case-wrapper ignore ...) other ...))
         ($ s ($reorder-and-treat-wrappers
                '(define-case-wrapper ignore ...) 'test '(other ...) )) )

        ((_ s 'case   '#f '((define-test-wrapper ignore ...) other ...))
         ($ s ($reorder-and-treat-wrappers
                'case '(define-test-wrapper ignore ...) '(other ...) )) ) ) )

    (define-syntax $ensure-default-wrappers
      (syntax-rules (quote define-case-wrapper define-test-wrapper)
        ((_ s '(#f     #f)) ($ s '((define-case-wrapper (run) (run))
                                   (define-test-wrapper (run) (run)))))

        ((_ s '(#f   test)) ($ s '((define-case-wrapper (run) (run)) test)))

        ((_ s '(case   #f)) ($ s '(case (define-test-wrapper (run) (run)))))

        ((_ s '(case test)) ($ s '(case test))) ) )

) )
