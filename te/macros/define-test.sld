(define-library (te macros define-test)

  (export $define-test
          $define-test-form?)

  (import (scheme base)
          (te internal data)
          (te sr ck)
          (te sr ck-kernel)
          (te sr ck-lists)
          (te sr ck-predicates))

  (begin

    (define-syntax $define-test-form?
      (syntax-rules (quote define-test)
        ((_ s '(define-test (name ...) body1 body2 ...)) ($ s '#t))
        ((_ s 'anything-else)                            ($ s '#f)) ) )

    (define-syntax $fixup-name
      (syntax-rules (quote)
        ((_ s 'name) ($ s ($if ($symbol? 'name)
                              ''(symbol->string 'name)
                              ''name ))) ) )

    (define-syntax $parse-define-test-form
      (syntax-rules (quote define-test)
        ((_ s '(define-test () test-body1 test-body2 ...))
         ($ s '(#f () ((quote (()))) (test-body1 test-body2 ...))) )

        ((_ s '(define-test (name) test-body1 test-body2 ...))
         ($ s ($cons ($fixup-name 'name)
                    '(() ((quote (()))) (test-body1 test-body2 ...)))) )

        ((_ s '(define-test (name data-args ...) #(data-body1 data-body2 ...)
                 test-body1 test-body2 ... ))
         ($ s ($cons ($fixup-name 'name)
                    '((data-args ...)
                      (data-body1 data-body2 ...)
                      (test-body1 test-body2 ...)) )) ) ) )

    (define-syntax $make-test
      (syntax-rules (quote make-test lambda)
        ((_ s '(param-args ...) '(fixture-defs ...)
              '(name (data-args ...) (data-body1 data-body2 ...)
                                     (test-body1 test-body2 ...) ) )
         ($ s '(make-test name
                 (lambda (data-args ...)
                   (lambda (param-args ...)
                     fixture-defs ...
                     test-body1 test-body2 ... ) )
                 (lambda () data-body1 data-body2 ...) )) ) ) )

    (define-syntax $define-test
      (syntax-rules (quote define-test)
        ((_ s 'param-args 'fixture-defs 'test-form)
         ($ s ($make-test
                'param-args
                'fixture-defs
                ($parse-define-test-form 'test-form) )) ) ) )
) )
