(define-library (te base)

  (export define-test-case
          make-test)

  (import (te macros define-test-case)
          (te internal data)) )
