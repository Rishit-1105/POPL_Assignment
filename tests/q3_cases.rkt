#lang racket/base

(require racket/runtime-path)

(define-runtime-path solution-path "../code/75_q3.rkt")

(define (check-output case-name function-name expected call)
  (define port (open-output-string))
  (parameterize ([current-output-port port]) (call))
  (define actual (get-output-string port))
  (unless (string=? expected actual)
    (error 's1-tests "~a / ~a: expected ~s, got ~s"
           case-name function-name expected actual)))

(check-output 'module 'load "" (lambda () (dynamic-require solution-path #f)))

;; Look up the grader's entry points without adding exports to the solution.
(define-values (print-inorder print-all-traversals print-height-and-leaves)
  (parameterize ([current-namespace (module->namespace solution-path)])
    (values (eval 'print-inorder)
            (eval 'print-all-traversals)
            (eval 'print-height-and-leaves))))

(struct example (name tree inorder preorder postorder height-and-leaves))

(define examples
  (list
   (example 't1
            '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ())))
            "(1 2 3 4 5 6 7)\n" "(4 2 1 3 6 5 7)\n" "(1 3 2 5 7 6 4)\n" "(3 4)\n")
   (example 't2 '(1 () (2 () (3 () ())))
            "(1 2 3)\n" "(1 2 3)\n" "(3 2 1)\n" "(3 1)\n")
   (example 't3 '(a (b () ()) (c () ()))
            "(b a c)\n" "(a b c)\n" "(b c a)\n" "(2 2)\n")
   (example 'empty '()
            "()\n" "()\n" "()\n" "(0 0)\n")
   (example 'single-node '(x () ())
            "(x)\n" "(x)\n" "(x)\n" "(1 1)\n")
   (example 'left-skewed '(d (c (b (a () ()) ()) ()) ())
            "(a b c d)\n" "(d c b a)\n" "(a b c d)\n" "(4 1)\n")
   (example 'right-skewed '(w () (x () (y () (z () ()))))
            "(w x y z)\n" "(w x y z)\n" "(z y x w)\n" "(4 1)\n")
   (example 'unbalanced '(a (b (d () ()) (e () ())) (c () (f (g () ()) ())))
            "(d b e a c g f)\n" "(a b d e c f g)\n" "(d e b g f c a)\n" "(4 3)\n")
   (example 'repeated-values '(2 (1 () (2 () ())) (2 (1 () ()) (3 () ())))
            "(1 2 2 1 2 3)\n" "(2 1 2 2 1 3)\n" "(2 1 1 3 2 2)\n" "(3 3)\n")))

(for ([case-data (in-list examples)])
  (define name (example-name case-data))
  (define tree (example-tree case-data))
  (define inorder (example-inorder case-data))
  (check-output name 'print-inorder inorder (lambda () (print-inorder tree)))
  (check-output name 'print-all-traversals
                (string-append inorder (example-preorder case-data) (example-postorder case-data))
                (lambda () (print-all-traversals tree)))
  (check-output name 'print-height-and-leaves
                (example-height-and-leaves case-data)
                (lambda () (print-height-and-leaves tree))))

(displayln "S1 output checks passed.")
