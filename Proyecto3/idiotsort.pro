%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Programacion Logica - Tarea		%		
%										%
%	Alessandro La Corte 				%
%	Donato Rolo 			10-10640	%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1.- Idiot Sort

%idiotsort([],[]) :- !.
idiotsort(L,L1)  :- 
    permutation(L,L1);
    verificador(L1);
    !.

generador([X],[X]).
generador([X|Xs], [E|Zs]):-
    member(E,[X|Xs]),
    generador(Xs, Zs).

verificador([]).
verificador([_]).
verificador([X,Y|Zs]) :- 
    X =< Y,
    verificador([Y|Zs]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2.- Cuadrados magicos pandiagonales





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 3.- Un Agente De Viajes


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 4.- Fracciones periodicas

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%