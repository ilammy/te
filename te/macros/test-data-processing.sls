#!r6rs

(import (rnrs base)
        (te)
        (te utils verify-test-case)
        (te macros data-processing)
        (te internal data)
        (te sr ck)
        (te sr ck-kernel))

(define-test-case (test-$anonymous-define-test?)

  (define-test ("accepts anonymous define-test")
    (equal? #t
      ($ ($anonymous-define-test? '(define-test () #t))) ) )

  (define-test ("rejects named define-test")
    (equal? #f
      ($ ($anonymous-define-test? '(define-test (with-name) (= 4 (+ 2 2))))) ) )

  (define-test ("rejects define-data")
    (equal? #f
      ($ ($anonymous-define-test? '(define-data (for-test) '(1 2 3)))) ) )

  (define-test ("rejects named make-test")
    (equal? #f
      ($ ($anonymous-define-test?
           '(make-test "name" (lambda () #t) (lambda () '())) )) ) )

  (define-test ("rejects anonymous make-test")
    (equal? #f
      ($ ($anonymous-define-test?
           '(make-test #f (lambda () #t) (lambda () '())) )) ) )
)
(verify-test-case! test-$anonymous-define-test?)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$test-definition-name)

  (define-test ("handles define-test string")
    (equal? "name"
      ($ ($test-definition-name '(define-test ("name") #t))) ) )

  (define-test ("handles define-test symbol")
    (equal? 'name
      ($ ($test-definition-name '(define-test ('name arg1 arg2) #t))) ) )

  ; Had to add quoting because identifiers aren't values in Scheme.
  (define-test ("handles define-test identifier")
    (equal? 'id
      ($ ($quote ($test-definition-name '(define-test (id) #t)))) ) )

  (define-test ("handles define-test number")
    (equal? 42
      ($ ($test-definition-name '(define-test (42) #t))) ) )

  (define-test ("handles define-data string")
    (equal? "name"
      ($ ($test-definition-name '(define-data ("name") #t))) ) )

  ; The same stuff about quoting.
  (define-test ("handles define-data symbol")
    (equal? 'name
      ($ ($quote ($test-definition-name '(define-data (name) #t)))) ) )

  (define-test ("handles define-data number")
    (equal? 42
      ($ ($test-definition-name '(define-data (42) #t))) ) )
)
(verify-test-case! test-$test-definition-name)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-$normalize-test-group)

  (define-fixture
    (define-syntax quote-normalize
      (syntax-rules ()
        ((_ expression)
         ($ ($quote ($normalize-test-group expression))) ) ) ) )

  (define-test ("anonymous test")
    (equal? '((define-test () #t) ())
      (quote-normalize '((define-test () #t))) ) )

  (define-test ("named test")
    (equal? '((define-test ("Name") #t) ())
      (quote-normalize '((define-test ("Name") #t))) ) )

  (define-test ("test + data")
    (equal? '((define-test (42) #t) (57))
      (quote-normalize '((define-test (42) #t)
                         (define-data (42) 57))) ) )

  (define-test ("data + test")
    (equal? '((define-test (!) #t) (complex expression))
      (quote-normalize '((define-data (!) complex expression)
                         (define-test (!) #t))) ) )
)
(verify-test-case! test-$normalize-test-group)
