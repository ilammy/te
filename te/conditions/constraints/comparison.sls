#!r6rs
(library (te conditions constraints comparison)

  (export is-=      is-not=
          is-<      is-<=
          is->      is->=

          is-approx=

          is-ci=    is-not-ci=
          is-ci<    is-ci<=
          is-ci>    is-ci>=)

  (import (rnrs base)
          (te conditions define-constraint)
          (te conditions common generic-comparators))

  (begin

    (define-constraint (actual is-approx= expected eps)
      (let ((eps (abs eps)))
        (if (<= (- expected eps) actual (+ expected eps))
            (assert-success actual)
            (assert-failure) ) ) )

    (define-syntax define-compare-constraint
      (syntax-rules ()
        ((_ (actual binding expected) (generic-comparator) form)
         (define-constraint (actual binding expected)
           (let ((generic-comparator (generic-comparator (type-of actual expected))))
             (if (not generic-comparator) (assert-failure "Unsupported type")
                 (if form
                     (assert-success actual)
                     (assert-failure) ) ) ) ) ) ) )

    (define-compare-constraint (actual is-= expected)       (generic-=)
      (generic-= actual expected) )

    (define-compare-constraint (actual is-< expected)       (generic-<)
      (generic-< actual expected) )

    (define-compare-constraint (actual is-> expected)       (generic->)
      (generic-> actual expected) )

    (define-compare-constraint (actual is-<= expected)      (generic-<=)
      (generic-<= actual expected) )

    (define-compare-constraint (actual is->= expected)      (generic->=)
      (generic->= actual expected) )

    (define-compare-constraint (actual is-ci= expected)     (generic-ci=)
      (generic-ci= actual expected) )

    (define-compare-constraint (actual is-ci< expected)     (generic-ci<)
      (generic-ci< actual expected) )

    (define-compare-constraint (actual is-ci> expected)     (generic-ci>)
      (generic-ci> actual expected) )

    (define-compare-constraint (actual is-ci<= expected)    (generic-ci<=)
      (generic-ci<= actual expected) )

    (define-compare-constraint (actual is-ci>= expected)    (generic-ci>=)
      (generic-ci>= actual expected) )

    (define-compare-constraint (actual is-not= expected)    (generic-=)
      (not (generic-= actual expected)) )

    (define-compare-constraint (actual is-not-ci= expected) (generic-ci=)
      (not (generic-ci= actual expected)) )

) )
