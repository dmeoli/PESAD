%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		fuzzy.pl
%
%	description:
%		"True" fuzzy branch: membership functions over graded clinical variables
%		(symptom duration in months, panic-attack frequency as a count, degree
%		of insight in [0,1]). When the active uncertainty method is
%		fuzzy_membership, the user supplies a crisp numeric value and the
%		corresponding membership grade becomes the certainty, replacing the
%		discrete multiple-choice options. The conjunction is still aggregated
%		with the minimum (Goedel t-norm).
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- dynamic known_value/2.
:- dynamic membership_mode/1.


%------------------------MEMBERSHIP-FUNCTION PRIMITIVES-------------------------

%	current_membership_mode(Mode): soft (the graded ramp, the default) or hard
%		(a Boolean step at the cutoff, used to compare the soft reading with the
%		crisp one the instruments' own algorithms apply).
current_membership_mode(Mode) :- membership_mode(Mode), !.
current_membership_mode(soft).

%	ramp_up(X,A,B,Mu): 0 for X=<A, 1 for X>=B, linear in between (open right shoulder);
%		under the hard mode a step, 1 iff X>=B (the cutoff).
ramp_up(X,_,B,D)   :- current_membership_mode(hard), !, ( X >= B -> D = 1.0 ; D = 0.0 ).
ramp_up(X,A,_,0.0) :- X =< A, !.
ramp_up(X,_,B,1.0) :- X >= B, !.
ramp_up(X,A,B,Mu)  :- Mu is (X-A)/(B-A).

%	ramp_down(X,A,B,Mu): 1 for X=<A, 0 for X>=B, linear in between (open left shoulder);
%		under the hard mode a step, 1 iff X=<A.
ramp_down(X,A,_,D)   :- current_membership_mode(hard), !, ( X =< A -> D = 1.0 ; D = 0.0 ).
ramp_down(X,A,_,1.0) :- X =< A, !.
ramp_down(X,_,B,0.0) :- X >= B, !.
ramp_down(X,A,B,Mu)  :- Mu is (B-X)/(B-A).

%	trapezoid(X,A,B,C,D,Mu): rises A->B, plateau B->C, falls C->D.
trapezoid(X,A,B,C,D,Mu) :-
	ramp_up(X,A,B,Up),
	ramp_down(X,C,D,Down),
	Mu is min(Up,Down).


%--------------------------NAMED MEMBERSHIP FUNCTIONS---------------------------

%	duration_membership(Allowed_Options, Months, Mu):
%		the allowed discrete options identify the diagnostic duration threshold;
%		Months is the crisp duration the user reports.
%	"at least 6 months" (soft 3 -> 6).
duration_membership([six_months_or_more],Months,Mu) :- !,
	ramp_up(Months,3,6,Mu).
%	"at least 1 month" (soft 0.25 -> 1).
duration_membership([one_to_three_months,three_to_six_months,six_months_or_more],Months,Mu) :- !,
	ramp_up(Months,0.25,1,Mu).
%	"less than 6 months" (the complement of "at least 6 months").
duration_membership([less_than_three_days,three_days_to_one_month,one_to_three_months,three_to_six_months],Months,Mu) :- !,
	ramp_down(Months,3,6,Mu).
%	"between 3 days and 1 month" (band, 3 days ~ 0.1 month).
duration_membership([three_days_to_one_month],Months,Mu) :- !,
	trapezoid(Months,0.05,0.1,1,1.5,Mu).

%	frequency_membership(Allowed_Options, Count, Mu):
%		"recurrent" panic attacks (>= 2), soft 1 -> 2.
frequency_membership([two_to_five,more_than_five],Count,Mu) :- !,
	ramp_up(Count,1,2,Mu).

%	insight_membership(Category, Degree, Mu):
%		Degree in [0,1] (0 = absent/delusional, 1 = good insight).
insight_membership(good_or_fair,Degree,Mu)        :- ramp_up(Degree,0.4,0.7,Mu).
insight_membership(poor,Degree,Mu)                :- trapezoid(Degree,0.1,0.3,0.5,0.7,Mu).
insight_membership(absent_or_delusional,Degree,Mu):- ramp_down(Degree,0.2,0.4,Mu).


%---------------------------GRADED VALUE ACQUISITION----------------------------

%	graded_options(Variable, Values): typical values of Variable, offered as
%	ready answers by the front-ends with buttons (any other number is accepted).
graded_options(duration_months,[0,0.5,1,2,3,4,5,6,9,12,24]).
graded_options(panic_attacks_count,[0,1,2,3,4,5,6,10]).

%	graded_available(Variable): the graded value of Variable can be used: in a
%	consultation it is asked, in an evaluation from facts (see evaluate.pl) it
%	must have been given, otherwise the discrete question takes its place.
graded_available(_) :-
	\+ evaluation_bound(_),
	!.
graded_available(Variable) :-
	known_value(Variable,_).

%	graded_value(Variable, Value): returns the crisp value for Variable, asking
%	the user for a number the first time and caching it in known_value/2.
graded_value(Variable,Value) :-
	known_value(Variable,Value),
	!.
graded_value(Variable,Value) :-
	white_lines(2),
	decode(Variable,Question),
	write(Question),
	write('?'),
	white_lines(1),
	ui_topic(graded(Variable)),
	repeat,
	write(' > '),
	ui_read(number,Input),
	( number(Input)
	-> Value = Input, assertz(known_value(Variable,Value)), !
	;  decode(answer_error,Answer_Error), write(Answer_Error), nl, fail ).
