(define-library (te macros parse-test-case-body)

  (export $parse-test-case-body)

  (import (scheme base)
          (te macros define-test)
          (te macros configuration-forms)
          (te internal data)
          (te sr ck)
          (te sr ck-lists)
          (te sr ck-predicates))

  (begin

    (define-syntax $test-case-form?
      (syntax-rules (quote)
        ((_ s 'x) ($ s ($or ($configuration-form? 'x)
                            ($define-test-form?   'x) ))) ) )

    (define-syntax $parse-test-case-body
      (syntax-rules (quote)
        ((_ s 'body)
         ($ s ($parse-test-case-body '0
                ($partition '$test-case-form? 'body) )) )

        ((_ s '0 '(test-case-forms internal-defs))
         ($ s ($parse-test-case-body '1
                ($span '$configuration-form? 'test-case-forms)
                'internal-defs )) )

        ((_ s '1 '(configuration-forms define-test-forms) 'internal-defs)
         ($ s ($parse-test-case-body '2
                ($ensure-default-configuration
                  ($normalize-configuration-forms 'configuration-forms) )
                'define-test-forms
                'internal-defs )) )

        ((_ s '2 '(case-wrapper test-wrapper fixture-forms)
                 'define-test-forms 'internal-defs )
         ($ s ($parse-test-case-body '3
                ($define-case-wrapper 'case-wrapper)
                ($define-test-wrapper 'test-wrapper)
                ($define-fixture      'fixture-forms)
                ($extract-param-args  'test-wrapper)
                'define-test-forms
                'internal-defs )) )

        ((_ s '3 'case-lambda 'test-lambda 'fixture-defs 'param-args
                 'define-test-forms 'internal-defs )
         ($ s ($parse-test-case-body '4
                'case-lambda 'test-lambda
                ($map '($define-test 'param-args 'fixture-defs)
                      'define-test-forms )
                'internal-defs )) )

        ((_ s '4 'case-lambda 'test-lambda
                 '(tests ...) 'internal-defs )
         ($ s '((case-lambda test-lambda (list tests ...))
                internal-defs)) ) ) )
) )
