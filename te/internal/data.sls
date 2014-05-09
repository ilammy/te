#!r6rs
(library (te internal data)

  (export make-test-case
            case-name
            test-wrap
            case-wrap
            test-list

          make-test
            test-name
            test-body)

  (import (rnrs base)
          (rnrs records syntactic))

  (begin

    (define-record-type (test-case make-test-case test-case?)
      (fields
        (immutable name      case-name)
        (immutable case-wrap case-wrap)
        (immutable test-wrap test-wrap)
        (immutable test-list test-list) ) )

    (define-record-type (test make-test test?)
      (fields
        (immutable name test-name)
        (immutable body test-body) ) )

) )
