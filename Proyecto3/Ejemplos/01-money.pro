/*
     SEND +
     MORE
   ------- 
    MONEY
 
   Estrategia general de exploración dirigida por Prolog.

   Se escriben reglas tales que:
     1.- Generan posibles soluciones (una a la vez).
     2.- Verifican si la solución es plausible.
     3.- La muestran.
   Se aprovecha el backtracking de Prolog para que en caso que
   (2) falle, se regresa a (1) para generar otra solución. Si (1)
   falla, simplemente no hay soluciones.
   
 */

smm(X) :-
        % Generar una posible solución
        X = [S,E,N,D,M,O,R,Y],
        Digits = [0,1,2,3,4,5,6,7,8,9],
        assign_digits(X, Digits),
        % Verificar si la solución es plausible, incluyendo
        % heurísticas para simplificar la búsqueda.
        M > 0, 
        S > 0,
        Send  is           1000*S + 100*E + 10*N + D,
        More  is           1000*M + 100*O + 10*R + E,
        Money is 10000*M + 1000*O + 100*N + 10*E + Y,
        Send + More =:= Money,
        % Tenemos una solución, así que la mostramos.
        % Si el problema tuviera múltiples soluciones, al
        % forzar el backtrack, se continuaría la búsqueda.
        % Si solamente interesa la primera solución o se sabe
        % que es única, aquí sería el lugar apropiado para
        % un cut.
        write(' SEND =  '), write(Send), nl,
        write(' MORE =  '), write(More), nl,
        write('MONEY = '), write(Money), nl.

assign_digits([], _List).
assign_digits([D|Ds], List):-
        select(D, List, NewList),
        assign_digits(Ds, NewList).

