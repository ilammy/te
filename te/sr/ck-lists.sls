#!r6rs
(library (te sr ck-lists)

  (export $cons $map $reverse $span $filter $group-by)

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
    (define-syntax $same-group?
      (syntax-rules (quote)
        ((_ s '(g ...) 'a 'b) ($ s ($same? (g ... 'a) (g ... 'b)))) ) )

    (define-syntax $group-list:insert
      (syntax-rules (quote)
        ((_ s 'g... 'x 'groups) ($ s ($group-list:insert 'g... 'x 'groups '())))

        ;; If there is no suitable group for the element then create a new one.
        ((_ s 'g... 'x '() '(groups ...)) ($ s '(groups ... (x))))

        ;; Check the element against the next group. If it is the right one
        ;; then append the element and get out. If not then continue scanning.
        ((_ s 'g... 'x '((y ys ...) other ...) '(groups ...))
         ($ s ($if ($same-group? 'g... 'x 'y)
                  ''(groups ... (y ys ... x) other ...)
                  '($group-list:insert 'g... 'x
                     '(other ...) '(groups ... (y ys ...)) ) )) ) ) )

    (define-syntax $group-by
      (syntax-rules (quote)
        ((_ s '(g ...) 'list)            ($ s ($group-by '(g ...) 'list '())))
        ((_ s 'group   'list)            ($ s ($group-by '(group) 'list '())))
        ((_ s '(g ...) '()      'result) ($ s 'result))
        ((_ s '(g ...) '(a . d) 'result) ($ s ($group-by '(g ...) 'd
                                                ($group-list:insert
                                                  '(g ...) 'a 'result ) ))) ) )
) )
