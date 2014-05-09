#!r6rs

(library (te utils verify-test-case)

  (export verify-test-case!)

  (import (rnrs base)
          (rnrs control)
          (te internal data))

  (begin

    (define (verify-test-case! test-case)
      (let ((case-name (case-name test-case))
            (case-wrap (case-wrap test-case))
            (test-wrap (test-wrap test-case))
            (test-list (test-list test-case)))
        (case-wrap
          (lambda ()
            (let continue ((passed 0)
                           (total  0)
                           (tests  test-list)
                           (failed-tests '()))
              (if (null? tests)
                  (unless (= passed total)
                    (error #f "Test case failed" case-name failed-tests) )
                  (let ((test-name (test-name (car tests)))
                        (test-body (test-body (car tests))))
                    (if (test-wrap test-body)
                        (continue (+ 1 passed) (+ 1 total) (cdr tests) failed-tests)
                        (continue (+ 0 passed) (+ 1 total) (cdr tests)
                                  (cons (if test-name
                                            test-name
                                            (+ 1 total) )
                                        failed-tests ) ) ) ) ) ) ) ) )
      #t )

) )
