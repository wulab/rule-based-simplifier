(load "global.scm")
(load "dict.scm")

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
