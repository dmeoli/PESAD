%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		bot_session.pl
%
%	description:
%		Session lifecycle for the Telegram front-end, exposed to Python over the
%		SWI-Prolog Machine Query Interface (library(mqi)).
%
%		Each Telegram chat owns one worker thread that runs the ordinary main/0
%		consultation. Because every interactive read now goes through
%		ui_read/2 (see bot_io.pl), the worker naturally blocks on its input
%		queue whenever it needs an answer, and resumes when Python posts one.
%		The session-state predicates are thread_local (declared in bot_boot.pl)
%		so concurrent chats never see each other's facts.
%
%		API (all deterministic, all quick - they only hand messages over):
%		  bot_start(+SessionId, -Kind, -Text)
%		  bot_answer(+SessionId, +Raw, -Kind, -Text)
%		  bot_cancel(+SessionId)
%		Kind is the answer kind the front-end must render (see bot_io.pl), or
%		the atom 'final' when the consultation is over and Text is its epilogue.
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Global registry shared between the MQI thread(s) and the worker threads.
:- dynamic session_queue/3.    % session_queue(SessionId, InQueue, OutQueue)
:- dynamic session_thread/2.   % session_thread(SessionId, ThreadId)

%	bot_start(+SessionId, -Kind, -Text):
%		(re)start a consultation for SessionId and return its first turn.
bot_start(SessionId, Kind, Text) :-
	cleanup_session(SessionId),
	message_queue_create(In),
	message_queue_create(Out),
	assertz(session_queue(SessionId, In, Out)),
	thread_create(worker_main(SessionId), Tid, [detached(true)]),
	assertz(session_thread(SessionId, Tid)),
	next_turn(Out, Kind, Text),
	maybe_finalize(SessionId, Kind).

%	bot_answer(+SessionId, +Raw, -Kind, -Text):
%		deliver the user's raw answer to the worker and return the next turn.
bot_answer(SessionId, Raw, Kind, Text) :-
	session_queue(SessionId, In, Out),
	!,
	thread_send_message(In, answer(Raw)),
	next_turn(Out, Kind, Text),
	maybe_finalize(SessionId, Kind).
bot_answer(_SessionId, _Raw, expired,
	   "Session expired. Send /start to begin a new consultation.").

%	bot_cancel(+SessionId):
%		abort and forget a running consultation.
bot_cancel(SessionId) :-
	cleanup_session(SessionId).

%	next_turn(+OutQueue, -Kind, -Text):
%		block until the worker emits its next turn (a prompt or the epilogue).
next_turn(Out, Kind, Text) :-
	thread_get_message(Out, Msg),
	( Msg = turn(K, T)  -> Kind = K, Text = T
	; Msg = final(T)    -> Kind = final, Text = T
	; /* otherwise */      Kind = final, Text = "Internal error." ).

%	maybe_finalize(+SessionId, +Kind):
%		once the worker reported 'final', drop its (now idle) queues. The thread
%		is already exiting, so it is not signalled, only forgotten.
maybe_finalize(SessionId, final) :-
	!,
	retractall(session_thread(SessionId, _)),
	forget_queues(SessionId).
maybe_finalize(_SessionId, _Kind).

%	worker_main(+SessionId):
%		body of a worker thread: bind its queues, redirect I/O, initialise the
%		per-session state, run the standard consultation and always flush a
%		final message (so the MQI side never blocks forever).
worker_main(SessionId) :-
	session_queue(SessionId, In, Out),
	assertz(session_io(In, Out)),
	bot_redirect_io,
	init_session_state,
	( catch(main, Error, report_worker_error(Error)) -> true ; true ),
	( catch(take_output(Final), _, fail) -> true ; Final = "" ),
	catch(thread_send_message(Out, final(Final)), _, true).

%	init_session_state:
%		seed the level indexes this worker needs. They have static initial
%		clauses in uncertainty.pl, but those are thread_local and therefore not
%		visible to worker threads, so each worker plants its own.
init_session_state :-
	assertz(last_level_I_index(1)),
	assertz(last_level_II_index(1)),
	assertz(last_level_III_index(1)),
	assertz(last_level_IV_index(1)).

%	report_worker_error(+Error):
%		surface an unexpected engine error to the user instead of dying silently
%		(a session_cancelled exception, raised by cleanup_session, is expected).
report_worker_error(session_cancelled) :- !.
report_worker_error(Error) :-
	message_to_codes(prolog, Error, Codes),
	string_codes(Msg, Codes),
	format("~n[engine error] ~w~n", [Msg]).

%	cleanup_session(+SessionId):
%		stop a still-running worker and discard its queues. Idempotent.
cleanup_session(SessionId) :-
	( retract(session_thread(SessionId, Tid))
	-> catch(thread_signal(Tid, throw(session_cancelled)), _, true)
	;  true ),
	forget_queues(SessionId).

%	forget_queues(+SessionId):
%		destroy and unregister a session's message queues.
forget_queues(SessionId) :-
	( retract(session_queue(SessionId, In, Out))
	-> catch(message_queue_destroy(In), _, true),
	   catch(message_queue_destroy(Out), _, true)
	;  true ).
