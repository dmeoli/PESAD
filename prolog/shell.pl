%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		shell.pl
%
%	description:
%		User shell: REPL loop, language selection, command dispatch,
%		investigation/control orchestration and result presentation.
%		Also hosts the decode/3 and explain/3 localization dispatch.
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%	decode(Key, Text):
%		looks up the label for Key in the active language; falls back to the key itself
decode(Key, Text) :-
	language(Language),
	label(Language, Key, Text),
	!.
decode(Key, Key).

%	explain(Key, Text):
%		looks up the explanation for Key in the active language; falls back to the key itself
explain(Key, Text) :-
	language(Language),
	explanation(Language, Key, Text),
	!.
explain(Key, Key).

%	main:
%		starts the system
main :-
	select_language,
	select_uncertainty_method,
	welcome,
	menu,
	repeat,
	white_lines(1),
	write('> '),
	ui_read(command,Command),
	run(Command),
	Command == quit,
	!,
	finish_main.

%	select_language:
%		asks the user which interface language to use and asserts language/1
select_language :-
	retractall(language(_)),
	white_lines(1),
	write('Select language / Seleziona lingua:'), nl,
	write('	1: English'), nl,
	write('	2: Italiano'), nl,
	repeat,
	write(' > '),
	ui_read(language,Choice),
	set_language(Choice),
	!.

set_language(1)  :- !, assertz(language(en)).
set_language(en) :- !, assertz(language(en)).
set_language(2)  :- !, assertz(language(it)).
set_language(it) :- !, assertz(language(it)).
set_language(_)  :- write('Invalid choice / Scelta non valida'), nl, fail.

%	select_uncertainty_method:
%		asks the user which uncertainty method to use and asserts uncertainty_method/1
select_uncertainty_method :-
	retractall(uncertainty_method(_)),
	white_lines(1),
	decode(method_request,T_Method_Request),
	write(T_Method_Request),
	white_lines(1),
	decode(method_cf,T_Method_CF),
	write('	1: '), write(T_Method_CF), nl,
	decode(method_fuzzy,T_Method_Fuzzy),
	write('	2: '), write(T_Method_Fuzzy), nl,
	decode(method_fuzzy_membership,T_Method_Fuzzy_Membership),
	write('	3: '), write(T_Method_Fuzzy_Membership), nl,
	repeat,
	write(' > '),
	ui_read(method,Choice),
	set_uncertainty_method(Choice),
	!.

set_uncertainty_method(1)     :- !, assertz(uncertainty_method(cf)).
set_uncertainty_method(cf)    :- !, assertz(uncertainty_method(cf)).
set_uncertainty_method(2)     :- !, assertz(uncertainty_method(fuzzy)).
set_uncertainty_method(fuzzy) :- !, assertz(uncertainty_method(fuzzy)).
set_uncertainty_method(3)                 :- !, assertz(uncertainty_method(fuzzy_membership)).
set_uncertainty_method(fuzzy_membership)  :- !, assertz(uncertainty_method(fuzzy_membership)).
set_uncertainty_method(_)     :- decode(answer_error,T_Answer_Error), write(T_Answer_Error), nl, fail.

%	welcome:
%		prints the system presentation message
welcome :-
	white_lines(3),
	decode(system_presentation,T_System_Presentation),
	write(T_System_Presentation).

%	menu:
%		prints the command menu with the description of each command
menu :- 
	white_lines(1),
	decode(available_commands,T_Available_Commands),	
	write(T_Available_Commands),
	white_lines(1),
	decode(command_investigation,T_Command_Investigation),	
	write(T_Command_Investigation),
	white_lines(1),
	decode(command_control,T_Command_Control),
	write(T_Command_Control),
	white_lines(1),
	decode(command_facts,T_Command_Facts),
	write(T_Command_Facts),
	white_lines(1),
	decode(command_help,T_Command_Help),
	write(T_Command_Help),
	white_lines(1),
	decode(command_clean,T_Command_Clean),
	write(T_Command_Clean),
	white_lines(1),
	decode(command_quit,T_Command_Quit),
	write(T_Command_Quit),
	white_lines(1).

%	run(Command):
%		runs the input command

%	starts the expert in investigation mode
run(investigation) :-
	solve(investigation),
	!.
%	starts the expert in control mode
run(control) :-
	solve(control),
	!.
%	shows the facts asserted by the user
run(facts) :-
	show_facts,
	!.
%	shows the menu with the commands provided by the system
run(help) :-
	menu,
	!.
%	closes the system
run(quit) :-
	clean_memory,
	!.
%	clears the memory, deleting all facts asserted by the user or the proof trees used in previous runs
run(clean) :-
	clean_memory,
	!.
%	case in which the command typed by the user is not valid
run(_) :-
	decode(command_error,T_Command_Error),
	write(T_Command_Error).
	
%	solve(investigation):
%		starts the expert system in investigation mode, returning and printing the list of solved goals
%		sorted in descending order by certainty value.
%		At the end of the investigation, it offers the option to display the proof tree for any goal of interest.
solve(investigation) :-
	delete_trees,
	investigate_goals(Goals_List),
	descending_order_goals(Goals_List,Sorted_Goals_List),
	display_investigation(Sorted_Goals_List),
	investigation_how(Sorted_Goals_List).

%	display_investigation(Goals_List):
%		prints the result of the investigation
display_investigation(Goals_List) :-
	white_lines(3),
	decode(diagnosis,T_Diagnosis),
	write(T_Diagnosis),
	white_lines(2),
	print_goals(Goals_List),
	white_lines(2).

