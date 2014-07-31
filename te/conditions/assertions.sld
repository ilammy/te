(define-library (te conditions assertions)

  (export assert-true   assert-false

          assert-eq     assert-not-eq
          assert-eqv    assert-not-eqv
          assert-equal  assert-not-equal

          assert-null
          assert-nan    assert-not-nan
          assert-finite assert-infinite

          assert-=      assert-not=
          assert-<      assert-<=
          assert->      assert->=

          assert-approx=

          assert-ci=    assert-not-ci=
          assert-ci<    assert-ci<=
          assert-ci>    assert-ci>=

          assert-raises)

  (import (te conditions assertions implicit)
          (te conditions assertions exceptions)
          (te conditions assertions comparison)
          (te conditions assertions equivalence)) )
