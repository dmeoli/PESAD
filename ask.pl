%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		ask.pl
%
%	description:
%		Knowledge acquisition: the three question protocols used to gather
%		information from the user (criterion ask, multiple ask, selective ask),
%		with answer parsing, validation and certainty elicitation.
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%	get_simple_response(Answer):
%		returns the user's answer to a yes/no question
get_simple_response(Answer) :-
	repeat,
	write('? '),
	decode(yes_no_hint,T_Yes_No_Hint),
	write(T_Yes_No_Hint),
	write(' > '), 
	read(User_Answer), 
	check_format_simple_response(User_Answer,Answer), 
	!.

%	check_format_simple_response(Answer,Y):
%		checks that the answer typed by the user is valid and, if so, returns it in a standard format
check_format_simple_response(si,Y) :-
	Y=yes, 
	!.
check_format_simple_response(s,Y) :-
	Y=yes, 
	!.
check_format_simple_response(yes,Y) :-
	Y=yes, 
	!.
check_format_simple_response(y,Y) :-
	Y=yes, 
	!.
check_format_simple_response(no,Y) :-
	Y=no, 
	!.
check_format_simple_response(n,Y) :-
	Y=no, 
	!.
check_format_simple_response(not,Y) :-
	Y=no, 
	!.
check_format_simple_response(_,_) :-
	decode(answer_error,T_Answer_Error),
	write(T_Answer_Error),
	fail.
	
%	criterion_ask(Attribute,Items_List,Required_Items_Number,Certainty):
%		verifies a "criterion" that can be composed of one or more items.
%		Each item consists of a question to which the user can answer "yes" or "no".
%		A criterion of N items (with N>=1) may require that M items be verified (with 1<=M<=N).
%		The criterion's certainty is computed by first selecting the set of certainties of the M required items and then
%		taking the lowest certainty from the obtained set.
%		E.g., N=3 {item1 0.4 - item2 0.7 - item3 0.6}; M=2 {item2 0.7 - item3 0.6}; Certainty=0.6
criterion_ask(Attribute,Items_List,Required_Items_Number,Certainty) :-
	once(ask_question(Attribute,Items_List,Required_Items_Number,Certainty,[])).

%	Loops over the items until the list is empty. Once the loop ends, computes the criterion's certainty
ask_question(Attribute,[],Required_Items_Number,Certainty,Facts_List) :-
	compute_certainty_criterion_ask(Attribute,Required_Items_Number,Certainty,Facts_List).
ask_question(Attribute,[Item|Remaining_Items],Required_Items_Number,Certainty,Facts_List) :-
	known_question_condition(Attribute,Item,Remaining_Items,Required_Items_Number,Certainty,Facts_List).

%	If there is already a positive answer for the n-th item, takes the certainty value and moves on to examine the next item
known_question_condition(Attribute,Item,Remaining_Items,Required_Items_Number,Certainty,Facts_List) :-
	known(yes,Attribute,Item,Answer_Certainty),
	!,
	add_element(fact(yes,Item,Answer_Certainty),Facts_List,Updated_Facts_List),
	ask_question(Attribute,Remaining_Items,Required_Items_Number,Certainty,Updated_Facts_List).
%	If there is already a negative answer for the n-th item, computes the certainty value and moves on to examine the next item
known_question_condition(Attribute,Item,Remaining_Items,Required_Items_Number,Certainty,Facts_List) :-
	known(no,Attribute,Item,Answer_Certainty),
	!,
	Computed_Answer_Certainty is 1-Answer_Certainty,
	add_element(fact(yes,Item,Computed_Answer_Certainty),Facts_List,Updated_Facts_List),
	ask_question(Attribute,Remaining_Items,Required_Items_Number,Certainty,Updated_Facts_List).
%	Asks the user the question
known_question_condition(Attribute,Item,Remaining_Items,Required_Items_Number,Certainty,Facts_List) :-	
	white_lines(2),
	decode(Item,Extended_Item),
	write(Extended_Item),
	get_criterion_response(Answer),
	check_type_criterion_response(Answer,Attribute,Item,Remaining_Items,Required_Items_Number,Certainty,Facts_List).

