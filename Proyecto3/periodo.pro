%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Programacion Logica - Tarea       %
%                                       %
%   Alessandro La Corte     09-10430    %
%   Donato Rolo             10-10640    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 4.- Fracciones Periodicas

periodo(_,0,[]):- !.
periodo(Dendo, Dvsor, Prdo):-
	X is Dendo/Dvsor,
	Y is truncate(X),
	Z is X - Y,
	calcPrdo(Z,Prdo).

decimalsToList(0.0,[]):- !.
decimalsToList(Z,[H|T]) :-
	X is Z*10,
	Y is truncate(X),
	Z1 is X-Y,

	decimalsToList(Z1,[H|T]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%