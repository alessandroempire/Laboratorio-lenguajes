% Implementacion del idiotsort
%
% idiotsort/2
%
% idiotsort(?Lista, ?Ordenada).
%
% idiotsort(Lista, Ordenada) :-
%   triunfa si Ordenada tiene los mismo elementos de Lista pero
%   ordenados según su valor ascendente 
%
% Para su funcionamineto es necesario
%   - verificador/1
%

idiotsort([], []) :- !.
idiotsort([X], [X]) :- !.
idiotsort(L, L1) :- 
    permute(L, L1),
    verificador(L1).

permute([X], [X]) :- !.
permute(L, [E|L1]) :-
    var(L1),
    member(E, L),
    select(E, L, Z),
    permute(Z, L1).
permute(L, L1) :-
    var(L),
    permute(L1, L).

permute1([X|Xs], L1):-
    var(L1),
    findall(E, permutation([X|Xs], E), L1),
    !.
permute1(L, [X|Xs]):-
    var(L),
    findall(E, permutation([X|Xs], E), L),
    !.

verificador([_]).
verificador([X,Y|Zs]) :- 
    X =< Y,
    verificador([Y|Zs]).
