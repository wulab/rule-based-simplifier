(load "global.scm")
(load "dict.scm")

;; PATTERN MATCHING
;;
;; A rule consists of a pattern and its replacement (skeleton).
;;
;;     ( (+ 0 (? e))   (: e) )
;;         pattern    skeleton
;;
;; This rule states that any expression plus zero will equal to that expression.
;;
;;     foo     matches exactly foo
;;     (f a b) matches any list whose the first, second, and third elements are
;;             f, a, and b correspondingly
;;     (?  e)  matches anything e.g. 1, x, (+ 1 x), call it e
;;     (?c a)  matches constant, call it a
;;     (?v x)  matches variable, call it x

; (define (match pat exp dict)
;   (cond ((eq? dict 'failed) 'failed)
;         ((atom? pat)
;           *** ATOMIC PATTERNS ***
;           )
;         *** PATTERN VARIABLE CLAUSES ***
;         ((atom? exp) 'failed) ; failed if pat is not atomic and exp is atomic
;         (else
;           (match (cdr pat)
;                  (cdr exp)
;                  (match (car pat)
;                         (car exp)
;                         dict)))))

; (define (match pat exp dict)
;   (cond ((eq? dict 'failed) 'failed)
;         ((atom? pat)
;           (if (atom? exp)
;               (if (eq? pat exp)
;                   dict
;                   'failed)
;               'failed))
;         *** PATTERN VARIABLE CLAUSES ***
;         ((atom? exp) 'failed) ; failed if pat is not atomic and exp is atomic
;         (else
;           (match (cdr pat)
;                  (cdr exp)
;                  (match (car pat)
;                         (car exp)
;                         dict)))))

(define (match pat exp dict)
  (cond ((eq? dict 'failed) 'failed) ; fastest way to propagate failure up
        ((atom? pat)
          (if (atom? exp)
              (if (eq? pat exp)
                  dict
                  'failed)
              'failed))
        ((arbitrary-constant? pat) ; (?c x)
          (if (constant? exp)
              (extend-dict pat exp dict)
              'failed))
        ((arbitrary-variable? pat) ; (?v x)
          (if (variable? exp)
              (extend-dict pat exp dict) ; failed when an existing value isn't the same
              'failed))
        ((arbitrary-expression? pat) ; (? x)
          (extend-dict pat exp dict))
        ((atom? exp) 'failed) ; failed if pat is not atomic and exp is atomic *
        (else
          (match (cdr pat)
                 (cdr exp)
                 (match (car pat)
                        (car exp)
                        dict)))))

;; * (match '(?c x) 10 dict) will be intercepted by
;;   (arbitrary-constant? pat) and won't fall into (atom? exp)

(define constant? number?)
(define variable? atom?)

(define (arbitrary-constant? pat)
  (if (pair? pat)
      (eq? (car pat) '?c)
      false))

(define (arbitrary-variable? pat)
  (if (pair? pat)
      (eq? (car pat) '?v)
      false))

(define (arbitrary-expression? pat)
  (if (pair? pat)
      (eq? (car pat) '?)
      false))
