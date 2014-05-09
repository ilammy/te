#!r6rs
(library (te sr ck)

  (export $)

  (import (rnrs base))

  (begin

    (define-syntax $
      (syntax-rules (quote)
        ; Syntactic sugar
        (($ e) ($ () e))

        ; Values evaluate to themselves
        (($ () 'v) v)

        ; Evaluated next argument - - - -> put it on a stack and go on
        (($ (((! ...) a ...) . s) 'v)      ($ s #f (! ... 'v) a ...))

        ; No arguments left - - - - - - -> reduce the application
        (($ s #f (! va ...))               (! s va ...))

        ; Next argument is a value - - - > put it on a stack and go on
        (($ s #f (! ...) 'v a ...)         ($ s #f (! ... 'v) a ...))

        ; Argument is not just a value - > evaluate it in a new stack frame
        (($ s #f (! ...) a aa ...)         ($ (((! ...) aa ...) . s) a))

        ; Incoming application - - - - - > prepare arguments for the call
        (($ s (! a ...))                   ($ s #f (!) a ...)) ) )

) )
