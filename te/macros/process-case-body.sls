#!r6rs
(library (te macros process-case-body)

  (export $process-case-body)

  (import (rnrs base)
          (te macros define-test)
          (te internal data)
          (te sr ck)
          (te sr ck-lists))

  (begin

    (define-syntax $define-test?
      (syntax-rules (quote define-test make-test)
        ((_ s '(define-test ignored ...)) ($ s '#t))
        ((_ s '(make-test ignored ...))   ($ s '#t)) ; temp
        ((_ s 'anything-else)             ($ s '#f)) ) )

    (define-syntax $split-case-body
      (syntax-rules (quote)
        ((_ s 'body) ($ s ($map '$reverse ($span '$define-test? ($reverse 'body))))) ) )

    (define-syntax $wrap-test
      (syntax-rules (quote define-test make-test)
        ((_ s '(define-test name-spec body1 body2 ...))
         ($ s ($define-test 'name-spec '(body1 body2 ...))) )
        ((_ s '(make-test ignored ...)) ; temp
         ($ s '(make-test ignored ...)) ) ) )

    (define-syntax $process-case-body
      (syntax-rules (quote)
        ((_ s 'body) ($ s ($process-case-body '1 ($split-case-body 'body))))
        ((_ s '1 '(define-tests other))
         ($ s ($process-case-body '2 'other ($map '$wrap-test 'define-tests))) )
        ((_ s '2 '(other ...) '(tests ...))
         ($ s '(other ... (list tests ...))) ) ) )

) )
