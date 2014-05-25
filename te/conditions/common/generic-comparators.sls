#!r6rs
(library (te conditions common generic-comparators)

  (export type-of
          generic-=
          generic-< generic-<=
          generic-> generic->=
          generic-ci=
          generic-ci< generic-ci<=
          generic-ci> generic-ci>=)

  (import (rnrs base)
          (rnrs unicode)
          (only (srfi :1) every))

  (begin

    (define (type-of . values)
      (let ((first (car values)) (rest (cdr values)))
        (cond ((number? first) (and (every number? rest) 'number))
              ((string? first) (and (every string? rest) 'string))
              ((char?   first) (and (every char?   rest) 'char  ))
              ((symbol? first) (and (every symbol? rest) 'symbol))
              (else #f) ) ) )

    (define-syntax define-generic-comparator
      (syntax-rules ()
        ((_ (binding) (type-token comparator) ...)
         (define (binding type)
           (case type
             ((type-token) comparator) ...
             (else #f) ) ) ) ) )

    (define-generic-comparator (generic-=)
      (number =)
      (string string=?)
      (char   char=?)
      (symbol symbol=?) )

    (define-generic-comparator (generic-<)
      (number <)
      (string string<?)
      (char   char<?) )

    (define-generic-comparator (generic-<=)
      (number <=)
      (string string<=?)
      (char   char<=?) )

    (define-generic-comparator (generic->)
      (number >)
      (string string>?)
      (char   char>?) )

    (define-generic-comparator (generic->=)
      (number >=)
      (string string>=?)
      (char   char>=?) )

    (define-generic-comparator (generic-ci=)
      (string string-ci=?)
      (char   char-ci=?) )

    (define-generic-comparator (generic-ci<)
      (string string-ci<?)
      (char   char-ci<?) )

    (define-generic-comparator (generic-ci<=)
      (string string-ci<=?)
      (char   char-ci<=?) )

    (define-generic-comparator (generic-ci>)
      (string string-ci>?)
      (char   char-ci>?) )

    (define-generic-comparator (generic-ci>=)
      (string string-ci>=?)
      (char   char-ci>=?) )

) )
