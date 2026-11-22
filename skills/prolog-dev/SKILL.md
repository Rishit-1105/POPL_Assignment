---
name: prolog-dev
description: Write and review this assignment's SWI-Prolog 9.x predicates and tests within the requested scope.
---

# Prolog development

Use SWI-Prolog 9.x. Read the relevant problem specification and existing code
before editing. Implement only the requested predicate, test file, or review;
preserve unrelated definitions and keep each requested unit in its own commit.

## Coding conventions and declarative reading

- Use snake_case predicate names, descriptive variables starting with capitals,
  and `_` for a value that is deliberately unused. Quote atoms when needed.
- Indent clause bodies by four spaces. Keep clauses of one predicate together.
  Prefer pattern matching, explicit base cases, and recursion over mutable state.
- Above each predicate, document its argument modes (`+` input, `-` output,
  `?` either) and its relation: "This holds when ...". Explain what makes the
  base case true and how recursive clauses relate smaller inputs to the result.
  For example, `expr_over(List, Tree, Value)` holds when Tree uses List's
  numbers once, in order, and evaluates to Value.
- Check the operational reading too: goals run left to right and clauses are
  explored on backtracking. Establish operands before arithmetic; make each
  recursive call decrease a finite input. Preserve every required solution.
- Use `=` for unification, `is` for arithmetic evaluation, `=:=` for numeric
  equality, and `==` for term identity. Do not interchange them.
- Use cuts or if-then-else only when their effect on the required solutions is
  understood. Do not cut an enumeration merely to make its first answer work.

## Assignment constraints

- Solution files contain definitions only. Do not add top-level queries,
  initialization directives, or calls to `halt/0` or `halt/1`.
- Loading a file must not print anything or run the solution or tests. Put any
  explicitly required output inside the requested predicate or test runner;
  otherwise keep predicates silent.
- Use SWI-Prolog built-ins and only these allowed libraries: `lists`, `apply`,
  `yall`, and `aggregate`. Do not introduce other library dependencies.
- Do not use `assert`, `asserta`, `assertz`, `retract`, `retractall`, or global
  variables such as `b_setval` and `nb_setval`. Pass state through arguments.
- For Problem 2, return SWI-Prolog strings, keep numbers in input order, and
  follow the canonical parenthesis rules. Do not render a string and parse it
  back into a term to evaluate it.
- Guard division before evaluating it: require integer operands, a nonzero
  divisor, and a zero remainder. Then compute the integer quotient. Invalid
  division must fail, including inside a subtree; negative intermediate values
  are valid. Reuse `apply_op/4` when evaluating expression trees.

## Running and testing

Run goals explicitly from the repository root:

```sh
swipl -q -f file.pl -g "goal" -t halt
swipl -q -f code/75_q2.pl -g "all_equations([4,2,5,3], Es)" -t halt
swipl -q -f tests/75_q2_tests.pl -g "run_q2_tests" -t halt
```

The command-line `-t halt` is permitted; do not put a halt call in a source file.
Keep tests in their requested test file, loading the solution by a path relative
to that file. Run both successful and failing cases, check exact output types,
and exhaust generators when checking all answers. Cover empty and singleton
lists, repeated values, zero divisors, non-exact division, and parentheses where
relevant. Bound cases meant to detect nontermination. Do not add tests when the
user asks for a predicate only. Report the runtime/version used and any checks
that could not be run; never describe an unexecuted check as passing.

## Self-review before answering

- Did I change only the requested unit and preserve existing definitions?
- Does every predicate have a clear declarative meaning and intended modes?
- Are recursive inputs smaller and searches finite for the required inputs?
- Are all required answers reachable on backtracking, without unwanted duplicates?
- Are required strings strings, with the specified spacing and parentheses?
- Do invalid cases fail without arithmetic or instantiation errors, as required?
- Is division checked for zero and exactness before computing a quotient?
- Are there no initialization directives, halt calls, top-level queries, or
  load-time printing? Is other printing limited to explicitly required output?
- Are all libraries allowed, with no assert/retract or global-variable state?
- Have I run the applicable checks and clearly stated any verification limits?

## Common AI mistakes

- Returning an atom (`'4*2=5+3'`) or a code list instead of a string
  (`"4*2=5+3"`). Use `number_string/2` or `format(string(S), ...)`.
- Calling arithmetic on unbound or wrong-type operands, causing an error where
  failure is required. Guard the intended input mode before evaluation.
- Using `/` and floating-point equality for exact integer division, checking
  zero too late, or accepting a non-exact division inside a subtree.
- Recursing on the same list or allowing an empty split, causing infinite
  recursion; using negation on unbound values as if it generated complements.
- Losing solutions through premature cuts, reordering numbers, or ignoring
  parentheses on a right child with equal precedence.
- Letting loading execute queries or print output, adding forbidden libraries,
  or claiming tests passed when only the code was inspected.
