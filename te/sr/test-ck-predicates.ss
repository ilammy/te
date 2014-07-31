(import (scheme base)
        (te base)
        (te conditions assertions)
        (te utils verify-test-case)
        (te sr ck)
        (te sr ck-predicates))

(define-syntax true?
  (syntax-rules ()
    ((_ expression) (assert-eq #t ($ expression))) ) )

(define-syntax false?
  (syntax-rules ()
    ((_ expression) (assert-eq #f ($ expression))) ) )

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-predicates:symbol? "CK predicate functions: $symbol?")

  (define-test ("symbol")        (true?  ($symbol? 'foo)))
  (define-test ("list")          (false? ($symbol? '(1 2 3))))
  (define-test ("empty list")    (false? ($symbol? '())))
  (define-test ("number")        (false? ($symbol? '42)))
  (define-test ("vector")        (false? ($symbol? '#(4 5 6))))
  (define-test ("quoted symbol") (false? ($symbol? ''f)))
  (define-test ("bool")          (false? ($symbol? '#f)))
)
(verify-test-case! ck-predicates:symbol?)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-predicates:list? "CK predicate functions: $list?")

  (define-test ("empty list")    (true?  ($list? '())))
  (define-test ("normal list")   (true?  ($list? '(1 2 3 4))))
  (define-test ("dotted list")   (false? ($list? '(1 2 . 3))))
  (define-test ("nested list 1") (true?  ($list? '(1 (2 3) (4)))))
  (define-test ("nested list 2") (true?  ($list? '(1 (2 . 4) ()))))
  (define-test ("vector")        (false? ($list? '#(1 2 3))))
  (define-test ("quoted list")   (true?  ($list? ''(1 2 3)))) ; sic! '(1) == (quote (1))
  (define-test ("string")        (false? ($list? '"foo bar")))
)
(verify-test-case! ck-predicates:list?)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-predicates:bool? "CK predicate functions: $bool?")

  (define-test ("#t")        (true?  ($bool? '#t)))
  (define-test ("#f")        (true?  ($bool? '#f)))
  (define-test ("quoted #t") (false? ($bool? ''#t)))
  (define-test ("quoted #t") (false? ($bool? ''#f)))
  (define-test ("nil")       (false? ($bool? '())))
  (define-test ("list")      (false? ($bool? '(1 2))))
  (define-test ("number")    (false? ($bool? '42)))
  (define-test ("string")    (false? ($bool? '"x")))
  (define-test ("symbol")    (false? ($bool? 'foo)))
)
(verify-test-case! ck-predicates:bool?)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-predicates:same? "CK predicate functions: $same?")

  (define-test ("numbers same")       (true?  ($same? '1 '1)))
  (define-test ("numbers not same")   (false? ($same? '1 '2)))

  (define-test ("ids same")           (true?  ($same? 'a 'a)))
  (define-test ("ids not same")       (false? ($same? 'a 'b)))

  (define-test ("bools same #f")      (true?  ($same? '#f '#f)))
  (define-test ("bools same #t")      (true?  ($same? '#t '#t)))
  (define-test ("bools not same")     (false? ($same? '#f '#t)))

  (define-test ("strings same")       (true?  ($same? '"foo" '"foo")))
  (define-test ("strings not same")   (false? ($same? '"Foo" '"foo")))

  (define-test ("quotes same")        (true?  ($same? ''foo ''foo)))
  (define-test ("quotes not same 0")  (false? ($same? ''foo ''Foo)))
  (define-test ("quotes not same 1-") (false? ($same? ''foo  'foo)))
  (define-test ("quotes not same 1+") (false? ($same?  'foo ''foo)))
  (define-test ("quotes not same 2-") (false? ($same? ''123  '123)))
  (define-test ("quotes not same 2+") (false? ($same?  '123 ''123)))
  (define-test ("quotes not same 3-") (false? ($same? ''"x"  '"x")))
  (define-test ("quotes not same 3+") (false? ($same?  '"x" ''"x")))
  (define-test ("quotes not same 4-") (false? ($same? ''(1)  '(1))))
  (define-test ("quotes not same 4+") (false? ($same?  '(1) ''(1))))
  (define-test ("quotes not same 5-") (false? ($same? ''#()  '#())))
  (define-test ("quotes not same 5+") (false? ($same?  '#() ''#())))

  (define-test ("nils same")          (true?  ($same? '() '())))
  (define-test ("nested not same")    (false? ($same? '() '(()))))

  (define-test ("pairs same")         (true?  ($same? '(1 . 2) '(1 . 2))))
  (define-test ("pairs not same")     (false? ($same? '(1 . 2) '(3 . 4))))

  (define-test ("lists 1 same")       (true?  ($same? '(1 2) '(1 2))))
  (define-test ("lists 1 not same")   (false? ($same? '(1 2) '(3 4))))

  (define-test ("lists 2 same")       (true?  ($same? '(a b) '(a b))))
  (define-test ("lists 2 not same")   (false? ($same? '(a b) '(c d))))

  (define-test ("lists 3 same")       (true?  ($same? '(((a) (b) c d) (e . f))
                                                            '(((a) (b) c d) (e . f)) )))
  (define-test ("lists 3 not same")   (false? ($same? '(((a) (b) c d) (e . f))
                                                            '(((a) (b . 9) c d) (e)) )))

  (define-test ("empty vecs same")    (true?  ($same? '#() '#())))

  (define-test ("vecs 1 same")        (true?  ($same? '#(1 2 3) '#(1 2 3))))
  (define-test ("vecs 1 not same")    (false? ($same? '#(1 2 3) '#(1 2 E))))

  (define-test ("vecs 2 same")        (true?  ($same? '#((1 2) #(#('f) (1 2)))
                                                            '#((1 2) #(#('f) (1 2))))))
  (define-test ("vecs 2 not same")    (false? ($same? '#((1 2) #(#('f) (1 2)))
                                                            '#((1 2) #(#('e) (1 2))))))
)
(verify-test-case! ck-predicates:same?)

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (ck-predicates:or "CK predicate functions: $or")

  (define-test () (false? ($or '#f)))
  (define-test () (true?  ($or '#t)))

  (define-test () (false? ($or '#f '#f)))
  (define-test () (true?  ($or '#f '#t)))
  (define-test () (true?  ($or '#t '#f)))
  (define-test () (true?  ($or '#t '#t)))

  (define-test () (false? ($or '#f '#f '#f '#f '#f)))
  (define-test () (true?  ($or '#f '#f '#f '#f '#f '#f '#f '#t '#f)))
)
(verify-test-case! ck-predicates:or)
