%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		explanation.pl
%
%	description:
%		Explanation module: pretty-prints the proof tree of a goal across the
%		three inference levels (how a conclusion was reached).
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%	print_tree(Goal):
%		prints the proof tree for the input goal
print_tree(Goal) :-	
	show_rule_I(Goal).

show_rule_I(Goal) :-
	rule_I(TV,Goal,CF,Index_I),
	Certainty is round(CF*100),
	decode(Goal,Goal_Name),
	write(Goal_Name),
	show_truth_value(TV),
	write(Certainty),
	write('%'),
	white_lines(1),
	decode(deduced,T_Deduced),
	write(T_Deduced),
	white_lines(2),
	show_rules_II(Index_I). 	

show_rules_II(Index_I) :-
	repeat,
	show_rule_II(Index_I),
	!.
	
show_rule_II(Index_I) :-
	rule_II(TV,Goal,CF,Index_I,Index_II),	
	write('\t'),
	Certainty is round(CF*100),
	decode(Goal,Goal_Name),
	write(Goal_Name),
	show_truth_value(TV),
	write(Certainty),
	write('%'),
	white_lines(1),
	write('\t'),
	decode(deduced,T_Deduced),
	write(T_Deduced),
	white_lines(2),
	show_rules_III(Index_I,Index_II),
	fail.
show_rule_II(_).

show_rules_III(Index_I,Index_II) :-
	repeat,
	show_rule_III(Index_I,Index_II),
	!.

show_rule_III(Index_I,Index_II) :-
	rule_III(TV,Goal,CF,Index_I,Index_II,Index_III),	
	write('\t\t'),
	Certainty is round(CF*100),
	decode(Goal,Goal_Name),
	write(Goal_Name),
	show_truth_value(TV),
	write(Certainty),
	write('%'),
	white_lines(1),
	write('\t\t'),
	decode(deduced,T_Deduced),
	write(T_Deduced),
	white_lines(2),
	show_assertions(Index_I,Index_II,Index_III),
	fail.
show_rule_III(_,_).

show_assertions(Index_I,Index_II,Index_III) :-
	repeat,
	show_assertion(Index_I,Index_II,Index_III),
	!.

show_assertion(Index_I,Index_II,Index_III) :-
	fact(TV,Attribute,Goal,CF,Index_I,Index_II,Index_III,_),	
	write('\t\t\t'),
	Certainty is round(CF*100),
	decode(Goal,Goal_Name),
	write(Goal_Name),
	decode(true_label,T_True),
	write(T_True),
	write(Certainty),
	write('%'),
	white_lines(1),
	write('\t\t\t'),
	decode(stated,T_Stated),
	write(T_Stated),
	white_lines(2),
	fail.
show_assertion(_,_,_).

%	show_truth_value(Value):
%		prints the true/false label
show_truth_value(yes) :-
	decode(true_label,T_True),
	write(T_True).
show_truth_value(no) :-
	decode(false_label,T_False),
	write(T_False).
