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
                           (test-n 1)
                           (failed-tests '()))
              (if (null? tests)
                  (unless (= passed total)
                    (error #f "Test case failed" case-name failed-tests) )
                  (let ((test-name (test-name (car tests)))
                        (test-body (test-body (car tests)))
                        (test-data (test-data (car tests))))
                    (let next-sample ((data-passed 0)
                                      (data-total  0)
                                      (data (test-data)))
                      (if (null? data)
                          (continue (+ data-passed passed) (+ data-total total)
                                    (cdr tests) (+ 1 test-n)
                                    (if (= data-passed data-total) failed-tests
                                        (cons (if test-name test-name test-n)
                                              failed-tests ) ) )
                          (if (test-wrap (apply test-body (car data)))
                              (next-sample (+ 1 data-passed) (+ 1 data-total) (cdr data))
                              (next-sample (+ 0 data-passed) (+ 1 data-total) (cdr data)) ) ) ) ) ) ) ) ) )
      #t )

) )
