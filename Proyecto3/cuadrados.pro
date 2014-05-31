%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Programacion Logica - Tarea       %
%                                       %
%   Alessandro La Corte     09-10430    %
%   Donato Rolo             10-10640    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2.- Cuadrados Magicos Pandiagonales

diabolico(Evil) :-
	var(Evil),
	generate(16,Evil).

diabolico(Evil) :-
	checkValues(Evil),
	checkRows(Evil),
	checkColumns(Evil),
	checkGreaterDiagonalR(Evil),
	checkGreaterDiagonalL(Evil).


check(A,B,C,D) :-
	34 is A + B + C + D.

checkValues([]).
checkValues([X|Xs]) :-
	X >= 1, X =< 16,
	checkValues(Xs).


checkColumns([A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16]):- 
	34 is A1 + A5 + A9 + A13,
	34 is A2 + A6 + A10 + A14,
	34 is A3 + A7 + A11 + A15,
	34 is A4 + A8 + A12 + A16.

checkRows([]).
checkRows([X1,X2,X3,X4|Xs]) :-
	34 is X1 + X2 + X3 + X4,
	checkRows(Xs).


checkGreaterDiagonalR([A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16]):-
	34 is A1 + A6 + A11 + A16,
	34 is A5 + A10 + A15 + A4,
	34 is A9 + A14 + A3 + A8,
	34 is A13 + A2 + A7 + A12.
	
checkGreaterDiagonalL([A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16]):-
	34 is A4 + A7 + A10 + A13,
	34 is A8 + A11 + A14 + A1,
	34 is A12 + A15 + A2 + A5,
	34 is A16 + A3 + A6 + A9.

generate(0,[]).
generate(N,[A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16]):-
	N > 0,
	genNumeros(16,NN),
	reverse(NN,G),
	
	select(A1,G,G1),
	select(A2,G1,G2),
	select(A3,G2,G3),
	select(A4,G3,G4),
	
	check(A1,A2,A3,A4), % Fila 1
	
	select(A5,G4,G5),
	select(A6,G5,G6),
	select(A7,G6,G7),
	select(A8,G7,G8),
	check(A5,A6,A7,A8), % Fila 2
	
	select(A9,G8,G9),
	A1 + A5 + A9 < 34,	% Pre-chequeo Columna 1
	A3 + A8 + A9 < 34,	% Pre-chequeo DiagonalR 3
	A3 + A6 + A9 < 34,	% Pre-chequeo DiagonalL 4
	select(A10,G9,G10),
	A2 + A6 + A10 < 34,	% Pre-chequeo Columna 2
	A5 + A4 + A10 < 34,	% Pre-chequeo DiagonalR 2
	A4 + A7 + A10 < 34,	% Pre-chequeo DiagonalL 1
	select(A11,G10,G11),
	A3 + A7 + A11 < 34, % Pre-chequeo Columna 3
	A1 + A6 + A11 < 34,	% Pre-chequeo DiagonalR 1
	A1 + A8 + A11 < 34, % Pre-chequeo DiagonalL 2
	select(A12,G11,G12),
	A4 + A8 + A12 < 34,	% Pre-chequeo Columna 4
	A2 + A7 + A12 < 34,	% Pre-chequeo DiagonalR 4
	A2 + A5 + A12 < 34, % Pre-chequeo DiagonalL 3
	check(A9,A10,A11,A12), % Fila 3
	
	select(A13,G12,G13),
	
	check(A1,A5,A9,A13),	% Columna 1
	check(A2,A7,A12,A13),	% DiagonalR 4
	check(A4,A7,A10,A13),	% DiagonalL 1	
	
	select(A14,G13,G14),
	
	check(A2,A6,A10,A14),	% Columna 2
	check(A3,A8,A9,A14),	% DiagonalR 3
	check(A1,A8,A11,A14),	% DiagonalL 2
	
	select(A15,G14,G15),
	
	check(A3,A7,A11,A15),	% Columna 3
	check(A4,A5,A10,A15),	% DiagonalR 2
	check(A2,A5,A12,A15),	% DiagonalL 3
	
	select(A16,G15,_),
	
	check(A4,A8,A12,A16),	% Columna 4
	check(A1,A6,A11,A16),	% DiagonalR 1
	check(A3,A6,A9,A16),
	check(A13,A14,A15,A16). % Fila 4

genNumeros(0,H) :- H = [].
genNumeros(N,[H|T]) :-
	N > 0,
	H is N,
	NN is N - 1,
	genNumeros(NN,T).



stopwatch(Predicate) :-
        real_time(Start),
        call(Predicate),
        real_time(Finish),
        Elapsed is (Finish - Start) / 1000,
        format('~4f seg~N',[Elapsed]), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%