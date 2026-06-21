%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		uncertainty.pl
%
%	description:
%		Uncertainty management: certainty-factor calculus (antecedent and
%		consequent certainty), certainty-based ordering and inference-level
%		index bookkeeping for the proof trees.
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%	descending_order_goals(Goals_List,Sorted_Goals_List):
%		sorts the goals in descending order, based on the certainty value
descending_order_goals(Goals_List,Sorted_Goals_List) :-
	predsort(compare_goals,Goals_List,Sorted_Goals_List).

compare_goals(<,goal(_,Ce_A),goal(_,Ce_B)) :-
  Ce_A > Ce_B.
compare_goals(>,_,_).
	
%	assert_fact(Attribute,Fact):
%		asserts a fact obtained from a yes/no question
assert_fact(Attribute,Fact) :-
	last_level_I_index(Index_I),
	last_level_II_index(Index_II),
	last_level_III_index(Index_III),
	last_level_IV_index(Index_IV),
	arg(1,Fact,Answer),
	arg(2,Fact,Item),
	arg(3,Fact,CF),
	assertz(fact(Answer,Attribute,Item,CF,Index_I,Index_II,Index_III,Index_IV)),
	next_level_IV_index(_).

%	ascending_order_facts(Facts_List,Sorted_Facts_List):
%		sorts the list of facts in ascending order, based on the certainty value
ascending_order_facts(Facts_List,Sorted_Facts_List) :-
	predsort(compare_ascending_facts,Facts_List,Sorted_Facts_List).

compare_ascending_facts(>,fact(_,_,Ce_A),fact(_,_,Ce_B)) :-
  Ce_A > Ce_B.
compare_ascending_facts(<,_,_).

%	descending_order_facts(Facts_List,Sorted_Facts_List):
%		sorts the list of facts in descending order, based on the certainty value
descending_order_facts(Facts_List,Sorted_Facts_List) :-
	predsort(compare_facts,Facts_List,Sorted_Facts_List).

compare_facts(<,fact(_,_,Ce_A),fact(_,_,Ce_B)) :-
  Ce_A > Ce_B.
compare_facts(>,_,_).

%	assert_fact_multiple_ask(Attribute,Answer,CF):
%		asserts a fact obtained from a multiple-choice question
assert_fact_multiple_ask(Attribute,Answer,CF) :-
	last_level_I_index(Index_I),
	last_level_II_index(Index_II),
	last_level_III_index(Index_III),
	last_level_IV_index(Index_IV),
	assertz(fact(yes,Attribute,Answer,CF,Index_I,Index_II,Index_III,Index_IV)),
	next_level_IV_index(_).

%	certainty(Goal,Goal_Type,Antecedent_CF_List,Rule_CF,Consequent_CF,Truth_Value):
%		computes the certainty from the certainty of the antecedent part of the rule and the certainty of the rule.
certainty(Goal,Goal_Type,Antecedent_CF_List,Rule_CF,Consequent_CF,Truth_Value) :-
	antecedent_certainty(Antecedent_CF_List,Antecedent_CF),
	consequent_certainty(Goal,Goal_Type,Antecedent_CF,Rule_CF,Consequent_CF,Truth_Value).

%	antecedent_certainty(Antecedent_CF_List,Antecedent_CF):
% 	computes the certainty of the antecedent part of a rule that requires all facts to be true.
%		The conjunction is evaluated with the active t-norm: the "cf" method uses the
%		Goedel t-norm (minimum, i.e. the weakest link), the "fuzzy" method uses the
%		product t-norm (the algebraic product of all the premises).
antecedent_certainty(Antecedent_CF_List,Antecedent_CF) :-
	( current_uncertainty_method(fuzzy)
	-> product_list(Antecedent_CF_List,Antecedent_CF)
	;  min_list(Antecedent_CF_List,Antecedent_CF) ).

%	current_uncertainty_method(Method): the active uncertainty method (defaults to cf).
current_uncertainty_method(Method) :-
	uncertainty_method(Method),
	!.
current_uncertainty_method(cf).

%	product_list(List,Product): the product t-norm of a list of certainties.
product_list([],1.0).
product_list([X|Xs],Product) :-
	product_list(Xs,Rest_Product),
	Product is X*Rest_Product.

