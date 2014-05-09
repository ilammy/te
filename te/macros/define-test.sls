#!r6rs
(library (te macros define-test)

  (export $define-test)

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
        ((_ s 'name '(body1 body2 ...))
         ($ s '(make-test name
                 (lambda ()
                   body1 body2 ... ) )) ) ) )

    (define-syntax $define-test
      (syntax-rules (quote)
        ((_ s 'name-spec 'body)
         ($ s ($make-test
                ($parse-name-spec 'name-spec)
                'body ) ) ) ) )

) )
