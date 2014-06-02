%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Programacion Logica - Tarea       %
%                                       %
%   Alessandro La Corte     09-10430    %
%   Donato Rolo             10-10640    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Agente.pro
% 
% Definimos el operador ":" infijo

:- op(300, xfx, :).

% horario/3

horario( new_york, chicago,
           [  9:40 / 10:50 / nw4733 / todos,
             13:40 / 14:50 / nw4773 / habiles,
             19:40 / 20:50 / nw4833 / [lun,mar,mie,jue,vie,dom] ] ). 
horario( chicago, new_york,
           [  9:10 / 10:00 / wn458 / todos,
             12:20 / 13:10 / wn511 / todos ] ). 

horario( chicago, dallas,
           [  9:40 / 10:50 / aa4732 / todos,
             11:40 / 12:50 / aa4752 / habiles,
             18:40 / 19:50 / aa4822 / [lun,mar,mie,jue,vie] ] ). 

horario( dallas, chicago,
           [  8:00 /  9:50 / zz8291 / todos,
             12:10 / 12:50 / zz9301 / habiles,
             18:40 / 19:50 / zz9278 / [lun,mar,mie,jue,vie] ] ). 

horario( dallas, los_angeles,
           [ 13:20 / 16:20 / nw212 / [lun,mar,mie,vie,dom],
             16:30 / 19:30 / aa473 / [lun,mie,jue,sab] ] ). 

horario( los_angeles, dallas,
           [ 13:20 / 16:20 / nw979 / habiles] ). 

horario( new_york, washington,
           [  9:10 / 11:45 / united614 / todos,
             14:45 / 17:20 / united805 / todos ] ). 

horario( washingting, new_york,
           [  9:10 / 11:45 / emi234 / todos,
             14:45 / 17:20 / emi102 / todos ] ). 

horario( chicago, miami,
           [  8:30 / 11:20 / nw510 / todos,
             11:00 / 13:50 / aa459 / todos ] ). 

horario( miami, chicago,
           [  8:30 / 11:20 / jk999 / todos,
             11:00 / 13:50 / zz901 / todos ] ). 

horario( los_angeles, san_francisco,
           [ 11:30 / 12:40 / sw322 / [mar,jue] ] ). 

horario( san_francisco, los_angeles,
           [  9:25 / 10:15 / aa621 / todos,
             12:45 / 13:35 / sw623 / todos ] ). 

horario( san_francisco, seattle,
           [ 11:10 / 12:20 / sw211 / [lun,mar,mie,vie,dom],
             20:30 / 21:30 / nw472 / [lun,mie,jue,sab] ] ). 

horario( seattle, san_francisco,
           [ 7:55 / 8:45 / aa620 / todos,
             11:25 / 12:15 / aa666 / habiles ] ).

horario( dallas, san_francisco,
           [ 13:30 / 14:40 / nw323 / [mar,jue] ] ). 

horario( san_francisco, dallas,
           [ 13:30 / 14:40 / nw545 / [mar,jue] ] ). 

horario( boston, new_york,
           [ 9:00 / 9:40 / aa613 / [lun,mar,mie,jue,vie,sab],
            16:10 / 16:55 / united806 / [lun,mar,mie,jue,vie,dom] ] ). 

horario( new_york, boston,
           [ 9:00 / 9:40 / zz765 / [lun,mar,mie,jue,vie,sab],
            16:10 / 16:55 / emi666 / [lun,mar,mie,jue,vie,dom] ] ). 

