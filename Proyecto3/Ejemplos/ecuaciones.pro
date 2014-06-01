:- dynamic([si_se_pudo/0]).

ecuaciones(Ns) :-
  ecuaciones(Ns,ExpI,ExpD),
  asserta((si_se_pudo :- true)),
  format('~w = ~w',[ExpI,ExpD]), nl,
  fail.
ecuaciones(_) :-
  si_se_pudo,
  retractall(si_se_pudo),
  !.

ecuaciones(Ns,ExpI,ExpD) :-
  partes(Ns,GrpI,GrpD),
  armar(GrpI,ExpI),
  armar(GrpD,ExpD),
  ExpI =:= ExpD.

partes(Ns,GrpI,GrpD) :-
  append(GrpI,GrpD,Ns),
  GrpI = [_|_],
  GrpD = [_|_].

armar([N],N).
armar(Ns,Exp) :-
  partes(Ns,I,D),
  armar(I,ExpI),
  armar(D,ExpD),
  binario(ExpI,ExpD,Exp).

binario(I,D,I+D).
binario(I,D,I-D).
binario(I,D,I*D).
binario(I,D,I/D) :- D =\= 0.

