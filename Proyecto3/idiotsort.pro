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
%   - permute/2 
%     permute(?L, ?L1).
%     Triunfa sí L1 es una permutación de elemento de L y viceversa. 
%   - verificador/1 
%     verificador(?L). 
%     Triunfa si L los elementos estan ordenados según su valor ascendente. 

idiotsort([X], [X]) :- !.
idiotsort(L, L1) :-
    var(L),
    permute1(L1, Z),
    member(L, Z).
idiotsort(L, L1) :-
    var(L1), 
    permute1(L, Z),
    member(L1, Z),
    verificador(L1).

permute([X], [X]) :- !.
permute(L, [E|L1]) :-
    member(E, L),
    select(E, L, Z),
    permute(Z, L1).
permute(L, L1) :-
    permute(L1, L).

permute1([X|Xs], L1):-
    findall(E, permutation([X|Xs], E), L1),
    !.
%permute1(L, [X|Xs]):-
%    findall(E, permutation([X|Xs], E), L),
%    !.

verificador([_]).
verificador([X,Y|Zs]) :- 
    X =< Y,
    verificador([Y|Zs]).
