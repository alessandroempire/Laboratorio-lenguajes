%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Programacion Logica - Tarea       %
%                                       %
%   Alessandro La Corte     09-10430    %
%   Donato Rolo             10-10640    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2.- Cuadrados Magicos Pandiagonales

%% diabolico/1
%% diabolico(?Evil).
%% diabolico(Evil):- 
%%  Triunfa si Evil es un cuadrado magico pandiagonal.
%%  Si Evil es una variable no unificada, regresa todos los posibles cuadrados,
%%  magicos pandiagonales.

diabolico(Evil) :-
    var(Evil),
    generate(Evil).
diabolico(Evil) :-
    checkValues(Evil),
    checkRows(Evil),
    checkColumns(Evil),
    checkGreaterDiagonalR(Evil),
    checkGreaterDiagonalL(Evil).


%% - check/4
%%   check(+A,+B,+C,+D)/2
%%   Triunfa si la suma de los cuatro parametros es igual a 34.

check(A,B,C,D) :-
    34 is A + B + C + D.

%% - checkValues/1
%%   checkValues(Evil)/1
%%   Triunfa si todos los elementos de la matriz estan entre 1 y 16, y se 
%%   repiten solo una vez.

checkValues([]).
checkValues([X|Xs]) :-
    numOfTimes(X,[X|Xs],N),
    N = 1,
    X >= 1, X =< 16,
    checkValues(Xs).

%% - numOfTimes/3
%%   numOfTimes(+A,+B,?C)/3
%%   Triunfa si el elemento 'A' se repite en la lista 'B', 'C' veces. Si solo se
%%   le dan los valores A y B, te devuelve el numero de veces que A aparece en 
%%   la lista.

numOfTimes(_,[],0). 
numOfTimes(X,[X|R],Num):- 
    numOfTimes(X,R,Num1), 
    Num is Num1+1,!. 
numOfTimes(X,[_|R],Num):- 
    numOfTimes(X,R,Num).

%%   checkColumns/1
%%   checkColumns(+Evil)/1
%%   Triunfa si la suma de cada una de las columnas de la matriz son iguales a 
%%   34.

checkColumns([A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16]):- 
    34 is A1 + A5 + A9 + A13,
    34 is A2 + A6 + A10 + A14,
    34 is A3 + A7 + A11 + A15,
    34 is A4 + A8 + A12 + A16.

%% - checkRows/1
%%   checkRows(+Evil)/1
%%   Triunfa si la suma de cada una de las columnas de la matriz son iguales a 
%%   34.

checkRows([]).
checkRows([X1,X2,X3,X4|Xs]) :-
    34 is X1 + X2 + X3 + X4,
    checkRows(Xs).

%%   checkGreaterDiagonalR/1
%%   checkGreaterDiagonalR(+Evil)/1
%%   Triunfa si la suma de cada una de las diagonales que van de izquierda a 
%%   derecha, son iguales a 34.

checkGreaterDiagonalR([A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16]):-
    34 is A1 + A6 + A11 + A16,
    34 is A5 + A10 + A15 + A4,
    34 is A9 + A14 + A3 + A8,
    34 is A13 + A2 + A7 + A12.
    
%%   checkGreaterDiagonalL/1
%%   checkGreaterDiagonalL(+Evil)/1
%%   Triunfa si la suma de cada una de las diagonales que van de derecha a
%%   izquierda, son iguales a 34.

checkGreaterDiagonalL([A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16]):-
    34 is A4 + A7 + A10 + A13,
    34 is A8 + A11 + A14 + A1,
    34 is A12 + A15 + A2 + A5,
    34 is A16 + A3 + A6 + A9.



%% - generate/1
%%   generate(?Evil)/1
%%   Este predicado devuelve todos los cuadrados magicos pandiagonales 
%%   posibles. Es importante destacar, que para mejorar su eficiencia, la 
%%   verificacion de la matriz se va haciendo a medida que la matriz se va 
%%   generando, de tal forma de descartar lo mas rapido posible, aquellas 
%%   matrices que no cumplen las condiciones de un cuadrado pandiagonal.

generate([A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15,A16]):-
    
    Digits = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],
    
    select(A1,Digits,G1),
    select(A2,G1,G2),
    select(A3,G2,G3),
    select(A4,G3,G4),
    
    % Fila 1
    check(A1,A2,A3,A4),
    
    select(A5,G4,G5),
    select(A6,G5,G6),
    select(A7,G6,G7),
    select(A8,G7,G8),

    % Fila 2
    check(A5,A6,A7,A8),
    
    select(A9,G8,G9),

    % Pre-chequeo Columna 1
    A1 + A5 + A9 < 34, 
    % Pre-chequeo DiagonalR 3
    A3 + A8 + A9 < 34,
    % Pre-chequeo DiagonalL 4
    A3 + A6 + A9 < 34,
    
    select(A10,G9,G10),
    
    % Pre-chequeo Columna 2
    A2 + A6 + A10 < 34,
    % Pre-chequeo DiagonalR 2
    A5 + A4 + A10 < 34,
    % Pre-chequeo DiagonalL 1
    A4 + A7 + A10 < 34,
    
    select(A11,G10,G11),
    
    % Pre-chequeo Columna 3
    A3 + A7 + A11 < 34,
    % Pre-chequeo DiagonalR 1
    A1 + A6 + A11 < 34,
    % Pre-chequeo DiagonalL 2
    A1 + A8 + A11 < 34,
    
    select(A12,G11,G12),

    % Pre-chequeo Columna 4
    A4 + A8 + A12 < 34,
    % Pre-chequeo DiagonalR 4
    A2 + A7 + A12 < 34,
    % Pre-chequeo DiagonalL 3
    A2 + A5 + A12 < 34,
    
    % Fila 3
    check(A9,A10,A11,A12),
    
    select(A13,G12,G13),
    
    % Columna 1
    check(A1,A5,A9,A13), 
    % DiagonalR 4   
    check(A2,A7,A12,A13),
    % DiagonalL 1
    check(A4,A7,A10,A13),   
    
    select(A14,G13,G14),
    
    % Columna 2
    check(A2,A6,A10,A14),
    % DiagonalR 3
    check(A3,A8,A9,A14),
    % DiagonalL 2
    check(A1,A8,A11,A14),
    
    select(A15,G14,G15),
    
    % Columna 3
    check(A3,A7,A11,A15),
    % DiagonalR 2
    check(A4,A5,A10,A15),
    % DiagonalL 3
    check(A2,A5,A12,A15),
    
    select(A16,G15,_),
    
    % Columna 4
    check(A4,A8,A12,A16),
    % DiagonalR 1
    check(A1,A6,A11,A16),
    % DiagonalL 4
    check(A3,A6,A9,A16),
    % Fila 4 
    check(A13,A14,A15,A16).


