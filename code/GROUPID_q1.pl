:- use_module(library(lists)).

%!  candidate(-Solution:list) is nondet.
%
%   Generates candidate assignments of departments, favorite languages,
%   and project preferences to the four friends ('Alex', 'Ben', 'Carla', 'Dana').
%   Each attribute value is used exactly once across the four friends.
%   Solution is unified with a list of terms p(Name, Department, Language, Project).
candidate([p('Alex', D1, L1, P1),
           p('Ben', D2, L2, P2),
           p('Carla', D3, L3, P3),
           p('Dana', D4, L4, P4)]) :-
    permutation([research, development, design, testing], [D1, D2, D3, D4]),
    permutation([python, java, 'c++', javascript], [L1, L2, L3, L4]),
    permutation(['AI', web, embedded, data], [P1, P2, P3, P4]).

%!  clue(+ClueNumber:integer, +Solution:list) is semidet.
%
%   True if Solution satisfies the clue identified by ClueNumber.

% Clue 1: The friend who prefers the AI project does not work in research and is not Dana.
clue(1, S) :-
    member(p(Name, Dept, _, 'AI'), S),
    \+ Dept = research,
    \+ Name = 'Dana'.

% Clue 2: Alex does not work in development and does not prefer C++.
clue(2, S) :-
    member(p('Alex', Dept, Lang, _), S),
    \+ Dept = development,
    \+ Lang = 'c++'.

% Clue 3: The friend working in the testing department likes Python.
clue(3, S) :-
    member(p(_, testing, python, _), S).

% Clue 4: Ben prefers web projects and does not work in testing.
clue(4, S) :-
    member(p('Ben', Dept, _, web), S),
    \+ Dept = testing.
