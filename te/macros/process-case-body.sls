#!r6rs
(library (te macros process-case-body)

  (export $process-case-body $process-case-body2)

  (import (rnrs base)
          (te macros define-test)
          (te macros case-configuration)
          (te macros data-processing)
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

    (define-syntax $engroup-test-definition
      (syntax-rules (quote)
        ((_ s 'x) ($ s '(x))) ) )

    (define-syntax $process-case-body2
      (syntax-rules (quote)
        ((_ s 'body)
         ($ s ($process-case-body2 '1 ($span '$configuration-form? 'body))) )

        ((_ s '1 '(raw-case-configuration raw-test-definitions))
         ($ s ($process-case-body2 '2
                'raw-case-configuration
                ($partition '$anonymous-define-test? 'raw-test-definitions) )) )

        ((_ s '2 'raw-case-configuration '(anon-test-defs named-test-defs))
         ($ s ($process-case-body2 '3
                ($ensure-default-configuration
                  ($normalize-case-configuration 'raw-case-configuration) )
                ($map '$normalize-test-group
                  ($append
                    ($group-by '$test-definition-name 'named-test-defs)
                    ($map '$engroup-test-definition 'anon-test-defs) ) ) )) )

        ((_ s '3 '(case-wrapper test-wrapper fixture) 'test-groups)
         ($ s ($process-case-body2 '4
                ($define-case-wrapper 'case-wrapper)
                ($define-test-wrapper 'test-wrapper)
                ($define-fixture      'fixture)
                ($extract-test-parameters 'test-wrapper)
                'test-groups )) )

        ((_ s '4 'case-wrapper-lambda 'test-wrapper-lambda 'fixture-defs
                 'param-args 'test-groups )
         (let-syntax (($define-test-thunk
                        (syntax-rules (quote)
                          ((_ ss 'param-args* 'fixture-defs* '(test-body data-body))
                           ($ ss ($define-test2 'data-body 'param-args*
                                                'fixture-defs* 'test-body )) ) ) ))
           ($ s ($process-case-body2 '5
                  'case-wrapper-lambda
                  'test-wrapper-lambda
                  ($map '($define-test-thunk 'param-args 'fixture-defs)
                        'test-groups ) ) ) ) )

        ((_ s '5 'case-wrapper-lambda 'test-wrapper-lambda '(tests ...))
         ($ s '(case-wrapper-lambda
                test-wrapper-lambda
                (list tests ...))) ) ) )
) )
