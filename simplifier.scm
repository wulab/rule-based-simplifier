(load "global.scm")
(load "dict.scm")
(load "match.scm")
(load "instantiate.scm")

;; RULE-BASED SIMPLIFIER
;;
;; Given a set of rules, it produces a procedure to simplify expression
;; containing things referred to by those rules.
;;
;;     ]=> (define dsimp (simplifier deriv-rules))
;;     ]=> (dsimp '(dd (+ x y) x))
;;     (+ 1 0)

; (define (simplifier the-rules)
;   (define (simplify-exp exp)
;     ***)
;   (define (simplify-parts exp)
;     ***)
;   (define (try-rules exp)
;     ***)
;   simplify-exp) ; return a simplification procedure for the rules

; (define (simplify-exp exp)
;   (try-rules (if (compound? exp)
;                  (simplify-parts exp)
;                  exp)))

; (define (simplify-parts exp)
;   (if (null? exp)
;       '()
;       (cons (simplify-exp (car exp))
;             (simplify-parts (cdr exp)))))

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
