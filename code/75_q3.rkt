#lang racket/base

(define (my-inorder tree)
  ;; Pending nodes are waiting for their left subtrees to finish.
  (let visit ([subtree tree] [pending '()])
    (cond
      [(not (null? subtree))
       (visit (cadr subtree) (cons subtree pending))]
      [(null? pending) '()]
      [else
       (let ([node (car pending)])
         (cons (car node)
               (visit (caddr node) (cdr pending))))])))

(define (print-inorder tree)
  (display (my-inorder tree))
  (newline))

(define (my-preorder tree)
  ;; Save each right subtree until its left sibling has been visited.
  (let visit ([subtree tree] [pending '()])
    (cond
      [(not (null? subtree))
       (cons (car subtree)
             (visit (cadr subtree) (cons (caddr subtree) pending)))]
      [(null? pending) '()]
      [else (visit (car pending) (cdr pending))])))
