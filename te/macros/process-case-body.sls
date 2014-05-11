#!r6rs
(library (te macros process-case-body)

  (export $process-case-body)

  (import (rnrs base)
          (te macros define-test)
          (te macros case-configuration)
          (te macros data-processing)
          (te internal data)
          (te sr ck)
          (te sr ck-lists))

  (begin

    (define-syntax $engroup-test-definition
      (syntax-rules (quote)
        ((_ s 'x) ($ s '(x))) ) )

    (define-syntax $process-case-body
      (syntax-rules (quote)
        ((_ s 'body)
         ($ s ($process-case-body '1 ($span '$configuration-form? 'body))) )

        ((_ s '1 '(raw-case-configuration raw-test-definitions))
         ($ s ($process-case-body '2
                'raw-case-configuration
                ($partition '$anonymous-define-test? 'raw-test-definitions) )) )

        ((_ s '2 'raw-case-configuration '(anon-test-defs named-test-defs))
         ($ s ($process-case-body '3
                ($ensure-default-configuration
                  ($normalize-case-configuration 'raw-case-configuration) )
                ($map '$normalize-test-group
                  ($append
                    ($group-by '$test-definition-name 'named-test-defs)
                    ($map '$engroup-test-definition 'anon-test-defs) ) ) )) )

        ((_ s '3 '(case-wrapper test-wrapper fixture) 'test-groups)
         ($ s ($process-case-body '4
                ($define-case-wrapper 'case-wrapper)
                ($define-test-wrapper 'test-wrapper)
                ($define-fixture      'fixture)
                ($extract-test-parameters 'test-wrapper)
                'test-groups )) )

        ((_ s '4 'case-wrapper-lambda 'test-wrapper-lambda 'fixture-defs
                 'param-args 'test-groups )
         ($ s ($process-case-body '5
                'case-wrapper-lambda
                'test-wrapper-lambda
                ($map '($define-test 'param-args 'fixture-defs)
                      'test-groups ) ) ) )

        ((_ s '5 'case-wrapper-lambda 'test-wrapper-lambda '(tests ...))
         ($ s '(case-wrapper-lambda
                test-wrapper-lambda
                (list tests ...))) ) ) )
) )
