#!r6rs
(library (te sr ck-lists)

  (export $cons $map $reverse $span)

  (import (rnrs base)
          (te sr ck)
          (te sr ck-kernel))

  (begin

    (define-syntax $cons
      (syntax-rules (quote)
        ((_ s 'a 'd) ($ s '(a . d))) ) )

    (define-syntax $map
      (syntax-rules (quote)
        ((_ s 'proc    'list)                ($ s ($map 'proc 'list '())))
        ((_ s 'proc    '()      'result)     ($ s 'result))
        ((_ s '(p ...) '(a . d) 'result)     ($ s ($map '(p ...) 'd 'result (p ... 'a))))
        ((_ s 'proc    '(a . d) 'result)     ($ s ($map 'proc    'd 'result (proc 'a))))
        ((_ s 'proc    'd '(result ...) 'aa) ($ s ($map 'proc    'd '(result ... aa)))) ) )

    (define-syntax $reverse
      (syntax-rules (quote)
        ((_ s 'list)            ($ s ($reverse 'list '())))
        ((_ s '() 'result)      ($ s 'result))
        ((_ s '(a . d) 'result) ($ s ($reverse 'd ($cons 'a 'result)))) ) )

    (define-syntax $span
      (syntax-rules (quote)
        ((_ s 'pred 'list)                ($ s ($span 'pred 'list '())))
        ((_ s 'pred '()       'head)      ($ s '(head ())))
        ((_ s 'pred '(a . d) '(head ...)) ($ s ($if (pred 'a)
                                                   '($span 'pred 'd '(head ... a))
                                                   ''((head ...) (a . d)) ))) ) )

) )
