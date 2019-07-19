%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                            
%	nome: 
%		anxiety_disorders.pl
%                                                                             
%	descrizione: 
%		Il modulo anxiety_disorders contiene la base di conoscenza del Sistema Esperto.
%		I disturbi d'ansia, codificati nella presente base di conoscenza, si riferiscono ai disturbi d'ansia di Asse I 
%		previsti dal DSM-IV-TR.                                     
%                                                                             
%	fonte: 
%		DSM-IV-TR Diagnostic and Statistical Manual of Mental Disorders (American Psychiatric Association)
% 								             
%	autore: 
%		Donato Meoli
%       								             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Diagnosi di controllo su un singolo disturbo
solve_goal(Y,CF):-
	paziente(X),
	disturbo(Y,X,CF).

% Diagnosi investigativa su piu' disturbi
investigate_goals(L):-
	paziente(X),
	findall(goal(Y,CF),disturbo(Y,X,CF),L).
	
%---------------------------------------------------DISTURBI D'ANSIA di AsseI------------------------------------------
%	Disturbo di Panico Senza Agorafobia
disturbo(disturbo_di_panico_senza_agorafobia,Paziente,CF) :- 
	disturbo_NC(disturbo_di_panico,Paziente,CF1,true),
	disturbo_NC(agorafobia,Paziente,CF2,false),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_di_panico_senza_agorafobia,1,[CF1,CF2,CF3,CF4],0.97,CF,true).

