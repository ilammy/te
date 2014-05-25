#!r6rs

(import (rnrs base)
        (te)
        (te utils verify-test-case)
        (te conditions constraints assert-that)
        (te conditions constraints comparison)
        (te conditions assertions comparison)
        (te conditions assertions equivalence)
        (te conditions common test-utils))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-are-equal)

  (define-test ("is-= accepts equal objects and returns actual" expected actual)
    #((list '(1 1) '("1" "1") '(#\1 #\1) '(one one)))
    (assert-equal actual (assert-that actual (is-= expected))) )

  (define-test ("is-= rejects objects of different types")
    (assert-fails (assert-that '1 (is-= "1"))) )

  ; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - ;

  (define-test ("is-not= accepts unequal objects and returns actual" expected actual)
    #((list '(1 2) '("y" "x") '(#\F #\5) '(one two)))
    (assert-equal actual (assert-that actual (is-not= expected))) )

  (define-test ("is-not= rejects objects of different types")
    (assert-fails (assert-that #\1 (is-not= 1))) )

  ; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - ;

  (define-test ("is-approx= accepts numbers in range" expected actual eps)
    #((list '(1 2 1) '(0 0.1 0.2) '(4 4.12312 0.2)))
    (assert-= actual (assert-that actual (is-approx= expected eps))) )

  (define-test ("is-approx= rejects numbers not in range" expected actual eps)
    #((list '(9 4 1) '(0 6.1 0.2) '(14 4.12312 0.2)))
    (assert-fails (assert-that actual (is-approx= expected eps))) )

  (define-test ("is-approx= treats epsilon as absolute")
    (assert-= 1.2 (assert-that 1.2 (is-approx= 1 -0.5))) )
)
(verify-test-case! test-are-equal)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-in-order)

  (define strictly-ordered-objects
    (list '(1 2) '(3 4) '("a" "ab") '("acdef" "omg") '(#\0 #\1)) )

  (define partially-ordered-objects
    (list '(1 1) '(2 4) '(4 5) '("ab" "ab") '("acdef" "omg") '(#\0 #\1)
          '(#\1 #\1) ) )

  (define-test ("is-< accepts proper objects and returns actual" actual expected)
    #(strictly-ordered-objects)
    (assert-equal actual (assert-that actual (is-< expected))) )

  (define-test ("is-> accepts proper objects and returns actual" actual expected)
    #((map reverse strictly-ordered-objects))
    (assert-equal actual (assert-that actual (is-> expected))) )

  (define-test ("is-<= accepts proper objects and returns actual" actual expected)
    #(partially-ordered-objects)
    (assert-equal actual (assert-that actual (is-<= expected))) )

  (define-test ("is->= accepts proper objects and returns actual" actual expected)
    #((map reverse partially-ordered-objects))
    (assert-equal actual (assert-that actual (is->= expected))) )

  (define-test ("is-< rejects objects of different types")
    (assert-fails (assert-that 1 (is-< #\2))) )

  (define-test ("is-> rejects objects of different types")
    (assert-fails (assert-that 3 (is-> "2"))) )

  (define-test ("is-<= rejects objects of different types")
    (assert-fails (assert-that #\2 (is-<= "2"))) )

  (define-test ("is->= rejects objects of different types")
    (assert-fails (assert-that "1" (is->= 1))) )
)
(verify-test-case! test-in-order)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-are-equal:case-insensitive)

  (define-test ("is-ci= accepts CI-equal objects and returns actual" actual expected)
    #((list '(#\a #\A) '("foo" "FOO") '(#\1 #\1)))
    (assert-equal actual (assert-that actual (is-ci= expected))) )

  (define-test ("is-ci= rejects objects of different type")
    (assert-fails (assert-that "1" (is-ci= #\1))) )

  ; -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - ;

  (define-test ("is-not-ci= accepts CI-unequal objects and returns actual" actual expected)
    #((list '(#\a #\B) '("foo" "BAR") '(#\4 #\1)))
    (assert-equal actual (assert-that actual (is-not-ci= expected))) )

  (define-test ("is-not-ci= rejects objects of different type")
    (assert-fails (assert-that "1" (is-not-ci= "2" #\3))) )
)
(verify-test-case! test-are-equal:case-insensitive)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (test-in-order:case-insensitive)

  (define strictly-case-insensitively-ordered-objects
    (list '("A" "b") '("Cdef" "X") '(#\A #\b) '(#\c #\D) ) )

  (define partially-case-insensitively-ordered-objects
    (list '("a" "A") '("b" "b") '("Cdef" "X") '(#\A #\b) '(#\C #\c)
          '(#\C #\D) ) )

  (define-test ("is-ci< accepts proper objects and returns actual" actual expected)
    #(strictly-case-insensitively-ordered-objects)
    (assert-equal actual (assert-that actual (is-ci< expected))) )

  (define-test ("is-ci> accepts proper objects and returns actual" actual expected)
    #((map reverse strictly-case-insensitively-ordered-objects))
    (assert-equal actual (assert-that actual (is-ci> expected))) )

  (define-test ("is-ci<= accepts proper objects and returns actual" actual expected)
    #(partially-case-insensitively-ordered-objects)
    (assert-equal actual (assert-that actual (is-ci<= expected))) )

  (define-test ("is-ci>= accepts proper objects and returns actual" actual expected)
    #((map reverse partially-case-insensitively-ordered-objects))
    (assert-equal actual (assert-that actual (is-ci>= expected))) )

  (define-test ("is-ci< rejects objects of different types")
    (assert-fails (assert-that "a" (is-ci< #\A))) )

  (define-test ("is-ci> rejects objects of different types")
    (assert-fails (assert-that "XX" (is-ci> #\X))) )

  (define-test ("is-ci<= rejects objects of different types")
    (assert-fails (assert-that "1" (is-ci<= #\1))) )

  (define-test ("is-ci>= rejects objects of different types")
    (assert-fails (assert-that 42 (is-ci>= "42"))) )
)
(verify-test-case! test-in-order:case-insensitive)
