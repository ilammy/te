#!r6rs
(library (te sr ck-lists)

  (export $cons $map $reverse $span $filter $partition)

  (import (rnrs base)
          (te sr ck)
          (te sr ck-kernel)
          (te sr ck-predicates))

  (begin

    (define-syntax $cons
      (syntax-rules (quote)
        ((_ s 'a 'd) ($ s '(a . d))) ) )

    (define-syntax $map
      (syntax-rules (quote)
        ((_ s '(p ...) 'list)                ($ s ($map '(p ...) 'list '())))
        ((_ s 'proc    'list)                ($ s ($map '(proc)  'list '())))
        ((_ s '(p ...) '()      'result)     ($ s 'result))
        ((_ s '(p ...) '(a . d) 'result)     ($ s ($map '(p ...) 'd 'result (p ... 'a))))
        ((_ s '(p ...) 'd '(result ...) 'aa) ($ s ($map '(p ...) 'd '(result ... aa)))) ) )

    (define-syntax $reverse
      (syntax-rules (quote)
        ((_ s 'list)            ($ s ($reverse 'list '())))
        ((_ s '() 'result)      ($ s 'result))
        ((_ s '(a . d) 'result) ($ s ($reverse 'd ($cons 'a 'result)))) ) )

    (define-syntax $span
      (syntax-rules (quote)
        ((_ s '(p ...) 'list)                ($ s ($span '(p ...) 'list '())))
        ((_ s 'pred    'list)                ($ s ($span '(pred)  'list '())))
        ((_ s '(p ...) '()      'head)       ($ s '(head ())))
        ((_ s '(p ...) '(a . d) '(head ...)) ($ s ($if (p ... 'a)
                                                   '($span '(p ...) 'd '(head ... a))
                                                   ''((head ...) (a . d)) ))) ) )
    (define-syntax $filter
      (syntax-rules (quote)
        ((_ s '(p ...) 'list)                  ($ s ($filter '(p ...) 'list '())))
        ((_ s 'pred    'list)                  ($ s ($filter '(pred)  'list '())))
        ((_ s '(p ...) '()      'result)       ($ s 'result))
        ((_ s '(p ...) '(a . d) '(result ...)) ($ s ($filter '(p ...) 'd
                                                      ($if (p ... 'a)
                                                          ''(result ... a)
                                                          ''(result ...) ) ))) ) )
    (define-syntax $partition
      (syntax-rules (quote)
        ((_ s '(p ...) 'list)     ($ s ($partition '(p ...) 'list '() '())))
        ((_ s 'pred    'list)     ($ s ($partition '(pred)  'list '() '())))
        ((_ s '(p ...) '() 't 'f) ($ s '(t f)))
        ((_ s '(p ...) '(a . d) '(t ...) '(f ...))
         ($ s ($if (p ... 'a)
                  '($partition '(p ...) 'd '(t ... a) '(f ...))
                  '($partition '(p ...) 'd '(t ...) '(f ... a)) )) ) ) )
) )
