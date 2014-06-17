%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Programacion Logica - Tarea       %
%                                       %
%   Alessandro La Corte     09-10430    %
%   Donato Rolo             10-10640    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 4.- Fracciones Periodicas

:-dynamic([seen/2]).


%%   periodo/3
%%   periodo(+Dendo,+Dvsor,?Prdo):-
%%   Triunfa si Prdo es la lista con los numeros que forman el periodo decimal 
%%   al dividir Dendo entre Dvsor. En caso de que Prdo, no tenga ningun valor 
%%   unificado, devuelve una lista con el periodo.

periodo(_,0,_):- !,fail.
periodo(Dendo,Dvsor,Prdo):-
    \+ var(Prdo),
    periodo(Dendo,Dvsor,X),
    X == Prdo,
    !.
periodo(Dendo, Dvsor, Prdo):-
    var(Prdo),
    !,
    retractall(seen(_,_)),
    X is Dendo mod Dvsor,
    Digits = [],
    getDecimals(X,Dvsor,Digits,L,R,P),
    ( R=0 

    -> Prdo = [0]
    
    ; write(P),reduceList(P,L,Prdo)).

%%  getDecimals/6
%%  getDecimals(+Dendo,+Dvsor,+Digits,?L,?R,?P)
%%  Este predicado devuelve los decimales que se obtienen al dividir Dendo entre
%%  Dvsor, en esta lista se encuentra el anteperiodo (si existe), seguido del 
%%  periodo repetido solo una vez.
getDecimals(Dendo,Dvsor,Digits,L,R,P) :-
    Remain is Dendo * 10,
    Aux is Remain//Dvsor,
    append(Digits,[Aux],NewDigits),
    NewRemain is Remain mod Dvsor,
    ( seen(NewRemain,_)
        %% if seen
    -> L = Digits
    -> R = NewRemain
    -> seen(NewRemain,P)
        %% if not seen
    ; length(NewDigits,Posi),
      asserta( seen(NewRemain,Posi) ),
      getDecimals(NewRemain,Dvsor,NewDigits,L,R,P)
    ).

%%  reduceList/3
%%  reduceList(+A,+B,?C)
%%  Este predicado, recibe una posicion en A y una lista en B, y retorna el 
%%  resto de la lista B a partir de la posicion A.
reduceList(1,X,X):- !.
reduceList(N,[_|T],X):- 
    N >= 0,
    N1 is N -1,
    reduceList(N1,T,X).