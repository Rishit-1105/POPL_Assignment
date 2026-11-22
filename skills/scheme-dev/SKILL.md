---
name: scheme-dev
description: Write, review, debug, and test this project's Scheme work in Racket 8.x using racket/base, with explicit recursion, consistent naming and comments, and no accidental execution on import.
---

# Scheme development

## Scope and working rules

- Target Racket 8.x. Start each source module with `#lang racket/base`.
- Read the task, applicable repository instructions, and nearby code first. Preserve required procedure names, arities, return shapes, permitted primitives, and file layout. Task-specific restrictions take precedence over these defaults.
- Keep `racket/base`; do not switch to `#lang racket` to make an unbound identifier disappear. Require only the libraries actually needed and permitted. Do not mix in teaching-language, R5RS, or Common Lisp forms.
- Default to pure procedures and explicit structural recursion for exercises. Use mutation, higher-order helpers, or additional libraries only when the task permits them and they serve the solution.
- Export only the interface the task or callers need; avoid blanket `(provide (all-defined-out))`.

## Names, layout, and comments

- Use lowercase, hyphen-separated names: `remove-first`, `remaining-items`. Preserve names required by the task.
- End Boolean predicates with `?`, procedures that mutate state with `!`, and conversions with `->` where appropriate. Do not add `!` merely to signal emphasis.
- Use meaningful parameter names. Short names such as `xs`, `ys`, and `acc` are fine in small recursive helpers when their roles are clear. Avoid shadowing primitives such as `list`, `cons`, and `map`.
- Use conventional Racket indentation, spaces rather than tabs, and one definition per logical block. Align `cond` clauses and use brackets consistently; let an editor handle indentation and delimiter matching.
- Use `;;;` for file or section notes, `;;` for procedure documentation, and `;` for brief inline notes. Keep comments focused on intent, assumptions, and invariants rather than narrating each expression.
- Before each public or nontrivial procedure, give an informal signature, purpose, and relevant input assumptions. State whether inputs must be proper lists, nonnegative integers, or otherwise constrained. These comments do not enforce runtime contracts.
- For a recursive helper, explain what its accumulator represents, what gets smaller, and any non-obvious output-order invariant. Update comments when behavior changes.

```racket
;; count-items : (Listof Any) -> Natural
;; Count the elements of a finite proper list.
(define (count-items xs)
  (cond
    [(null? xs) 0]
    [else (add1 (count-items (cdr xs)))]))
```

## Recursion and common AI mistakes

