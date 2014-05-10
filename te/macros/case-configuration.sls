#!r6rs
(library (te macros case-configuration)

  (export $configuration-form?
          $define-fixture
          $define-case-wrapper
          $define-test-wrapper
          $extract-test-parameters
          $normalize-case-configuration
          $ensure-default-configuration)

  (import (rnrs base)
          (te sr ck))

  (begin

    (define-syntax $configuration-form?
      (syntax-rules (quote define-fixture define-case-wrapper define-test-wrapper)
        ((_ s '(define-fixture      ignore ...)) ($ s '#t))
        ((_ s '(define-case-wrapper ignore ...)) ($ s '#t))
        ((_ s '(define-test-wrapper ignore ...)) ($ s '#t))
        ((_ s 'anything-else)                    ($ s '#f)) ) )

    (define-syntax $define-fixture
      (syntax-rules (quote define-fixture)
        ((_ s '())                        ($ s '()))
        ((_ s '(define-fixture body ...)) ($ s '(body ...))) ) )

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

    (define-syntax $normalize-case-configuration
      (syntax-rules (quote define-case-wrapper define-test-wrapper)
        ((_ s 'specs) ($ s ($normalize-case-configuration '#f '#f '#f 'specs)))

        ((_ s 'case 'test 'defs '()) ($ s '(case test defs)))

        ((_ s '#f   'test 'defs
              '((define-case-wrapper body ...) other ...))
         ($ s ($normalize-case-configuration
                '(define-case-wrapper body ...) 'test 'defs '(other ...) )) )

        ((_ s 'case  '#f  'defs
              '((define-test-wrapper body ...) other ...))
         ($ s ($normalize-case-configuration
                'case '(define-test-wrapper body ...) 'defs '(other ...) )) )

        ((_ s 'case 'test   '#f
              '((define-fixture body-defs ...) other ...))
         ($ s ($normalize-case-configuration
                'case 'test '(define-fixture body-defs ...) '(other ...) )) ) ) )

    (define-syntax $ensure-default-configuration
      (syntax-rules (quote define-case-wrapper define-test-wrapper)
        ((_ s '(#f   test defs))
         ($ s ($ensure-default-configuration '((define-case-wrapper (run) (run)) test defs) )))

        ((_ s '(case  #f  defs))
         ($ s ($ensure-default-configuration '(case (define-test-wrapper (run) (run)) defs) )))

        ((_ s '(case test   #f))
         ($ s ($ensure-default-configuration '(case test ()) )))

        ((_ s '(case test defs)) ($ s '(case test defs))) ) )

) )
