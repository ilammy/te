(define-library (te sr ck-kernel)

  (export $quote $if)

  (import (scheme base)
          (te sr ck))

  (begin

    (define-syntax $quote
      (syntax-rules (quote)
        ((_ s 'x) ($ s ''x)) ) )

    (define-syntax $if
      (syntax-rules (quote)
        ((_ s '#t 't 'f) ($ s t))
        ((_ s '#f 't 'f) ($ s f)) ) )

) )