%	get_criterion_response(Answer):
%		asks for and obtains an answer from the user to a yes/no/why question
get_criterion_response(Answer) :-
	repeat,
	write('? '),
	decode(yes_no_hint,T_Yes_No_Hint2),
	write(T_Yes_No_Hint2),
	write(' > '), 
	read(User_Answer), 
	check_format_criterion_response(User_Answer,Answer), 
	!.

%	check_format_criterion_response(User_Answer,Answer):
%		checks that the answer typed by the user is valid and, if so, returns it in a standard format
check_format_criterion_response(si,Y) :-
	Y=yes, 
	!.
check_format_criterion_response(s,Y) :-
	Y=yes, 
	!.
check_format_criterion_response(yes,Y) :-
	Y=yes, 
	!.
check_format_criterion_response(y,Y) :-
	Y=yes, 
	!.
check_format_criterion_response(no,Y) :-
	Y=no, 
	!.
check_format_criterion_response(n,Y) :-
	Y=no, 
	!.
check_format_criterion_response(not,Y) :-
	Y=no, 
	!.
check_format_criterion_response(perche,Y) :-
	Y=why, 
	!.
check_format_criterion_response(p,Y) :-
	Y=why, 
	!.
check_format_criterion_response(why,Y) :-
	Y=why, 
	!.
check_format_criterion_response(_,_) :-
	decode(answer_error,T_Answer_Error),
	write(T_Answer_Error),
	fail.

%	check_type_criterion_response(Answer,Attribute,Item,Remaining_Items,Required_Items_Number,Certainty,Facts_List):
%		processes the answer given by the user.
check_type_criterion_response(yes,Attribute,Item,Remaining_Items,Required_Items_Number,Certainty,Facts_List) :-
	ask_certainty(Answer_Certainty),
	asserta(known(yes,Attribute,Item,Answer_Certainty)),
	add_element(fact(yes,Item,Answer_Certainty),Facts_List,Updated_Facts_List),
	ask_question(Attribute,Remaining_Items,Required_Items_Number,Certainty,Updated_Facts_List).
check_type_criterion_response(no,Attribute,Item,Remaining_Items,Required_Items_Number,Certainty,Facts_List) :-
	ask_certainty(Answer_Certainty),
	asserta(known(no,Attribute,Item,Answer_Certainty)),
	Computed_Answer_Certainty is 1-Answer_Certainty,
	add_element(fact(yes,Item,Computed_Answer_Certainty),Facts_List,Updated_Facts_List),
	ask_question(Attribute,Remaining_Items,Required_Items_Number,Certainty,Updated_Facts_List).
check_type_criterion_response(why,Attribute,Item,Remaining_Items,Required_Items_Number,Certainty,Facts_List) :-
	explain(Item,Explanation),
	write(Explanation),
	known_question_condition(Attribute,Item,Remaining_Items,Required_Items_Number,Certainty,Facts_List).

%	ask_certainty(Certainty):
%		returns the degree of certainty the user associates with the answer
ask_certainty(Certainty) :-
	white_lines(1),
	decode(certainty_request,T_Certainty_Request),
	write(T_Certainty_Request),
	repeat,
	decode(certainty_hint,T_Certainty_Hint),
	write(T_Certainty_Hint),
	write(' >'),
	read(Certainty),
	check_certainty(Certainty),
	!.

%	check_certainty(Certainty):
%		checks that the certainty value typed by the user is correct
check_certainty(Certainty) :-
	float(Certainty),
	Certainty =< 1.0,
	Certainty >= 0.0,
	!.
check_certainty(_) :-
	decode(certainty_error,T_Certainty_Error),
	write(T_Certainty_Error),
	fail.

%	compute_certainty_criterion_ask(Attribute,Required_Items_Number,Certainty,Facts_List):
%		computes the criterion's certainty.
%		From the list of certainties it takes the M highest ones, with M equal to the number of items required by the criterion.
%		From the M certainties it takes the lowest certainty.
compute_certainty_criterion_ask(Attribute,Required_Items_Number,Certainty,Facts_List) :-
	descending_order_facts(Facts_List,Sorted_Facts_List),
	get_certainty_criterion(Attribute,Required_Items_Number,Certainty,Sorted_Facts_List,1,[]).

