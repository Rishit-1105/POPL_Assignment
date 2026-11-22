:- use_module(library(lists)).
:- use_module(library(apply)).

% Load solution file relative to either repository root or tests/ directory.
:- (   exists_file('../code/GROUPID_q1.pl')
   ->  consult('../code/GROUPID_q1.pl')
   ;   exists_file('code/GROUPID_q1.pl')
   ->  consult('code/GROUPID_q1.pl')
   ;   true
   ).

%!  test_empty_clues is semidet.
%
%   Checks that count_solutions([], N) produces exactly 13824 candidates.
test_empty_clues :-
    count_solutions([], 13824).

%!  test_active_clues is semidet.
%
%   Checks that count_solutions([1,2,3,4,5,6,7,8], N) executes successfully
%   and yields a valid integer count.
test_active_clues :-
    count_solutions([1,2,3,4,5,6,7,8], N),
    integer(N),
    N > 0.

%!  test_main_output is semidet.
%
%   Checks that main/0 executes and prints exactly four formatted lines.
test_main_output :-
    with_output_to(string(Output), main),
    split_string(Output, "\n", "\r", RawLines),
    exclude(=(""), RawLines, Lines),
    length(Lines, 4).

%!  report(+TestName:atom, :Goal) is det.
%
%   Executes Goal and prints PASS or FAIL for TestName without halting.
report(TestName, Goal) :-
    (   catch(Goal, _, fail)
    ->  format('[PASS] ~w~n', [TestName])
    ;   format('[FAIL] ~w~n', [TestName])
    ).

%!  run_tests is det.
%
%   Runs all unit tests for Problem 1 and outputs pass/fail status per test.
run_tests :-
    report('count_solutions([], 13824)', test_empty_clues),
    report('count_solutions([1,2,3,4,5,6,7,8], N) runs', test_active_clues),
    report('main/0 prints four lines', test_main_output).
