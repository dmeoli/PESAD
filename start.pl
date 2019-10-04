%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		start.pl
%                                                                           
%	description:
%		Il modulo start ha il compito di avviare il sistema esperto dopo aver fornito alcune
%       direttive all'interprete Prolog e aver caricato i moduli di cui si compone.
%                                       									    
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- dynamic ultimo_indice_I_livello/1, ultimo_indice_II_livello/1, ultimo_indice_III_livello/1, ultimo_indice_IV_livello/1.
:- ensure_loaded(library(lists)).

:- style_check(-singleton).
:- style_check(-discontiguous).

:- reconsult('interface_it.pl').
:- reconsult('inference_engine.pl').
:- reconsult('anxiety_disorders.pl').

:- main.