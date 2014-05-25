#!r6rs
(library (te conditions constraints exceptions)

  (export raises)

  (import (except (rnrs base) error)
          (rnrs exceptions)
          (te conditions define-constraint))

  (begin

    (define-constraint (thunk raises expected?)
      (guard (condition
              ((expected? condition) (assert-success condition))
              (else (assert-failure "Unexpected exception")) )
        (thunk)
        (assert-failure "No exception") ) )

) )
