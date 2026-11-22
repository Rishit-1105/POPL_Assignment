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

(define (my-postorder tree)
  ;; Each pending frame pairs a node with a flag for whether its right subtree has started.
  (let visit ([subtree tree] [pending '()])
    (cond
      [(not (null? subtree))
       (visit (cadr subtree) (cons (cons subtree #f) pending))]
      [(null? pending) '()]
      [else
       (let* ([frame (car pending)]
              [node (car frame)]
              [remaining (cdr pending)])
         (if (cdr frame)
             (cons (car node) (visit '() remaining))
             (visit (caddr node) (cons (cons node #t) remaining))))])))
