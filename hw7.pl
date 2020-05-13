% dfa/1

% dfa/1: Base Case
dfa([]).

% dfa/1: Non-empty Case
% Actions = List of State Transitions
% More = Rest of the States in the dfa
% actionCheck/1 = Helper function that checks Actions for any move(_)
dfa([state(_, Actions, _)|More]) :-
   actionCheck(Actions),
   dfa(More).

% actionCheck/1

% actionCheck/1: Base Case
actionCheck([]).

% actionCheck/1 : Recursive Case
% Action = Transition
% Rest = Rest of the Transitions
actionCheck([Action|Rest]) :-
   Action = read(_, _),
   actionCheck(Rest).

% fa_state/3

% Name = Name of State
% Check = Name of the Potential State Compound Term
% Moves = Moves of the Potential State Compound Term
% Accept = Acceptance of the Potential State Compound Term
% Rest = Rest of the Potential State Compound Terms
% Result = The State's Compound Term
fa_state(Name, [state(Check, Moves, Accept)|Rest], Result) :-
   ( Name = Check -> Result = state(Check, Moves, Accept)
   ; fa_state(Name, Rest, Result)
   ).

% next_state/4

% Actions = List of Transitions
% Input = Input
% Name = Name of the Next State
% Leftover = Leftover Input after getting to Next State
% actionNext/4 = Helper function that finds All Next States
next_state(state(_, Actions, _), Input, Name, Leftover) :-
   actionNext(Actions, Input, Name, Leftover).

% actionNext/4
% More = Rest of the Transitions
% Input = First Input
% Rest = Rest of the Input
% Name = Name of the Next State
% Leftover = Leftover Input after getting to the Next State

% actionNext/4: Regular Transition Case
actionNext([read(A, B)|More], [Input|Rest], Name, Leftover) :-
   (A = Input, Name = B, Leftover = Rest);
   actionNext(More, [Input|Rest], Name, Leftover).

% actionNext/4: Null Transition Case
actionNext([move(A)|More], [Input|Rest], Name, Leftover) :- 
   (Name = A, Leftover = [Input|Rest]);
   actionNext(More, [Input|Rest], Name, Leftover).

% accepts/2

% accepts/2
% [State|States] = Finite Automata
% Input = Input
% State = Start State
accepts([State|States], Input) :- accepts(State, [State|States], Input).

% accepts/3: Recursive Case
% Start = Start State
% [State|States] = Finite Automata
% Input = First Input
% Rest = Rest of Input
% Name = Name of Next State
% Leftover = Leftover Input after getting to Next State
% Result = Next State's Compound Term
accepts(Start, [State|States], [Input|Rest]) :-
   next_state(Start, [Input|Rest], Name, Leftover),
   fa_state(Name, [State|States], Result),
   accepts(Result, [State|States], Leftover).

% accepts/3 Base Case
% Only true if it is an accept state (yes) and no more input ([])
accepts(state(_, _, yes), _, []).

% Testing accepts/2
% String = Input
demo(String) :-
	accepts(
		[ state(even,  [read(0, even), read(1, other)], yes)
	  , state(odd,   [read(0, even), read(1, odd), read(1, other)], no)
 	  , state(other, [move(odd), read(0, even), read(1, other)], no)],
    String
  ).