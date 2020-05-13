:- begin_tests(path).
:- include(hw6).

implemented(mode_A).
implemented(mode_B).
implemented(mode_C).
implemented(mode_D).
implemented(mode_E).
implemented(mode_F).


friend(alice, bob).
friend(bob, carol).
friend(carol, daniel).
friend(carol, eve).
friend(frank, daniel).
friend(frank, eve).

friends(A,B) :- friend(A,B); friend(B,A).


test(mode_A, [nondet]) :- path(friends, alice, eve, [alice, bob, carol, eve], 4).

test(mode_B, [ condition(implemented(mode_B))
             , set([S,T,N] == [[daniel, bob, 3]])]) :-
	path(friends, S, T, [daniel, carol, bob], N).

test(mode_C, [ condition(implemented(mode_C))
             , set(P == [[alice, bob, carol, eve]])]) :-
	path(friends, alice, eve, P, 4).

test(mode_D, [ condition(implemented(mode_D))
             , set([P,N] == [[[alice,bob,carol,daniel],4],
                            [[alice,bob,carol,eve,frank,daniel], 6]])]) :-
	path(friends, alice, daniel, P, N).

test(mode_E, [condition(implemented(mode_E)), set([S,T,P] == 
		[ [alice,frank,[alice,bob,carol,eve,frank]]
		, [alice,frank,[alice,bob,carol,daniel,frank]]
		, [bob,daniel,[bob,carol,eve,frank,daniel]]
		, [bob,eve,[bob,carol,daniel,frank,eve]]
		, [daniel,bob,[daniel,frank,eve,carol,bob]]
		, [eve,bob,[eve,frank,daniel,carol,bob]]
		, [frank,alice,[frank,eve,carol,bob,alice]]
		, [frank,alice,[frank,daniel,carol,bob,alice]]
		])]) :-
	path(friends, S, T, P, 5).

test(mode_F, [condition(implemented(mode_F)), fail]) :-
	path(friends, _, _, _, _), false.

:- end_tests(path).