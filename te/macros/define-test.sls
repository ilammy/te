#!r6rs
(library (te macros define-test)

  (export $define-test?
          $define-test)

  (import (rnrs base)
          (te internal data)
          (te sr ck)
          (te sr ck-kernel)
          (te sr ck-predicates))

  (begin

    (define-syntax $define-test?
      (syntax-rules (quote define-test make-test)
        ((_ s '(define-test ignored ...)) ($ s '#t))
        ((_ s 'anything-else)             ($ s '#f)) ) )

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
                 (lambda (args ...)
                   fix-defs ...
                   body1 body2 ... ) )) ) ) )

    (define-syntax $define-test
      (syntax-rules (quote define-test make-test)
        ((_ s 'args 'fix-defs '(define-test name-spec body1 body2 ...))
         ($ s ($make-test
                ($parse-name-spec 'name-spec)
                'args
                'fix-defs
                '(body1 body2 ...) )) ) ) )

) )
