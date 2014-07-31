(define-library (te conditions constraints)

  (export is-true   is-false

          is-eq     is-not-eq
          is-eqv    is-not-eqv
          is-equal  is-not-equal

          is-null
          is-nan    is-not-nan
          is-finite is-infinite

          is-=      is-not=
          is-<      is-<=
          is->      is->=

          is-approx=

          is-ci=    is-not-ci=
          is-ci<    is-ci<=
          is-ci>    is-ci>=

          raises)

  (import (te conditions constraints implicit)
          (te conditions constraints exceptions)
          (te conditions constraints comparison)
          (te conditions constraints equivalence)) )
