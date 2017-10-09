; Mariana Quinde Garcia
; CS360 PA1 Problem 1
; This program defines sample-messages and sample-trees for the example in
; week 2 (figures 1-2) and uses code from the SICP Book for the Huffman 
; algorithm to allow its decoding and encoding
; To call: (decode decode-message2 sample-tree2) 
; To call: (encode encode-message2 sample-tree2)
; (or 1 to see the smaller tree in figure 1)
;--------------------------------------------------------------------------
;CODE FROM CHAPTER 2 OF STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

;SECTION 2.3.3

;; representing

(define (element-of-set? x set) 
   (cond ((null? set) false) 
         ((equal? x (car set)) true) 
         (else (element-of-set? x (cdr set)))))

(define (make-leaf symbol weight)
  (list 'leaf symbol weight))

(define (leaf? object)
  (eq? (car object) 'leaf))

(define (symbol-leaf x) (cadr x))

(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))

(define (left-branch tree) (car tree))

(define (right-branch tree) (cadr tree))

(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))

(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))

;; decoding
(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
        '()
        (let ((next-branch
               (choose-branch (car bits) current-branch)))
          (if (leaf? next-branch)
              (cons (symbol-leaf next-branch)
                    (decode-1 (cdr bits) tree))
              (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "bad bit -- CHOOSE-BRANCH" bit))))

;; sets

(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set))
        (else (cons (car set)
                    (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set (make-leaf (car pair)
                               (cadr pair))
                    (make-leaf-set (cdr pairs))))))


;; EXERCISE 2.67

(define sample-tree
   (make-code-tree (make-leaf 'A 4)
                   (make-code-tree
                    (make-leaf 'B 2)
                    (make-code-tree (make-leaf 'D 1)
                                    (make-leaf 'C 1)))))

 (define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))


;; EXERCISE 2.68

(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))

;; EXERCISE 2.69

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))
;---------------------------------------------------------------------------
; The following code was added to support the encode function above

; Function that recieves a symbol and a tree and  returns the list of bits that encodes the symbol according the tree.
(define (encode-symbol symbol tree) 
   (define (branch-correct? branch) 
     (if (leaf? branch) 
         (equal? symbol (symbol-leaf branch)) 
         (element-of-set? symbol (symbols branch)))) 
  
   (let ((lb (left-branch tree)) 
         (rb (right-branch tree))) 
     (cond ((branch-correct? lb) 
            (if (leaf? lb) '(0) (cons 0 (encode-symbol symbol lb)))) 
           ((branch-correct? rb) 
            (if (leaf? rb) '(1) (cons 1 (encode-symbol symbol rb)))) 
           (else (error "error: symbol not in tree" bit)))))
;---------------------------------------------------------------------------
; This samples are for testing encoding and decoding functions and
; correspond to the trees and messages in figure 1 and 2 of week 2 exampless:

(define sample-tree1
  (make-code-tree (make-leaf 'A 0)
                  (make-code-tree
						  (make-code-tree 
							 (make-leaf 'B 0)
							 (make-leaf 'C 1))
						  (make-leaf 'D 1))))

(define decode-message1 '(1 0 0 1 0 1 1 1 0))
(define encode-message1 '(B C D A))
(define sample-tree2
  (make-code-tree (make-code-tree 
						  (make-leaf 'D 22)
						  (make-leaf 'E 23))
						(make-code-tree
						  (make-leaf 'F 27)
						  (make-code-tree 
							 (make-leaf 'C 12)
							 (make-code-tree 
								(make-leaf 'A 7)
								(make-leaf 'B 9))))))

(define decode-message2 '(1 0 1 1 1 0 1 1 0 0 1 1 1 1 1))
(define encode-message2 '(F A C E B))

