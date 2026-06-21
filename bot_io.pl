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

% io_mode(terminal) | io_mode(bot): global for the whole process. The terminal
% bootstrap (start.pl) leaves the default; the bot bootstrap switches it once.
:- dynamic io_mode/1.
io_mode(terminal).

% Per-worker plumbing (only ever populated in bot mode).
:- thread_local outbuf/1.        % accumulated console output of this worker
:- thread_local session_io/2.    % session_io(InQueue, OutQueue) of this worker

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
ui_read(_Kind, Term) :-
	io_mode(terminal),
	!,
	read(Term).
ui_read(Kind, Term) :-
	session_io(In, Out),
	take_output(Text),
	thread_send_message(Out, turn(Kind, Text)),
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
