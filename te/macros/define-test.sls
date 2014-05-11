#!r6rs
(library (te macros define-test)

  (export $define-test $define-test2)

  (import (rnrs base)
          (te internal data)
          (te sr ck)
          (te sr ck-kernel)
          (te sr ck-predicates))

  (begin

    (define-syntax $parse-name-spec
      (syntax-rules (quote)
        ((_ s '())     ($ s '#f))
        ((_ s '(name)) ($ s ($if ($symbol? 'name)
                                ''(symbol->string 'name)
                                ''name ))) ) )
    (define-syntax $make-test
      (syntax-rules (quote)
        ((_ s 'name '(args ...) '(fix-defs ...) '(body1 body2 ...))
         ($ s '(make-test name
                 (lambda ()
                   (lambda (args ...)
                     fix-defs ...
                     body1 body2 ... ) )
                 (lambda () '(())) )) ) ) )

    (define-syntax $define-test
      (syntax-rules (quote define-test make-test)
        ((_ s 'args 'fix-defs '(define-test name-spec body1 body2 ...))
         ($ s ($make-test
                ($parse-name-spec 'name-spec)
                'args
                'fix-defs
                '(body1 body2 ...) )) ) ) )


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

    (define-syntax $make-test2
      (syntax-rules (quote)
        ((_ s 'name '(data-args ...) '(param-args ...) '(fixture-defs ...)
              '(body1 body2 ...) '(data-body1 data-body2 ...) )
         ($ s '(make-test name
                 (lambda (data-args ...)
                   (lambda (param-args ...)
                     fixture-defs ...
                     body1 body2 ... ) )
                 (lambda () data-body1 data-body2 ...) )) ) ) )

    (define-syntax $define-test2
      (syntax-rules (quote define-test make-test)
        ((_ s 'data-body 'param-args 'fixture-defs
              '(define-test name-spec test-body1 test-body2 ...) )
         ($ s ($make-test2
                ($test-name 'name-spec) ($data-args 'name-spec)
                'param-args 'fixture-defs
                '(test-body1 test-body2 ...)
                ($normalize-data-thunk 'data-body) )) ) ) )
) )