%	From the list of facts sorted by certainty value, takes the first M facts required by the criterion.
get_certainty_criterion(Attribute,Required_Items_Number,Certainty,Sorted_Facts_List,Counter,Candidate_Facts_List) :-
	Counter =< Required_Items_Number,
	!,
	Sorted_Facts_List = [Max_Certainty_Fact|Sorted_Facts_List_Rest],
	add_element(Max_Certainty_Fact,Candidate_Facts_List,Updated_Candidate_Facts_List),
	Updated_Counter is Counter+1,
	assert_fact(Attribute,Max_Certainty_Fact),
	get_certainty_criterion(Attribute,Required_Items_Number,Certainty,Sorted_Facts_List_Rest,Updated_Counter,Updated_Candidate_Facts_List).
%	From the M candidate facts takes the one with the lowest certainty, which will determine the criterion's final certainty.
get_certainty_criterion(_,_,Certainty,_,_,Candidate_Facts_List) :-
	ascending_order_facts(Candidate_Facts_List,Sorted_Candidate_Facts_List),
	Sorted_Candidate_Facts_List = [Min_Certainty_Fact|_],
	arg(3,Min_Certainty_Fact,Certainty).

%	multiple_ask(Attribute,Options_List,Allowed_Options_List,Certainty):
%		allows asking questions in which the answer must be chosen from a list of possible values.
%		If the answer is one of those allowed by the question, then the certainty equals the one typed by the user,
%		otherwise it is given by the ratio between the complement of the certainty of the user's answer and the remaining options.
%		E.g. Question 1; Answers: a, b, c; Allowed Answers: a; User Answer: c with Certainty 0.7; Certainty = (1-0.7)/2
multiple_ask(Attribute,Options_List,Allowed_Options_List,Certainty) :-
	known(yes,Attribute,Answer,Answer_Certainty),
	!,
	compute_certainty_multiple_ask(Attribute,Certainty,Answer,Answer_Certainty,Options_List,Allowed_Options_List).
multiple_ask(Attribute,Options_List,Allowed_Options_List,Certainty) :-
	white_lines(2),	
	decode(Attribute,Extended_Attribute),
	write(Extended_Attribute),
	write('?'),
	white_lines(1),
	show_options(Options_List),
	get_multiple_response(Chosen_Option,Encoded_Chosen_Option,Options_List),
	check_type_multiple_response(Encoded_Chosen_Option,Answer,Attribute,Options_List,Allowed_Options_List,Certainty).

%	show_options(Options_List):
%		prints the various options of the question under examination	
show_options(Options_List) :-
	show_option(1,Options_List).

show_option(_,[]).
show_option(N,[Option|Remaining_Options_List]) :-
	write('\t'),
	write(N),
	write(': '),
	decode(Option,Extended_Option),
	write(Extended_Option),
	white_lines(1), 
	NN is N+1,
	show_option(NN,Remaining_Options_List).

%	get_multiple_response(Chosen_Option,Answer,Options_List):
%		asks for and obtains an answer from the user for a multiple-choice question
get_multiple_response(Chosen_Option,Answer,Options_List) :-
	white_lines(1),
	decode(option_request,T_Option_Request),
	write(T_Option_Request),
	repeat,
	write(' > '),
	read(Chosen_Option),
	check_multiple_response(Chosen_Option,Answer,Options_List),
	!.

%	check_multiple_response(Chosen_Option,Answer,Options_List):
%		checks that the option chosen by the user as the answer is valid
check_multiple_response(Chosen_Option,Answer,Options_List) :-
	integer(Chosen_Option),
	Chosen_Option \== 0,
	length(Options_List,Options_Number),
	Chosen_Option =< Options_Number,
	!,
	Answer = Chosen_Option.
check_multiple_response(perche,why,_) :-
	!.
