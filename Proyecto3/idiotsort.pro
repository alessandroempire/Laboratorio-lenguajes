% idiotsort(Lista, Ordenada) :-
%
%
%
%
%

% cut verde
idiotsort([],[]).
idiotsort(L,L1)  :- 
    generador(L,L1),
    verificador(L1).

generador([X],[X]).
generador([X|Xs], [E|Zs]):-
    member(E,[X|Xs]),
    generador(Xs, Zs).

verificador([]).
verificador([_]).
verificador([X,Y|Zs]) :- 
    X =< Y,
    verificador([Y|Zs]).

