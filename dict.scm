(define (extend-dict pat dat dict)
  (let ((name (variable-name pat)))
    (let ((v (assq name dict)))
      (cond ((not v)
             (cons (list name dat) dict)) ; extend dict by adding new entry to the front
            ((eq? (cadr v) dat) dict)     ; return unmodified dict if existing value equals dat
            (else 'failed)))))            ; failed if existing value does not equal dat

(define (lookup var dict)
  (let ((v (assq var dict)))
    (if (not v) var (cadr v))))

(define (empty-dict) '())

(define variable-name cadr)
