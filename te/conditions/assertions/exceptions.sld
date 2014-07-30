(define-library (te conditions assertions exceptions)

  (export assert-raises)

  (import (scheme base)
          (te conditions define-assertion))

  (begin

    (define-assertion (assert-raises expected? thunk)
      (guard (condition
              ((expected? condition) (assert-success condition))
              (else (assert-failure "Unexpected exception")) )
        (thunk)
        (assert-failure "No exception") ) )

) )
