#!r6rs
(library (te conditions assertions exceptions)

  (export assert-raises)

  (import (except (rnrs base) error)
          (rnrs exceptions)
          (te conditions define-assertion))

  (begin

    (define-assertion (assert-raises expected? thunk)
      (guard (condition
              ((expected? condition) (assert-success condition))
              (else (assert-failure "Unexpected exception")) )
        (thunk)
        (assert-failure "No exception") ) )

) )
