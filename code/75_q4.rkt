#lang racket/base

;;; S2: Insert an atom at the front of every nested list whose original
;;; top-level length is below the given threshold, including the outer list.
;;; Allowed forms and built-ins (S2):
;;;   define, lambda, let, let*, letrec, named let, if, cond (with else),
;;;   and, or, not, begin, quote ('), cons, car, cdr, list,
;;;   car/cdr compositions up to four levels (cadr, cddr, caddr, cdddr,
;;;   cadddr, cddddr, ...), null?, pair?, eq?, assq, assoc,
;;;   +, -, *, <, >, <=, >=, =, max, display, newline, read.
;;; Forbidden: set! and relatives, vectors, hash tables, strings,
;;;   loops (do, for), length, append, reverse, map, filter, member,
;;;   memq, list-ref, list-tail. Write helpers such as my-length and my-map.

;; my-length : proper list -> nonnegative integer
;; Count top-level elements; a sublist counts as one element.
;; The loop carries a count as it advances by cdr, with the call in tail position.
(define (my-length lst)
  (let loop ([remaining lst] [count 0])
    (if (null? remaining)
        count
        (loop (cdr remaining) (+ count 1)))))

;; my-map : (Any -> Any) proper list -> proper list
;; Apply f to each top-level element, preserving their order.
;; The empty list ends the recursion; each step conses the mapped head
;; onto the result of mapping the tail.
(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst))
            (my-map f (cdr lst)))))

;; make-inserter : atom (nonnegative integer -> Boolean) -> (proper list -> proper list)
;; Return a function that inserts x into each list accepted by len-ok?.
;; Each recursive call measures its original list before rebuilding child lists.
;; The inner recursion uses my-map to descend into each child list, leaving atoms
;; unchanged, then prepends x if len-ok? accepts the original length.
(define (make-inserter x len-ok?)
  (letrec ([insert (lambda (lst)
                     (let* ([original-length (my-length lst)]
                            [mapped (my-map (lambda (item)
                                              (if (or (pair? item) (null? item))
                                                  (insert item)
                                                  item))
                                            lst)])
                       (if (len-ok? original-length)
                           (cons x mapped)
                           mapped)))])
    insert))

;; insert-if-short : atom proper list nonnegative integer -> proper list
;; Insert x wherever a list's original top-level length is less than n.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))

;; print-insert-result : -> void
;; Read x, lst, and n in order; display only the resulting list and a newline.
(define (print-insert-result)
  (let* ([x (read)]
         [lst (read)]
         [n (read)])
    (display (insert-if-short x lst n))
    (newline)))