- **Reaching for `length`:** Use `(null? xs)` to test an empty proper list, not `(= (length xs) 0)`. Repeatedly measuring shrinking tails can turn a linear traversal into quadratic work. Compute a length only when the result actually needs it and the task allows it.
- **Reaching for `map`:** Do not hide a required recursive solution inside `map`, `filter`, folds, or `for/list`. When higher-order procedures are allowed, `map` is appropriate for producing transformed values; do not use it merely for side effects or discard its result.
- **Reaching for `append`:** Prepend an element with `cons`. Avoid repeatedly appending a singleton to a growing accumulator, which copies that accumulator and can make the algorithm quadratic. Use direct recursive construction, or accumulate with `cons` and reverse once if allowed. Check output order. `append` is reasonable for genuine concatenation when permitted; these are decision rules, not claims that the primitives are invalid Scheme.
- **Calling things at the top level:** Keep example calls, printing, input, benchmarks, and driver invocations out of the module body. Put assertions in `module+ test` and an intended command-line entry point in `module+ main`. A `define` initializer also runs when the module is instantiated: hiding `(main)` or I/O inside a definition does not fix this. Pure constant construction is fine.
- **Missing base cases:** Handle the empty case before `car` or `cdr`. For every branch, identify the smaller recursive input and confirm termination. If recursing over two lists, define the unequal-length behavior instead of assuming it away.
- **Confusing list shapes:** `(cons x xs)` prepends an element; `(list x xs)` nests the second argument. `cons` can also construct an improper pair. Do not flatten, nest, or change proper-list structure unintentionally. Only handle improper lists or trees when the contract calls for them.
- **Treating parentheses as grouping:** `(f x)` applies a procedure; an extra pair of parentheses can call a value accidentally. Quote literal symbols and lists, but do not quote an expression that should execute. A single quote is not a string delimiter.
- **Importing other languages' truth rules:** Only `#f` is false in Racket; `'()` and `0` are true. Use `null?` for emptiness. `and`, `or`, and membership procedures can return non-Boolean values; normalize the result when the contract promises a Boolean predicate.
- **Choosing the wrong equality:** Use `=` for numeric equality and `equal?` for structural data equality. Reserve `eq?` for identity or suitable symbol comparisons, not general number, string, or list comparison.
- **Assuming mutable lists:** Ordinary Racket pairs are immutable. Do not invent `set-car!`/`set-cdr!` solutions or mix mutable pairs with ordinary lists unless the task explicitly requires that representation.
- **Accidentally repeating work:** Bind a recursive result if several expressions need it instead of recomputing it. Keep accumulator calls in tail position when constant stack usage is intended; wrapping them in `cons`, arithmetic, or other pending work removes tail position. Direct non-tail structural recursion is still appropriate when it is the clearest solution.

## Run and test

Use the repository's documented commands if present. Otherwise, run these from the repository root, substituting real paths for `path/to/file.rkt`:

```sh
racket --version
raco make path/to/file.rkt
raco test path/to/file.rkt
raco test .
```

- Confirm the runtime is 8.x; use any more specific version pinned by the project. If `racket` or `raco` is unavailable, report that limitation instead of claiming a successful run.
- `raco make` checks compilation; it does not establish behavioral correctness. Run the changed module's tests, then the applicable project suite. `raco test .` recursively discovers modules; inspect the repository before using it because files without a test submodule may have their module bodies run.
- Run `racket path/to/file.rkt` for a module intended as a program. Its `module+ main` holds the driver call; this command is not a substitute for `raco test`.
- For a reusable library, check import behavior with `racket -e '(require "path/to/file.rkt")'`. It should finish without demonstration output, input prompts, or driver activity.
- Use RackUnit assertions in `(module+ test (require rackunit) ...)`, or follow an established separate-test layout. Do not use printed results as the test oracle.
- Select meaningful cases for the contract: empty and singleton inputs, ordinary inputs, relevant boundaries, duplicates, and order preservation. Check invalid inputs only when behavior for them is specified; do not invent validation or new failure behavior.

For the `count-items` example, the tests belong in the same module:

```racket
(module+ test
  (require rackunit)
  (check-equal? (count-items '()) 0)
  (check-equal? (count-items '(a)) 1)
  (check-equal? (count-items '(a b a)) 3))
```

See the official documentation for [main and test submodules](https://docs.racket-lang.org/guide/Module_Syntax.html) and [`raco test`](https://docs.racket-lang.org/raco/test.html) when command behavior needs clarification.

## Before answering

- [ ] Confirm Racket 8.x and `#lang racket/base`, required interfaces, permitted primitives, and task constraints.
- [ ] Check names, signatures, comments, and any helper invariant against the actual implementation.
- [ ] Trace base cases, recursive progress, result shape, and output order; inspect every `car`/`cdr` precondition.
- [ ] Review each `length`, `map`, and `append` use, any substitute that evades a recursion requirement, and repeated recursive calls. Check the claimed time and space costs.
- [ ] Check truth tests, equality, quoting, application parentheses, and imports for dialect mistakes.
- [ ] Ensure importing the module does not execute examples, tests, I/O, or a driver, including through definition initializers.
- [ ] Run the relevant compile and test commands and inspect their results. Distinguish passing assertions from a command that found no tests. State exactly what could not be run and why.
- [ ] Review the final changes for task scope, accidental debug output, and stale comments. In the answer, briefly state what changed, how it was checked, and any unresolved limitation; do not claim execution based on inspection alone.
