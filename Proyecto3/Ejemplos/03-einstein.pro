%
% Cada casa es una lista
% [color,nacionalidad,carro,bebida,mascota]
%
% La solución es una lista de casas
% [casa1,casa2,casa3,casa4,casa5]
%

vecino(A,B,L) :- a_la_derecha(A,B,L).
vecino(A,B,L) :- a_la_derecha(B,A,L).

a_la_derecha(A,B,[A,B|_]).
a_la_derecha(A,B,[_|X]) :- a_la_derecha(A,B,X).

vecindad(Cuadra) :- Cuadra = [_,_,[_,_,_,leche,_],_,_],
                    Cuadra = [[_,noruego,_,_,_],_,_,_,_],
	            member( [verde,_,_,cafe,_],        Cuadra),
		    member( [rojo,ingles,_,_,_],       Cuadra),
		    member( [_,ruso,_,te,_],           Cuadra),
		    member( [amarilla,_,maserati,_,_], Cuadra),
		    member( [_,_,honda,jugo,_],        Cuadra),
		    member( [_,japones,jaguar,_,_],    Cuadra),
		    member( [_,espanol,_,_,perro],     Cuadra),
		    member( [_,_,porsche,_,caracol],   Cuadra),
		    a_la_derecha( [marfil,_,_,_,_], [verde,_,_,_,_], Cuadra),
		    vecino( [_,noruego,_,_,_], [azul,_,_,_,_], Cuadra),
		    vecino( [_,_,maserati,_,_], [_,_,_,_,caballo], Cuadra),
		    vecino( [_,_,saab,_,_], [_,_,_,_,zorro], Cuadra),
		    true.
% ¿Quien es dueño de la cebra?

cebra :- vecindad(Cuadra),
   member([_,X,_,_,cebra],Cuadra),
   write('El '), write(X), write(' es el dueño de la cebra.'), nl.

% ¿Quien toma agua?

agua :- vecindad(Cuadra),
   member([_,X,_,agua,_],Cuadra),
   write('El '), write(X), write(' toma agua.'), nl.
