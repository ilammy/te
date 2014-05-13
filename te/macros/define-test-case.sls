#!r6rs
(library (te macros define-test-case)

  (export define-test-case)

  (import (rnrs base)
          (te internal data)
          (te macros process-case-body)
          (te sr ck))

  (begin

    (define-syntax $define-test-case
      (syntax-rules (quote)
        ((_ s '(binding name) '((case-lambda test-lambda test-list)
                                (internal-defs ...)))
         ($ s '(define binding
                 (let ()
                   internal-defs ...
                   (make-test-case name
                     case-lambda test-lambda
                     test-list ) ) )) ) ) )

    (define-syntax $parse-name-binding
      (syntax-rules (quote)
        ((_ s '(binding))      ($ s '(binding (symbol->string 'binding))))
        ((_ s '(binding name)) ($ s '(binding name))) ) )

    (define-syntax define-test-case
      (syntax-rules ()
        ((_ name-binding body1 body2 ...)
         ($ ($define-test-case
              ($parse-name-binding 'name-binding)
              ($process-case-body '(body1 body2 ...)) )) ) ) )

) )
