:- use_module(library(clpfd)).


tree(nil).
tree(b(Left, Here, Right)) :-
	tree(Left),
	tree(Right).

mirror(nil, nil).
mirror(b(L, H, R), b(A, H, C)) :- 	
	mirror(L, C), 
	mirror(R, A).

echo([],[]).
echo([X|Y], [X,X|Result]) :-
	echo(Y,Result).

unecho([],[]).
unecho([X], [X]).
unecho([X,X|Y], [X|Result]) :-
    unecho([X|Y], [X|Result]).
unecho([X,Y|Z], [X|Result]) :-
    X \== Y,
    unecho([Y|Z], Result).

slist([]).
slist([_]).
slist([A,B|T]) :- 
	A @=< B, slist([B|T]).


sselect(X, [], [X]).
sselect(X, [Y|Z], [X,Y|Z]) :-
    X @< Y.
sselect(X, [Y|Z], [Y|B]) :-
	sselect(X, Z, B).

