:- dynamic fibDyn/2.
:- retractall( fibDyn(_,_) ).  

%% without this, youll retain all the previous 
%% facts even if you reload the program



fibDyn(1,1).
fibDyn(2,1).

fibDyn(N,F) :- N > 2,
               N1 is N-1,
               fibDyn(N1,F1),
               N2 is N-2,
               fibDyn(N2,F2),
               F is F1+F2,
               asserta( (fibDyn(N,F):-!) ).





%:- dinamic fib/2.
%fib(1,1).
%fib(2,1).
%fib(N, F) :-
%    N1 is N -1, 
%    fib(N1, F),
%    N2 is N - 2,
%    fib(N2, F).
