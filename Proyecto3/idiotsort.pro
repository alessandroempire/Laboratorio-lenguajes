%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Programacion Logica - Tarea		%		
%										%
%	Alessandro La Corte 				%
%	Donato Rolo 			10-10640	%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1.- Idiot Sort

% Implementacion del idiotsort
%
% idiotsort/2
%
% idiotsort(?Lista, ?Ordenada).
%
% idiotsort(Lista, Ordenada) :-
%   triunfa si Ordenada tiene los mismo elementos de Lista pero
%   ordenados según su valor ascendente. 
%   Se usa un cut verde: existe una sola forma de ordenar ascendentemente
%   una lista. 
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
    permute(L1, L).
idiotsort(L, L1) :-
    var(L1), 
    permute(L, L1),
    verificador(L1),
    !.

permute([X|Xs], E):-
    findall(E, permutation([X|Xs], E), L1),
    member(E, L1).

verificador([_]).
verificador([X,Y|Zs]) :- 
    X =< Y,
    verificador([Y|Zs]).
