---
name: prolog-dev
description: SWI-Prolog development guidelines, rules, testing instructions, review checklists, and common AI failure modes for POPL assignments.
---

# Prolog Development Guidelines (SWI-Prolog)

## 1. Language and Version
- **Target Platform**: SWI-Prolog 9.x (ISO-compliant core with SWI extensions).
- **Paradigm**: Pure logic programming with clean declarative semantics.

## 2. Coding Conventions
- **Naming Conventions**:
  - **Predicates**: Use `snake_case` (e.g., `solve_puzzle/2`, `find_path/3`).
  - **Variables**: Start with an uppercase letter or an underscore (e.g., `Result`, `State`, `_Temp`). Use a single underscore `_` for anonymous/ignored variables.
  - **Atoms**: Lowercase identifiers (e.g., `red`, `monday`). Special atoms (e.g., containing uppercase letters, spaces, or symbols) must be explicitly single-quoted (e.g., `'AI'`, `'c++'`).
- **Declarative Reading Comments**:
  - Every predicate must have a comment describing its declarative reading: what logical relation holds true.
  - Specify argument types and modes (`+` for input/instantiated, `-` for output/uninstantiated, `?` for either):
    ```prolog
    %!  subset_sum(+Numbers:list(integer), +Target:integer, -Subset:list(integer)) is nondet.
    %   True if Subset is a sublist of Numbers whose elements sum to Target.
    ```
- **Singleton Variables**: Code must compile cleanly without singleton variable warnings. Always name unused variables with a leading underscore or use `_`.

## 3. Running and Testing
- Run queries non-interactively using:
  ```bash
  swipl -q -f FILE -g "GOAL" -t halt
  ```
- **Usage Examples**:
  - Run a specific query:
    ```bash
    swipl -q -f code/solution.pl -g "solve(Result), writeln(Result)" -t halt
    ```
  - Run an automated test suite:
    ```bash
    swipl -q -f tests/test_p1.pl -g "run_tests" -t halt
    ```
  - Test and handle exit codes:
    ```bash
    swipl -q -f code/solution.pl -g "test_all, halt(0)" -t "halt(1)"
    ```

## 4. Strict Language Rules
- **No dynamic state modifications**:
  - Do NOT use `assert/1`, `asserta/1`, `assertz/1`, `retract/1`, or `retractall/1`.
  - Do NOT use global variables (e.g., `nb_setval/2`, `b_setval/2`).
  - Rely entirely on pure logical relation and argument passing (accumulators, state passing).
- **No `halt/0` in solution files**:
  - Do NOT include `halt/0` or `halt/1` inside predicate definitions or library files.
  - Halting is controlled solely via the `-t halt` CLI flag when invoking `swipl`.
- **No `:- initialization(...)` directive**:
  - Do NOT include initialization directives in source files. Goals should be invoked explicitly by test harnesses or command-line execution flags.
- **Allowed Libraries**:
  - Only the following standard SWI-Prolog libraries may be imported:
    ```prolog
    :- use_module(library(lists)).
    :- use_module(library(apply)).
    :- use_module(library(yall)).
    :- use_module(library(aggregate)).
    ```
  - Do NOT import other external or third-party libraries.

## 5. Self-Review Checklist
Before finalizing any Prolog solution, verify:
- [ ] **Declarative Semantics**: Does each predicate read as a clear logical relation rather than an imperative procedure?
- [ ] **Base Case Placement**: Are base cases defined before recursive rules to ensure predictable, terminating recursion?
- [ ] **Recursion Termination**: Does every recursive step make strict progress toward a base case?
- [ ] **Instantiation Safety**: Are all arithmetic expressions fully instantiated before invoking `is/2`, `<`/2, `=:=`/2, etc.?
- [ ] **Atom Quoting**: Are atoms with uppercase characters, operators, or spaces properly enclosed in single quotes (e.g., `'AI'`, `'c++'`)?
- [ ] **Cut Prudence**: Are cuts (`!`) used strictly where determinism is required? Does removing the cut change declarative truth? Are choice points pruned intentionally without suppressing valid alternative solutions?
- [ ] **Determinism & Uniqueness**: Does the predicate avoid generating redundant or duplicate solutions upon backtracking?
- [ ] **Clean Compilation**: Does the file compile without warnings (especially singleton variables or discontiguous predicates)?

## 6. Known Failure Modes of AI Tools Writing Prolog
1. **Wrong Quoting of Atoms**:
   - *Problem*: Writing `AI` or `c++` without quotes.
   - *Consequence*: `AI` is parsed as a free variable rather than an atom! `c++` triggers syntax errors because `+` is an operator.
   - *Fix*: Always single-quote atoms starting with uppercase letters or containing symbols: `'AI'`, `'c++'`.
2. **Infinite Recursion / Non-Termination**:
   - *Problem*: Recursive calls placed before condition checks, missing base cases, or lack of structural reduction on list/term arguments.
   - *Fix*: Structure recursive clauses with strict structural degradation (e.g., `[Head|Tail]` operating on `Tail`) and position base cases first.
3. **Misused Cuts (`!`)**:
   - *Problem*: Placing cuts inappropriately, turning green cuts into unintended red cuts, or suppressing valid backtracking solutions in puzzle solvers and search spaces.
   - *Fix*: Rely on mutually exclusive clause patterns or guard conditions where possible; place cuts only when committing to a deterministic branch after all guard conditions succeed.
4. **Unbound Variables in Arithmetic**:
   - *Problem*: Evaluating `X is Y + 1` when `Y` is still uninstantiated. Prolog arithmetic is not constraint solving (`clpfd`); `is/2` requires the right-hand side to be fully ground.
   - *Fix*: Ensure variables in arithmetic expressions are bound by previous goals prior to evaluation, or compute values unidirectionally.
5. **Duplicate Solutions**:
   - *Problem*: Multiple clauses or permutations matching the same logical solution, causing query responses to repeat identical results when the user presses `;`.
   - *Fix*: Impose ordering constraints (e.g., symmetry breaking), use `setof/3` or `distinct/2` where appropriate, or ensure clause head patterns are mutually exclusive.
