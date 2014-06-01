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

% Agente.pro
% 
% Definimos el operador ":" infijo

:- op( 7, xfx, :).

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


ruta(Origen, Destino, Dia, Flight) :-
    horario(Origen, Destino, Vuelos),
    find_flight(Vuelos, Dia, Flight),
    !.
ruta(Origen, Destino, Dia, Ruta) :-
    findall(I, horario(Origen, I, _), Zs), 
    member(Intermedio, Zs),
    horario(Origen, Intermedio, Vuelos),
    find_flight(Vuelos, Dia, Flight),
    check_times(Intermedio, Flight),
    % ruta(Intermedio, Destino, Dia, Ruta),
    !. 
    %intermedio es un arreglo....


check_times([]).
check_times(Intermedio, [X|Xs]) :-
    check_tiempos(Intermedio, X),
    check_times(Intermedio, Xs).

check_tiempos(Intermedio, A:B / C:D / _ / _ ) :-
    member(Intermedio, [new_york, chicago, los_angeles]),
    suma(1:30, A:B, X:Y),
    my_compare(X:Y, C:D).
check_tiempos(Intermedio, A:B / C:D / _ / _ ) :-
    member(Intermedio, [san_francisco, dallas, miami]),
    suma(1:00, A:B, X:Y),
    my_compare(X:Y, C:D).
check_tiempos(Intermedio, a:b / c:d / _ / _ ) :-
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

my_compare(A:B, C:D) :-
    A =< C,
    B =< D.



find_flight(Xs, Day, Z):-
    findall(E, member(E, Xs), Z),
    check_flight(E, Day).

check_flight(_ / _ / _ / Xs, Day) :-
    check_day(Xs, Day).

check_day(todos, Day) :-
    member(Day, [lun, mar, mie, jue, vie, sab, dom]).
check_day(habiles, Day) :-
    member(Day, [lun, mar, mie, jue, vie]).
check_day(Xs, Day) :-
    member(Day, Xs).

%%Hallar ruta..
