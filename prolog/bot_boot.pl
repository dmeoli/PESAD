%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		bot_boot.pl
%
%	description:
%		Bootstrap for the Telegram front-end. It mirrors start.pl but with two
%		differences that make the engine safe to share between many concurrent
%		chats and drivable from Python:
%		  1. the runtime/working-memory predicates are declared thread_local
%		     instead of dynamic, so every worker thread (one per chat) gets its
%		     own isolated copy of the proof trees, facts, indexes and the
%		     chosen language / uncertainty method;
%		  2. it does NOT call main/0 - the consultation is launched per chat by
%		     bot_start/3 (see bot_session.pl), driven over the MQI by Python.
%
%		Files are loaded by absolute path (relative to this file) so the
%		bootstrap can be consulted regardless of the MQI server's working dir.
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Per-session (per-worker) runtime state: isolated through thread_local.
:- thread_local last_level_I_index/1, last_level_II_index/1,
                last_level_III_index/1, last_level_IV_index/1.
:- thread_local language/1.
:- thread_local uncertainty_method/1.
:- thread_local known/4, fact/8, rule_I/4, rule_II/5, rule_III/6.
:- thread_local known_value/2.

% label/3 and explanation/3 are contributed by both locale files (shared, RO).
:- multifile label/3, explanation/3.
:- discontiguous label/3, explanation/3.

:- ensure_loaded(library(lists)).

:- style_check(-singleton).
:- style_check(-discontiguous).

%	load_pesad:
%		reconsult every component by absolute path, in the same order as the
%		terminal bootstrap, then add the bot session layer.
load_pesad :-
	prolog_load_context(directory, Dir),
	forall(member(File, [ 'interface_en.pl',
	                      'interface_it.pl',
	                      'bot_io.pl',
	                      'utils.pl',
	                      'uncertainty.pl',
	                      'fuzzy.pl',
	                      'memory.pl',
	                      'ask.pl',
	                      'explanation.pl',
	                      'shell.pl',
	                      'disorders.pl',
	                      'criteria.pl',
	                      'bot_session.pl' ]),
	       ( atomic_list_concat([Dir, '/', File], Path),
	         reconsult(Path) )).

:- load_pesad.

% Switch the I/O layer to bot mode for the whole process.
:- retractall(io_mode(_)), assertz(io_mode(bot)).
