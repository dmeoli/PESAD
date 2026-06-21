%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		memory.pl
%
%	description:
%		Working-memory management: asserting/retracting facts and proof trees
%		and displaying the facts stated by the user.
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%	show_facts:
%		prints to screen the facts asserted by the user
show_facts :- 
	white_lines(2),
	decode(facts,T_Facts),
	write(T_Facts),
	white_lines(1),
	repeat,
	show_fact.

%	show_fact:
%		prints each fact in the format: (User Answer, Attribute, Value, Certainty)
show_fact :-
	known(Answer,Attribute,Value,Certainty),
	write('('),
	write(Answer), 
	write(','),
	write(Attribute),
	write(','),
	write(Value),
	write(','),
	write(Certainty),
	write(')'),	
	white_lines(1),
	fail.
show_fact.


%	clean_memory:
%		clears the working memory of facts and traces from previous runs of the system
clean_memory :-
	delete_facts,
	delete_trees.

%	delete_tree(Goal):
%		deletes the tree for the goal specified as input
delete_tree(Goal) :-
	retractall(rule_I(_,Goal,_,Index_I)),
	retractall(rule_II(_,_,_,Index_I,_)),
	retractall(rule_III(_,_,_,Index_I,_,_)),
	retractall(fact(_,_,_,_,Index_I,_,_,_)),
	reset_level_I_index.

%	delete_trees:
%		deletes the (proof) trees present in memory
delete_trees :-
	retractall(rule_I(_,_,_,_)),
	retractall(rule_II(_,_,_,_,_)),
	retractall(rule_III(_,_,_,_,_,_)),
	retractall(fact(_,_,_,_,_,_,_,_)),
	reset_level_I_index.

%	delete_facts:
%		deletes the facts present in memory
delete_facts :-
	retractall(known(_,_,_,_)).
