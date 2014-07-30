(define-library (te internal test-conditions)

  (export make-test-condition test-condition?
            condition-type
            condition-object
            condition-message)

  (import (scheme base))

  (begin

    (define-record-type test-condition
      (make-test-condition type object message) test-condition?

      (type    condition-type)
      (object  condition-object)
      (message condition-message) )

) )
