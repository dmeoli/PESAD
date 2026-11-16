%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		bot_io.pl
%
%	description:
%		I/O abstraction layer that lets the very same inference engine run in
%		two front-ends without touching the knowledge base:
%		  - terminal mode (default): input is read with read/1 and output is
%		    written to the console exactly as before;
%		  - bot mode: each consultation runs inside a dedicated worker thread
%		    whose console output is captured and whose input requests are
%		    served, one turn at a time, through a pair of message queues.
%		    This is what makes the otherwise blocking Prolog REPL suspendable
%		    and resumable from an asynchronous Telegram bot.
%
%		The only change required in the engine/shell is to replace each
%		interactive read/1 with ui_read(Kind, Term): Kind tells the front-end
%		which kind of answer is expected (so it can render the right keyboard),
%		while in terminal mode it is simply ignored.
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- use_module(library(prolog_stream)).
:- use_module(library(http/json)).

% io_mode(terminal) | io_mode(bot): global for the whole process. The terminal
% bootstrap (start.pl) leaves the default; the bot bootstrap switches it once.
:- dynamic io_mode/1.
io_mode(terminal).

% Per-worker plumbing (only ever populated in bot mode).
:- thread_local outbuf/1.        % accumulated console output of this worker
:- thread_local session_io/2.    % session_io(InQueue, OutQueue) of this worker
:- thread_local current_topic/1. % what the pending question is about (ui_topic/1)

%	finish_main:
%		closes main/0. In terminal mode it halts the process as before; in bot
%		mode it just succeeds so the worker thread can flush its last message.
finish_main :- io_mode(bot), !.
finish_main :- halt.


%--------------------------------OUTPUT CAPTURE-------------------------------%
% prolog_stream callbacks. open_prolog_stream/4 calls user:stream_write/2 for
% write streams and user:stream_read/2 for read streams.

%	stream_write(+Stream, +String):
%		append the freshly written text to this worker's output buffer
stream_write(_Stream, String) :-
	( retract(outbuf(Old)) -> true ; Old = "" ),
	string_concat(Old, String, New),
	assertz(outbuf(New)).

%	stream_read(+Stream, -Text):
%		the redirected input stream is only there to absorb any stray read/1
%		that does not go through ui_read/2: always report end-of-file.
stream_read(_Stream, "").

stream_close(_Stream).

%	bot_redirect_io:
%		called once at the start of every worker thread to rebind its
%		user_input/user_output/user_error to the prolog_stream callbacks above.
bot_redirect_io :-
	retractall(outbuf(_)),
	assertz(outbuf("")),
	open_prolog_stream(user, write, Out, []),
	open_prolog_stream(user, read, In, []),
	set_prolog_IO(In, Out, Out).

%	take_output(-Text):
%		flush and return everything written since the previous turn, then reset
take_output(Text) :-
	flush_output(user_output),
	( retract(outbuf(Old)) -> Text = Old ; Text = "" ),
	assertz(outbuf("")).


%--------------------------------INPUT ABSTRACTION----------------------------%

%	ui_read(+Kind, -Term):
%		obtain the next answer. Kind is one of:
%		  language | method | command | simple | criterion | certainty
%		  | menu | menu_why | number
%		In terminal mode Kind is ignored and a Prolog term is read as usual.
%		In bot mode the turn sent out is turn(Kind, Text, Topic), where Text
%		is the console output since the previous turn and Topic is the JSON
%		description of the question (see topic_json/2).
ui_read(_Kind, Term) :-
	io_mode(terminal),
	!,
	read(Term).
ui_read(Kind, Term) :-
	session_io(In, Out),
	take_output(Text),
	topic_json(Kind, Topic),
	thread_send_message(Out, turn(Kind, Text, Topic)),
	thread_get_message(In, answer(Raw)),
	parse_answer(Raw, Term).

