(define (assert exp)
  (if (exp)
      'passed
      (raise 'assert-error)))

(define (assert-not exp)
  (if ((not exp))
      'passed
      (raise 'assert-not-error)))

(define (assert-equal exp1 exp2)
  (if (equal? exp1 exp2)
      'passed
      (raise 'assert-equal-error)))

(define (assert-not-equal exp1 exp2)
  (if (not (equal? exp1 exp2))
      'passed
      (raise 'assert-not-equal-error)))
