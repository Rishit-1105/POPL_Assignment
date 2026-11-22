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
