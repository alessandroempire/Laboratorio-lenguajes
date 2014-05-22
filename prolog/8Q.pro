% Problema de las 8 reinas 
% generar
% probar
% ?

%start([1/Y1,2/Y2,3/Y3,4/Y4,5/Y5,6/Y6,7/Y7,8/Y8]).

%queens([]).
%queens([X/Y | Otras]) :-
%        queens(Otras),
%        member(Y, [1,2,3,4,5,6,7,8]),
%        noattack(X/Y, Otras).

%noattack( _, []).
%noattack( X/Y, [X1/Y1 | Otras]) :-
%        Y =\= Y1,
%       Y1-Y =\= X1-X,
%       Y1-Y =\= X-X1,
%       noattack( X/Y, Otras).

ocho([1/Y1,2/Y2,3/Y3,4/Y4,5/Y5,6/Y6,7/Y7,8/Y8]).

queens([]).
queens([X/Y|Otras]) :-
  queens(Otras),
  member(Y,[1,2,3,4,5,6,7,8]),
  noattack(X/Y,Otras).

noattack(_,[]).
noattack(X/Y, [X1/Y1 | Otras] ) :-
  Y =\= Y1,
  Y1-Y =\= X1-X,
  Y1-Y =\= X-X1,
  noattack( X/Y, Otras ).

