#!r6rs
(library (te macros define-test)

  (export $define-test)

  (import (rnrs base)
          (te internal data)
          (te sr ck)
          (te sr ck-kernel)
          (te sr ck-predicates))

  (begin

    (define-syntax $test-name
      (syntax-rules (quote)
        ((_ s '())                   ($ s '#f))
        ((_ s '(name data-args ...)) ($ s ($if ($symbol? 'name)
                                              ''(symbol->string 'name)
                                              ''name ))) ) )
    (define-syntax $data-args
      (syntax-rules (quote)
        ((_ s '())                   ($ s '()))
        ((_ s '(name data-args ...)) ($ s '(data-args ...))) ) )

    (define-syntax $normalize-data-thunk
      (syntax-rules (quote)
        ((_ s '()) ($ s '('(()))))
        ((_ s '::) ($ s '::)) ) )

    (define-syntax $make-test
      (syntax-rules (quote)
        ((_ s 'name '(data-args ...) '(param-args ...) '(fixture-defs ...)
              '(body1 body2 ...) '(data-body1 data-body2 ...) )
         ($ s '(make-test name
                 (lambda (data-args ...)
                   (lambda (param-args ...)
                     fixture-defs ...
                     body1 body2 ... ) )
                 (lambda () data-body1 data-body2 ...) )) ) ) )

    (define-syntax $define-test
      (syntax-rules (quote define-test make-test)
        ((_ s 'param-args 'fixture-defs
              '((define-test name-spec test-body1 test-body2 ...) data-body) )
         ($ s ($make-test
                ($test-name 'name-spec) ($data-args 'name-spec)
                'param-args 'fixture-defs
                '(test-body1 test-body2 ...)
                ($normalize-data-thunk 'data-body) )) ) ) )
) )