%	Disturbo di Panico Con Agorafobia 
disturbo(disturbo_di_panico_con_agorafobia,Paziente,CF) :- 
	disturbo_NC(disturbo_di_panico,Paziente,CF1,true),
	disturbo_NC(agorafobia,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_di_panico_con_agorafobia,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Fobia Specifica Tipo Animali
disturbo(fobia_specifica_tipo_animali,Paziente,CF) :-
	disturbo_NC(fobia_specifica,Paziente,CF1,true),
	tipo_fobia_specifica(tipo_animali,Paziente,CF2,true),
	certezza(fobia_specifica_tipo_animali,1,[CF1,CF2],0.98,CF,true).

%	Disturbo Fobia Specifica Tipo Ambiente Naturale
disturbo(fobia_specifica_tipo_ambiente_naturale,Paziente,CF) :-
	disturbo_NC(fobia_specifica,Paziente,CF1,true),
	tipo_fobia_specifica(tipo_ambiente_naturale,Paziente,CF2,true),
	certezza(fobia_specifica_tipo_ambiente_naturale,1,[CF1,CF2],0.98,CF,true).

%	Disturbo Fobia Specifica Tipo Sangue-Iniezioni-Ferite
disturbo(fobia_specifica_tipo_sangue_iniezioni_ferite,Paziente,CF) :-
	disturbo_NC(fobia_specifica,Paziente,CF1,true),
	tipo_fobia_specifica(tipo_sangue_iniezioni_ferite,Paziente,CF2,true),
	certezza(fobia_specifica_tipo_sangue_iniezioni_ferite,1,[CF1,CF2],0.98,CF,true).

%	Disturbo Fobia Specifica Tipo Situazionale
disturbo(fobia_specifica_tipo_situazionale,Paziente,CF) :-
	disturbo_NC(fobia_specifica,Paziente,CF1,true),
	tipo_fobia_specifica(tipo_situazionale,Paziente,CF2,true),
	certezza(fobia_specifica_tipo_situazionale,1,[CF1,CF2],0.98,CF,true).

%	Disturbo Fobia Specifica Altro Tipo
disturbo(fobia_specifica_tipo_altro,Paziente,CF) :-
	disturbo_NC(fobia_specifica,Paziente,CF1,true),
	tipo_fobia_specifica(tipo_altro,Paziente,CF2,true),
	certezza(fobia_specifica_tipo_altro,1,[CF1,CF2],0.98,CF,true).

%	Disturbo Fobia Sociale Generalizzata
disturbo(fobia_sociale_generalizzata,Paziente,CF) :-	
	disturbo_NC(fobia_sociale,Paziente,CF1,true),
	tipo_fobia_sociale(tipo_generalizzata,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(fobia_sociale_generalizzata,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Fobia Sociale Circoscritta
disturbo(fobia_sociale_circoscritta,Paziente,CF) :-
	disturbo_NC(fobia_sociale,Paziente,CF1,true),
	tipo_fobia_sociale(tipo_circoscritta,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(fobia_sociale_circoscritta,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Agorafobia Senza Anamnesi di Disturbo di Panico
disturbo(agorafobia_senza_anamnesi_di_disturbo_di_panico,Paziente,CF) :-
	disturbo_NC(agorafobia,Paziente,CF1,true),
	disturbo_NC(disturbo_di_panico,Paziente,CF2,false),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(agorafobia_senza_anamnesi_di_disturbo_di_panico,1,[CF1,CF2,CF3,CF4],0.96,CF,true).

%	Disturbo Post-Traumatico da Stress Acuto
disturbo(disturbo_post_traumatico_da_stress_acuto,Paziente,CF):-
	disturbo_NC(disturbo_post_traumatico_da_stress,Paziente,CF1,true),
	tipo_disturbo_post_traumatico_da_stress(tipo_acuto,Paziente,CF2,true),	
	certezza(disturbo_post_traumatico_da_stress_acuto,1,[CF1,CF2],0.98,CF,true).

%	Disturbo Post-Traumatico da Stress Acuto ad Esordio Ritardato
disturbo(disturbo_post_traumatico_da_stress_acuto_ad_esordio_ritardato,Paziente,CF):- 
	disturbo_NC(disturbo_post_traumatico_da_stress,Paziente,CF1,true),
	tipo_disturbo_post_traumatico_da_stress(tipo_acuto_ad_esordio_ritardato,Paziente,CF2,true),
	certezza(disturbo_post_traumatico_da_stress_acuto_ad_esordio_ritardato,1,[CF1,CF2],0.98,CF,true).

%	Disturbo Post-Traumatico da Stress Cronico
disturbo(disturbo_post_traumatico_da_stress_cronico,Paziente,CF):-
	disturbo_NC(disturbo_post_traumatico_da_stress,Paziente,CF1,true),
	tipo_disturbo_post_traumatico_da_stress(tipo_cronico,Paziente,CF2,true),
	certezza(disturbo_post_traumatico_da_stress_cronico,1,[CF1,CF2],0.98,CF,true).

%	Disturbo Post-Traumatico da Stress Cronico ad Esordio Ritardato
disturbo(disturbo_post_traumatico_da_stress_cronico_ad_esordio_ritardato,Paziente,CF):- 
	disturbo_NC(disturbo_post_traumatico_da_stress,Paziente,CF1,true),
	tipo_disturbo_post_traumatico_da_stress(tipo_cronico_ad_esordio_ritardato,Paziente,CF2,true),
	certezza(disturbo_post_traumatico_da_stress_cronico_ad_esordio_ritardato,1,[CF1,CF2],0.98,CF,true).

%	Disturbo Acuto da Stress
disturbo(disturbo_acuto_da_stress,Paziente,CF) :- 
	disturbo_NC(disturbo_acuto_da_stress,Paziente,CF1,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF2,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF3,false),
	certezza(disturbo_acuto_da_stress,1,[CF1,CF2,CF3],0.97,CF,true).

%	Disturbo Ossessivo-Compulsivo a Contenuto Aggressivo
disturbo(disturbo_ossessivo_compulsivo_aggressioni,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo,Paziente,CF1,true),
	tipo_ossessioni_compulsioni(tipo_aggressivo,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_aggressioni,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo a Contenuto Aggressivo con Scarso Insight
disturbo(disturbo_ossessivo_compulsivo_aggressioni_con_scarso_insight,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo_con_scarso_insight,Paziente,CF1,true),
	tipo_ossessioni_compulsioni(tipo_aggressivo,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_aggressioni_con_scarso_insight,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo da Contaminazione
disturbo(disturbo_ossessivo_compulsivo_contaminazioni,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo,Paziente,CF1,true),
	tipo_ossessioni_compulsioni(tipo_contaminativo,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_contaminazioni,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo da Contaminazione con Scarso Insight
disturbo(disturbo_ossessivo_compulsivo_contaminazioni_con_scarso_insight,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo_con_scarso_insight,Paziente,CF1,true),	
	tipo_ossessioni_compulsioni(tipo_contaminativo,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_contaminazioni_con_scarso_insight,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo a Contenuto Sessuale
disturbo(disturbo_ossessivo_compulsivo_sesso,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo,Paziente,CF1,true),
	tipo_ossessioni_compulsioni(tipo_sessuale,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_sesso,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo a Contenuto Sessuale con Scarso Insight
disturbo(disturbo_ossessivo_compulsivo_sesso_con_scarso_insight,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo_con_scarso_insight,Paziente,CF1,true),	
	tipo_ossessioni_compulsioni(tipo_sessuale,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_sesso_con_scarso_insight,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo di Tipo Accumulo
disturbo(disturbo_ossessivo_compulsivo_accumulo,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo,Paziente,CF1,true),
	tipo_ossessioni_compulsioni(tipo_accumulativo,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_accumulo,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo di Tipo Accumulo con Scarso Insight
disturbo(disturbo_ossessivo_compulsivo_accumulo_con_scarso_insight,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo_con_scarso_insight,Paziente,CF1,true),
	tipo_ossessioni_compulsioni(tipo_accumulativo,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_accumulo_con_scarso_insight,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo a Contenuto Religioso
disturbo(disturbo_ossessivo_compulsivo_religione,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo,Paziente,CF1,true),
	tipo_ossessioni_compulsioni(tipo_religioso,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_religione,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo a Contenuto Religioso con Scarso Insight
disturbo(disturbo_ossessivo_compulsivo_religione_con_scarso_insight,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo_con_scarso_insight,Paziente,CF1,true),	
	tipo_ossessioni_compulsioni(tipo_religioso,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_religione_con_scarso_insight,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo di Tipo Ordine e Simmetria
disturbo(disturbo_ossessivo_compulsivo_ordine_e_simmetria,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo,Paziente,CF1,true),
	tipo_ossessioni_compulsioni(tipo_ordine_e_simmetria,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_ordine_e_simmetria,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo di Tipo Ordine e Simmetria con Scarso Insight
disturbo(disturbo_ossessivo_compulsivo_ordine_e_simmetria_con_scarso_insight,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo_con_scarso_insight,Paziente,CF1,true),	
	tipo_ossessioni_compulsioni(tipo_ordine_e_simmetria,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_ordine_e_simmetria_con_scarso_insight,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo di Tipo Somatico
disturbo(disturbo_ossessivo_compulsivo_somatico,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo,Paziente,CF1,true),
	tipo_ossessioni_compulsioni(tipo_somatico,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_somatico,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo di Tipo Somatico con Scarso Insight
disturbo(disturbo_ossessivo_compulsivo_somatico_con_scarso_insight,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo_con_scarso_insight,Paziente,CF1,true),	
	tipo_ossessioni_compulsioni(tipo_somatico,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_somatico_con_scarso_insight,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo di Tipo Superstizioso
disturbo(disturbo_ossessivo_compulsivo_superstizione,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo,Paziente,CF1,true),	
	tipo_ossessioni_compulsioni(tipo_superstizioso,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_superstizione,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo di Tipo Superstizioso con Scarso Insight
disturbo(disturbo_ossessivo_compulsivo_superstizione_con_scarso_insight,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo_con_scarso_insight,Paziente,CF1,true),	
	tipo_ossessioni_compulsioni(tipo_superstizioso,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_superstizione_con_scarso_insight,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo di Tipo Perfezione e Responsabilita'
disturbo(disturbo_ossessivo_compulsivo_perfezione_e_responsabilita,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo,Paziente,CF1,true),
	tipo_ossessioni_compulsioni(tipo_perfezione_e_responsabilita,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_perfezione_e_responsabilita,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo di Tipo Perfezione e Responsabilita' con Scarso Insight
disturbo(disturbo_ossessivo_compulsivo_perfezione_e_responsabilita_con_scarso_insight,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo_con_scarso_insight,Paziente,CF1,true),	
	tipo_ossessioni_compulsioni(tipo_perfezione_e_responsabilita,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_perfezione_e_responsabilita_con_scarso_insight,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo con Contenuto Vario
disturbo(disturbo_ossessivo_compulsivo_vario,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo,Paziente,CF1,true),
	tipo_ossessioni_compulsioni(tipo_vario,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_vario,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo Ossessivo-Compulsivo con Contenuto Vario con Scarso Insight
disturbo(disturbo_ossessivo_compulsivo_vario_con_scarso_insight,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo_con_scarso_insight,Paziente,CF1,true),	
	tipo_ossessioni_compulsioni(tipo_vario,Paziente,CF2,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF3,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF4,false),
	certezza(disturbo_ossessivo_compulsivo_vario_con_scarso_insight,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Disturbo d'Ansia Generalizzato 
disturbo(disturbo_ansia_generalizzato,Paziente,CF) :-
	disturbo_NC(disturbo_ansia_generalizzato,Paziente,CF1,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF2,false),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF3,false),
	certezza(disturbo_ansia_generalizzato,1,[CF1,CF2,CF3],0.97,CF,true).

%	Disturbo d'Ansia Indotto da Sostanze con Ansia Generalizzata
disturbo(disturbo_ansia_indotto_da_sostanze_con_ansia_generalizzata,Paziente,CF) :-
	disturbo_NC(disturbo_ansia_generalizzato,Paziente,CF1,true),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF2,true),
	certezza(disturbo_ansia_indotto_da_sostanze_con_ansia_generalizzata,1,[CF1,CF2],0.90,CF,true).

%	Disturbo d'Ansia Indotto da Sostanze con Attacchi di Panico
disturbo(disturbo_ansia_indotto_da_sostanze_con_attacchi_di_panico,Paziente,CF) :-
	disturbo_NC(disturbo_di_panico,Paziente,CF1,true),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF2,true),
	certezza(disturbo_ansia_indotto_da_sostanze_con_attacchi_di_panico,1,[CF1,CF2],0.87,CF,true).

%	Disturbo d'Ansia Indotto da Sostanze con Sintomi Ossessivo-Compulsivi
disturbo(disturbo_ansia_indotto_da_sostanze_con_sintomi_ossessivo_compulsivi,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo,Paziente,CF1,true),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF2,true),
	certezza(disturbo_ansia_indotto_da_sostanze_con_sintomi_ossessivo_compulsivi,1,[CF1,CF2],0.85,CF,true).

%	Disturbo d'Ansia Indotto da Sostanze con Sintomi Fobici
disturbo(disturbo_ansia_indotto_da_sostanze_con_sintomi_fobici,Paziente,CF) :-
	disturbo_NC(fobia_sociale,Paziente,CF1,true),
	disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF2,true),
	certezza(disturbo_ansia_indotto_da_sostanze_con_sintomi_fobici,1,[CF1,CF2],0.83,CF,true).
 
%	Disturbo d'Ansia Dovuto ad una Condizione Medica Generale con Ansia Generalizzata
disturbo(disturbo_ansia_dovuto_a_condizione_medica_generale_con_ansia_generalizzata,Paziente,CF) :-
	disturbo_NC(disturbo_ansia_generalizzato,Paziente,CF1,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF2,true),
	certezza(disturbo_ansia_dovuto_a_condizione_medica_generale_con_ansia_generalizzata,1,[CF1,CF2],0.90,CF,true).
 
%	Disturbo d'Ansia Dovuto ad una Condizione Medica Generale con Attacchi di Panico
disturbo(disturbo_ansia_dovuto_a_condizione_medica_generale_con_attacchi_di_panico,Paziente,CF) :-
	disturbo_NC(disturbo_di_panico,Paziente,CF1,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF2,true),
	certezza(disturbo_ansia_dovuto_a_condizione_medica_generale_con_attacchi_di_panico,1,[CF1,CF2],0.85,CF,true).

%	Disturbo d'Ansia Dovuto ad una Condizione Medica Generale con Sintomi Ossessivo-Compulsivi	
disturbo(disturbo_ansia_dovuto_a_condizione_medica_generale_con_sintomi_ossessivo_compulsivi,Paziente,CF) :-
	disturbo_NC(disturbo_ossessivo_compulsivo,Paziente,CF1,true),
	disturbo_NC(condizione_medica_generale_associata,Paziente,CF2,true),
	certezza(disturbo_ansia_dovuto_a_condizione_medica_generale_con_sintomi_ossessivo_compulsivi,1,[CF1,CF2],0.80,CF,true).


%--------------------------------------------DISTURBI D'ANSIA NON CODIFICABILI-----------------------------------------
disturbo_NC(disturbo_di_panico,Paziente,CF,TV) :- 
	manifestazione_sintomatica(attacco_di_panico_inaspettato,Paziente,CF1,true),
	caratteristica_sintomatica(frequenti_attacchi_di_panico,Paziente,CF2,true),
	manifestazione_sintomatica(ansia_anticipatoria_situazioni_panico,Paziente,CF3,true),
	caratteristica_sintomatica(durata_almeno_un_mese,Paziente,CF4,true),
	certezza(disturbo_di_panico,2,[CF1,CF2,CF3,CF4],0.97,CF,TV).

disturbo_NC(agorafobia,Paziente,CF,TV) :-
	manifestazione_sintomatica(ansia_agorafobica,Paziente,CF1,true), 
	manifestazione_sintomatica(evitamento_o_sopportazione_con_disagio,Paziente,CF2,true),
	certezza(agorafobia,2,[CF1,CF2],0.98,CF,TV).

disturbo_NC(fobia_specifica,bambino,CF,TV) :-
	manifestazione_sintomatica(ansia_fobica_specifica,bambino,CF1,true),
	manifestazione_sintomatica(attacco_di_panico_causato_dalla_situazione,bambino,CF2,true),	
	manifestazione_sintomatica(evitamento_o_sopportazione_con_disagio,bambino,CF3,true),
	manifestazione_sintomatica(disagio_significativo,bambino,CF4,true),		
	caratteristica_sintomatica(durata_almeno_sei_mesi,bambino,CF5,true),
	certezza(fobia_specifica,2,[CF1,CF2,CF3,CF4,CF5],0.99,CF,TV).

disturbo_NC(fobia_specifica,adolescente,CF,TV) :-
	manifestazione_sintomatica(ansia_fobica_specifica,adolescente,CF1,true),
	manifestazione_sintomatica(attacco_di_panico_causato_dalla_situazione,adolescente,CF2,true),
	manifestazione_sintomatica(riconoscimento_eccesso_o_irragionevolezza_fobia,adolescente,CF3,true),		
	manifestazione_sintomatica(evitamento_o_sopportazione_con_disagio,adolescente,CF4,true),
	manifestazione_sintomatica(disagio_significativo,adolescente,CF5,true),		
	caratteristica_sintomatica(durata_almeno_sei_mesi,adolescente,CF6,true),
	certezza(fobia_specifica,2,[CF1,CF2,CF3,CF4,CF5,CF6],0.99,CF,TV).

disturbo_NC(fobia_specifica,adulto,CF,TV) :-
	manifestazione_sintomatica(ansia_fobica_specifica,adulto,CF1,true),
	manifestazione_sintomatica(attacco_di_panico_causato_dalla_situazione,adulto,CF2,true),		
	manifestazione_sintomatica(riconoscimento_eccesso_o_irragionevolezza_fobia,adulto,CF3,true),
	manifestazione_sintomatica(evitamento_o_sopportazione_con_disagio,adulto,CF4,true),
	manifestazione_sintomatica(disagio_significativo,adulto,CF5,true),		
	certezza(fobia_specifica,2,[CF1,CF2,CF3,CF4,CF5],0.99,CF,TV).

disturbo_NC(fobia_sociale,bambino,CF,TV) :-
	manifestazione_sintomatica(ansia_fobica_sociale,bambino,CF1,true),
	manifestazione_sintomatica(attacco_di_panico_causato_dalla_situazione,bambino,CF2,true),	
	manifestazione_sintomatica(evitamento_o_sopportazione_con_disagio,bambino,CF3,true),
	manifestazione_sintomatica(disagio_significativo,bambino,CF4,true),		
	caratteristica_sintomatica(durata_almeno_sei_mesi,bambino,CF5,true),
	certezza(fobia_sociale,2,[CF1,CF2,CF3,CF4,CF5],0.99,CF,TV).

disturbo_NC(fobia_sociale,adolescente,CF,TV) :-
	manifestazione_sintomatica(ansia_fobica_sociale,adolescente,CF1,true),
	manifestazione_sintomatica(attacco_di_panico_causato_dalla_situazione,adolescente,CF2,true),		
	manifestazione_sintomatica(riconoscimento_eccesso_o_irragionevolezza_fobia,adolescente,CF3,true),
	manifestazione_sintomatica(evitamento_o_sopportazione_con_disagio,adolescente,CF4,true),
	manifestazione_sintomatica(disagio_significativo,adolescente,CF5,true),		
	caratteristica_sintomatica(durata_almeno_sei_mesi,adolescente,CF6,true),
	certezza(fobia_sociale,2,[CF1,CF2,CF3,CF4,CF5,CF6],0.99,CF,TV).

disturbo_NC(fobia_sociale,adulto,CF,TV) :-
	manifestazione_sintomatica(ansia_fobica_sociale,adulto,CF1,true),
	manifestazione_sintomatica(attacco_di_panico_causato_dalla_situazione,adulto,CF2,true),			
	manifestazione_sintomatica(riconoscimento_eccesso_o_irragionevolezza_fobia,adulto,CF3,true),
	manifestazione_sintomatica(evitamento_o_sopportazione_con_disagio,adulto,CF4,true),
	manifestazione_sintomatica(disagio_significativo,adulto,CF5,true),		
	certezza(fobia_sociale,2,[CF1,CF2,CF3,CF4,CF5],0.99,CF,TV).

disturbo_NC(disturbo_acuto_da_stress,Paziente,CF,TV) :-
	manifestazione_sintomatica(trauma_psicologico,Paziente,CF1,true),
	manifestazione_sintomatica(dissociazione,Paziente,CF2,true),
	manifestazione_sintomatica(evento_traumatico_rivissuto,Paziente,CF3,true),
	manifestazione_sintomatica(evitamento_stimoli_associati_trauma,Paziente,CF4,true),
	manifestazione_sintomatica(arousal_aumentato,Paziente,CF5,true),
	manifestazione_sintomatica(disagio_significativo,Paziente,CF6,true),
	caratteristica_sintomatica(durata_due_giorni_meno_un_mese,Paziente,CF7,true),
	caratteristica_sintomatica(esordio_entro_un_mese,Paziente,CF8,true),
	certezza(disturbo_acuto_da_stress,2,[CF1,CF2,CF3,CF4,CF5,CF6,CF7,CF8],0.97,CF,TV).

disturbo_NC(disturbo_post_traumatico_da_stress,Paziente,CF,TV) :-
	manifestazione_sintomatica(trauma_psicologico,Paziente,CF1,true),
	manifestazione_sintomatica(evento_traumatico_rivissuto,Paziente,CF2,true),
	manifestazione_sintomatica(evitamento_stimoli_associati_trauma,Paziente,CF3,true),
	manifestazione_sintomatica(attenuazione_reattivita_generale,Paziente,CF4,true),
	manifestazione_sintomatica(arousal_aumentato,Paziente,CF5,true),
	manifestazione_sintomatica(disagio_significativo,Paziente,CF6,true),
	certezza(disturbo_post_traumatico_da_stress,2,[CF1,CF2,CF3,CF4,CF5,CF6],0.98,CF,TV).

disturbo_NC(disturbo_ossessivo_compulsivo,Paziente,CF,TV) :- 
	manifestazione_sintomatica(ansia_ossessiva_compulsiva,Paziente,CF1,true),
	manifestazione_sintomatica(disagio_significativo,Paziente,CF2,true),
	manifestazione_sintomatica(alto_riconoscimento_eccesso_o_irragionevolezza_ossessioni_compulsioni,Paziente,CF3,true),
	certezza(disturbo_ossessivo_compulsivo,2,[CF1,CF2,CF3],0.97,CF,TV).

disturbo_NC(disturbo_ossessivo_compulsivo_con_scarso_insight,Paziente,CF,TV) :- 
	manifestazione_sintomatica(ansia_ossessiva_compulsiva,Paziente,CF1,true),
	manifestazione_sintomatica(disagio_significativo,Paziente,CF2,true),
	manifestazione_sintomatica(basso_riconoscimento_eccesso_o_irragionevolezza_ossessioni_compulsioni,Paziente,CF3,true),
	certezza(disturbo_ossessivo_compulsivo_con_scarso_insight,2,[CF1,CF2,CF3],0.97,CF,TV).

disturbo_NC(disturbo_ansia_generalizzato,Paziente,CF,TV):-
	manifestazione_sintomatica(ansia_generalizzata,Paziente,CF1,true),
	manifestazione_sintomatica(disagio_significativo,Paziente,CF2,true),
	caratteristica_sintomatica(durata_almeno_sei_mesi,Paziente,CF3,true),
	certezza(disturbo_ansia_generalizzato,2,[CF1,CF2,CF3],0.97,CF,TV).

disturbo_NC(alterazione_indotta_da_sostanza_associata,Paziente,CF,TV) :-
	manifestazione_sintomatica(intossicazione_astinenza_sostanza_o_assunzione_farmaco,Paziente,CF1,true),
	caratteristica_sintomatica(evidenza_eziologica_sostanza_o_farmaco_e_ansia,Paziente,CF2,true),
	manifestazione_sintomatica(disagio_significativo,Paziente,CF3,true),
	certezza(alterazione_indotta_da_sostanza_associata,2,[CF1,CF2,CF3],0.95,CF,TV).

disturbo_NC(condizione_medica_generale_associata,Paziente,CF,TV):-
	manifestazione_sintomatica(condizione_medica_generale,Paziente,CF1,true),
	caratteristica_sintomatica(evidenza_eziologica_condizione_medica_e_ansia,Paziente,CF2,true),
	manifestazione_sintomatica(disagio_significativo,Paziente,CF3,true),
	certezza(condizione_medica_generale_associata,2,[CF1,CF2,CF3],0.95,CF,TV).


%------------------------------------------------TIPI DI "FOBIA SPECIFICA"---------------------------------------------
tipo_fobia_specifica(tipo_animali,Paziente,CF,TV) :-
	manifestazione_sintomatica(fobia_animali,Paziente,CF1,true),
	certezza(tipo_animali,2,[CF1],0.99,CF,TV).

tipo_fobia_specifica(tipo_ambiente_naturale,Paziente,CF,TV) :-
	manifestazione_sintomatica(fobia_ambiente_naturale,Paziente,CF1,true),
	certezza(tipo_ambiente_naturale,2,[CF1],0.99,CF,TV).

tipo_fobia_specifica(tipo_sangue_iniezioni_ferite,Paziente,CF,TV) :-
	manifestazione_sintomatica(fobia_sangue_iniezioni_ferite,Paziente,CF1,true),
	certezza(tipo_sangue_iniezioni_ferite,2,[CF1],0.99,CF,TV).

tipo_fobia_specifica(tipo_situazionale,Paziente,CF,TV) :-
	manifestazione_sintomatica(fobia_situazioni,Paziente,CF1,true),
	certezza(tipo_situazionale,2,[CF1],0.99,CF,TV).

tipo_fobia_specifica(tipo_altro,Paziente,CF,TV) :-
	manifestazione_sintomatica(fobia_altro,Paziente,CF1,true),
	certezza(tipo_altro,2,[CF1],0.99,CF,TV).


%----------------------------------------------TIPI DI "FOBIA SOCIALE"-------------------------------------------------
tipo_fobia_sociale(tipo_generalizzata,Paziente,CF,TV) :-
	manifestazione_sintomatica(fobia_generalizzata,Paziente,CF1,true),
	certezza(tipo_generalizzata,2,[CF1],0.98,CF,TV).

tipo_fobia_sociale(tipo_circoscritta,Paziente,CF,TV) :-
	manifestazione_sintomatica(fobia_circoscritta,Paziente,CF1,true),
	certezza(tipo_circoscritta,2,[CF1],0.98,CF,TV).


%-------------------------------------------TIPI DI "OSSESSIONI-COMPULSIONI"-------------------------------------------
tipo_ossessioni_compulsioni(tipo_aggressivo,Paziente,CF,TV) :-
	manifestazione_sintomatica(ossessioni_compulsioni_aggressioni,Paziente,CF1,true),
	certezza(tipo_aggressivo,2,[CF1],0.97,CF,TV).

tipo_ossessioni_compulsioni(tipo_contaminativo,Paziente,CF,TV) :-
	manifestazione_sintomatica(ossessioni_compulsioni_contaminazione,Paziente,CF1,true),
	certezza(tipo_contaminativo,2,[CF1],0.97,CF,TV).

tipo_ossessioni_compulsioni(tipo_sessuale,Paziente,CF,TV) :-
	manifestazione_sintomatica(ossessioni_compulsioni_sesso,Paziente,CF1,true),
	certezza(tipo_sessuale,2,[CF1],0.97,CF,TV).

tipo_ossessioni_compulsioni(tipo_accumulativo,Paziente,CF,TV) :-
	manifestazione_sintomatica(ossessioni_compulsioni_accumulo,Paziente,CF1,true),
	certezza(tipo_accumulativo,2,[CF1],0.97,CF,TV).

tipo_ossessioni_compulsioni(tipo_religioso,Paziente,CF,TV) :-
	manifestazione_sintomatica(ossessioni_compulsioni_religione,Paziente,CF1,true),
	certezza(tipo_religioso,2,[CF1],0.97,CF,TV).

tipo_ossessioni_compulsioni(tipo_ordine_e_simmetria,Paziente,CF,TV) :-
	manifestazione_sintomatica(ossessioni_compulsioni_ordine_e_simmetria,Paziente,CF1,true),
	certezza(tipo_ordine_e_simmetria,2,[CF1],0.97,CF,TV).
	
tipo_ossessioni_compulsioni(tipo_somatico,Paziente,CF,TV) :-
	manifestazione_sintomatica(ossessioni_compulsioni_corpo,Paziente,CF1,true),
	certezza(tipo_somatico,2,[CF1],0.97,CF,TV).

tipo_ossessioni_compulsioni(tipo_superstizioso,Paziente,CF,TV) :-
	manifestazione_sintomatica(ossessioni_compulsioni_superstizione,Paziente,CF1,true),
	certezza(tipo_superstizioso,2,[CF1],0.97,CF,TV).

tipo_ossessioni_compulsioni(tipo_perfezione_e_responsabilita,Paziente,CF,TV) :-
	manifestazione_sintomatica(ossessioni_compulsioni_perfezione_e_responsabilita,Paziente,CF1,true),
	certezza(tipo_perfezione_e_responsabilita,2,[CF1],0.97,CF,TV).

tipo_ossessioni_compulsioni(tipo_vario,Paziente,CF,TV) :-
	manifestazione_sintomatica(ossessioni_compulsioni_vario,Paziente,CF1,true),
	certezza(tipo_vario,2,[CF1],0.97,CF,TV).


%---------------------------------------TIPI DI "DISTURBI POST TRAUMATICI DA STRESS"-----------------------------------
tipo_disturbo_post_traumatico_da_stress(tipo_acuto,Paziente,CF,TV) :-
	caratteristica_sintomatica(durata_un_mese_meno_tre_mesi,Paziente,CF1,true),
	caratteristica_sintomatica(esordio_entro_sei_mesi,Paziente,CF2,true),
	certezza(tipo_acuto,2,[CF1,CF2],0.99,CF,TV).

tipo_disturbo_post_traumatico_da_stress(tipo_acuto_ad_esordio_ritardato,Paziente,CF,TV) :-
	caratteristica_sintomatica(durata_un_mese_meno_tre_mesi,Paziente,CF1,true),
	caratteristica_sintomatica(esordio_almeno_sei_mesi_dopo,Paziente,CF2,true),
	certezza(tipo_acuto_ad_esordio_ritardato,2,[CF1,CF2],0.99,CF,TV).
	
tipo_disturbo_post_traumatico_da_stress(tipo_cronico,Paziente,CF,TV) :-
	caratteristica_sintomatica(durata_almeno_tre_mesi,Paziente,CF1,true),
	caratteristica_sintomatica(esordio_entro_sei_mesi,Paziente,CF2,true),
	certezza(tipo_cronico,2,[CF1,CF2],0.99,CF,TV).

tipo_disturbo_post_traumatico_da_stress(tipo_cronico_ad_esordio_ritardato,Paziente,CF,TV) :-
	caratteristica_sintomatica(durata_almeno_tre_mesi,Paziente,CF1,true),
	caratteristica_sintomatica(esordio_almeno_sei_mesi_dopo,Paziente,CF2,true),
	certezza(tipo_cronico_ad_esordio_ritardato,2,[CF1,CF2],0.99,CF,TV).


%----------------------------------------------MANIFESTAZIONI SINTOMATICHE---------------------------------------------
manifestazione_sintomatica(attacco_di_panico_inaspettato,Paziente,CF,TV) :-
	sintomo([escalation_ansia_o_forte_paura],1,CF1),
	sintomo([palpitazioni,sudorazione,tremore,dispnea,asfissia,dolore_al_petto,nausea,testa_leggera,derealizzazione,depersonalizzazione,paura_di_impazzire,paura_di_morire,parestesie,brividi_o_vampate_calore],4,CF2),
	tipo_attacco([attacco_inaspettato],CF3),
	certezza(attacco_di_panico_inaspettato,3,[CF1,CF2,CF3],0.99,CF,TV).

manifestazione_sintomatica(attacco_di_panico_causato_dalla_situazione,Paziente,CF,TV) :-
	sintomo([escalation_ansia_o_forte_paura],1,CF1),
	sintomo([palpitazioni,sudorazione,tremore,dispnea,asfissia,dolore_al_petto,nausea,testa_leggera,derealizzazione,depersonalizzazione,paura_di_impazzire,paura_di_morire,parestesie,brividi_o_vampate_calore],4,CF2),
	tipo_attacco([attacco_provocato],CF3),
	certezza(attacco_di_panico_causato_dalla_situazione,3,[CF1,CF2,CF3],0.99,CF,TV).

manifestazione_sintomatica(trauma_psicologico,bambino,CF,TV) :-
	!,
	sintomo([trauma],1,CF1),
	sintomo([comportamento_disorganizzato,agitazione],1,CF2),
	certezza(trauma_psicologico,3,[CF1,CF2],0.98,CF,TV).
manifestazione_sintomatica(trauma_psicologico,Paziente,CF,TV) :-
	sintomo([trauma],1,CF1),
	sintomo([sentimento_orrore,sentimento_impotenza],1,CF2),
	certezza(trauma_psicologico,3,[CF1,CF2],0.98,CF,TV).

manifestazione_sintomatica(condizione_medica_generale,Paziente,CF,TV) :-
	sintomo([condizione_medica],1,CF1),
	certezza(condizione_medica_generale,3,[CF1],0.96,CF,TV).

manifestazione_sintomatica(intossicazione_astinenza_sostanza_o_assunzione_farmaco,Paziente,CF,TV) :-
	sintomo([intossicazione_o_astinenza_sostanza,assunzione_farmaco_o_esposizione_tossina],1,CF1),	
	certezza(intossicazione_astinenza_sostanza_o_assunzione_farmaco,3,[CF1],0.95,CF,TV).

manifestazione_sintomatica(riconoscimento_eccesso_o_irragionevolezza_fobia,Paziente,CF,TV) :-
	sintomo([insight_eccesso_o_irragionevolezza_paura_fobica],1,CF1),
	certezza(riconoscimento_eccesso_o_irragionevolezza_fobia,3,[CF1],1.0,CF,TV).

manifestazione_sintomatica(alto_riconoscimento_eccesso_o_irragionevolezza_ossessioni_compulsioni,Paziente,CF,TV) :-
	insight_eccesso_o_irragionevolezza_ossessioni_compulsioni([insight_alto],CF1),
	certezza(alto_riconoscimento_eccesso_o_irragionevolezza_ossessioni_compulsioni,3,[CF1],0.99,CF,TV).

manifestazione_sintomatica(basso_riconoscimento_eccesso_o_irragionevolezza_ossessioni_compulsioni,Paziente,CF,TV) :-
	insight_eccesso_o_irragionevolezza_ossessioni_compulsioni([insight_nullo,insight_basso],CF1),
	certezza(basso_riconoscimento_eccesso_o_irragionevolezza_ossessioni_compulsioni,3,[CF1],0.98,CF,TV).

manifestazione_sintomatica(ansia_anticipatoria_situazioni_panico,Paziente,CF,TV) :-
	sintomo([preoccupazione_nuovi_attacchi_ansia,preoccupazione_conseguenze_attacchi_ansia,comportamento_evitante,comportamento_protettivo],1,CF1),
	certezza(ansia_anticipatoria_situazioni_panico,3,[CF1],0.98,CF,TV).

manifestazione_sintomatica(evitamento_stimoli_associati_trauma,Paziente,CF,TV) :-
	sintomo([evitamento_pensieri_o_sensazioni_o_conversazioni_associati_trauma,evitamento_attivita_o_luoghi_o_persone_associate_trauma],1,CF1),
	certezza(evitamento_stimoli_associati_trauma,3,[CF1],0.99,CF,TV).

manifestazione_sintomatica(disagio_significativo,Paziente,CF,TV) :-
	sintomo([disagio_lavorativo,disagio_sociale,disagio_comportamentale],1,CF1),
	certezza(disagio_significativo,3,[CF1],0.97,CF,TV).

manifestazione_sintomatica(attenuazione_reattivita_generale,Paziente,CF,TV) :-
	sintomo([riduzione_interesse_attivita,sentimento_estraneita,affettivita_ridotta,diminuzione_prospettive_future],1,CF1),	
	certezza(attenuazione_reattivita_generale,3,[CF1],0.98,CF,TV).

manifestazione_sintomatica(ansia_ossessiva_compulsiva,Paziente,CF,TV) :-
	sintomo([ansia_ossessiva,ansia_compulsiva],1,CF1),
	sintomo([preoccupazione_controllo_ossessioni_compulsioni],1,CF2),
	sintomo([spreco_tempo],1,CF3),
	certezza(ansia_ossessiva_compulsiva,3,[CF1,CF2,CF3],0.97,CF,TV).

manifestazione_sintomatica(dissociazione,Paziente,CF,TV) :-
	sintomo([affettivita_ridotta,sentimento_estraneita,riduzione_consapevolezza_ambientale,derealizzazione,depersonalizzazione,amnesia_dissociativa],3,CF1),
	certezza(dissociazione,3,[CF1],0.98,CF,TV). 

manifestazione_sintomatica(evento_traumatico_rivissuto,bambino,CF,TV) :-
	!,
	sintomo([manifestazione_giochi_associati_trauma,manifestazione_sogni_spaventosi,manifestazione_rappresentazioni_ripetitive,disagio_psicologico_fattori_caratterizzanti_trauma,reattivita_fisiologica],1,CF1),
	certezza(evento_traumatico_rivissuto,3,[CF1],0.99,CF,TV).
manifestazione_sintomatica(evento_traumatico_rivissuto,Paziente,CF,TV) :-
	sintomo([manifestazione_ricordi_associati_trauma,manifestazione_sogni_associati_trauma,ripresentazione_trauma,disagio_psicologico_fattori_caratterizzanti_trauma,reattivita_fisiologica],1,CF1),
	certezza(evento_traumatico_rivissuto,3,[CF1],0.99,CF,TV).

manifestazione_sintomatica(arousal_aumentato,Paziente,CF,TV) :-
	sintomo([alterazione_sonno,irritabilita,difficolta_concentrarsi,ipervigilanza,allarme_esagerato],2,CF1),
	certezza(arousal_aumentato,3,[CF1],0.98,CF,TV).

manifestazione_sintomatica(ansia_generalizzata,bambino,CF,TV) :-
	!,
	sintomo([preoccupazione_circostanze_abitudinarie_o_piccoli_imprevisti],1,CF1),
	sintomo([difficolta_controllo_preoccupazione],1,CF2),
	sintomo([irrequietezza,facile_affaticabilita,difficolta_concentrarsi,irritabilita,tensione_muscolare,alterazione_sonno],1,CF3),	
	tipo_ansia([attesa_apprensiva],CF4),
	certezza(ansia_generalizzata,3,[CF1,CF2,CF3,CF4],0.98,CF,TV).
manifestazione_sintomatica(ansia_generalizzata,Paziente,CF,TV) :-
	sintomo([preoccupazione_circostanze_abitudinarie_o_piccoli_imprevisti],1,CF1),
	sintomo([difficolta_controllo_preoccupazione],1,CF2),
	sintomo([irrequietezza,facile_affaticabilita,difficolta_concentrarsi,irritabilita,tensione_muscolare,alterazione_sonno],3,CF3),
	tipo_ansia([attesa_apprensiva],CF4),
	certezza(ansia_generalizzata,3,[CF1,CF2,CF3,CF4],0.98,CF,TV).

manifestazione_sintomatica(ansia_agorafobica,Paziente,CF,TV) :-
	sintomo([paura_agorafobica],1,CF1),
	sintomo([fobia_uscite,fobia_luoghi_affollati,fobia_lunghe_file,fobia_solitudine,fobia_mezzi_trasporto,fobia_spazi_stretti_o_chiusi],3,CF2),
	tipo_ansia([difficolta_allontanamento_o_indisponibilita_aiuto],CF3),
	certezza(ansia_agorafobica,3,[CF1,CF2,CF3],0.98,CF,TV).

manifestazione_sintomatica(ansia_fobica_specifica,Paziente,CF,TV) :-
	sintomo([paura_fobica_specifica],1,CF1),
	tipo_ansia([pericolo_salute,imbarazzo_in_pubblico],CF2),
	certezza(ansia_fobica_specifica,3,[CF1,CF2],0.98,CF,TV).

manifestazione_sintomatica(ansia_fobica_sociale,Paziente,CF,TV) :-
	sintomo([paura_fobica_sociale,paura_fobica_prestazionale],1,CF1),
	tipo_ansia([imbarazzo_in_pubblico],CF2),
	certezza(ansia_fobica_sociale,3,[CF1,CF2],0.98,CF,TV).

manifestazione_sintomatica(evitamento_o_sopportazione_con_disagio,Paziente,CF,TV) :-
	tipo_reazione_fobica([evitamento,sopportazione_con_disagio],CF1),
	certezza(evitamento_o_sopportazione_con_disagio,3,[CF1],0.99,CF,TV).

manifestazione_sintomatica(fobia_animali,Paziente,CF,TV):-
	sintomo([fobia_ragni,fobia_uccelli,fobia_rettili_o_serpenti,fobia_topi,fobia_cani_o_gatti,fobia_insetti,fobia_api_o_calabroni],1,CF1),
	certezza(fobia_animali,3,[CF1],0.98,CF,TV).

manifestazione_sintomatica(fobia_ambiente_naturale,Paziente,CF,TV):-
	sintomo([fobia_temporali,fobia_altezze,fobia_buio,fobia_acqua],1,CF1),
	certezza(fobia_ambiente_naturale,3,[CF1],0.97,CF,TV).

manifestazione_sintomatica(fobia_sangue_iniezioni_ferite,Paziente,CF,TV):-
	sintomo([fobia_sangue_o_ferite,fobia_aghi_o_iniezioni,fobia_medicazioni_invasive],1,CF1),
	certezza(fobia_sangue_iniezioni_ferite,3,[CF1],0.98,CF,TV).

manifestazione_sintomatica(fobia_situazioni,Paziente,CF,TV):-
	sintomo([fobia_mezzi_trasporto,fobia_spazi_stretti_o_chiusi],1,CF1),
	certezza(fobia_situazioni,3,[CF1],0.96,CF,TV).

manifestazione_sintomatica(fobia_altro,Paziente,CF,TV):-
	sintomo([fobia_malattie_o_soffocamento,fobia_vomito,fobia_boati_o_rumori_forti,fobia_maschere,fobia_morte],1,CF1),
	certezza(fobia_altro,3,[CF1],0.95,CF,TV).

manifestazione_sintomatica(fobia_generalizzata,Paziente,CF,TV) :-
	sintomo([fobia_incontrare_autorita,fobia_partecipare_festa,fobia_ricevere_ospiti,fobia_parlare_estranei,fobia_incontrare_sesso_opposto,fobia_parlare_agire_pubblicamente,fobia_usare_telefono_pubblicamente,fobia_mangiare_bere_pubblicamente,fobia_scrivere_firmare_pubblicamente,fobia_essere_osservato_pubblicamente,fobia_frequentare_bagni_pubblici,fobia_entrare_stanza_affollata,fobia_presentarsi_estranei],10,CF1),
	certezza(fobia_generalizzata,3,[CF1],0.99,CF,TV).

manifestazione_sintomatica(fobia_circoscritta,Paziente,CF,TV) :-
	sintomo([fobia_incontrare_autorita,fobia_partecipare_festa,fobia_ricevere_ospiti,fobia_parlare_estranei,fobia_incontrare_sesso_opposto,fobia_parlare_agire_pubblicamente,fobia_usare_telefono_pubblicamente,fobia_mangiare_bere_pubblicamente,fobia_scrivere_firmare_pubblicamente,fobia_essere_osservato_pubblicamente,fobia_frequentare_bagni_pubblici,fobia_entrare_stanza_affollata,fobia_presentarsi_estranei],1,CF1),
	certezza(fobia_circoscritta,3,[CF1],0.99,CF,TV).

manifestazione_sintomatica(ossessioni_compulsioni_aggressioni,Paziente,CF,TV) :-
	sintomo([o_c_ferire_fisicamente_o_verbalmente,o_c_fare_cose_imbarazzanti,o_c_provocare_incidenti],1,CF1),
	certezza(ossessioni_compulsioni_aggressioni,3,[CF1],0.99,CF,TV).

manifestazione_sintomatica(ossessioni_compulsioni_contaminazione,Paziente,CF,TV) :-
	sintomo([o_c_contaminazione_oggetti_o_animali_o_persone,o_c_contaminazione_posti_o_luoghi_contaminati,o_c_contaminazione_germi_o_malattie_o_secrezioni_o_feci,o_c_pulizia_ambiente,o_c_pulizia_personale],1,CF1),
	certezza(ossessioni_compulsioni_contaminazione,3,[CF1],0.98,CF,TV).

manifestazione_sintomatica(ossessioni_compulsioni_sesso,Paziente,CF,TV) :-
	sintomo([o_c_atti_sessuali,o_c_immagini_pornografiche,o_c_omosessualita],1,CF1),
	certezza(ossessioni_compulsioni_sesso,3,[CF1],0.93,CF,TV).

manifestazione_sintomatica(ossessioni_compulsioni_accumulo,Paziente,CF,TV) :-
	sintomo([o_c_collezionare_oggetti_inutili,o_c_spazi_vuoti,o_c_controllare_rifiuti,o_c_recuperare_oggetti_da_terra],1,CF1),
	certezza(ossessioni_compulsioni_accumulo,3,[CF1],0.92,CF,TV).

manifestazione_sintomatica(ossessioni_compulsioni_religione,Paziente,CF,TV) :-
	sintomo([o_c_bestemmie,o_c_sacrilegio,o_c_moralita,o_c_credo_religioso,o_c_preghiere],1,CF1),
	certezza(ossessioni_compulsioni_religione,3,[CF1],0.96,CF,TV).

manifestazione_sintomatica(ossessioni_compulsioni_ordine_e_simmetria,Paziente,CF,TV) :-
	sintomo([o_c_ordine_oggetti,o_c_disagio_disordine,o_c_simmetria],1,CF1),
	certezza(ossessioni_compulsioni_ordine_e_simmetria,3,[CF1],0.95,CF,TV).
	
manifestazione_sintomatica(ossessioni_compulsioni_corpo,Paziente,CF,TV) :-
	sintomo([o_c_controllo_forme_corporee,o_c_giudizio_altrui_aspetto_fisico],1,CF1),
	certezza(ossessioni_compulsioni_corpo,3,[CF1],0.89,CF,TV).

manifestazione_sintomatica(ossessioni_compulsioni_superstizione,Paziente,CF,TV) :-
	sintomo([o_c_parole_superstiziose,o_c_colori_simboli_o_numeri_superstiziosi,o_c_credenze_superstiziose],1,CF1),
	certezza(ossessioni_compulsioni_superstizione,3,[CF1],0.97,CF,TV).

manifestazione_sintomatica(ossessioni_compulsioni_perfezione_e_responsabilita,Paziente,CF,TV) :-
	sintomo([o_c_rifare_cose,o_c_controllo_errori,o_c_dire_cose_insensate,o_c_scadenze],1,CF1),
	certezza(ossessioni_compulsioni_perfezione_e_responsabilita,3,[CF1],0.90,CF,TV).

manifestazione_sintomatica(ossessioni_compulsioni_vario,Paziente,CF,TV) :-
	sintomo([o_c_numero_morsi,o_c_rumori,o_c_toccare,o_c_conteggi,o_c_ricordi],1,CF1),
	certezza(ossessioni_compulsioni_vario,3,[CF1],0.75,CF,TV).


%--------------------------------------------CARATTERISTICHE SINTOMATICHE----------------------------------------------
caratteristica_sintomatica(frequenti_attacchi_di_panico,Paziente,CF,TV) :-
	frequenza_attacchi_di_panico([da_due_a_cinque,piu_di_cinque],CF1),
	certezza(frequenti_attacchi_di_panico,3,[CF1],0.98,CF,TV).

caratteristica_sintomatica(evidenza_eziologica_condizione_medica_e_ansia,Paziente,CF,TV) :-
	evidenza_eziologica([esordio_sintomi_successivo_esordio_malattia,rafforzamento_sintomi_in_seguito_esacerbazione_malattia,indebolimento_sintomi_in_seguito_remissione_malattia],1,CF1),
	certezza(evidenza_eziologica_condizione_medica_e_ansia,3,[CF1],0.95,CF,TV).

caratteristica_sintomatica(evidenza_eziologica_sostanza_o_farmaco_e_ansia,Paziente,CF,TV) :-
	evidenza_eziologica([esordio_sintomi_successivo_esordio_uso_sostanze_o_farmaci,correlazione_sintomi_sostanze_o_farmaci],1,CF1),
	certezza(evidenza_eziologica_sostanza_o_farmaco_e_ansia,3,[CF1],0.90,CF,TV).

caratteristica_sintomatica(durata_due_giorni_meno_un_mese,Paziente,CF,TV) :-
	durata_sintomi([due_giorni_meno_un_mese],CF1),
	certezza(durata_due_giorni_meno_un_mese,3,[CF1],1.0,CF,TV).

caratteristica_sintomatica(durata_almeno_un_mese,Paziente,CF,TV) :-
	durata_sintomi([un_mese_meno_tre_mesi,tre_mesi_meno_sei_mesi,sei_mesi_piu],CF1),
	certezza(durata_almeno_un_mese,3,[CF1],1.0,CF,TV).	

caratteristica_sintomatica(durata_un_mese_meno_tre_mesi,Paziente,CF,TV) :-
	durata_sintomi([un_mese_meno_tre_mesi],CF1),
	certezza(durata_un_mese_meno_tre_mesi,3,[CF1],1.0,CF,TV).

caratteristica_sintomatica(durata_almeno_tre_mesi,Paziente,CF,TV) :-
	durata_sintomi([tre_mesi_meno_sei_mesi,sei_mesi_piu],CF1),
	certezza(durata_almeno_tre_mesi,3,[CF1],1.0,CF,TV).

caratteristica_sintomatica(durata_almeno_sei_mesi,Paziente,CF,TV) :-
	durata_sintomi([sei_mesi_piu],CF1),
	certezza(durata_almeno_sei_mesi,3,[CF1],1.0,CF,TV).	

caratteristica_sintomatica(esordio_entro_un_mese,Paziente,CF,TV) :-
	esordio_sintomi([meno_un_mese],CF1),
	certezza(esordio_entro_un_mese,3,[CF1],1.0,CF,TV).

caratteristica_sintomatica(esordio_entro_sei_mesi,Paziente,CF,TV) :-
	esordio_sintomi([meno_un_mese,un_mese_meno_sei_mesi],CF1),
	certezza(esordio_entro_sei_mesi,3,[CF1],1.0,CF,TV).

caratteristica_sintomatica(esordio_almeno_sei_mesi_dopo,Paziente,CF,TV) :-
	esordio_sintomi([sei_mesi_o_piu],CF1),
	certezza(esordio_almeno_sei_mesi_dopo,3,[CF1],1.0,CF,TV).


%---------------------------------------------DOMANDE DA CHIEDERE ALL'UTENTE-------------------------------------------
tipo_attacco(L,CF) :- 
	multiple_ask(tipo_attacco,[attacco_inaspettato,attacco_provocato],L,CF).

insight_eccesso_o_irragionevolezza_ossessioni_compulsioni(L,CF) :- 
	multiple_ask(insight_eccesso_o_irragionevolezza_ossessioni_compulsioni,[insight_nullo,insight_alto,insight_basso],L,CF).

frequenza_attacchi_di_panico(L,CF) :- 
	multiple_ask(frequenza_attacchi_di_panico,[uguale_minore_uno,da_due_a_cinque,piu_di_cinque],L,CF).

durata_sintomi(L,CF) :- 
	multiple_ask(durata_sintomi,[meno_due_giorni,due_giorni_meno_un_mese,un_mese_meno_tre_mesi,tre_mesi_meno_sei_mesi,sei_mesi_piu],L,CF).

esordio_sintomi(L,CF) :- 
	multiple_ask(esordio_sintomi,[meno_un_mese,un_mese_meno_sei_mesi,sei_mesi_o_piu,no_esordio],L,CF).

tipo_ansia(L,CF) :- 
	multiple_ask(tipo_ansia,[difficolta_allontanamento_o_indisponibilita_aiuto,imbarazzo_in_pubblico,pericolo_salute,attesa_apprensiva,altro_tipo_ansia],L,CF).

tipo_reazione_fobica(L,CF) :- 
	multiple_ask(tipo_reazione_fobica,[evitamento,sopportazione_con_disagio,sopportazione_senza_problemi],L,CF).

sintomo(Y,Z,CF) :- 
	criterion_ask(sintomo,Y,Z,CF).

evidenza_eziologica(Y,Z,CF) :- 
	criterion_ask(sintomo,Y,Z,CF).

paziente(X) :- 
	selective_ask(paziente,X,[bambino,adolescente,adulto]).


%----------------------------------------LISTA DEI DISTURBI D'ANSIA CODIFICATI-----------------------------------------
lista_goals([disturbo_di_panico_senza_agorafobia,disturbo_di_panico_con_agorafobia,fobia_specifica_tipo_animali,fobia_specifica_tipo_ambiente_naturale,fobia_specifica_tipo_sangue_iniezioni_ferite,fobia_specifica_tipo_situazionale,fobia_specifica_tipo_altro,fobia_sociale_generalizzata,fobia_sociale_circoscritta,agorafobia_senza_anamnesi_di_disturbo_di_panico,disturbo_post_traumatico_da_stress_acuto,disturbo_post_traumatico_da_stress_acuto_ad_esordio_ritardato,disturbo_post_traumatico_da_stress_cronico,disturbo_post_traumatico_da_stress_cronico_ad_esordio_ritardato,disturbo_acuto_da_stress,disturbo_ossessivo_compulsivo_aggressioni,disturbo_ossessivo_compulsivo_aggressioni_con_scarso_insight,disturbo_ossessivo_compulsivo_contaminazioni,disturbo_ossessivo_compulsivo_contaminazioni_con_scarso_insight,disturbo_ossessivo_compulsivo_sesso,disturbo_ossessivo_compulsivo_sesso_con_scarso_insight,disturbo_ossessivo_compulsivo_accumulo,disturbo_ossessivo_compulsivo_accumulo_con_scarso_insight,disturbo_ossessivo_compulsivo_religione,disturbo_ossessivo_compulsivo_religione_con_scarso_insight,disturbo_ossessivo_compulsivo_ordine_e_simmetria,disturbo_ossessivo_compulsivo_ordine_e_simmetria_con_scarso_insight,disturbo_ossessivo_compulsivo_somatico,disturbo_ossessivo_compulsivo_somatico_con_scarso_insight,disturbo_ossessivo_compulsivo_superstizione,disturbo_ossessivo_compulsivo_superstizione_con_scarso_insight,disturbo_ossessivo_compulsivo_perfezione_e_responsabilita,disturbo_ossessivo_compulsivo_perfezione_e_responsabilita_con_scarso_insight,disturbo_ossessivo_compulsivo_vario,disturbo_ossessivo_compulsivo_vario_con_scarso_insight,disturbo_ansia_generalizzato,disturbo_ansia_indotto_da_sostanze_con_ansia_generalizzata,disturbo_ansia_indotto_da_sostanze_con_attacchi_di_panico,disturbo_ansia_indotto_da_sostanze_con_sintomi_ossessivo_compulsivi,disturbo_ansia_indotto_da_sostanze_con_sintomi_fobici,disturbo_ansia_dovuto_a_condizione_medica_generale_con_ansia_generalizzata,disturbo_ansia_dovuto_a_condizione_medica_generale_con_attacchi_di_panico,disturbo_ansia_dovuto_a_condizione_medica_generale_con_sintomi_ossessivo_compulsivi]).


