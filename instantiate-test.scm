(load "test.scm")
(load "instantiate.scm")

;; instantiate
(define dict (extend-dict '(?c c) 10 (empty-dict)))
(assert-equal '(+ x 10) (instantiate '(+ x (: c)) dict))
(assert-equal '(+ x 9) (instantiate '(+ x (: (- c 1))) dict))
(assert-equal '(+ x y) (instantiate '(+ x (: y)) dict))
