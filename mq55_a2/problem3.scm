; Mariana Quinde Garcia
; CS360 PA2 Problem 3
; This program solves SICP programming problems
; 4.4, 4.9 of section 4.1.2 and 4.11 of section 4.1.3.
; To call: testAnd system-global-environment
;			  testOr system-global-environment
;			  testWhile system-global-environment
;			  testDefine
;
; ---------------- 4.4 in 4.1.2 --------------------
(define (and? expr) 
  (tagged-list? expr 'and))

;; function to evaluate the tail of expressions
(define (evalAnd expr envrm)
  ;; expand the clauses and evaluate each 
  (define (expandClausesA expr)
	 ;; eval first clause and store it in first
    (let ((head (eval (car expr) envrm)) (tail (cdr expr)))
		;; if not true, whole expression is false
      (if (not (true? head))
        #f
		  ;; if this is last expression and all were true
		  ;; return this element
        (if (null? tail)
          head
			 ;; else evaluate rest of expression
          (expandClausesA tail)))))
  (if (null? tail)
	 ;; if no expressions, return true
    #t
	 ;; else continue evaluating
    (expandClausesA tail)))

(define (testAnd envrm)
  (eval '(and (> 10 9)(> 11 9)) envrm)
)

;; or
(define (or? expr) 
	(tagged-list? expr 'or))

;; function to evaluate the tail of expressions
(define (evalOr expr env)
	;; expand clauses and evaluate
	(define (expandClausesO expr)
	;; if there are no expressions false is returned
	(if (null? expr)
      #f
		;; evaluate first and get tail
      (let ((head (eval (car expr) env)) (tail (cdr expr)))
			;; if one is true, return it and stop evaluating
			(if (true? head)
				head
				;; else keep on evaluating tail
				(expandClausesO tail)))))
  (expandClausesO tail))

;; test or for empty
(define (testOr envrm)
  (eval '(or) envrm)
)

; ------------------- 4.9 in 4.1.2 ------------------

; do 
(define (do? expr)
	(tagged-list? expr 'do))
; start loop
(define (evalDo expr envrm)
	(define (expandDo expr)
		(let ((exe (car expr)) (condi (cadr expr)))
			; execute at least one
			((exe)
			; check condition after
			(if eval (condi)
				(expandDo expr))
			))))
; for
(define (for? expr)
	(tagged-list? expr 'for))
; loop
(define (evalFor expr envrm)
	(define (expandFor expr)
		(let ((it (car expr)) (exe (cadr expr)))
		;execute
			((exe)
		; update iterator
			(set! it (- it 1))
		;return
			(expandFor ((exe) (it)))
			))))

; while
(define (while? expr)
	(tagged-list? expr 'while))

;; start loop
(define (evalWhile expr envrm)
	(define (expandWhile expr)
		(let ((condi (car expr)) (it (cadr expr)) (exe (caddr expr)))
			; check condition
			(if eval (condi)
			; execute and update
				((exe)
				(it)
			; return to evaluation
				(expandWhile expr))
			) 
		)))

; until 
(define (until? expr)
	(tagged-list? expr 'until))
; loop
(define (evalUntil expr envrm)
	(define (expandUntil expr)
		(let ((cond (car expr)) (it (cadr expr)) (exe (caddr expr)))
			; check it is not true
			(if eval (not(condi))
				; execute
				((exe)
				; update
				(it)
				; return
				(expandUntil expr))
			) 
		)))
;---------------- 4.11--------------------

; make a map with the pairs as a list, with each binding
; holding a pair
(define (make-frame variables values) 
  (cons 
	 'list
	 (map cons variables values))) 
 
; get pair map from key
(define (fPairs frame) (map car frame))
;get values map
(define (fValues frame) (map cdr frame)) 

; rewrite of binding environment operation
(define (bindToFrame! variables values frame) 
  (set-cdr! frame 
				(cons (cons variables values) (fPairs frame))))
