%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		start.pl
%
%	description:
%		Bootstrap module: it sets a few directives for the Prolog interpreter,
%		loads the modules the system is composed of and starts the expert system.
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Runtime-asserted predicates.
:- dynamic last_level_I_index/1, last_level_II_index/1, last_level_III_index/1, last_level_IV_index/1.
:- dynamic language/1.
:- dynamic uncertainty_method/1.
:- dynamic known/4, fact/8, rule_I/4, rule_II/5, rule_III/6.
:- dynamic known_value/2.

% label/3 and explanation/3 are contributed by both locale files.
:- multifile label/3, explanation/3.
:- discontiguous label/3, explanation/3.

:- ensure_loaded(library(lists)).

:- style_check(-singleton).
:- style_check(-discontiguous).

% Localization (interface) data.
:- reconsult('interface_en.pl').
:- reconsult('interface_it.pl').

% Inference engine.
:- reconsult('bot_io.pl').
:- reconsult('utils.pl').
:- reconsult('uncertainty.pl').
:- reconsult('fuzzy.pl').
:- reconsult('memory.pl').
:- reconsult('ask.pl').
:- reconsult('explanation.pl').
:- reconsult('shell.pl').

% Knowledge base.
:- reconsult('disorders.pl').
:- reconsult('criteria.pl').

:- main.
