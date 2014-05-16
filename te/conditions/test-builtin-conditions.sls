#!r6rs

(import (except (rnrs base) error assert)
        (rnrs control)
        (rnrs exceptions)
        (te)
        (te utils verify-test-case)
        (te conditions assertions)
        (te conditions builtin-conditions)
        (te internal test-conditions))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (builtin-conditions)

  (define-test ("Condition type" signal expected-type)
    #((list `(,error  error)
            `(,fail   failed)
            `(,notify notification)
            `(,pass   passes)
            `(,pend   pending)
            `(,omit   omitted) ))
    (guard (condition
            (#t (assert-true (test-condition? condition))
                (assert-eq expected-type (condition-type condition)) ) )
      (signal "something") ) )

  (define-test ("Condition contents" signal)
    #((list `(,error) `(,fail) `(,notify) `(,pass) `(,pend) `(,omit)))

    (let ((unique-object (list 'unique)))
      (guard (condition
              (#t (assert-equal? "Message" (condition-message condition))
                  (assert-eq? unique-object (condition-object condition)) ) )
        (signal "Message" unique-object) ) ) )

  (define-test ("Default contents" signal)
    #((list `(,error) `(,fail) `(,notify) `(,pass) `(,pend) `(,omit)))

    (guard (condition
            (#t (assert-eq #f (condition-object condition)) ) )
      (signal "Message") ) )

  (define-test ("Non-continuable conditions" signal)
    #((list `(,error) `(,fail) `(,pass) `(,pend) `(,omit)))

    (assert-true
     (raises-non-continuable-exception?
       (lambda () (signal "something")) ) ) )

  (define-test ("Continuable conditions" signal)
    #((list `(,notify)))

    (assert-true
     (raises-continuable-exception?
       (lambda () (signal "something")) ) ) )

  ; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - ;

  ;; Non-continuable exceptions throw another (unspecified) exception
  ;; if their initial handler returns something instead of escaping.
  (define (raises-non-continuable-exception? thunk)
    (let* ((unique-object (list 'unique))
           (result (guard (recurring-condition (#t unique-object))
                     (with-exception-handler
                       (lambda (condition) 'continued)
                       thunk ) )) )
      (eq? result unique-object) ) )

  ;; Handlers of continuable exceptions do not cause any recurring
  ;; exceptions when they return anything.
  (define (raises-continuable-exception? thunk)
    (let* ((unique-object (list 'unique))
           (result (guard (recurring-condition (#t unique-object))
                     (with-exception-handler
                       (lambda (condition) 'anything) ; fingers crossed this
                       thunk )) ) )                   ; won't break the thunk
      (not (eq? result unique-object)) ) )
)
(verify-test-case! builtin-conditions)
