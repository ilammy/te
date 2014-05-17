#!r6rs
(library (te conditions assertions comparison)

  (export assert-=      assert-<>
          assert-<      assert-<=
          assert->      assert->=

          assert-approx=

          assert-ci=    assert-ci<>
          assert-ci<    assert-ci<=
          assert-ci>    assert-ci>=)

  (import (except (rnrs base) error)
          (rnrs unicode)
          (only (srfi :1) every)
          (te conditions define-assertion))

  (begin

    (define-assertion (assert-approx= expected actual eps)
      (let ((eps (abs eps)))
        (if (<= (- expected eps) actual (+ expected eps))
            (assert-success actual)
            (assert-failure) ) ) )

    (define (type-of values)
      (let ((first (car values)))
        (cond ((number? first) 'number)
              ((string? first) 'string)
              ((char?   first) 'char  )
              ((symbol? first) 'symbol)
              (else #f) ) ) )

    (define-syntax define-compare-assertion
      (syntax-rules ()
        ((_ (binding args) (comparator generic) form)
         (define-assertion (binding obj1 obj2 . other)
           (let* ((args (apply list obj1 obj2 other))
                  (comparator (generic (type-of args))) )
             (if (not comparator) (assert-failure "Unsupported type")
                 (if form
                     (assert-success (car args))
                     (assert-failure) ) ) ) ) ) ) )

    (define-compare-assertion (assert-= values)     (= generic-=)
      (apply = values) )

    (define-compare-assertion (assert-< values)     (< generic-<)
      (apply < values) )

    (define-compare-assertion (assert-> values)     (> generic->)
      (apply > values) )

    (define-compare-assertion (assert-<= values)    (<= generic-<=)
      (apply <= values) )

    (define-compare-assertion (assert->= values)    (>= generic->=)
      (apply >= values) )

    (define-compare-assertion (assert-<> values)    (= generic-=)
      (not (apply = values)) )

    (define-compare-assertion (assert-ci= values)   (ci= generic-ci=)
      (apply ci= values) )

    (define-compare-assertion (assert-ci< values)   (ci< generic-ci<)
      (apply ci< values) )

    (define-compare-assertion (assert-ci> values)   (ci> generic-ci>)
      (apply ci> values) )

    (define-compare-assertion (assert-ci<= values)  (ci<= generic-ci<=)
      (apply ci<= values) )

    (define-compare-assertion (assert-ci>= values)  (ci>= generic-ci>=)
      (apply ci>= values) )

    (define-compare-assertion (assert-ci<> values)  (ci= generic-ci=)
      (not (apply ci= values)) )

    (define-syntax define-generic-comparator
      (syntax-rules ()
        ((_ (binding) (type-token comparator) ...)
         (define (binding type)
           (case type
             ((type-token) comparator) ...
             (else #f) ) ) ) ) )

    (define-generic-comparator (generic-=)
      (number =) (string string=?) (char char=?) (symbol symbol=?) )

    (define-generic-comparator (generic-<)
      (number <) (string string<?) (char char<?) )

    (define-generic-comparator (generic-<=)
      (number <=) (string string<=?) (char char<=?) )

    (define-generic-comparator (generic->)
      (number >) (string string>?) (char char>?) )

    (define-generic-comparator (generic->=)
      (number >=) (string string>=?) (char char>=?) )

    (define-generic-comparator (generic-ci=)
      (string string-ci=?) (char char-ci=?) )

    (define-generic-comparator (generic-ci<)
      (string string-ci<?) (char char-ci<?) )

    (define-generic-comparator (generic-ci<=)
      (string string-ci<=?) (char char-ci<=?) )

    (define-generic-comparator (generic-ci>)
      (string string-ci>?) (char char-ci>?) )

    (define-generic-comparator (generic-ci>=)
      (string string-ci>=?) (char char-ci>=?) )

) )
