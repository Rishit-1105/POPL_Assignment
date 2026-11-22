% Run from the repository root:
% swipl -q -f tests/75_q2_tests.pl -g run_q2_tests -t halt
% Loading this file does not run tests or print anything.
:- ensure_loaded('../code/75_q2.pl').

q2_expected_examples([
    "4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
    "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"
]).

q2_test(pdf_generate,
        (generate_equation([4,2,5,3], E),
         string(E), q2_expected_examples(Expected), memberchk(E, Expected))).
q2_test(pdf_all_seven,
        (q2_expected_examples(Expected),
         all_equations([4,2,5,3], Es), Es == Expected)).
q2_test(pdf_count_seven, count_equations([4,2,5,3], 7)).
q2_test(pdf_no_equation_generate, \+ generate_equation([2,3,4], _)).
q2_test(pdf_no_equation_all,
        (all_equations([2,3,4], Es), Es == [])).
q2_test(pdf_multiplication,
        (all_equations([2,4,8], Es), Es == ["2*4=8"])).

q2_test(empty_generate, \+ generate_equation([], _)).
q2_test(empty_all, (all_equations([], Es), Es == [])).
q2_test(empty_count, count_equations([], 0)).
q2_test(singleton_generate, \+ generate_equation([5], _)).
q2_test(singleton_all, (all_equations([5], Es), Es == [])).
q2_test(singleton_count, count_equations([5], 0)).

q2_test(zero_pair_generate,
        (generate_equation([0,0], E), E == "0=0")).
q2_test(zero_pair_all,
        (all_equations([0,0], Es), Es == ["0=0"])).
q2_test(zero_pair_count, count_equations([0,0], 1)).
% Exhaust the generator so an exception on a later division also fails.
q2_test(zero_divisor_generate,
        (findall(E, generate_equation([5,0,0], E), Es),
         Es == ["5*0=0"])).
q2_test(zero_divisor_all,
        (all_equations([5,0,0], Es), Es == ["5*0=0"])).
q2_test(zero_divisor_count, count_equations([5,0,0], 1)).

% Run every case, report exceptions/nontermination as FAIL, and fail overall
% if any case fails. The inference limit bounds each of these small cases.
run_q2_tests :-
    findall(Name-Goal, q2_test(Name, Goal), Tests),
    q2_run_cases(Tests, Failures),
    Failures =:= 0.

q2_run_cases([], 0).
q2_run_cases([Name-Goal|Rest], Failures) :-
    (   catch((call_with_inference_limit(once(Goal), 1000000, Result),
               Result \== inference_limit_exceeded), _, fail)
    ->  format('PASS ~w~n', [Name]),
        Failed = 0
    ;   format('FAIL ~w~n', [Name]),
        Failed = 1
    ),
    q2_run_cases(Rest, RestFailures),
    Failures is Failed + RestFailures.
