---
name: prolog-dev
description: SWI-Prolog 9.x development guidelines, coding conventions, constraints, testing instructions, self-review checklists, and common AI failure modes for POPL assignments.
---

# Prolog Development Guidelines (SWI-Prolog 9.x)

Use SWI-Prolog 9.x. Read the relevant problem specification and existing code before editing. Implement only the requested predicate, test file, or review; preserve unrelated definitions and keep each requested unit in its own commit.

## 1. Language and Version
- **Target Platform**: SWI-Prolog 9.x (ISO-compliant core with SWI extensions).
- **Paradigm**: Pure logic programming, relational thinking, constraint satisfaction, and declarative problem solving.

## 2. Coding Conventions and Declarative Reading
- **Naming Conventions**:
  - **Predicates**: Use `snake_case` (e.g., `solve_puzzle/2`, `find_path/3`, `expr_over/3`).
  - **Variables**: Start with an uppercase letter or an underscore (e.g., `Result`, `State`, `Tree`, `_Temp`). Use a single underscore `_` for anonymous/ignored variables.
  - **Atoms**: Lowercase identifiers (e.g., `red`, `monday`). Special atoms (containing uppercase letters, spaces, or symbols) must be explicitly single-quoted (e.g., `'AI'`, `'c++'`).
- **Formatting**: Indent clause bodies by four spaces. Keep clauses of one predicate together. Prefer pattern matching, explicit base cases, and recursion over mutable state.
- **Declarative Reading Comments**:
  - Above each predicate, document its argument modes (`+` input/instantiated, `-` output/uninstantiated, `?` either) and its relation: "This holds when ...".
  - Explain what makes the base case true and how recursive clauses relate smaller inputs to the result (e.g., `expr_over(List, Tree, Value)` holds when `Tree` uses `List`'s numbers once, in order, and evaluates to `Value`).
  - Example PlDoc comment:
    ```prolog
    %!  subset_sum(+Numbers:list(integer), +Target:integer, -Subset:list(integer)) is nondet.
    %   True if Subset is a sublist of Numbers whose elements sum to Target.
    ```
- **Operational Reading**:
  - Goals execute left-to-right and clauses are explored on backtracking. Establish operands before arithmetic; ensure each recursive call decreases a finite input. Preserve every required solution.
  - Distinguish relational operators clearly:
    - `=` for term unification.
    - `is` for arithmetic evaluation.
    - `=:=` for numeric value equality.
    - `==` for strict term identity.
    Do not interchange them.
  - Use cuts (`!`) or if-then-else (`-> ;`) only when their pruning effect on required solutions is fully understood. Do not cut an enumeration merely to make its first answer work.
- **Singleton Variables**: Code must compile cleanly without singleton variable warnings. Always name unused variables with a leading underscore or use `_`.

## 3. Assignment Rules and Strict Constraints
- **Solution files contain definitions only**:
  - Do NOT call `halt/0` or `halt/1` inside predicate definitions or library files. Halting is controlled solely via the `-t halt` CLI flag.
  - Do NOT include `:- initialization(...)` directives in source files.
  - Loading a file must not print anything or run solutions/tests. Keep predicates silent unless explicit output is required.
- **No dynamic state modifications**:
  - Strictly avoid `assert/1`, `asserta/1`, `assertz/1`, `retract/1`, and `retractall/1`.
  - No global variables or mutating state (`b_setval/2`, `nb_setval/2`, etc.). Pass all state explicitly through arguments.
- **Allowed Libraries Only**:
  - Only use the following standard libraries via `:- use_module(library(...)).`:
    - `lists`: Standard list manipulation (`member/2`, `append/3`, `select/3`, `permutation/2`, etc.).
    - `apply`: Higher-order operations (`maplist/2..N`, `include/3`, `exclude/3`, `foldl/4..N`).
    - `yall`: Lambda syntax for closures (e.g., `[X, Y]>>(Y is X + 1)`).
    - `aggregate`: Aggregations (`aggregate/3`, `aggregate_all/3`).
  - Do NOT import any other external or third-party libraries.
- **Arithmetic and Equation Rules (Problem 2)**:
  - Return SWI-Prolog strings (`"..."`), not atoms or code lists. Keep numbers in input order and follow canonical parenthesis rules. Do not render a string and parse it back into a term to evaluate it.
  - Guard division before evaluating it: require integer operands, a non-zero divisor, and a zero remainder (`B =\= 0, 0 is A mod B`), then compute integer quotient `A // B`. Invalid division must fail cleanly without error, including inside subtrees; negative intermediate values are valid. Reuse `apply_op/4` when evaluating expression trees.

## 4. Running and Testing
- Run goals explicitly from the repository root:
  ```bash
  swipl -q -f FILE -g "GOAL" -t halt
  ```
- **Usage Examples**:
  - Run specific queries:
    ```bash
    swipl -q -f code/75_q1.pl -g "main" -t halt
    swipl -q -f code/75_q2.pl -g "all_equations([4,2,5,3], Es)" -t halt
    ```
  - Run unit test suites:
    ```bash
    swipl -q -f tests/q1_tests.pl -g "run_tests" -t halt
    swipl -q -f tests/75_q2_tests.pl -g "run_q2_tests" -t halt
    ```
  - Test and handle exit codes:
    ```bash
    swipl -q -f code/75_q1.pl -g "test_all, halt(0)" -t "halt(1)"
    ```
- **Testing Practices**:
  - Command-line `-t halt` is permitted; do not put halt calls in source files.
  - Keep tests in their designated test file, loading solutions by a relative path.
  - Cover empty and singleton lists, repeated values, zero divisors, non-exact division, and boundary cases.
  - Report the runtime/version used and any checks that could not be run; never report unexecuted checks as passing.

## 5. Self-Review Checklist
Before finalizing any Prolog solution or response, verify:
- [ ] **Scope Integrity**: Did I change only the requested unit and preserve existing definitions?
- [ ] **Declarative Semantics**: Does each predicate read as a clear logical relation with documented argument modes (`+`, `-`, `?`)?
- [ ] **Base Case & Well-Founded Termination**: Are base cases defined before recursive rules? Does each recursive step strictly reduce towards the base case?
- [ ] **Instantiation Safety**: Are all arithmetic expressions ground before evaluating `is`, `<`, `>`, `=:=`, etc.?
- [ ] **Exact Division Guards**: Is division checked for zero and exactness (`0 is A mod B`) before computing the quotient?
- [ ] **Atom & String Types**: Are non-standard atoms properly quoted (e.g., `'AI'`, `'c++'`)? Are required strings SWI-Prolog strings (`"..."`)?
- [ ] **Cut Prudence**: Are cuts (`!`) used strictly where determinism is required without suppressing valid alternative solutions on backtracking?
- [ ] **No Unwanted Duplicates**: Does backtracking yield all valid solutions without unintended duplicates?
- [ ] **Prohibited Constructs Check**: Zero calls to `assert`, `retract`, global variables, `halt`, `initialization`, or top-level print/queries on load?
- [ ] **Library Whitelist**: Are imports strictly limited to `library(lists)`, `library(apply)`, `library(yall)`, and `library(aggregate)`?
- [ ] **Clean Compilation**: Does the file compile without warnings (especially singleton variables or discontiguous predicates)?

## 6. Known Failure Modes of AI Tools Writing Prolog
1. **Wrong Quoting of Atoms**:
   - *Problem*: Writing `AI` or `c++` without quotes.
   - *Consequence*: `AI` is parsed as a free variable; `c++` triggers syntax errors because `+` is an operator.
   - *Fix*: Always single-quote atoms starting with uppercase letters or containing symbols: `'AI'`, `'c++'`.
2. **Incorrect Output Types (Atoms/Code Lists vs Strings)**:
   - *Problem*: Returning an atom (`'4*2=5+3'`) or code list instead of an SWI-Prolog string (`"4*2=5+3"`).
   - *Fix*: Use `number_string/2` or `format(string(S), ...)`.
3. **Infinite Recursion & Ordering of Clauses**:
   - *Problem*: Recursive calls placed before condition checks, missing base cases, or lack of structural reduction on list arguments.
   - *Fix*: Structure recursive clauses with strict structural degradation and position base cases first.
4. **Misused Cuts (`!`) and Premature Pruning**:
   - *Problem*: Placing cuts inappropriately, turning green cuts into red cuts, or suppressing valid backtracking solutions in solvers and equations.
   - *Fix*: Use cuts only when committing to a deterministic branch after all guard conditions succeed.
5. **Unbound Variables in Arithmetic (`is/2`)**:
   - *Problem*: Evaluating arithmetic on uninstantiated variables raises `instantiation_error`.
   - *Fix*: Ensure all operands are bound and verified before evaluation.
6. **Improper Division Handling**:
   - *Problem*: Using `/` and float comparisons for exact integer division, checking zero too late, or accepting non-exact division in subtrees.
   - *Fix*: Guard with `B =\= 0, 0 is A mod B` and use integer division `A // B`.
7. **Duplicate Solutions from Overlapping Constraints**:
   - *Problem*: Multiple clauses or permutations matching the same logical solution, generating duplicate answers on backtracking.
   - *Fix*: Impose ordering constraints, symmetry breaking, or mutually exclusive clause heads.
8. **Negation as Failure (`\+`) Misconceptions**:
   - *Problem*: Using `\+ Goal` with free variables expecting it to bind them. Negation as failure only checks lack of provability.
   - *Fix*: Ensure variables in negated goals are properly grounded before applying `\+`.