check_multiple_response(p,why,_) :-
	!.
check_multiple_response(why,why,_) :-
	!.
check_multiple_response(_,_,_) :-
	decode(answer_error,T_Answer_Error),
	write(T_Answer_Error),
	fail.

%	check_type_multiple_response(Chosen_Option,Answer,Attribute,Options_List,Allowed_Options_List,Certainty):
%		processes the user's answer
check_type_multiple_response(why,_,Attribute,Options_List,Allowed_Options_List,Certainty) :-
	!,
	explain(Attribute,Explanation),
	write(Explanation),
	multiple_ask(Attribute,Options_List,Allowed_Options_List,Certainty).
check_type_multiple_response(Chosen_Option,Answer,Attribute,Options_List,Allowed_Options_List,Certainty) :-
	parse_response(1,Chosen_Option,Answer,Options_List),
	ask_certainty(Answer_Certainty),
	asserta(known(yes,Attribute,Answer,Answer_Certainty)),
	compute_certainty_multiple_ask(Attribute,Certainty,Answer,Answer_Certainty,Options_List,Allowed_Options_List).

%	parse_response(Counter,Chosen_Option,Answer,Options_List):
%		returns the option chosen by the user via the number selected from the menu
parse_response(Num,Num,Option,[Option|_]).
parse_response(Counter,Num,Answer,[_|Remaining_Options_List]) :-
	Updated_Counter is Counter+1,
	parse_response(Updated_Counter,Num,Answer,Remaining_Options_List).

%	compute_certainty_multiple_ask(Attribute,Certainty,Answer,Answer_Certainty,Options_List,Allowed_Options_List):
%		computes the certainty for a multiple-choice question.
%		If the answer is one of those allowed by the question, then the certainty equals the one typed by the user,
%		otherwise it is given by the ratio between the complement of the certainty of the user's answer and the remaining options.
compute_certainty_multiple_ask(Attribute,Certainty,Answer,Answer_Certainty,_,Allowed_Options_List) :-
	member(Answer,Allowed_Options_List),
	!,
	Certainty = Answer_Certainty,
	assert_fact_multiple_ask(Attribute,Answer,Answer_Certainty).
compute_certainty_multiple_ask(Attribute,Certainty,_,Answer_Certainty,Options_List,Allowed_Options_List) :-
	Allowed_Options_List = [Answer|_],
	length(Options_List,Options_Number),
	Certainty is (1-Answer_Certainty)/(Options_Number-1),
	assert_fact_multiple_ask(Attribute,Answer,Certainty).

%	selective_ask(Attribute,Allowed_Option,Options_List):
%		allows asking questions in which the answer must be chosen selectively from a list of possible values.
%		Note that if the chosen option is not the correct one for the question under examination, a failure occurs.
selective_ask(Attribute,Allowed_Option,_) :-
	known(yes,Attribute,Allowed_Option,_),
	!.
selective_ask(Attribute,_,_) :-
	known(yes,Attribute,_,_),
	!,
	fail.
selective_ask(Attribute,Allowed_Option,Options_List) :-
	white_lines(1),
	decode(Attribute,Extended_Attribute),
	write(Extended_Attribute),
	white_lines(1),
	show_options(Options_List),
	get_multiple_response(Chosen_Option,Encoded_Chosen_Option,Options_List),
	check_type_selective_response(Encoded_Chosen_Option,Answer,Attribute,Options_List,Allowed_Option).

%	check_type_selective_response(Chosen_Option,Answer,Attribute,Options_List,Allowed_Option):
%		processes the user's answer.
check_type_selective_response(why,_,Attribute,Options_List,Allowed_Option) :-
	!,
	explain(Attribute,Explanation),
	write(Explanation),
	white_lines(1),
	selective_ask(Attribute,Allowed_Option,Options_List).
check_type_selective_response(Chosen_Option,Answer,Attribute,Options_List,Allowed_Option) :-
	parse_response(1,Chosen_Option,Answer,Options_List),
	asserta(known(yes,Attribute,Answer,1.0)),
	Allowed_Option = Answer.
