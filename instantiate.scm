(load "global.scm")
(load "dict.scm")

;; SKELETON INSTANTIATION
;;
;; foo     instantiates to itself
;; (f a b) instantiates to a list of 3 elements
;;         results of instantiating each of f, a, b
;; (: x)   instantiates to the value of x in the pattern matched

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
