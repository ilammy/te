#!r6rs

(import (rnrs base)
        (only (srfi :1) every)
        (te)
        (te utils verify-test-case)
        (te macros process-case-body)
        (te internal data)
        (te sr ck)
        (te sr ck-lists))

(define (valid-test-case-body? test-case-body test-count)
  (and (list? test-case-body)
       (= 3 (length test-case-body))
       (procedure?  (list-ref test-case-body 0))
       (procedure?  (list-ref test-case-body 1))
       (let ((tests (list-ref test-case-body 2)))
         (and (list? tests)
              (= test-count (length tests))
              (every test? tests) ) ) ) )

(define-test-case (test-$process-case-body:syntax)

  (define-test ("define-test only")
    (define processed
      ($ ($cons 'list
           ($process-case-body
             '((define-test () 1) (define-test () 2)) ) )) )

    (valid-test-case-body? processed 2) )

  (define-test ("define-test + case wrapper")
    (define processed
      ($ ($cons 'list
           ($process-case-body
             '((define-case-wrapper (run) (cons 1 2) (run))
               (define-test () 1) (define-test () 2)) ) )) )

    (valid-test-case-body? processed 2) )

  (define-test ("define-test + test wrapper")
    (define processed
      ($ ($cons 'list
           ($process-case-body
             '((define-test-wrapper (run) (cons 1 2) (run))
               (define-test () 1)) ) )) )

    (valid-test-case-body? processed 1) )

  (define-test ("define-test + both wrappers")
    (define processed
      ($ ($cons 'list
           ($process-case-body
             '((define-case-wrapper (run) (cons 1 2) (run))
               (define-test-wrapper (run) (cons 3 4) (run))
               (define-test () 1) (define-test () 2)
               (define-test () 3) (define-test () 4)) ) )) )

    (valid-test-case-body? processed 4) )
)
(verify-test-case! test-$process-case-body:syntax)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$process-case-body:wrapper-handling)

  (define-test ("normal wrapper order")
    (define processed
      ($ ($cons 'list
           ($process-case-body
             '((define-case-wrapper (run) (run) 'CASE-HIJACK!)
               (define-test-wrapper (run) (run) 'TEST-HIJACK!)
               (define-test () #t)) ) )) )

    (let ((case-wrapper (list-ref processed 0))
          (test-wrapper (list-ref processed 1)))
      (and (equal? (case-wrapper (lambda () #t)) 'CASE-HIJACK!)
           (equal? (test-wrapper (lambda () #t)) 'TEST-HIJACK!) ) ) )

  (define-test ("inverted wrapper order")
    (define processed
      ($ ($cons 'list
           ($process-case-body
             '((define-test-wrapper (run) (run) 'TEST-HIJACK!)
               (define-case-wrapper (run) (run) 'CASE-HIJACK!)
               (define-test () #t)) ) )) )

    (let ((case-wrapper (list-ref processed 0))
          (test-wrapper (list-ref processed 1)))
      (and (equal? (case-wrapper (lambda () #t)) 'CASE-HIJACK!)
           (equal? (test-wrapper (lambda () #t)) 'TEST-HIJACK!) ) ) )

  (define-test ("test wrapper argument extraction")
    (define processed
      ($ ($cons 'list
           ($process-case-body
             '((define-test-wrapper (run woobley wobbley) (run 'zog 'bork))
               (define-test ("product = 42")
                 (= 42 (* woobley wobbley)) )) ) )) )

    (let* ((tests (list-ref processed 2))
           (test  (list-ref tests     0)))
      ((test-body test) 6 7) ) )
)
(verify-test-case! test-$process-case-body:wrapper-handling)
