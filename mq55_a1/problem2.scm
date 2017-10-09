; Mariana Quinde Garcia
; CS360 PA1 Problem 2
; This scheme function receives a list with values (start step end)
; It returns a function which when called returns the next number 
; in the sequence of (range (start step end))
; To call: (define function(iterator '(start step end)))
; call (function) repeatedly to get next value in sequence
;
(define (iterator L)
  ; define variables to use in count
  (let ((start (car L)) (step (cadr L)) (end (caddr L)) (count 0) (n 0))
	 (lambda ()
		; define next number by adding the step to the start 
		(set! n(+ start (* step count)))
		(set! count(+ count 1))
		; if next number is more than end return empty list
		(if (> n end)
		  '()
		  n))))
