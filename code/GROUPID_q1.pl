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

% Clue 5: The friend whose favorite language is Java works in the design department.
clue(5, S) :-
    member(p(_, design, java, _), S).

% Clue 6: Carla's project preference is not embedded, and her department is not development.
clue(6, S) :-
    member(p('Carla', Dept, _, Project), S),
    \+ Dept = development,
    \+ Project = embedded.

% Clue 7: Dana's favorite language is not Java, and she works in research or testing.
clue(7, S) :-
    member(p('Dana', Dept, Lang, _), S),
    \+ Lang = java,
    (   Dept = research
    ;   Dept = testing
    ).

% Clue 8: The friend who prefers data projects works in research and does not use JavaScript.
clue(8, S) :-
    member(p(_, research, Lang, data), S),
    \+ Lang = javascript.
