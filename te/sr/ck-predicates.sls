#!r6rs
(library (te sr ck-predicates)

  (export $symbol?)

  (import (rnrs base)
          (te sr ck))

  (begin

    (define-syntax ?symbol
      (syntax-rules ()
        ((_  (a . b) t f) f)
        ((_ #(x ...) t f) f)
        ((_ a-symbol t f)
          (let-syntax
            ((? (syntax-rules ()
                  ((_ a-symbol  tt ff) tt)
                  ((_ else      tt ff) ff))))
            (? ! t f)))))

    (define-syntax $symbol?
      (syntax-rules (quote)
        ((_ s 'x) (?symbol x ($ s '#t) ($ s '#f))) ) )

) )
