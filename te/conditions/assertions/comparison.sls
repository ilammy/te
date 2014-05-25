#!r6rs
(library (te conditions assertions comparison)

  (export assert-=      assert-not=
          assert-<      assert-<=
          assert->      assert->=

          assert-approx=

          assert-ci=    assert-not-ci=
          assert-ci<    assert-ci<=
          assert-ci>    assert-ci>=)

  (import (rnrs base)
          (te conditions define-assertion)
          (te conditions common generic-comparators))

  (begin

    (define-assertion (assert-approx= expected actual eps)
      (let ((eps (abs eps)))
        (if (<= (- expected eps) actual (+ expected eps))
            (assert-success actual)
            (assert-failure) ) ) )

    (define-syntax define-compare-assertion
      (syntax-rules ()
        ((_ (binding args) (generic-comparator) form)
         (define-assertion (binding obj1 obj2 . other)
           (let ((args (apply list obj1 obj2 other))
                 (generic-comparator
                  (generic-comparator (apply type-of obj1 obj2 other)) ) )
             (if (not generic-comparator) (assert-failure "Unsupported type")
                 (if form
                     (assert-success obj1)
                     (assert-failure) ) ) ) ) ) ) )

    (define-compare-assertion (assert-= values)       (generic-=)
      (apply generic-= values) )

    (define-compare-assertion (assert-< values)       (generic-<)
      (apply generic-< values) )

    (define-compare-assertion (assert-> values)       (generic->)
      (apply generic-> values) )

    (define-compare-assertion (assert-<= values)      (generic-<=)
      (apply generic-<= values) )

    (define-compare-assertion (assert->= values)      (generic->=)
      (apply generic->= values) )

    (define-compare-assertion (assert-ci= values)     (generic-ci=)
      (apply generic-ci= values) )

    (define-compare-assertion (assert-ci< values)     (generic-ci<)
      (apply generic-ci< values) )

    (define-compare-assertion (assert-ci> values)     (generic-ci>)
      (apply generic-ci> values) )

    (define-compare-assertion (assert-ci<= values)    (generic-ci<=)
      (apply generic-ci<= values) )

    (define-compare-assertion (assert-ci>= values)    (generic-ci>=)
      (apply generic-ci>= values) )

    (define-compare-assertion (assert-not= values)    (generic-=)
      (not (apply generic-= values)) )

    (define-compare-assertion (assert-not-ci= values) (generic-ci=)
      (not (apply generic-ci= values)) )

) )
