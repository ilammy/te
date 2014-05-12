#!r6rs
(library (te macros data-processing)

  (export $anonymous-define-test?
          $test-definition-name
          $normalize-test-group)

  (import (rnrs base)
          (te sr ck))

  (begin

    (define-syntax $anonymous-define-test?
      (syntax-rules (quote define-test)
        ((_ s '(define-test () body ...)) ($ s '#t))
        ((_ s 'anything-else)             ($ s '#f)) ) )

    (define-syntax $test-definition-name
      (syntax-rules (quote define-test define-data)
        ((_ s '(define-test (name args ...) body ...)) ($ s 'name))
        ((_ s '(define-data (name) body ...))          ($ s 'name)) ) )

    (define-syntax $normalize-test-group
      (syntax-rules (quote define-test define-data)
        ((_ s '((define-test ()     body ...)))
         ($ s '((define-test ()     body ...) ())))

        ((_ s '((define-test (name) body ...)))
         ($ s '((define-test (name) body ...) ())))

        ((_ s '((define-test (name args ...) test-body ...)
                (define-data (name*)         data-body ...)))
         ($ s '((define-test (name args ...) test-body ...) (data-body ...))) )

        ((_ s '((define-data (name*)         data-body ...)
                (define-test (name args ...) test-body ...)))
         ($ s '((define-test (name args ...) test-body ...) (data-body ...))) ) ) )

) )
