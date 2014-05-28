% m(?X,?L)
% * m/2 triunfa si X es elemento de la lista L.
% * El predicado puede usarse con backtracking para encontrar todos
%   los resultados posibles -- también puede usarse para enumerar
%   los elementos de la lista.
% * Este es un predicado estándar en Prolog con el nombre member/2.

m(E,[E|_]).
m(E,[_|R]) :- m(E,R).

% a(?L1,?L2,?L12)
% * a/3 triunfa si L1 concatenado con L2 unifica con L12.
% * Si L1 o inclusive L2 no están instanciados, el predicado puede
%   usarse con backtracking para encontrar todas las maneras de
%   construir la lista L12.
% * Este es un predicado estándar en Prolog con el nombre append/3.

a([],L,L).
a([X|R1],L,[X|L1]) :- a(R1,L,L1).

% Problema: ¿Cómo escribir m/2 usando a/3?
% Ejercicio: 
% l(?E,?L)
% * last/2 triunfa si E es el último elemento de L.
% * El predicado puede usarse con backtracking.
% * Este es un predicado estándar en Prolog con el nombre last/2.

% d(?L1,?E,?L2).
% * d/3 triunfa si L2 unifica con L1 después de eliminar todas las
%   ocurrencias de E.
% * El predicado puede usarse con backtracking para encontrar las
%   lista con eliminación parcial de instancias de E, para encontrar
%   la lista original o el elemento eliminado entre dos listas.
% * Este es un predicado estándar de Prolog con el nombre delete/3.

d(_,[],[]).
d(E,[E|R],S)     :- d(E,R,S).
d(E,[F|R],[F|S]) :- d(E,R,S).

% Ejercicio:
% insert(X,L1,L2).
% * insert/3 triunfa si puede insertarse X en cualquier posición
%   de L1 para obtener L2.
% * Este no es un predicado estándar de Prolog.

% s(?L1,?L2)
% * s/2 triunfa si L1 es sublista de L2.
% * El predicado puede usarse con backtracking.
% * Este es un predicado estándar en Prolog con el nombre sublist/2.

s(S,L) :-
        a(L1,L2,L),
        a(S,L3,L2).

% la(?L,?N)
% * la/2 triunfa si L tiene N elementos.
% * El predicado puede usarse con backtracking.
% * Este es un predicado estándar en Prolog con el nombre length/2.

la([],0).
la([_|R],N1) :- la(R,N), N1 is N+1.

% Ejercicio:
% r(?L,?R)
% * r/2 triunfa si R es la lista L con los elementos en orden inverso.
% * El predicado puede usarse con backtracking.
% * Este es un predicado estándar en Prolog con el nombre reverse/2.
%
% flatten(+List,?FlatList)
% * flatten/2 triunfa con List instanciada a una lista con listas
%   anidadas arbitrariamente, y FlatList instanciada tomando todos
%   los elementos de las sublistas para constituir una sola lista,
%   e.g. flatten([a,b,[c,d],[],[[[e]]],f],L) triunfa unificando
%   L = [a,b,c,d,e,f]
