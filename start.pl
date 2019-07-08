%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                            
%	nome: 
%		start.pl
%                                                                           
%	descrizione: 
%		il modulo start ha il compito di avviare il Sistema Esperto dopo aver fornito alcune direttive all'interprete
%       Prolog e aver caricato i moduli di cui si compone.
%                                       									    
%	autore: 
%		Donato Meoli
%      								            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%	Direttive per l'interprete prolog
:- source.		
:- dynamic ultimo_indice_I_livello/1, ultimo_indice_II_livello/1, ultimo_indice_III_livello/1, ultimo_indice_IV_livello/1.
:- ensure_loaded(library(lists)).

%	Caricamento dei moduli
:- reconsult('interface_it.pl').
:- reconsult('inference_engine.pl').
:- reconsult('anxiety_disorders.pl').


%	Avvio del sistema
:- main.
