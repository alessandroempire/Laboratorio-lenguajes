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
