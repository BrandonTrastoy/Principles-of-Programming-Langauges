:- use_module(library(clpfd)).

% This passes all given tests A B C D E & F

helper(Relation, First, First, Rest, List, Size) :- 
	not(member(First,Rest)), 
	reverse([First|Rest], List), 
	length([First|Rest], Size), !.
helper(Relation, First, Last, Rest, List, Size) :- 
	call(Relation, First, Next), 
	not(member(First,Rest)), 
	helper(Relation, Next, Last, [First|Rest], List, Size).
path(Relation, First, Last, List, Size) :- 
	helper(Relation, First, Last, [], List, Size).
