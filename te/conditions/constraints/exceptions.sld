(define-library (te conditions constraints exceptions)

  (export raises)

  (import (scheme base)
          (te conditions define-constraint))

  (begin

    (define-constraint (thunk raises expected?)
      (guard (condition
              ((expected? condition) (assert-success condition))
              (else (assert-failure "Unexpected exception")) )
        (thunk)
        (assert-failure "No exception") ) )

) )
