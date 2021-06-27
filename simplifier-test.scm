(load "test.scm")
(load "simplifier.scm")

;; simplifier
(define deriv-rules
  '(
    ( (dd (?c c) (? v))               0                                 )
    ( (dd (?v v) (? v))               1                                 )
    ( (dd (?v u) (? v))               0                                 )
    ( (dd (+ (? x1) (? x2)) (? v))    (+ (dd (: x1) (: v))
                                         (dd (: x2) (: v)))             )
    ( (dd (* (? x1) (? x2)) (? v))    (+ (* (: x1) (dd (: x2) (: v)))
                                         (* (dd (: x1) (: v)) (: x2)))  )
    ( (dd (** (? x) (?c n)) (? v))    (* (* (: n) (+ (: x) (: (- n 1))))
                                         (dd (: x) (: v)))              )
  ))

(define dsimp (simplifier deriv-rules))
(assert-equal '(+ 1 0) (dsimp '(dd (+ x y) x)))

(define algebra-rules
  '(
    ( ((? op) (?c c1) (?c c2))                   (: (op c1 c2))                )
    ( ((? op) (?  e ) (?c c ))                   ((: op) (: c) (: e))          )
    ( (+ 0 (? e))                                (: e)                         )
    ( (* 1 (? e))                                (: e)                         )
    ( (* 0 (? e))                                0                             )
    ( (* (?c c1) (* (?c c2) (? e )))             (* (: (* c1 c2)) (: e))       )
    ( (* (?  e1) (* (?c c ) (? e2)))             (* (: c ) (* (: e1) (: e2)))  )
    ( (* (* (? e1) (? e2)) (? e3))               (* (: e1) (* (: e2) (: e3)))  )
    ( (+ (?c c1) (+ (?c c2) (? e )))             (+ (: (+ c1 c2)) (: e))       )
    ( (+ (?  e1) (+ (?c c ) (? e2)))             (+ (: c ) (+ (: e1) (: e2)))  )
    ( (+ (+ (? e1) (? e2)) (? e3))               (+ (: e1) (+ (: e2) (: e3)))  )
    ( (+ (* (?c c1) (? e)) (* (?c c2) (? e)))    (* (: (+ c1 c2)) (: e))       )
    ( (* (? e1) (+ (? e2) (? e3)))               (+ (* (: e1) (: e2)))         )
  ))

(define asimp (simplifier algebra-rules))
(assert-equal '(+ x y) (asimp '(+ x (* 1 (+ y (* 0 z))))))