%	parse_answer(+Raw, -Term):
%		turn the raw string coming from Telegram into the term the existing
%		check predicates expect: a number when it looks like one (menu index,
%		certainty, graded value), otherwise an atom (yes/no/why/command/...).
%		atom_string is used instead of term_string so that capitalised or
%		multi-word payloads can never be misread as Prolog variables/operators.
parse_answer(Raw, Term) :-
	( number_string(Number, Raw)
	-> Term = Number
	;  atom_string(Term, Raw) ).


%-------------------------------SCREEN TOPICS---------------------------------%
% Besides the console text, every turn carries a structured description of the
% pending question (a JSON string), so a front-end such as the web API can show
% it without parsing the console output. The engine names the topic right
% before asking, with ui_topic/1; ui_read/2 serialises it only if it matches
% the kind of answer requested, otherwise the topic is the empty string.

%	ui_topic(+Topic):
%		record what the next question is about. Topic is one of
%		  item(Attribute, Item)       criterion question (yes/no)
%		  certainty(Key)              certainty degree of the last answer
%		  choice(Attribute, Options)  multiple-choice question
%		  graded(Variable)            numeric (graded) value, with typical values
%		  diagnosis(Goals)            ranked goal(Goal, CF) list of a run
ui_topic(Topic) :-
	retractall(current_topic(_)),
	assertz(current_topic(Topic)).

%	topic_json(+Kind, -Json):
%		the JSON description of the current topic, localized in the session
%		language, or "" when there is no topic for this kind of answer.
topic_json(Kind, Json) :-
	current_topic(Topic),
	topic_dict(Kind, Topic, Dict),
	!,
	atom_json_dict(Json, Dict, [as(string), width(0)]).
topic_json(_Kind, "").

topic_dict(criterion, item(_Attribute, Item),
	   _{type: criterion, id: Item, text: Text, why: Why,
	     options: Options}) :-
	question_text(Item, Text),
	explanation_or_null(Item, Why),
	decode(answer_yes, Yes),
	decode(answer_no, No),
	Options = [_{value: yes, label: Yes}, _{value: no, label: No}].
topic_dict(certainty, certainty(Key),
	   _{type: certainty, id: Key, text: Text, help: Help}) :-
	decode(certainty_request, Request),
	normalize_space(string(Text), Request),
	decode(certainty_hint, Help).
topic_dict(menu_why, choice(Attribute, Options_List),
	   _{type: choice, id: Attribute, text: Text, why: Why,
	     options: Options}) :-
	question_text(Attribute, Text),
	explanation_or_null(Attribute, Why),
	findall(_{value: Option, label: Label},
		( member(Option, Options_List), decode(Option, Label) ),
		Options).
topic_dict(number, graded(Variable),
	   _{type: number, id: Variable, text: Text, options: Options}) :-
	question_text(Variable, Text),
	graded_options(Variable, Values),
	findall(_{value: Value, label: Value},
		( member(Number, Values), format(string(Value), '~w', [Number]) ),
		Options).
topic_dict(simple, diagnosis(Goals),
	   _{type: diagnosis, title: Title, goals: Items, ranking: Ranking,
	     none: None, disclaimer: Disclaimer}) :-
	decode(diagnosis, Banner),
	split_string(Banner, "", "= ", [Title]),
	findall(_{id: Goal, name: Name, code: Code, certainty: Certainty,
		  tree: Tree},
		( member(goal(Goal, CF), Goals),
		  decode(Goal, Name),
		  ( rule_I(_, Goal, _, Code) -> true ; Code = null ),
		  Certainty is round(CF*100),
		  (   with_output_to(string(Tree), print_tree(Goal))
		  ->  true
		  ;   Tree = ""
		  ) ),
		Items),
	decode(ranking_note, Ranking),
	decode(no_diagnosis, None),
	decode(disclaimer, Disclaimer).

%	question_text(+Key, -Text):
%		the localized question for Key, ending with a question mark.
question_text(Key, Text) :-
	decode(Key, Label),
	atomic_list_concat([Label, '?'], Text).

%	explanation_or_null(+Key, -Text):
%		the "why" explanation of Key in the session language, or null.
explanation_or_null(Key, Text) :-
	language(Language),
	explanation(Language, Key, Text),
	!.
explanation_or_null(_Key, null).
