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