%
% 3.2 Cálculo de Rutas
%
% ruta(Origen, Destino, Dia, Ruta).
% ruta/4 
% ruta( +Origen, +Destino, +Dia, 
%
% Consiste en ver si existe un precidado horario con el Origen, Destino,
% dia y ruta especificado.
%

ruta(Origen, Destino, Dia, Flight) :-
    horario(Origen, Destino, Vuelos),
    find_flight(Vuelos, Dia, Flight),
    !.
ruta(Origen, Destino, Dia, Flights) :-
    \+ horario(Origen, Destino, _),
    findall(X, camino(Origen, Destino, [], X), Paths),
    map_flights(Paths, Dia, Flights),
    !.

%
% Preciado que triunfa si logra recibir una lista de caminos para llegar de
% Origen a Destino y las convierte en una lista de vuelos de Origen a Destino
%

map_flights([X], Day, [V]) :-
    map_vuelos(X, Day, Z),
    check_empty(Z, V).
map_flights([X|Xs], Day, [V|Zs]) :- 
    map_vuelos(X, Day, Z),
    check_empty(Z, V),
    map_flights(Xs, Day, Zs).

map_vuelos([Origen, Destino], Day, [Flight]) :-
    ruta(Origen, Destino, Day, Flight).
map_vuelos([Origen, Destino | Xs], Day, [Flight_V | Zs]) :-
    ruta(Origen, Destino, Day, Flight),
    check_times( Destino, Flight, Flight_V),
    map_vuelos([Destino | Xs], Day, Zs).

check_empty(Xs, Z) :-
    member(E, Xs),
    check_vacio(E),
    Z = [[]].
check_empty(Xs, Xs).

check_vacio([]).

%
% El predicado camino triunfa si logra construir un camino desde Origen a
% Destino, sin repetición de ciudades. 
% camino(-Origen, -Destino, -Acc, ?Lista).
%camino (Origen, Destino, [], X).
%
camino(Origen, Origen, Acc, Zs) :-
    append(Acc, [Origen], Zs).
camino(Origen, Destino, Acc, V) :-
    findall(X, horario(Origen, X, _), Inter),
    append(Acc, [Origen], NewAcc),
    member(I, Inter),
    \+ member(I, NewAcc),
    camino(I, Destino, NewAcc, V).


% Necesito una función auxiliar que triunfe si Day esta en la lista de vuelos.
% find_flight(-Xs, -Day). 
%
% Necesito una funcion auxiliar que me revise cada uno
% Xs puede ser habiles, todos o una lista de dias.
% Day es el dia que preguntamos si tiene el vuelo.
% 
% check_flight( -Vuelo, -Day).
% check_day triunfa sí Day es subconjunto de dias. 
% check_day( -dias, -Day)

find_flight(Xs, Day, Z):-
    findall(E, (member(E, Xs), check_flight(E, Day)), Z).

check_flight(_ / _ / _ / Xs, Day) :-
    check_day(Xs, Day).

check_day(todos, Day) :-
    member(Day, [lun, mar, mie, jue, vie, sab, dom]), !.
check_day(habiles, Day) :-
    member(Day, [lun, mar, mie, jue, vie]), !.
check_day(Xs, Day) :-
    member(Day, Xs), !.



% Necesito un predicado que triunfe cuando dado una lista de vuelos
% y un aeropuerto intermedio, los tiempos de llegada y salida sean
% mayor a un threshold indicado. 
% check_times(-Intermedio, -Vuelos, ?Vuelos_Validos)
% 
% 

check_times(Intermedio, Xs, Z) :-
    findall(X, (member(X, Xs), check_tiempos(Intermedio, X)), Z),
    !.

check_tiempos(Intermedio, A:B / C:D / _ / _) :-
    member(Intermedio, [new_york, chicago, los_angeles]),
    suma(1:30, A:B, X:Y),
    my_compare(X:Y, C:D).
check_tiempos(Intermedio, A:B / C:D / _ / _ ) :-
    member(Intermedio, [san_francisco, dallas, miami]),
    suma(1:00, A:B, X:Y),
    my_compare(X:Y, C:D).
check_tiempos(Intermedio, A:B / C:D / _ / _ ) :-
    \+ member(Intermedio, [new_york, chicago, los_angeles, san_francisco, dallas, miami]),
    suma(0:40, A:B, X:Y),
    my_compare(X:Y, C:D).
     
suma(A:B, C:D, X:Y) :-
    N1 is B + D,
    N2 is A + C,
    fix_time(N2:N1, X:Y),
    !.

fix_time(A:B, X:D) :-
    B >= 60,
    D is B-60,
    C is A + 1,
    C >= 24,
    X is C - 24.

fix_time(A:B, C:D) :-
    B >= 60,
    D is B-60,
    C is A + 1.

fix_time(A:B, C:B) :-
    A >= 24,
    C is A - 24.

fix_time(A:B, A:B).

my_compare(A:_, C:_) :-
    A < C.
my_compare(A:B, C:D) :-
    A == C,
    B =< D.


%
% Pregunta 3.3
% Cálculo de Giras.
%
%

%gira([Ciudad], Dias, Ruta).

gira([C | Cs], Dias, Ruta) :-
    last([C|Cs], C2),
    findall(X, camino(C, C2, [], X), Path),
    member([C|Cs], Path),
    start_tour([C|Cs], Dias),
    map_flights([[C|Cs]], _ , Ruta),
    !.

start_tour([_], _).
start_tour([X, Y | Xs], Dias) :-
    new_h(X, Y, Dias, Z),
    horario(X, Y, Vuelos),
    check_horario(Vuelos, Z),
    start_tour([Y | Xs], Dias),
    !.

% check_schedule(-Vuelo, -Vuelo+Dias) 
%
check_horario([X],[Y]) :-
    check_schedule(X,Y),
    !.
check_horario([X|Xs], [Y|Ys]) :-
    check_schedule(X,Y),
    check_horario(Xs, Ys),
    !.


check_schedule( _ / _ / _ / todos, _ / _ / _ / _).
check_schedule( _ / _ / _ / habiles, _ / _ / _ / habiles).
check_schedule( _ / _ / _ / habiles, _ / _ / _ / Xs) :-
    member(E, Xs),
    es_habil(E).
check_schedule( _ / _ / _ / Vs, _ / _ / _ / Xs) :-
    member(E, Xs),
    member(E, Vs).

new_h(X, Y, Dias, Nv) :-
    horario(X, Y, Vuelos),
    sumar_dias(Vuelos, Dias, Nv),
    !.

sumar_dias([Vuelos], Dias, [Z]) :-
    sumar_days(Vuelos, Dias, Z).
sumar_dias([X|Xs], Dias, [Z|Zs]) :-
    sumar_days(X, Dias, Z),
    sumar_dias(Xs, Dias, Zs).

sumar_days( A / B / C / todos, _ , A / B / C / todos).
sumar_days( A / B / C / habiles, 7, A / B / C / habiles).
sumar_days( A / B / C / habiles, Dias, A / B / C / Zs) :-
    H = [lun, mar, mie, jue, vie],
    add_day_A(H, Dias, Z),
    dejar_habiles(Z, Zs).
sumar_days( A / B / C / Xs, Dias, A / B / C / Z) :-
    add_day_A(Xs, Dias, Z).

dejar_habiles(Xs, Z) :-
    findall(E, ( es_habil(E), member(E,Xs) ), Z).

es_habil(X) :-
    dias(C, X),
    C < 6.
        
add_day_A([X], Dias, [N]) :-
    add_days(X, Dias, N),
    !.
add_day_A([X|Xs], Dias, [N|Zs]):-
    add_days(X, Dias, N),
    add_day_A(Xs, Dias, Zs),
    !.

add_days(Day, Cantidad, Z) :-
    dias(C, Day),
    Nc is C + Cantidad,
    fix_cantidad(Nc, NewC),
    dias(NewC, Z),
    !.
     
fix_cantidad(N, X) :- 
    N > 7,
    X is N - 7.
fix_cantidad(X, X).

%definimos
dias(1, lun).
dias(2, mar).
dias(3, mie).
dias(4, jue).
dias(5, vie).
dias(6, sab).
dias(7, dom).


%
% Interfaz del programa
%

ui :- write('Bienvenido ala agencia de viajes.'), nl, 
      write('1) Mostrar vuelos entre Ciudad1 y Cuidad2.'), nl, 
      write('2) Mostrar días que se puede volar entre Ciudad1 y Cuidad2.'), nl,
      write('3) Mostrar días para viajar directo de Ciudad1 a Ciudad2.'),nl,
      write('4) Mostrar Gira entre Ciudad1 a Ciudad2 con parada de N días.'),nl,
      write('5) Mostrar como hacer viaje de ida y vuelta entre Ciudad1 y Ciudad2 con posibliemente con paradas de N días.'),nl,
      write('6) Salir'),nl,
      read(X), 
      procesar(X).

procesar(1) :-
    write('Introduzca Ciudad1: '), nl,
    read(C1),
    write('Introduzca Ciudad2: '), nl,
    read(C2),
    ruta(C1, C2, _ , Opciones),
    write('Los posibles vuelos son : '), nl, 
    write('Para viajar de '),
    write(C1),
    write(' a '),
    write(C2), nl,
    printer1(Opciones, C1, C2),
    ui.

procesar(2) :-
    write('Introduzca Ciudad1: '), nl,
    read(C1),
    write('Introduzca Ciudad2: '), nl,
    read(C2),
    ruta(C1, C2, _ , Opciones),
    write('Los posibles días : '), nl, 
    write('Para viajar de '),
    write(C1),
    write(' a '),
    write(C2), nl,
    printer2(Opciones, C1, C2),
    ui.

procesar(3) :-
    write('Introduzca Ciudad1: '), nl,
    read(C1),
    write('Introduzca Ciudad2: '), nl,
    read(C2),
    ruta(C1, C2, _ , Opciones),
    write('Los posibles días : '), nl, 
    write('Para viajar de '),
    write(C1),
    write(' a '),
    write(C2), nl,
    printer3(Opciones, C1, C2),
    ui.


procesar(4) :-
    write('Introduzca Ciudad1: '), nl,
    read(C1),
    write('Introduzca Ciudad2: '), nl,
    read(C2),
    write('Introduzca número de días '), nl, 
    read(N),
    write('Para realizar una gira de  '),
    write(C1),
    write(' a '),
    write(C2), nl,
    findall(X, camino(C1, C2, [], X), Path),
    ordenar(Path, Ordenado),
    %aux4(Ordenado, N, C1, C2).
    get_head(Ordenado, Ciudades),
    member(Ciudades, Ordenado),
    gira(Ciudades, N, Ruta),
    printer1(Ruta, C1, C2),
    ui. 



procesar(5) :-
    write('Opcione no disponible.'), nl.

procesar(6) :-
    write('Hasta Luego'), nl.

%
% Preciados para opcion 1
%

printer1(Opciones, C1, C2) :-
    horario(C1, C2, _),
    print_Opciones_simples(Opciones),
    !.
printer1(Opciones, C1, C2) :-
    \+ horario(C1, C2, _),
    findall(X, camino(C1, C2, [], X), Path),
    ordenar(Path, Caminos),
    ordenar(Opciones, Options),
    print_Opciones_c(Options, Caminos).    

print_Opciones_c([], _).
print_Opciones_c([X|Xs], [P|Ps]):-
    write('Posible Vuelo :'), nl,
    print2(X, P),
    print_Opciones_c(Xs, Ps).

print2([], _).
print2([X|Xs], [A, B | Zs]) :-
    write('vuelo de '),
    write(A),
    write(' a '),
    write(B), nl, 
    print_Opciones_simples(X),
    print2(Xs, [B | Zs]).

print_Opciones_simples([]) :-
    nl.
print_Opciones_simples([X|Xs]) :-
    write(X), nl,
    print_Opciones_simples(Xs).
 
%
% Los predicados para opcion2.
%

printer2(Opciones, C1, C2) :-
    horario(C1, C2, _),
    print_Opciones_simples2(Opciones),
    !.
printer2(Opciones, C1, C2) :-
    \+ horario(C1, C2, _),
    findall(X, camino(C1, C2, [], X), Path),
    ordenar(Path, Caminos),
    ordenar(Opciones, Options),
    print_Opciones_c2(Options, Caminos).    

print_Opciones_c2([], _).
print_Opciones_c2([X|Xs], [P|Ps]):-
    write('Posible Vuelo :'), nl,
    print22(X, P),
    print_Opciones_c2(Xs, Ps).

print22([], _).
print22([X|Xs], [A, B | Zs]) :-
    write('vuelo de '),
    write(A),
    write(' a '),
    write(B), nl, 
    print_Opciones_simples2(X),
    print22(Xs, [B | Zs]).

print_Opciones_simples2([]) :-
    nl.
print_Opciones_simples2([X|Xs]) :-
    print_solo_dias(X),
    print_Opciones_simples2(Xs).
 
print_solo_dias(_ / _ / _ / Xs):-
    write(Xs), 
    nl.

%
% Los predicados para opcion 3
%

printer3(Opciones, C1, C2) :-
    horario(C1, C2, _),
    print_Opciones_simples2(Opciones),
    !.
printer3(_, C1, C2) :-
    \+ horario(C1, C2, _),
    write('No hay dias con vuelos directos entre '),
    write(C1),
    write(' y '),
    write(C2),
    nl.  

get_head([X], X).
get_head([X|Xs], X).

% predicado que triunfa si logra ordenar de forma ascendente el arreglo Xs
% en el arreglo L.
%
ordenar(Xs, L) :-
    permutation(Xs, L),
    test_length(L),
    !. 

test_length([_]).
test_length([X,Y | Zs]) :-
    length(X, A),
    length(Y, B),
    A =< B,
    test_length([Y | Zs]).

aux4(Xs, N, C1, C2):-
    findall(Ruta, (gira(E,N, Ruta),  member(E,Xs)), Z),
    aux5(Z, C1, C2).

aux5([X], C1, C2) :-
    printer1(X, C1, C2),
    ui.
aux5([X|Xs], C1, C2) :-
    printer1(X, C1, C2),
    aux5(Xs, C1, C2).
