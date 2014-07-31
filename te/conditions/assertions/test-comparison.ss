(import (scheme base)
        (te base)
        (te utils verify-test-case)
        (te conditions assertions comparison)
        (te conditions assertions equivalence)
        (te conditions common test-utils))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define (reverse* list) (map reverse list))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-assert-equality)

  (define-test ("assert-= accepts equal objects and returns expected" expected actual)
    #((list '(1 1) '("1" "1") '(#\1 #\1) '(one one)))
    (assert-equal expected (assert-= expected actual)) )

  (define-test ("assert-= accepts multiple objects and returns first")
    (assert-equal "x" (assert-= "x" "\x78;" "x" (symbol->string 'x))) )

  (define-test ("assert-= rejects objects of different types")
    (assert-fails (assert-= '1 "1" 1)) )

  ; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - ;

  (define-test ("assert-not= accepts unequal objects and returns expected" expected actual)
    #((list '(1 2) '("y" "x") '(#\F #\5) '(one two)))
    (assert-equal expected (assert-not= expected actual)) )

  (define-test ("assert-not= accepts multiple objects and returns the first")
    (assert-equal "1" (assert-not= "1" "\x38;" "5" (symbol->string 'foo))) )

  (define-test ("assert-not= rejects objects of different types")
    (assert-fails (assert-not= '1 "2" #\3)) )

  ; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - ;

  (define-test ("assert-approx= accepts numbers in range" expected actual eps)
    #((list '(1 2 1) '(0 0.1 0.2) '(4 4.12312 0.2)))
    (assert-= actual (assert-approx= expected actual eps)) )

  (define-test ("assert-approx= rejects numbers not in range" expected actual eps)
    #((list '(9 4 1) '(0 6.1 0.2) '(14 4.12312 0.2)))
    (assert-fails (assert-approx= expected actual eps)) )

  (define-test ("assert-approx= treats epsilon as absolute")
    (assert-= 1.2 (assert-approx= 1 1.2 -0.5)) )
)
(verify-test-case! test-assert-equality)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-assert-order)

  (define strictly-ordered-objects
    (list '((1 2 3 4 5))
          '(("a" "ab" "acdef" "omg"))
          '((#\0 #\1 #\F)) ) )

  (define partially-ordered-objects
    (list '((1 1 2 4 4 5))
          '(("a" "ab" "ab" "acdef" "omg"))
          '((#\0 #\1 #\1 #\F)) ) )

  (define-test ("assert-< accepts proper objects and returns first" objects)
    #(strictly-ordered-objects)
    (assert-equal (car objects) (apply assert-< objects)) )

  (define-test ("assert-> accepts proper objects and returns first" objects)
    #((map reverse* strictly-ordered-objects))
    (assert-equal (car objects) (apply assert-> objects)) )

  (define-test ("assert-<= accepts proper objects and returns first" objects)
    #(partially-ordered-objects)
    (assert-equal (car objects) (apply assert-<= objects)) )

  (define-test ("assert->= accepts proper objects and returns first" objects)
    #((map reverse* partially-ordered-objects))
    (assert-equal (car objects) (apply assert->= objects)) )

  (define-test ("assert-< rejects objects of different types")
    (assert-fails (assert-< 1 #\2 "3")) )

  (define-test ("assert-> rejects objects of different types")
    (assert-fails (assert-> 3 "2" 1)) )

  (define-test ("assert-<= rejects objects of different types")
    (assert-fails (assert-<= 1 #\2 "2")) )

  (define-test ("assert->= rejects objects of different types")
    (assert-fails (assert->= 1 "1" "1")) )
)
(verify-test-case! test-assert-order)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-assert-equality:case-insensitive)

  (define-test ("assert-ci= accepts CI-equal objects and returns first" actual expected)
    #((list '(#\a #\A) '("foo" "FOO") '(#\1 #\1)))
    (assert-equal actual (assert-ci= actual expected)) )

  (define-test ("assert-ci= accepts multiple CI-equal objects and returns first")
    (assert-equal "foo" (assert-ci= "foo" "fOo" "Foo" "FOO")) )

  (define-test ("assert-ci= rejects objects of different type")
    (assert-fails (assert-ci= "1" #\1)) )

  ; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - ;

  (define-test ("assert-not-ci= accepts CI-unequal objects and returns expected" expected actual)
    #((list '(#\a #\B) '("foo" "BAR") '(#\4 #\1)))
    (assert-equal expected (assert-not-ci= expected actual)) )

  (define-test ("assert-not-ci= accepts multiple CI-unequal objects and returns first")
    (assert-equal "foo" (assert-not-ci= "foo" "Bar" "Zog" "FOO")) )

  (define-test ("assert-not-ci= rejects objects of different type")
    (assert-fails (assert-not-ci= "1" "2" #\3)) )
)
(verify-test-case! test-assert-equality:case-insensitive)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-assert-order:case-insensitive)

  (define strictly-case-insensitively-ordered-objects
    (list '(("A" "b" "Cdef" "X"))
          '((#\A #\b #\c #\D) )) )

  (define partially-case-insensitively-ordered-objects
    (list '(("a" "A" "b" "b" "Cdef" "X"))
          '((#\A #\b #\C #\c #\C #\D)) ) )

  (define-test ("assert-ci< accepts proper objects and returns first" objects)
    #(strictly-case-insensitively-ordered-objects)
    (assert-equal (car objects) (apply assert-ci< objects)) )

  (define-test ("assert-ci> accepts proper objects and returns first" objects)
    #((map reverse* strictly-case-insensitively-ordered-objects))
    (assert-equal (car objects) (apply assert-ci> objects)) )

  (define-test ("assert-ci<= accepts proper objects and returns first" objects)
    #(partially-case-insensitively-ordered-objects)
    (assert-equal (car objects) (apply assert-ci<= objects)) )

  (define-test ("assert-ci>= accepts proper objects and returns first" objects)
    #((map reverse* partially-case-insensitively-ordered-objects))
    (assert-equal (car objects) (apply assert-ci>= objects)) )

  (define-test ("assert-ci< rejects objects of different types")
    (assert-fails (assert-ci< "a" #\A)) )

  (define-test ("assert-ci> rejects objects of different types")
    (assert-fails (assert-ci> "XX" #\X)) )

  (define-test ("assert-ci<= rejects objects of different types")
    (assert-fails (assert-ci<= "1" #\1)) )

  (define-test ("assert-ci>= rejects objects of different types")
    (assert-fails (assert-ci>= 42 "42")) )
)
(verify-test-case! test-assert-order:case-insensitive)