%	consequent_certainty(Goal,Inference_Level,Antecedent_CF,Rule_CF,Consequent_CF,Truth_Value):
%		computes the certainty of the consequent part of a rule.
%		If the goal is not negated, the certainty is obtained by multiplying the certainty of the rule by the certainty of the antecedent part
%		If the goal is negated, the certainty is instead obtained as the complement of the product between the certainty of the rule and
%		the certainty of the antecedent part.
consequent_certainty(Goal,1,Antecedent_CF,Rule_CF,Consequent_CF,true) :-
	Consequent_CF is Rule_CF*Antecedent_CF,
	last_level_I_index(Index_I),
	assertz(rule_I(yes,Goal,Consequent_CF,Index_I)),
	next_level_I_index(_),
	reset_level_II_index.
consequent_certainty(Goal,1,Antecedent_CF,Rule_CF,Consequent_CF,false) :-
	Consequent_CF is 1-(Rule_CF*Antecedent_CF),
	last_level_I_index(Index_I),
	assertz(rule_I(no,Goal,Consequent_CF,Index_I)),
	next_level_I_index(_),
	reset_level_II_index.
consequent_certainty(Goal,2,Antecedent_CF,Rule_CF,Consequent_CF,true) :-
	Consequent_CF is Rule_CF*Antecedent_CF,
	last_level_I_index(Index_I),
	last_level_II_index(Index_II),
	assertz(rule_II(yes,Goal,Consequent_CF,Index_I,Index_II)),
	next_level_II_index(_),
	reset_level_III_index.
consequent_certainty(Goal,2,Antecedent_CF,Rule_CF,Consequent_CF,false) :-
	Consequent_CF is 1-(Rule_CF*Antecedent_CF),
	last_level_I_index(Index_I),
	last_level_II_index(Index_II),
	assertz(rule_II(no,Goal,Consequent_CF,Index_I,Index_II)),
	next_level_II_index(_),
	reset_level_III_index.
consequent_certainty(Goal,3,Antecedent_CF,Rule_CF,Consequent_CF,true) :-
	Consequent_CF is Rule_CF*Antecedent_CF,
	last_level_I_index(Index_I),
	last_level_II_index(Index_II),
	last_level_III_index(Index_III),
	assertz(rule_III(yes,Goal,Consequent_CF,Index_I,Index_II,Index_III)),
	next_level_III_index(_),
	reset_level_IV_index.
consequent_certainty(Goal,3,Antecedent_CF,Rule_CF,Consequent_CF,false) :-
	Consequent_CF is 1-(Rule_CF*Antecedent_CF),
	last_level_I_index(Index_I),
	last_level_II_index(Index_II),
	last_level_III_index(Index_III),
	assertz(rule_III(no,Goal,Consequent_CF,Index_I,Index_II,Index_III)),
	next_level_III_index(_),
	reset_level_IV_index.

%	returns the available index for inference level I
last_level_I_index(1).

%	returns the available index for inference level II
last_level_II_index(1).

%	returns the available index for inference level III
last_level_III_index(1).

%	returns the available index for inference level IV
last_level_IV_index(1).

%	advances the index for inference level I
next_level_I_index(Next) :-
        retract(last_level_I_index(Last)),
        Next is Last+1,
        assert(last_level_I_index(Next)).

%	advances the index for inference level II
next_level_II_index(Next) :-
        retract(last_level_II_index(Last)),
        Next is Last+1,
        assert(last_level_II_index(Next)).

%	advances the index for inference level III
next_level_III_index(Next) :-
        retract(last_level_III_index(Last)),
        Next is Last+1,
        assert(last_level_III_index(Next)).

%	advances the index for inference level IV
next_level_IV_index(Next) :-
        retract(last_level_IV_index(Last)),
        Next is Last+1,
        assert(last_level_IV_index(Next)).

%	resets the index for inference level I
reset_level_I_index :-
	retract(last_level_I_index(_)),
	assert(last_level_I_index(1)).

%	resets the index for inference level II
reset_level_II_index :-
	retract(last_level_II_index(_)),
	assert(last_level_II_index(1)).

%	resets the index for inference level III
reset_level_III_index :-
	retract(last_level_III_index(_)),
	assert(last_level_III_index(1)).

%	resets the index for inference level IV
reset_level_IV_index :-
	retract(last_level_IV_index(_)),
	assert(last_level_IV_index(1)).
