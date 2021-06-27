(load "test.scm")
(load "match.scm")

;; match
(define match-result
  (match
    '(+ (* (?c c) (?v v)) (?v v))
    '(+ (* 3 x) x)
    (empty-dict)))

(assert-not-equal 'failed match-result)
(assert-equal 3 (lookup 'c match-result))
(assert-equal 'x (lookup 'v match-result))
