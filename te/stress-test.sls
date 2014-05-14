#!r6rs

(import (rnrs base)
        (only (srfi :1) make-list)
        (te)
        (te utils verify-test-case))

; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ;

(define-test-case (stress-test "Detecting non-linear expansions")

  (define-fixture
    (define x01 0) (define x02 0) (define x03 0) (define x04 0) (define x05 0)
    (define x06 0) (define x07 0) (define x08 0) (define x09 0) (define x10 0)
    (define x11 0) (define x12 0) (define x13 0) (define x14 0) (define x15 0)
    (define x16 0) (define x17 0) (define x18 0) (define x19 0) (define x20 0)
    (define x21 0) (define x22 0) (define x23 0) (define x24 0) (define x25 0)
    (define x26 0) (define x27 0) (define x28 0) (define x29 0) (define x30 0)
    (define x31 0) (define x32 0) (define x33 0) (define x34 0) (define x35 0)
    (define x36 0) (define x37 0) (define x38 0) (define x39 0) (define x40 0)
    (define x41 0) (define x42 0) (define x43 0) (define x44 0) (define x45 0)
    (define x46 0) (define x47 0) (define x48 0) (define x49 0) (define x50 0) )

  (define-test () #t) (define v01 0) (define-test () #t) (define v11 0)
  (define-test () #t) (define v02 0) (define-test () #t) (define v12 0)
  (define-test () #t) (define v03 0) (define-test () #t) (define v13 0)
  (define-test () #t) (define v04 0) (define-test () #t) (define v14 0)
  (define-test () #t) (define v05 0) (define-test () #t) (define v15 0)
  (define-test () #t) (define v06 0) (define-test () #t) (define v16 0)
  (define-test () #t) (define v07 0) (define-test () #t) (define v17 0)
  (define-test () #t) (define v08 0) (define-test () #t) (define v18 0)
  (define-test () #t) (define v09 0) (define-test () #t) (define v19 0)
  (define-test () #t) (define v10 0) (define-test () #t) (define v20 0)

  (define-test (X v1)
    #((list (make-list  1 #f))) #t )
  (define-test (X v1 v2)
    #((list (make-list  2 #f))) #t )
  (define-test (X v1 v2 v3)
    #((list (make-list  3 #f))) #t )
  (define-test (X v1 v2 v3 v4)
    #((list (make-list  4 #f))) #t )
  (define-test (X v1 v2 v3 v4 v5)
    #((list (make-list  5 #f))) #t )
  (define-test (X v1 v2 v3 v4 v5 v6)
    #((list (make-list  6 #f))) #t )
  (define-test (X v1 v2 v3 v4 v5 v6 v7)
    #((list (make-list  7 #f))) #t )
  (define-test (X v1 v2 v3 v4 v5 v6 v7 v8)
    #((list (make-list  8 #f))) #t )
  (define-test (X v1 v2 v3 v4 v5 v6 v7 v8 v9)
    #((list (make-list  9 #f))) #t )
  (define-test (X v1 v2 v3 v4 v5 v6 v7 v8 v9 v10)
    #((list (make-list 10 #f))) #t )
  (define-test (X v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11)
    #((list (make-list 11 #f))) #t )
  (define-test (X v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12)
    #((list (make-list 12 #f))) #t )
  (define-test (X v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13)
    #((list (make-list 13 #f))) #t )
  (define-test (X v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14)
    #((list (make-list 14 #f))) #t )
  (define-test (X v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15)
    #((list (make-list 15 #f))) #t )
  (define-test (X v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16)
    #((list (make-list 16 #f))) #t )

  (define-test () #t) (define v21 0) (define-test () #t) (define v31 0)
  (define-test () #t) (define v22 0) (define-test () #t) (define v32 0)
  (define-test () #t) (define v23 0) (define-test () #t) (define v33 0)
  (define-test () #t) (define v24 0) (define-test () #t) (define v34 0)
  (define-test () #t) (define v25 0) (define-test () #t) (define v35 0)
  (define-test () #t) (define v26 0) (define-test () #t) (define v36 0)
  (define-test () #t) (define v27 0) (define-test () #t) (define v37 0)
  (define-test () #t) (define v28 0) (define-test () #t) (define v38 0)
  (define-test () #t) (define v29 0) (define-test () #t) (define v39 0)
  (define-test () #t) (define v30 0) (define-test () #t) (define v40 0)
)
(verify-test-case! stress-test)
