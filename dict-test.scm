(load "test.scm")
(load "dict.scm")

;; empty-dict
(assert-equal (empty-dict) '())

;; variable-name
(assert-equal 'x (variable-name '(? x)))
(assert-equal 'c (variable-name '(?c c)))
(assert-equal 'v (variable-name '(?v v)))

;; extend-dict
(define dict (extend-dict '(?c c) 10 (empty-dict)))
(assert-not-equal 'failed dict)
(assert-equal 'failed (extend-dict '(?c c) 20 dict))

;; lookup
(assert-equal 10 (lookup 'c dict))
(assert-equal 'x (lookup 'x dict))
