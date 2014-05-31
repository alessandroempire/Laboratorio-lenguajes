d(X,X,1)              :- !.
d(C,_,0)              :- atomic(C).
d(-U,X,-A)            :- d(U,X,A).
d(U+V,X,A+B)          :- d(U,X,A), d(V,X,B).
d(U-V,X,A-B)          :- d(U,X,A), d(V,X,B).
d(C*U,X,C*A)          :- atomic(C), C \= X, d(U,X,A), !.
d(U*V,X,B*U+A*V)      :- d(U,X,A), d(V,X,B).
d(U/V,X,A)            :- d(U*(V^(-1)),X,A).
d(U^C,X,C*U^(C-1)*W)  :- atomic(C), C \= X, d(U,X,W).
d(ln(U),X,A*U^(-1))   :- d(U,X,A).
d(exp(U),X,A*exp(U))  :- d(U,X,A).
d(sin(U),X,A*cos(U))  :- d(U,X,A).
d(cos(U),X,-A*sin(U)) :- d(U,X,A).

simplifica(E,E) :- atomic(E), !.
simplifica(E,F) :-
  E =.. [Funcion, Arg],
  simplifica(Arg,X),
  s(Funcion,X,F), !.
simplifica(E,F) :- 
  E =.. [Operador, Arg1, Arg2],
  simplifica(Arg1,X),
  simplifica(Arg2,Y),
  s(Operador,X,Y,F), !.

s(+,X,0,X)       :- !.
s(+,0,X,X)       :- !.
s(+,X,Y,Z)       :- integer(X), integer(Y), Z is X+Y, !.
s(+,X,X,2*X)     :- atomic(X), !.
s(+,C,X,X+C)     :- integer(C), atomic(X), !.
s(+,X,Y,X+Y)     :- !.
s(-,X,0,X)       :- !.
s(-,0,X,Y)       :- integer(X), Y is 0-X, !.
s(-,X,X,0)       :- !.
s(-,X,Y,X-Y)     :- !.
s(*,_,0,0)       :- !.
s(*,0,_,0)       :- !.
s(*,X,1,X)       :- !.
s(*,1,X,X)       :- !.
s(*,X,-1,-X)     :- !.
s(*,-1,X,-X)     :- !.
s(*,A,B,C)       :- integer(A), integer(B), C is A*B, !.
s(*,X,C,C*X)     :- integer(C), atomic(X), !.
s(*,A*X,B,C*X)   :- integer(A), integer(B), C is A*B, !.
s(*,A,B*X,C*X)   :- integer(A), integer(B), C is A*B, !.
s(*,X,Y,X*Y).  
s(/,X,1,X).
s(/,X,X,1).
s(/,X,Y,X/Y).
s(^,_,0,1).
s(^,X,1,X).
s(^,X,Y,X^Y).

s(-,0,0)    :- !.
s(-,X,(-X)) :- !.
s(exp,0,1)  :- !.
s(exp,1,e)  :- !.
s(exp,A,R)  :- number(A), R is exp(A).
s(exp,X,exp(X)).
s(ln,1,0) :- !.
s(ln,e,1) :- !.
s(ln,X,ln(X)).
s(sin,0,0)     :- !.
s(sin,pi,0)    :- !.
s(sin,C*pi,0)  :- integer(C), !.
s(sin,pi*C,0)  :- integer(C), !.
s(sin,A,R)     :- number(A), R is sin(A).
s(sin,X,sin(X)).
s(cos,0,1)     :- !.
s(cos,pi,-1)   :- !.
s(cos,X*pi,-1) :- integer(X), odd(X), !.
s(cos,X*pi,1)  :- integer(X), even(X), !.
s(cos,A,R)     :- number(A), R is cos(A).
s(cos,X,cos(X)).

even(0).
even(N) :- N > 0, N1 is N-1, odd(N1), !.
odd(N)  :- N > 0, N1 is N-1, even(N1), !.

derivar :-
  repeat,
  write('Función:  '), read(F),
  procesar(F), !.

procesar(salir).
procesar(F) :-
  write('Variable: '), read(X),
  derivar(F,X),
  fail.

derivar(F,X) :-
  atomic(X), !,
  d(F,X,D),
  simplifica(D,R),
  write('Derivada: '), write(R),
  nl, nl.
derivar(_,X) :-
  write('No puedo usar "'), write(X), write('" para derivar.').
