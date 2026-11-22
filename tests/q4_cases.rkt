;; my-length: empty list
(q4-check (my-length '()) 0)

;; my-length: sublists each count once
(q4-check (my-length '((1 2) () a)) 3)

;; my-map: empty list
(q4-check (my-map (lambda (x) (+ x 1)) '()) '())

;; my-map: one output per top-level element, in order
(q4-check (my-map (lambda (x) (pair? x)) '(a (1) ())) '(#f #t #f))

;; S2 example 1
(q4-check (insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3) '((42 1 2) (3 4 5) (42 6) (42)))

;; S2 example 2
(q4-check (insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3) '((0 (0 1) 2) (0 3) (0 (4 5 6) (0))))

;; S2 example 3: empty top-level list qualifies
(q4-check (insert-if-short 7 '() 3) '(7))

;; S2 example 4: zero threshold leaves an empty list empty
(q4-check (insert-if-short 7 '() 0) '())
