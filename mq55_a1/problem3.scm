; Mariana Quinde Garcia
; CS360 PA1 Problem 3

; This scheme function receives a name and an association list.
; It returns that pair within the list with such a name or a null
; list if such pair does not exist.
; To call: (lookup name List)
; returns (name value) pair

(define (lookup name L)
  (cond 
	 ; check if list is empty
	 ((null? L) '())
	 ; recursively look for name at head of list
	 ((equal? name (car (car L))) (car L))
	 (else (lookup name (cdr L)))))

; This scheme function receives a name and an environment with 
; association lists. It returns the pair within the environment 
; with such name or a null list if it does not exist.
; To call: (lookup-env name env)
; returns (name value) pair 
(define (lookup-env name L)
  (cond 
	 ; check if list is empty
	 ((null? L) '())
	 ; recursively look for name at head of lists using lookup
	 (else (let ((res (lookup name (car L)))) 
				(cond 
				  ((null? res) (lookup-env name (cdr L)))
				  (else res))))))
