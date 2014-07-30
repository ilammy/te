(define-library (te internal data)

  (export make-test-case   test-case?
            case-name
            test-wrap
            case-wrap
            test-list

          make-test   test?
            test-name
            test-body
            test-data)

  (import (scheme base))

  (begin

    (define-record-type test-case
      (make-test-case name case-wrap test-wrap test-list) test-case?

      (name      case-name)
      (case-wrap case-wrap)
      (test-wrap test-wrap)
      (test-list test-list) )

    (define-record-type test
      (make-test name body data) test?

      (name test-name)
      (body test-body)
      (data test-data) )

) )
