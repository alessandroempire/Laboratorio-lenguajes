/*
 * dfs - Infraestructura para resolver problemas por búsqueda DFS
 *
 * dfs(Estado,Historia,Movimientos)
 *
 *   -> Estado es una estado posible del problema.
 *   -> Historia son los movimientos previamente efectuados.
 *   <- Movimientos son los movimientos que resuelven el problema.
 *
 * Para su funcionamiento es necesario:
 *
 *   - Crear una definición propia para el estado del problema.
 *   - final/2 debe triunfar para los posibles estados finales.
 *   - movimiento/3 debe generar (via backtracking) los movimientos
 *     posibles a partir de un estado particular.
 *   - moverse/4 debe efectuar el cambio de estado según un
 *     movimiento particular, generando el nuevo estado.
 *   - legal/2 determina si un estado es legal o no.
 */

:- discontiguous([inicial/2,final/2,movimiento/3,moverse/4,legal/2]).

dfs(Problema,Estado,_,[]) :- 
	final(Problema,Estado).
dfs(Problema,Estado,Historia,[Movimiento|Movimientos]) :-
	movimiento(Problema,Estado,Movimiento),
	moverse(Problema,Estado,Movimiento,Proximo),
	legal(Problema,Proximo),
	\+ member(Proximo,Historia),
	dfs(Problema,Proximo,[Proximo|Historia],Movimientos).

resolver(Problema,Movimientos) :-
    inicial(Problema,Estado), dfs(Problema,Estado,[Estado],Movimientos).

simular(Problema) :-
    inicial(Problema,Estado),
    dfs(Problema,Estado,[Estado],Movimientos), !,
    mostrar(Problema,Estado,Movimientos).
 
/*
 * Problema del lobo, la chivo y el repollo.
 *
 * Representaremos el Estado del problema como
 *
 *    lcr(Bote,OrillaIzquierda,OrillaDerecha)
 *
 * donde Bote indica la posición como izquierda o derecha, mientras que
 * OrillaIzquierda y OrillaDerecha son listas con atomes (lobo, chivo
 * y repollo) que indican la carga que * hay en cada orilla. Ambas
 * listas se mantendrán ordenadas según lobo < chivo < repollo.
 *
 */
inicial(lcr,lcr(izquierda,[lobo,chivo,repollo],[])).

final(lcr,lcr(derecha,[],[lobo,chivo,repollo])).

movimiento(lcr,lcr(izquierda,I,_),Carga) :- member(Carga,I).
movimiento(lcr,lcr(derecha,_,D),Carga)   :- member(Carga,D).
movimiento(lcr,lcr(_,_,_),solo).

moverse(lcr,lcr(B,I,D),Carga,lcr(B1,I1,D1)) :-
   cambios_en_bote(B,B1),
   cambios_en_orillas(Carga,B,I,D,I1,D1).

cambios_en_bote(izquierda,derecha).        
cambios_en_bote(derecha,izquierda).
        
cambios_en_orillas(solo,_,I,D,I,D).
cambios_en_orillas(Carga,izquierda,I,D,I1,D1) :- 
    select(Carga,I,I1), insert(Carga,D,D1).
cambios_en_orillas(Carga,derecha,I,D,I1,D1) :- 
    select(Carga,D,D1), insert(Carga,I,I1).

insert(X,[Y|Ys],[X,Y|Ys]) :-
    precede(X,Y).
insert(X,[Y|Ys],[Y|Zs]) :-
    precede(Y,X), insert(X,Ys,Zs).
insert(X,[],[X]).

precede(lobo,_).
precede(_,repollo).

legal(lcr,lcr(izquierda,_,D)) :- \+ peligrosa(D).
legal(lcr,lcr(derecha,I,_))   :- \+ peligrosa(I).

peligrosa(Orilla) :- member(lobo,Orilla), member(chivo,Orilla).
peligrosa(Orilla) :- member(chivo,Orilla), member(repollo,Orilla).

mostrar(lcr,_,[])     :- !.
mostrar(lcr,E,[M|Ms]) :-
  mostrar_estado(lcr,E),
  moverse(lcr,E,M,N),
  mostrar_movimiento(lcr,E,M), nl,
  mostrar(lcr,N,Ms), !.

mostrar_estado(lcr,lcr(_,I,D)) :-
  write('Orilla Izquierda: '), write(I), nl,
  write('Orilla Derecha:   '), write(D), nl. 

mostrar_movimiento(lcr,lcr(B,_,_),solo) :- 
  name(solo,Str),
  mostrar_bote(B,Str).
mostrar_movimiento(lcr,lcr(B,_,_),Carga) :-
  name(Carga,Str),
  append("llevando el ",Str,Msg),
  mostrar_bote(B,Msg).

mostrar_bote(Desde,Con) :-
  opuesto(Desde,Hacia),
  format("Viajar de ~a a ~a ~s.",[Desde,Hacia,Con]), nl.

opuesto(izquierda,derecha).
opuesto(derecha,izquierda).

/*
 * Problema del paseo del caballo en un tablero de ajedrez de
 * dimensiones arbitrarias.
 *
 * Representaremos el Estado del problema como
 *
 *    knight(F,C,MaxF,MaxC)
 *
 * donde F y C indican la fila y columna actual del caballo en el
 * tablero, mientras que MaxF y MaxC indican las dimensiones máximas
 * del tablero.
 *
 * Los movimientos posibles de un caballo están definidos por la lista
 * de cambios de coordenadas (en el sentido de las agujas del reloj)
 *
 * [ [2,1], [1,2], [-1,2], [-2,1], [-2,-1], [-1,-2], [1,-2], [-1,2] ]
 */

inicial(knight,knight(1,1,5,10)).
final(knight,knight(5,7,5,10)).

movimiento(knight,_,Move) :-
  member(Move, [[2,1],[1,2],[-1,2],[-2,1],[-2,-1],[-1,-2],[1,-2],[-1,2]]).
  
moverse(knight,knight(F,C,MaxF,MaxC),[DF,DC],knight(NF,NC,MaxF,MaxC)) :-
  NF is F + DF,
  NC is C + DC.

legal(knight,knight(F,C,MaxF,MaxC)) :-
  F >= 1, F =< MaxF,
  C >= 1, C =< MaxC.
