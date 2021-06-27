(load "global.scm")
(load "dict.scm")
(load "match.scm")
(load "instantiate.scm")

(define (simplifier the-rules)
  (define (simplify-exp exp)
    (try-rules (if (compound? exp) ; try every sub-expressions from atom to compound
                   (map simplify-exp exp)
                   exp)))
  (define (try-rules exp)
    (define (scan rules)
      (if (null? rules)
          exp
          (let ((dict
                 (match (pattern (car rules))
                        exp
                        (empty-dict))))
      (if (eq? dict 'failed)
          (scan (cdr rules))
          (simplify-exp
           (instantiate (skeleton (car rules)) dict))))))
    (scan the-rules))
  simplify-exp)

(define compound? pair?)
(define pattern car)
(define skeleton cadr)
