%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Programacion Logica - Tarea       %
%                                       %
%   Alessandro La Corte     09-10430    %
%   Donato Rolo             10-10640    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 4.- Fracciones Periodicas

:-dynamic([seen/2]).

%% periodo(_,0,_):- !,fail.
%% periodo(Dendo, Dvsor, Prdo):-
%% 	retractall(seen(_,_)),
%% 	X is Dendo mod Dvsor,
%% 	assert(seen(X,0)),
%% 	Digits = [],
%% 	getDecimals(X,Dvsor,Digits,L,A),
%% 	( A=0 

%% 	-> append(L,[0],Prdo1)
%% 	-> seen(A,X1)
%% 	-> reduceList(X1,Prdo1,Prdo)

%% 	;		)




getDecimals(Dendo,Dvsor,Digits,L,Y) :-
    Remain is Dendo * 10,
    Aux is Remain//Dvsor,
    append(Digits,[Aux],NewDigits),
    NewRemain is Remain mod Dvsor,
    ( seen(NewRemain,_)
        %% if seen
    -> L = Digits
    -> Y = NewRemain
        %% if not seen
    ; length(NewDigits,Posi),
      asserta( seen(NewRemain,Posi) ),
      getDecimals(NewRemain,Dvsor,NewDigits,L,Y)
    ).



decimalsToList(_,[],0):- !.
decimalsToList(Z,[H|T],N) :-
	N > 0,
	N1 is N -1,
	X is Z*10,
	H is truncate(X),
	Z1 is X-H,

	decimalsToList(Z1,T,N1).


reduceList(1,X,X):- !.
reduceList(N,[_|T],X):- 
	N > 1,
	N1 is N -1,
	reduceList(N1,T,X).

numOfTimes(_,[],0). 
numOfTimes(X,[X|R],Num):- 
	numOfTimes(X,R,Num1), 
	Num is Num1+1,!. 
numOfTimes(X,[_|R],Num):- 
	numOfTimes(X,R,Num).

pos(X,[X|_],1). 
pos(_,[],_):- !,fail. 
pos(X,[_|R],Pos):- 
	pos(X,R,Pos1), 
	Pos is Pos1+1.

