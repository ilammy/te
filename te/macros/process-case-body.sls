#!r6rs
(library (te macros process-case-body)

  (export $process-case-body)

  (import (rnrs base)
          (te macros define-test)
          (te macros case-configuration)
          (te internal data)
          (te sr ck)
          (te sr ck-lists))

  (begin

    (define-syntax $process-case-body
      (syntax-rules (quote)
        ((_ s 'body)
         ($ s ($process-case-body '1 ($span '$configuration-form? 'body))) )

        ((_ s '1 '(case-configuration test-definitions))
         ($ s ($process-case-body '2
                ($ensure-default-configuration
                  ($normalize-case-configuration 'case-configuration) )
                'test-definitions ) ) )

        ((_ s '2 '(case-wrapper test-wrapper fixture) 'test-definitions)
         ($ s ($process-case-body '3
                ($define-case-wrapper 'case-wrapper)
                ($define-test-wrapper 'test-wrapper)
                ($define-fixture      'fixture)
                ($extract-test-parameters 'test-wrapper)
                'test-definitions )) )

        ((_ s '3 'case-wrapper-lambda 'test-wrapper-lambda 'fixture-defs
                 'test-parameters 'test-definitions )
         ($ s ($process-case-body '4
                'case-wrapper-lambda
                'test-wrapper-lambda
                ($map '($define-test 'test-parameters 'fixture-defs)
                      'test-definitions ) )) )

        ((_ s '4 'case-wrapper-lambda 'test-wrapper-lambda '(tests ...))
         ($ s '(case-wrapper-lambda
                test-wrapper-lambda
                (list tests ...))) ) ) )

) )