%	print_goals(Goals_List):
%		prints the list of goals with the certainty degree obtained for each
print_goals([]). 
print_goals([H|T]) :-
	arg(1,H,Goal),
	arg(2,H,CF),
	rule_I(_,Goal,_,Goal_Code),
	Certainty is round(CF*100),
	decode(code,T_Code),
	write(T_Code),
	write(Goal_Code),
	write(') '),
	decode(Goal,Goal_Name),
	write(Goal_Name),
	decode(certainty,T_Certainty),
	write(T_Certainty),
	write(Certainty),
	write('%'),
	white_lines(2),
	print_goals(T). 

%	investigation_how(Goals_List):
%		asks whether the user is interested in how any goal's conclusion was reached
%		and, if the answer is positive, prints the tree for the chosen goal.
investigation_how(Goals_List) :-
	ask_investigation_how(Answer),		
	check_response_investigation_how(Answer,Goals_List).

%	ask_investigation_how(Answer):
%		asks the user whether they are interested in printing the "how", returning their answer
ask_investigation_how(Answer) :-
	decode(how_request_investigation,T_How_Request_Investigation),
	write(T_How_Request_Investigation),
	get_simple_response(Answer).

%	check_response_investigation_how(Answer,Goals_List):
%		processes the user's answer regarding the request for how any solution was reached
check_response_investigation_how(yes,Goals_List) :-
	pick_goal(Goals_List,Chosen_Goal_Name),
	print_tree(Chosen_Goal_Name),
	white_lines(1),
	investigation_how(Goals_List).
check_response_investigation_how(no,_).

%	pick_goal(Goals_List,Goal_Name):
%		returns the name of the goal chosen by the user
pick_goal(Goals_List,Goal_Name) :-
	white_lines(1),
	decode(option_request,T_Option_Request),
	write(T_Option_Request),
	repeat,
	write(' > '),
	ui_read(menu,Chosen_Goal_Index),
	check_goal(Chosen_Goal_Index,Goals_List),
	parse_goal(Chosen_Goal_Index,Goal_Name),
	white_lines(2),
	!.

%	check_goal(Goal_Index,Goals_List):
%		checks that the goal chosen by the user as the answer is valid
check_goal(Goal_Index,Goals_List) :-
	integer(Goal_Index),
	Goal_Index \== 0,
	length(Goals_List,Goals_Number),
	Goal_Index =< Goals_Number.
check_goal(_,_) :-
	decode(answer_error,T_Answer_Error),
	write(T_Answer_Error),
	fail.

%	parse_goal(Goal_Index,Goal_Name):
%		returns the name of the goal starting from the index
parse_goal(Goal_Index,Goal_Name) :-
	rule_I(_,Goal_Name,_,Goal_Index).

%	solve(control):
%		starts the expert system in control mode, returning and printing the chosen goal with its certainty degree.
%		At the end of the investigation, it offers the option to display the proof tree.
solve(control) :-
	selection_goal(Goal_Name),	
	delete_tree(Goal_Name),
	solve_goal(Goal_Name,CF),
	display_control(Goal_Name,CF),
	control_how(Goal_Name).

%	selection_goal(Goal):
%		returns the goal chosen by the user from a list of possible goals
selection_goal(Goal_Name) :-
	white_lines(1),	
	decode(goal_request,T_Goal_Request),
	write(T_Goal_Request),
	write('?'),
	white_lines(1),
	goals_list(Goals_List),
	show_options(Goals_List),
	get_goal(Goal_Name,Goals_List),
	white_lines(1).

%	get_goal(Goal_Name,Goals_List):
%		returns the name of the goal selected by the user
get_goal(Goal_Name,Goals_List) :-
	white_lines(1),
	decode(option_request,T_Option_Request),
	write(T_Option_Request),
	repeat,
	write(' > '),
	ui_read(menu,Goal_Index),
	check_selection_goal(Goal_Index,Goals_List),
	parse_response(1,Goal_Index,Goal_Name,Goals_List),
	!.

%	check_selection_goal(Goal_Index,Goals_List):
%		checks that the input goal is present in the list
check_selection_goal(Goal_Index,Goals_List) :-
	integer(Goal_Index),
	Goal_Index \== 0,
	length(Goals_List,Goals_Number),
	Goal_Index =< Goals_Number,
	!.
check_selection_goal(_,_) :-
	decode(answer_error,T_Answer_Error),
	write(T_Answer_Error),
	fail.
	
%	display_control(Goal,CF):
%		prints the result of the control
display_control(Goal,CF) :-
	white_lines(2),
	decode(diagnosis,T_Diagnosis),
	write(T_Diagnosis),
	white_lines(2),
	decode(diagnosis_result,T_Diagnosis_Result),
	write(T_Diagnosis_Result),
	decode(Goal,Goal_Name),
	write(Goal_Name),
	decode(certainty,T_Certainty),
	write(T_Certainty),
	Certainty is round(CF*100),
	write(Certainty),
	write('%'),
	white_lines(2).

%	control_how(Goal):
%		asks whether the user is interested in how the conclusion of the input goal was reached and,
%		if the answer is positive, prints the tree for the chosen goal.
control_how(Goal) :-
	ask_control_how(Answer),
	check_response_control_how(Answer,Goal).

%	ask_control_how(Answer):
%		asks the user whether they are interested in printing the "how", returning their answer
ask_control_how(Answer) :-
	decode(how_request_control,T_How_Request_Control),
	write(T_How_Request_Control),
	get_simple_response(Answer).

%	check_response_control_how(Answer,Goal):
%		processes the user's answer regarding the request for how the goal's solution was reached
check_response_control_how(yes,Goal) :-
	white_lines(1),
	print_tree(Goal).
check_response_control_how(no,_).
