(load "global.scm")
(load "dict.scm")

(define (instantiate skeleton dict)
  (define (loop s)
    (cond ((atom? s) s)
          ((skeleton-evaluation? s) ; (: x)
           (evaluate (eval-exp s) dict))
          (else (cons (loop (car s))
                      (loop (cdr s))))))
  (loop skeleton))

(define (skeleton-evaluation? s)
  (if (pair? s)
      (eq? (car s) ':)
      false))

(define eval-exp cadr)

(define (evaluate form dict)
  (if (atom? form)
      (lookup form dict)
      (apply (eval (lookup (car form) dict)
                   user-initial-environment)
             (map (lambda (v) (lookup v dict))
                  (cdr form)))))