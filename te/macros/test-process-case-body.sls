#!r6rs

(import (rnrs base)
        (te)
        (te utils verify-test-case)
        (te macros process-case-body)
        (te internal data)
        (te sr ck)
        (te sr ck-lists))

(define (named-test? test name)
  (and (test? test)
       (equal? name (test-name test)) ) )

(define-test-case (process-case-body "$process-case-body")
  (lambda (run) (run))
  (lambda (run) (run))

  (define-test ("define-test only")
    (define processed
      ($ ($cons 'list ($process-case-body
                        '((lambda (run) (run))
                          (lambda (run) (run))
                          (define-test ("Test 1") (= 2 2))
                          (define-test ("Test 2") #t)) ))) )
    (and (list? processed)
         (= 3 (length processed))
         (procedure?  (list-ref processed 0))
         (procedure?  (list-ref processed 1))
         (let ((tests (list-ref processed 2)))
           (and (list? tests)
                (= 2 (length tests))
                (named-test? (list-ref tests 0) "Test 1")
                (named-test? (list-ref tests 1) "Test 2") ) ) ) )

  (define-test ("define-test mixed with make-test") ; temp
    (define processed
      ($ ($cons 'list ($process-case-body
                        '((lambda (run) (run))
                          (lambda (run) (run))
                          (make-test "Test 1" (lambda (x y z) (= 2 2)))
                          (define-test ("Test 2") #t)) ))) )
    (and (list? processed)
         (= 3 (length processed))
         (procedure?  (list-ref processed 0))
         (procedure?  (list-ref processed 1))
         (let ((tests (list-ref processed 2)))
           (and (list? tests)
                (= 2 (length tests))
                (named-test? (list-ref tests 0) "Test 1")
                (named-test? (list-ref tests 1) "Test 2") ) ) ) ) )

(verify-test-case! process-case-body)
