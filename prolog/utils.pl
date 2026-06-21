%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		utils.pl
%
%	description:
%		General-purpose utility predicates (output spacing, list helpers).
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 	white_lines(Newlines_Number):
%		prints a number of blank lines depending on the value specified as input
white_lines(Newlines_Number) :-
	white_line(Newlines_Number,0).

white_line(Newlines_Number,Counter) :-
	Counter < Newlines_Number,
	!,
	nl,
	Updated_Counter is Counter+1,
	white_line(Newlines_Number,Updated_Counter).
white_line(Newlines_Number,Counter).

%	add_element(X,L,L1)
%		adds element X to the list L obtaining L1
add_element(Element,List,[Element|List]).

%	delete_element(X,L,L1)
%		removes element X from the list L obtaining L1
delete_element(Element,[],[]).
delete_element(Element,[Element|List_Rest],List_Rest) :-
	!.
delete_element(Element,[Head|Tail],[Head|List_Rest]) :-
	delete_element(Element,Tail,List_Rest).
