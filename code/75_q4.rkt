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
