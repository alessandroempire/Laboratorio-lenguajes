% p01 find the last elemet of the list
%my_last(X,L) :- X es el ultimo elemnto de la lista L
%my_last(?X1, ?X2)

my_last(X,[X]).
my_last(X,[_|B]) :- my_last(X,B).

%p03 find the Kth element of the list
% (X,L,K) :- X es el elemento k-esimo de la lista L
% element_at(?X1, ?X2, ?X3)

element_at(X,[X|_],1).
element_at(X,[_|B],K) :- K > 1, N is K - 1, element_at(X,B,N), !.

%p04 find the number of elements of a list
% my_length(L,N) :- la lista L tiene N elementos
% my_length(?X1, ?X2)

my_length([],0).
my_length([_|L],K) :- my_length(L,N), K is N + 1.

%p05 reverse a list
%my_reverse(L1,L2) :- L2 is the list obtained from L1 by reversing
%

my_reverse(L1,L2) :- my_rev(L1,L2,[]).

my_rev([],L2,L2) :- !.
my_rev([X|XS],L2,Acc) :- my_rev(XS,L2,[X|Acc]).

%p06
%palindrome(L) :- la lista es palindrome

my_palindrome(L) :- my_reverse(L,L).

%p07
%my_flatten(L,X) :- X tiene solo elementos de las listas de L
% no se...

%p08
%compress(L,X) :- X tiene elementos no repetidos de L

compress([],[]).
compress([X],[X]).
compress([X,X|Xs],Zs) :- compress([X|Xs],Zs).
compress([X,Y|Ys],[X|Zs]) :- Y \= X, compress([Y|Ys], Zs).

%p09
%pack(L,X)
% no se

%p14
%dupli(L,X) :- duplicar los elementos de una lista

dupli([],[]).
dupli([X|Xs], [X,X|Ys]) :- dupli(Xs,Ys).

%p15
%muy peludo
% my_dupli(L,K,L1)

%my_dupli(E,1,[E]).
%my_dupli(E,K,L) :- K > 1, N is K - 1, my_dupli(E,N,[E|L]).
%my_dupli([X|Xs],K,[D|Zs] :- my_dupli(Xs,K,Zs), 

%p17
%split(L,K,L1,L2) :- los primeros k esta en L1, y el resto en L2

split(L,0,[],L).
split([X|Xs], K, [X|Zs], L2) :- K > 0, N is K - 1, split(Xs, N, Zs, L2).

%p20
%remove_at(X,L,K,R) :- remover el K-esimo elemento de la lista L
%                      el resto en R, y el elemento en X
%si L es vacio no triunfa

remove_at(X,[X|Xs],1,Xs).
remove_at(X,[Y|Ys],K,[Y|R]) :- N is K - 1, remove_at(X,Ys,N,R).

%p21
%insert_at(E,L,K,L1) :- insertar elemento E en la lista L en la pos
%                       k, el resultado en L1. 

insert_at(E,Zs,1,[E|Zs]).
insert_at(E, [X|Xs], K, [X|Zs]) :- N is K - 1, insert_at(E,Xs, N, Zs).

%p22
%range(X, Y, L) :- 

range(N1, N1, [N1]).
range(N1, N2, [N1|Zs]) :- K is N1 + 1, range(K, N2, Zs).
