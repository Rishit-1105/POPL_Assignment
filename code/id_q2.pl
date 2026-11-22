% expr_string(+Tree, -String) renders a ground expression tree canonically.
expr_string(Number, String) :-
    number(Number),
    !,
    number_string(Number, String).
expr_string(op(O, A, B), String) :-
    Precedences = ['+'-1, '-'-1, '*'-2, '/'-2],
    memberchk(O-Precedence, Precedences),
    expr_string(A, AString),
    expr_string(B, BString),
    (   A = op(AOp, _, _),
        memberchk(AOp-APrecedence, Precedences),
        APrecedence < Precedence
    ->  format(string(Left), '(~s)', [AString])
    ;   Left = AString
    ),
    (   B = op(BOp, _, _),
        memberchk(BOp-BPrecedence, Precedences),
        BPrecedence =< Precedence
    ->  format(string(Right), '(~s)', [BString])
    ;   Right = BString
    ),
    format(string(String), '~s~a~s', [Left, O, Right]).
