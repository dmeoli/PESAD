%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		inference_engine.pl
%                                                                            
%	description:
%		Il modulo inference_engine costituisce il motore inferenziale del sistema esperto e
%       si occupa di fornire i meccanismi di inferenza utili alla soluzione del problema.
%						     
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%	main:
%		avvia il sistema
main :- 
	welcome,
	menu,
	repeat,
	white_lines(1), 
	write('> '), 
	read(X),	
	run(X),
	X=chiudi.

%	welcome:
%		stampa il messaggio di presentazione del sistema
welcome :-
	white_lines(3),
	decodifica(presentazione_sistema,T_Presentazione_Sistema),
	write(T_Presentazione_Sistema).

%	menu:
%		stampa il menu' dei comandi con la descrizione relativa a ciascuno di essi
menu :- 
	white_lines(1),
	decodifica(comandi_disponibili,T_Comandi_Disponibili),	
	write(T_Comandi_Disponibili),
	white_lines(1),
	decodifica(comando_investigazione,T_Comando_Investigazione),	
	write(T_Comando_Investigazione),
	white_lines(1),
	decodifica(comando_controllo,T_Comando_Controllo),
	write(T_Comando_Controllo),
	white_lines(1),
	decodifica(comando_fatti,T_Comando_Fatti),
	write(T_Comando_Fatti),
	white_lines(1),
	decodifica(comando_aiuto,T_Comando_Aiuto),
	write(T_Comando_Aiuto),
	white_lines(1),
	decodifica(comando_pulisci,T_Comando_Pulisci),
	write(T_Comando_Pulisci),
	white_lines(1),
	decodifica(comando_chiudi,T_Comando_Chiudi),
	write(T_Comando_Chiudi),
	white_lines(1).

%	run(Comando):
%		esegue il comando in input

%	avvia l'esperto in modalita' investigazione
run(investigazione) :-
	solve(investigation),
	!.
%	avvia l'esperto in modalita' controllo
run(controllo) :-
	solve(control),
	!.
%	mostra i fatti asseriti dall'utente
run(fatti) :-
	show_facts,
	!.
%	mostra il menu con i comandi previsti dal sistema
run(aiuto) :-
	menu,
	!.
%	chiude il sistema
run(chiudi) :-
	clean_memory,
	!.
%	pulisce la memoria, cancellando tutti i fatti asseriti dall'utente o gli alberi di dimostrazione utilizzati nelle precedenti esecuzioni
run(pulisci) :-
	clean_memory,
	!.
%	caso in cui il comando digitato dall'utente non e' valido
run(X) :-
	decodifica(errore_comando,T_Errore_Comando),
	write(T_Errore_Comando).
	
%	solve(investigation):
%		avvia il sistema esperto in modalita' investigazione restituendo e stampando a video la lista dei goal risolti
%		ordinati in maniera decrescente in base al valore di certezza.	
%		A fine investigazione, da la possibilita' di visualizzare l'albero di dimostrazione per qualsiasi goal di interesse.	
solve(investigation) :-
	cancella_alberi,
	investigate_goals(Lista_Goal),
	descending_order_goals(Lista_Goal,Lista_Goal_Ordinata),
	display_investigation(Lista_Goal_Ordinata),
	investigation_how(Lista_Goal_Ordinata).

%	display_investigation(Lista_Goal):
%		stampa a video il risultato della investigazione
display_investigation(Lista_Goal) :-
	white_lines(3),
	decodifica(diagnosi,T_Diagnosi),
	write(T_Diagnosi),
	white_lines(2),
	print_goals(Lista_Goal),
	white_lines(2).

%	print_goals(Lista_Goal):
%		stampa a video la lista dei goal con il relativo grado di certezza ottenuto	
print_goals([]). 
print_goals([H|T]) :-
	arg(1,H,Goal),
	arg(2,H,CF),
	rule_I(_,Goal,_,Codice_Goal),
	Certezza is round(CF*100),
	decodifica(codice,T_Codice),
	write(T_Codice),
	write(Codice_Goal),
	write(') '),
	decodifica(Goal,Nome_Goal),
	write(Nome_Goal),
	decodifica(certezza,T_Certezza),
	write(T_Certezza),
	write(Certezza),
	write('%'),
	white_lines(2),
	print_goals(T). 

%	investigation_how(Lista_Goal):
%		chiede se l'utente e' interessato al come si e' giunti alla conclusione di un qualsiasi goal
%		e, nel caso la risposta sia positiva, stampa l'albero relativo al goal scelto.	
investigation_how(Lista_Goal) :-
	ask_investigation_how(Risposta),		
	check_response_investigation_how(Risposta,Lista_Goal).

%	ask_investigation_how(Risposta):
%		chiede all'utente se e' interessato alla stampa del "come" restituendone la relativa risposta
ask_investigation_how(Risposta) :-
	decodifica(richiesta_come_investigazione,T_Richiesta_Come_Investigazione),
	write(T_Richiesta_Come_Investigazione),
	get_simple_response(Risposta).

%	check_response_investigation_how(Risposta,Lista_Goal):
%		elabora la risposta dell'utente in merito alla richiesta del "come" si e' giunti ad una qualsiasi soluzione
check_response_investigation_how(yes,Lista_Goal) :-
	pick_goal(Lista_Goal,Nome_Goal_Scelto),
	print_tree(Nome_Goal_Scelto),
	white_lines(1),
	investigation_how(Lista_Goal_Ordinata).
check_response_investigation_how(no,_).

%	pick_goal(Lista_Goal,Nome_Goal):
%		restituisce il nome del goal scelto dall'utente
pick_goal(Lista_Goal,Nome_Goal) :-
	white_lines(1),
	decodifica(richiesta_opzione,T_Richiesta_Opzione),
	write(T_Richiesta_Opzione),
	repeat,
	write(' > '),
	read(Indice_Goal_Scelto),
	check_goal(Indice_Goal_Scelto,Lista_Goal),
	parse_goal(Indice_Goal_Scelto,Nome_Goal),
	white_lines(2),
	!.

%	check_goal(Indice_Goal,Lista_Goal):
%		controlla che il goal scelto dall'utente come risposta sia valido
check_goal(Indice_Goal,Lista_Goal) :-
	integer(Indice_Goal),
	Indice_Goal \== 0,
	length(Lista_Goal,Numero_Goal),
	Indice_Goal =< Numero_Goal.
check_goal(_,_) :-
	decodifica(errore_risposta,T_Errore_Risposta),
	write(T_Errore_Risposta),
	fail.

%	parse_goal(Indice_Goal,Nome_Goal):
%		restituisce il nome del goal a partite dall'indice	
parse_goal(Indice_Goal,Nome_Goal) :-
	rule_I(_,Nome_Goal,_,Indice_Goal).

%	solve(control):
%		avvia il sistema esperto in modalita' controllo restituendo e stampando a video il goal scelto con il relativo grado di certezza.	
%		A fine investigazione, da la possibilita' di visualizzare l'albero di dimostrazione.	
solve(control) :-
	selection_goal(Nome_Goal),	
	cancella_albero(Nome_Goal),
	solve_goal(Nome_Goal,CF),
	display_control(Nome_Goal,CF),
	control_how(Nome_Goal).

%	selection_goal(Goal):
%		restituisce il goal scelto dall'utente da una lista di possibili goal
selection_goal(Nome_Goal) :-
	white_lines(1),	
	decodifica(richiesta_goal,T_Richiesta_Goal),
	write(T_Richiesta_Goal),
	write('?'),
	white_lines(1),
	lista_goals(Lista_Goal),
	show_options(Lista_Goal),
	get_goal(Nome_Goal,Lista_Goal),
	white_lines(1).

%	get_goal(Nome_Goal,Lista_Goal):
%		restituisce il nome del goal selezionato dall'utente
get_goal(Nome_Goal,Lista_Goal) :-
	white_lines(1),
	decodifica(richiesta_opzione,T_Richiesta_Opzione),
	write(T_Richiesta_Opzione),
	repeat,
	write(' > '),
	read(Indice_Goal),
	check_selection_goal(Indice_Goal,Lista_Goal),
	parse_response(1,Indice_Goal,Nome_Goal,Lista_Goal),
	!.

%	check_selection_goal(Indice_Goal,Lista_Goal):
%		controlla che il goal in input sia presente in lista	
check_selection_goal(Indice_Goal,Lista_Goal) :-
	integer(Indice_Goal),
	Indice_Goal \== 0,
	length(Lista_Goal,Numero_Goal),
	Indice_Goal =< Numero_Goal,
	!.
check_selection_goal(_,_) :-
	decodifica(errore_risposta,T_Errore_Risposta),
	write(T_Errore_Risposta),
	fail.
	
%	display_control(Goal,CF):
%		stampa a video il risultato del controllo
display_control(Goal,CF) :-
	white_lines(2),
	decodifica(diagnosi,T_Diagnosi),
	write(T_Diagnosi),
	white_lines(2),
	decodifica(risultato_diagnosi,T_Risultato_Diagnosi),
	write(T_Risultato_Diagnosi),
	decodifica(Goal,Nome_Goal),
	write(Nome_Goal),
	decodifica(certezza,T_Certezza),
	write(T_Certezza),
	Certezza is round(CF*100),
	write(Certezza),
	write('%'),
	white_lines(2).

%	control_how(Goal):
%		chiede se l'utente e' interessato al come si e' giunti alla conclusione del goal in input e,
%		nel caso la risposta sia positiva, stampa l'albero relativo al goal scelto.		
control_how(Goal) :-
	ask_control_how(Risposta),
	check_response_control_how(Risposta,Goal).

%	ask_control_how(Risposta):
%		chiede all'utente se e' interessato alla stampa del "come" restituendone la risposta
ask_control_how(Risposta) :-
	decodifica(richiesta_come_controllo,T_Richiesta_Come_Controllo),
	write(T_Richiesta_Come_Controllo),
	get_simple_response(Risposta).

%	check_response_control_how(Risposta,Goal):
%		elabora la risposta dell'utente in merito alla richiesta del "come" si e' giunti alla soluzione del goal
check_response_control_how(yes,Goal) :-
	white_lines(1),
	print_tree(Goal).
check_response_control_how(no,_).

%	get_simple_response(Risposta):
%		restituisce la risposta utente per una domanda del tipo "si-no"
get_simple_response(Risposta) :-
	repeat,
	write('? '),
	decodifica(indicazione_risposta_si_no,T_Indicazione_Risposta_Si_No),
	write(T_Indicazione_Risposta_Si_No),
	write(' > '), 
	read(Risposta_Utente), 
	check_format_simple_response(Risposta_Utente,Risposta), 
	!.

%	check_format_simple_response(Risposta,Y):
%		controlla che la risposta digitata dall'utente sia valida e, nel caso positivo, la restituisce in un formato standard
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
	decodifica(errore_risposta,T_Errore_Risposta),
	write(T_Errore_Risposta),
	fail.

%	print_tree(Goal):
%		stampa l'albero di dimostrazione per il goal in input
print_tree(Goal) :-	
	show_rule_I(Goal).

show_rule_I(Goal) :-
	rule_I(TV,Goal,CF,Index_I),
	Certezza is round(CF*100),
	decodifica(Goal,Nome_Goal),
	write(Nome_Goal),
	%decodifica(vero,T_Vero),
	%write(T_Vero),
	show_truth_value(TV),
	write(Certezza),
	write('%'),
	white_lines(1),
	decodifica(dedotto,T_Dedotto),
	write(T_Dedotto),
	white_lines(2),
	show_rules_II(Index_I). 	

show_rules_II(Index_I) :-
	repeat,
	show_rule_II(Index_I),
	!.
	
show_rule_II(Index_I) :-
	rule_II(TV,Goal,CF,Index_I,Index_II),	
	write('\t'),
	Certezza is round(CF*100),
	decodifica(Goal,Nome_Goal),
	write(Nome_Goal),
	show_truth_value(TV),
	write(Certezza),
	write('%'),
	white_lines(1),
	write('\t'),
	decodifica(dedotto,T_Dedotto),
	write(T_Dedotto),
	white_lines(2),
	show_rules_III(Index_I,Index_II),
	fail.
show_rule_II(_).

show_rules_III(Index_I,Index_II) :-
	repeat,
	show_rule_III(Index_I,Index_II),
	!.

show_rule_III(Index_I,Index_II) :-
	rule_III(TV,Goal,CF,Index_I,Index_II,Index_III),	
	write('\t\t'),
	Certezza is round(CF*100),
	decodifica(Goal,Nome_Goal),
	write(Nome_Goal),
	show_truth_value(TV),
	write(Certezza),
	write('%'),
	white_lines(1),
	write('\t\t'),
	decodifica(dedotto,T_Dedotto),
	write(T_Dedotto),
	white_lines(2),
	show_assertions(Index_I,Index_II,Index_III),
	fail.
show_rule_III(_,_).

show_assertions(Index_I,Index_II,Index_III) :-
	repeat,
	show_assertion(Index_I,Index_II,Index_III),
	!.

show_assertion(Index_I,Index_II,Index_III) :-
	fact(TV,Attributo,Goal,CF,Index_I,Index_II,Index_III,_),	
	write('\t\t\t'),
	Certezza is round(CF*100),
	decodifica(Goal,Nome_Goal),
	write(Nome_Goal),
	decodifica(vero,T_Vero),
	write(T_Vero),
	write(Certezza),
	write('%'),
	white_lines(1),
	write('\t\t\t'),
	decodifica(detto,T_Detto),
	write(T_Detto),
	white_lines(2),
	fail.
show_assertion(_,_,_).

%	show_truth_value(Valore):
%		stampa la label vero o falso
show_truth_value(yes) :-
	decodifica(vero,T_Vero),
	write(T_Vero).
show_truth_value(no) :-
	decodifica(falso,T_Falso),
	write(T_Falso).

%	descending_order_goals(Lista_Goal,Lista_Goal_Ordinata):
%		effettua l'ordinamento dei goal, in maniera decrescente, in base al valore di certezza	
descending_order_goals(Lista_Goal,Lista_Goal_Ordinata) :-
	predsort(compare_goals,Lista_Goal,Lista_Goal_Ordinata).

compare_goals(<,goal(_,Ce_A),goal(_,Ce_B)) :-
  Ce_A > Ce_B.
compare_goals(>,_,_).

%	show_facts:
%		stampa a video i fatti asseriti dall'utente	
show_facts :- 
	white_lines(2),
	decodifica(fatti,T_Fatti),
	write(T_Fatti),
	white_lines(1),
	repeat,
	show_fact.

%	show_fact:
%		stampa ciascun fatto nel formato: (Risposta Utente, Attributo, Valore, Certezza)
show_fact :-
	known(Risposta,Attributo,Valore,Certezza),
	write('('),
	write(Risposta), 
	write(','),
	write(Attributo),
	write(','),
	write(Valore),
	write(','),
	write(Certezza),
	write(')'),	
	white_lines(1),
	fail.
show_fact.


%	clean_memory:
%		pulisce la working memory da fatti e tracce relative ad esecuzioni precedenti del sistema
clean_memory :-
	cancella_fatti,
	cancella_alberi.
	
%	criterion_ask(Attributo,Lista_Item,Numero_Item_Richiesti,Certezza):
%		consente di verificare un "criterio" che puo' essere composto da uno o piu' item.
%		Ogni item consiste in una domanda in cui l'utente puo' rispondere con "si" o "no".
%		Un criterio di N item (con N>=1) puo' richiedere che siano verificati M item (con 1<=M<=N).
%		La certezza del criterio viene calcolato selezionando dapprima il set di certezze degli M item richiesti e, dopo,
%		prendendo la certezza piu' bassa dal set ottenuto. 
%		Per es., N=3 {item1 0.4 - item2 0.7 - item3 0.6}; M=2 {item2 0.7 - item3 0.6}; Certezza=0.6
criterion_ask(Attributo,Lista_Item,Numero_Item_Richiesti,Certezza) :-
	ask_question(Attributo,Lista_Item,Numero_Item_Richiesti,Certezza,[]).

%	Cicla sugli item fin quando la lista non e' vuota. Terminato il ciclo, calcola la certezza del criterio
ask_question(Attributo,[],Numero_Item_Richiesti,Certezza,Lista_Fatti) :-
	compute_certainty_criterion_ask(Attributo,Numero_Item_Richiesti,Certezza,Lista_Fatti).
ask_question(Attributo,[Item|Item_Restanti],Numero_Item_Richiesti,Certezza,Lista_Fatti) :-
	known_question_condition(Attributo,Item,Item_Restanti,Numero_Item_Richiesti,Certezza,Lista_Fatti).

%	Se per l'n-esimo item c'e' gia' una risposta positiva, si prende il valore di certezza e si passa ad esaminare il successivo item
known_question_condition(Attributo,Item,Item_Restanti,Numero_Item_Richiesti,Certezza,Lista_Fatti) :-
	known(yes,Attributo,Item,Certezza_Risposta),
	!,
	add_element(fact(yes,Item,Certezza_Risposta),Lista_Fatti,Lista_Fatti_Aggiornata),
	ask_question(Attributo,Item_Restanti,Numero_Item_Richiesti,Certezza,Lista_Fatti_Aggiornata).
%	Se per l'n-esimo item c'e' gia' una risposta negativa, si computa il valore di certezza e si passa ad esaminare il successivo item
known_question_condition(Attributo,Item,Item_Restanti,Numero_Item_Richiesti,Certezza,Lista_Fatti) :-
	known(no,Attributo,Item,Certezza_Risposta),
	!,
	Certezza_Risposta_Computata is 1-Certezza_Risposta,
	add_element(fact(yes,Item,Certezza_Risposta_Computata),Lista_Fatti,Lista_Fatti_Aggiornata),
	ask_question(Attributo,Item_Restanti,Numero_Item_Richiesti,Certezza,Lista_Fatti_Aggiornata).
%	Effettua la domanda all'utente
known_question_condition(Attributo,Item,Item_Restanti,Numero_Item_Richiesti,Certezza,Lista_Fatti) :-	
	white_lines(2),
	decodifica(Item,Item_Esteso),
	write(Item_Esteso),
	get_criterion_response(Risposta),
	check_type_criterion_response(Risposta,Attributo,Item,Item_Restanti,Numero_Item_Richiesti,Certezza,Lista_Fatti).

%	get_criterion_response(Risposta):
%		chiede ed ottiene una risposta dall'utente per una domanda del tipo "si-no-perche"
get_criterion_response(Risposta) :-
	repeat,
	write('? '),
	decodifica(indicazione_risposta_si_no,T_Indicazione_Si_No),
	write(T_Indicazione_Si_No),
	write(' > '), 
	read(Risposta_Utente), 
	check_format_criterion_response(Risposta_Utente,Risposta), 
	!.

%	check_format_criterion_response(Risposta_Utente,Risposta):
%		controlla che la risposta digitata dall'utente sia valida e, nel caso positivo, la restituisce in un formato standard
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
	decodifica(errore_risposta,T_Errore_Risposta),
	write(T_Errore_Risposta),
	fail.

%	check_type_criterion_response(Risposta,Attributo,Item,Item_Restanti,Numero_Item_Richiesti,Certezza,Lista_Fatti):
%		elabora la risposta data dall'utente.
check_type_criterion_response(yes,Attributo,Item,Item_Restanti,Numero_Item_Richiesti,Certezza,Lista_Fatti) :-
	ask_certainty(Certezza_Risposta),
	asserta(known(yes,Attributo,Item,Certezza_Risposta)),
	add_element(fact(yes,Item,Certezza_Risposta),Lista_Fatti,Lista_Fatti_Aggiornata),
	ask_question(Attributo,Item_Restanti,Numero_Item_Richiesti,Certezza,Lista_Fatti_Aggiornata).
check_type_criterion_response(no,Attributo,Item,Item_Restanti,Numero_Item_Richiesti,Certezza,Lista_Fatti) :-
	ask_certainty(Certezza_Risposta),
	asserta(known(no,Attributo,Item,Certezza_Risposta)),
	Certezza_Risposta_Computata is 1-Certezza_Risposta,
	add_element(fact(yes,Item,Certezza_Risposta_Computata),Lista_Fatti,Lista_Fatti_Aggiornata),
	ask_question(Attributo,Item_Restanti,Numero_Item_Richiesti,Certezza,Lista_Fatti_Aggiornata).
check_type_criterion_response(why,Attributo,Item,Item_Restanti,Numero_Item_Richiesti,Certezza,Lista_Fatti) :-
	spiega(Item,Spiegazione),
	write(Spiegazione),
	known_question_condition(Attributo,Item,Item_Restanti,Numero_Item_Richiesti,Certezza,Lista_Fatti).

%	ask_certainty(Certezza):
%		restituisce il grado di certezza che l'utente associa alla risposta
ask_certainty(Certezza) :-
	white_lines(1),
	decodifica(richiesta_certezza,T_Richiesta_Certezza),
	write(T_Richiesta_Certezza),
	repeat,
	decodifica(indicazione_certezza,T_Indicazione_Certezza),
	write(T_Indicazione_Certezza),
	write(' >'),
	read(Certezza),
	check_certainty(Certezza),
	!.

%	check_certainty(Certezza):
%		controlla che il valore di certezza digitato dall'utente sia corretto
check_certainty(Certezza) :-
	float(Certezza),
	Certezza =< 1.0,
	Certezza >= 0.0,
	!.
check_certainty(_) :-
	decodifica(errore_certezza,T_Errore_Certezza),
	write(T_Errore_Certezza),
	fail.

%	compute_certainty_criterion_ask(Attributo,Numero_Item_Richiesti,Certezza,Lista_Fatti):
%		calcola la certezza del criterio. 
%		Dalla lista di certezze prende le M piu' alte con M pari al numero di item richiesti dal criterio.
%		Dalle M certezze prende la certezza piu' bassa.
compute_certainty_criterion_ask(Attributo,Numero_Item_Richiesti,Certezza,Lista_Fatti) :-
	descending_order_facts(Lista_Fatti,Lista_Fatti_Ordinata),
	get_certainty_criterion(Attributo,Numero_Item_Richiesti,Certezza,Lista_Fatti_Ordinata,1,[]).

%	Dalla lista dei fatti ordinati per valore di certezza, preleva i primi M fatti richiesti dal criterio.
get_certainty_criterion(Attributo,Numero_Item_Richiesti,Certezza,Lista_Fatti_Ordinata,Contatore,Lista_Fatti_Candidati) :-
	Contatore =< Numero_Item_Richiesti,
	!,
	Lista_Fatti_Ordinata = [Fatto_Certezza_Max|Residuo_Lista_Fatti_Ordinata],
	add_element(Fatto_Certezza_Max,Lista_Fatti_Candidati,Lista_Fatti_Candidati_Aggiornata),
	Contatore_Aggiornato is Contatore+1,
	assert_fact(Attributo,Fatto_Certezza_Max),
	get_certainty_criterion(Attributo,Numero_Item_Richiesti,Certezza,Residuo_Lista_Fatti_Ordinata,Contatore_Aggiornato,Lista_Fatti_Candidati_Aggiornata).
%	Dagli M fatti candidati prende quello con certezza piu' bassa, il quale caratterizzera' la certezza finale del criterio.
get_certainty_criterion(_,_,Certezza,_,_,Lista_Fatti_Candidati) :-
	ascending_order_facts(Lista_Fatti_Candidati,Lista_Fatti_Candidati_Ordinata),
	Lista_Fatti_Candidati_Ordinata = [Fatto_Certezza_Min|_],
	arg(3,Fatto_Certezza_Min,Certezza).
	
%	assert_fact(Attributo,Fatto):
%		asserisce un fatto ottenuto da una domanda a risposta secca
assert_fact(Attributo,Fatto) :-
	ultimo_indice_I_livello(Index_I),
	ultimo_indice_II_livello(Index_II),
	ultimo_indice_III_livello(Index_III),
	ultimo_indice_IV_livello(Index_IV),
	arg(1,Fatto,Risposta),
	arg(2,Fatto,Item),
	arg(3,Fatto,CF),
	assertz(fact(Risposta,Attributo,Item,CF,Index_I,Index_II,Index_III,Index_IV)),
	prossimo_indice_IV_livello(_).

%	ascending_order_facts(Lista_Fatti,Lista_Fatti_Ordinata):
%		effettua l'ordinamento della lista dei fatti, in maniera ascendente, in base al valore di certezza	
ascending_order_facts(Lista_Fatti,Lista_Fatti_Ordinata) :-
	predsort(compare_ascending_facts,Lista_Fatti,Lista_Fatti_Ordinata).

compare_ascending_facts(>,fact(_,_,Ce_A),fact(_,_,Ce_B)) :-
  Ce_A > Ce_B.
compare_ascending_facts(<,_,_).

%	descending_order_facts(Lista_Fatti,Lista_Fatti_Ordinata):
%		effettua l'ordinamento della lista dei fatti, in maniera decrescente, in base al valore di certezza	
descending_order_facts(Lista_Fatti,Lista_Fatti_Ordinata) :-
	predsort(compare_facts,Lista_Fatti,Lista_Fatti_Ordinata).

compare_facts(<,fact(_,_,Ce_A),fact(_,_,Ce_B)) :-
  Ce_A > Ce_B.
compare_facts(>,_,_).

%	multiple_ask(Attributo,Lista_Opzioni,Lista_Opzioni_Ammesse,Certezza):
%		consente di invocare domande in cui la risposta va scelta tra un elenco di possibili valori.
%		Se la risposta e' una tra quelle ammesse dalla domanda, allora la certezza e' pari a quella digitata dall'utente,
%		altrimenti e' data dal rapporto tra il complemento della certezza della risposta data dall'utente e le opzioni restanti.
%		Es. Domanda 1; Risposte: a, b, c; Risposte Ammesse: a; Risposta Utente: c con Certezza 0.7; Certezza = (1-0.7)/2
multiple_ask(Attributo,Lista_Opzioni,Lista_Opzioni_Ammesse,Certezza) :-
	known(yes,Attributo,Risposta,Certezza_Risposta),
	!,
	compute_certainty_multiple_ask(Attributo,Certezza,Risposta,Certezza_Risposta,Lista_Opzioni,Lista_Opzioni_Ammesse).
multiple_ask(Attributo,Lista_Opzioni,Lista_Opzioni_Ammesse,Certezza) :-
	white_lines(2),	
	decodifica(Attributo,Attributo_Esteso),
	write(Attributo_Esteso),
	write('?'),
	white_lines(1),
	show_options(Lista_Opzioni),
	get_multiple_response(Opzione_Scelta,Opzione_Scelta_Codificata,Lista_Opzioni),
	check_type_multiple_response(Opzione_Scelta_Codificata,Risposta,Attributo,Lista_Opzioni,Lista_Opzioni_Ammesse,Certezza).

%	show_options(Lista_Opzioni):
%		stampa le varie opzioni della domanda in esame	
show_options(Lista_Opzioni) :-
	show_option(1,Lista_Opzioni).

show_option(_,[]).
show_option(N,[Opzione|Lista_Opzioni_Restanti]) :-
	write('\t'),
	write(N),
	write(': '),
	decodifica(Opzione,Opzione_Estesa),
	write(Opzione_Estesa),
	white_lines(1), 
	NN is N+1,
	show_option(NN,Lista_Opzioni_Restanti).

%	get_multiple_response(Opzione_Scelta,Risposta,Lista_Opzioni):
%		chiede ed ottiene una risposta dall'utente relativamente ad una domanda con risposta multipla
get_multiple_response(Opzione_Scelta,Risposta,Lista_Opzioni) :-
	white_lines(1),
	decodifica(richiesta_opzione,T_Richiesta_Opzione),
	write(T_Richiesta_Opzione),
	repeat,
	write(' > '),
	read(Opzione_Scelta),
	check_multiple_response(Opzione_Scelta,Risposta,Lista_Opzioni),
	!.

%	check_multiple_response(Opzione_Scelta,Risposta,Lista_Opzioni):
%		controlla che l'opzione scelta dall'utente come risposta sia valida
check_multiple_response(Opzione_Scelta,Risposta,Lista_Opzioni) :-
	integer(Opzione_Scelta),
	Opzione_Scelta \== 0,
	length(Lista_Opzioni,Numero_Opzioni),
	Opzione_Scelta =< Numero_Opzioni,
	!,
	Risposta = Opzione_Scelta.
check_multiple_response(perche,why,_) :-
	!.
check_multiple_response(p,why,_) :-
	!.
check_multiple_response(why,why,_) :-
	!.
check_multiple_response(_,_,_) :-
	decodifica(errore_risposta,T_Errore_Risposta),
	write(T_Errore_Risposta),
	fail.

%	check_type_multiple_response(Opzione_Scelta,Risposta,Attributo,Lista_Opzioni,Lista_Opzioni_Ammesse,Certezza):
%		elabora la risposta utente
check_type_multiple_response(why,_,Attributo,Lista_Opzioni,Lista_Opzioni_Ammesse,Certezza) :-
	!,
	spiega(Attributo,Spiegazione),
	write(Spiegazione),
	multiple_ask(Attributo,Lista_Opzioni,Lista_Opzioni_Ammesse,Certezza).
check_type_multiple_response(Opzione_Scelta,Risposta,Attributo,Lista_Opzioni,Lista_Opzioni_Ammesse,Certezza) :-
	parse_response(1,Opzione_Scelta,Risposta,Lista_Opzioni),
	ask_certainty(Certezza_Risposta),
	asserta(known(yes,Attributo,Risposta,Certezza_Risposta)),
	compute_certainty_multiple_ask(Attributo,Certezza,Risposta,Certezza_Risposta,Lista_Opzioni,Lista_Opzioni_Ammesse).

%	parse_response(Contatore,Opzione_Scelta,Risposta,Lista_Opzioni):
%		restituisce l'opzione scelta dall'utente tramite il numero scelto dal menu'
parse_response(Num,Num,Opzione,[Opzione|_]).
parse_response(Contatore,Num,Risposta,[_|Lista_Opzioni_Restanti]) :-
	Contatore_Aggiornato is Contatore+1,
	parse_response(Contatore_Aggiornato,Num,Risposta,Lista_Opzioni_Restanti).

%	compute_certainty_multiple_ask(Attributo,Certezza,Risposta,Certezza_Risposta,Lista_Opzioni,Lista_Opzioni_Ammesse):
%		calcola la certezza per una domanda a risposta multipla.
%		Se la risposta e' una tra quelle ammesse dalla domanda, allora la certezza e' pari a quella digitata dall'utente,
%		altrimenti e' data dal rapporto tra il complemento della certezza della risposta data dall'utente e le opzioni restanti.
compute_certainty_multiple_ask(Attributo,Certezza,Risposta,Certezza_Risposta,_,Lista_Opzioni_Ammesse) :-
	member(Risposta,Lista_Opzioni_Ammesse),
	!,
	Certezza = Certezza_Risposta,
	assert_fact_multiple_ask(Attributo,Risposta,Certezza_Risposta).
compute_certainty_multiple_ask(Attributo,Certezza,_,Certezza_Risposta,Lista_Opzioni,Lista_Opzioni_Ammesse) :-
	Lista_Opzioni_Ammesse = [Risposta|_],
	length(Lista_Opzioni,Numero_Opzioni),
	Certezza is (1-Certezza_Risposta)/(Numero_Opzioni-1),
	assert_fact_multiple_ask(Attributo,Risposta,Certezza).

%	assert_fact_multiple_ask(Attributo,Risposta,CF):
%		asserisce un fatto ottenuto da una domanda a risposta multipla
assert_fact_multiple_ask(Attributo,Risposta,CF) :-
	ultimo_indice_I_livello(Index_I),
	ultimo_indice_II_livello(Index_II),
	ultimo_indice_III_livello(Index_III),
	ultimo_indice_IV_livello(Index_IV),
	assertz(fact(yes,Attributo,Risposta,CF,Index_I,Index_II,Index_III,Index_IV)),
	prossimo_indice_IV_livello(_).

%	selective_ask(Attributo,Opzione_Ammessa,Lista_Opzioni):
%		consente di invocare domande in cui la risposta va scelta selettivamente tra un elenco di possibili valori.
%		Si noti che se l'opzione scelta non e' quella corretta per la domanda in esame, avviene un fallimento.
selective_ask(Attributo,Opzione_Ammessa,_) :-
	known(yes,Attributo,Opzione_Ammessa,_),
	!.
selective_ask(Attributo,_,_) :-
	known(yes,Attributo,_,_),
	!,
	fail.
selective_ask(Attributo,Opzione_Ammessa,Lista_Opzioni) :-
	white_lines(1),
	decodifica(Attributo,Attributo_Esteso),
	write(Attributo_Esteso),
	white_lines(1),
	show_options(Lista_Opzioni),
	get_multiple_response(Opzione_Scelta,Opzione_Scelta_Codificata,Lista_Opzioni),
	check_type_selective_response(Opzione_Scelta_Codificata,Risposta,Attributo,Lista_Opzioni,Opzione_Ammessa).

%	check_type_selective_response(Opzione_Scelta,Risposta,Attributo,Lista_Opzioni,Opzione_Ammessa):
%		elabora la risposta utente.
check_type_selective_response(why,_,Attributo,Lista_Opzioni,Opzione_Ammessa) :-
	!,
	spiega(Attributo,Spiegazione),
	write(Spiegazione),
	white_lines(1),
	selective_ask(Attributo,Opzione_Ammessa,Lista_Opzioni).
check_type_selective_response(Opzione_Scelta,Risposta,Attributo,Lista_Opzioni,Opzione_Ammessa) :-
	parse_response(1,Opzione_Scelta,Risposta,Lista_Opzioni),
	asserta(known(yes,Attributo,Risposta,1.0)),
	Opzione_Ammessa = Risposta.

%	certezza(Goal,Tipo_Goal,Lista_CF_Antecedente,CF_Regola,CF_Conseguente,Truth_Value): 
%		calcola la certezza a partire dalla certezza della parte antecedente della regola e dalla certezza della regola.
certezza(Goal,Tipo_Goal,Lista_CF_Antecedente,CF_Regola,CF_Conseguente,Truth_Value) :-
	certezza_antecedente(Lista_CF_Antecedente,CF_Antecedente),
	certezza_conseguente(Goal,Tipo_Goal,CF_Antecedente,CF_Regola,CF_Conseguente,Truth_Value).

%	certezza_antecedente(Lista_CF_Antecedente,CF_Antecedente):
% 	calcola la certezza delle parte antecedente di una regola in cui e' richiesto che siano veri tutti i fatti.
%		La certezza e' data dunque dal fatto con certezza piu' bassa.
certezza_antecedente(Lista_CF_Antecedente,CF_Antecedente) :-
	min_list(Lista_CF_Antecedente,CF_Antecedente).

%	certezza_conseguente(Goal,Livello_Inferenza,CF_Antecedente,CF_Regola,CF_Conseguente,Truth_Value):
%		calcola la certezza relativa alla parte conseguente di una regola.
%		Se il goal non e' negato, la certezza si ottiene moltiplicando la certezza della regola per la certezza della parte antecedente
%		Se il goal e' negato, invece, la certezza si ottiene facendo il complemento del prodotto ottenuto tra la certezza della regola e 
%		la certezza della parte antecedente.
certezza_conseguente(Goal,1,CF_Antecedente,CF_Regola,CF_Conseguente,true) :-
	CF_Conseguente is CF_Regola*CF_Antecedente,
	ultimo_indice_I_livello(Index_I),
	assertz(rule_I(yes,Goal,CF_Conseguente,Index_I)),
	prossimo_indice_I_livello(_),
	azzera_indice_II_livello.
certezza_conseguente(Goal,1,CF_Antecedente,CF_Regola,CF_Conseguente,false) :-
	CF_Conseguente is 1-(CF_Regola*CF_Antecedente),
	ultimo_indice_I_livello(Index_I),
	assertz(rule_I(no,Goal,CF_Conseguente,Index_I)),
	prossimo_indice_I_livello(_),
	azzera_indice_II_livello.
certezza_conseguente(Goal,2,CF_Antecedente,CF_Regola,CF_Conseguente,true) :-
	CF_Conseguente is CF_Regola*CF_Antecedente,
	ultimo_indice_I_livello(Index_I),
	ultimo_indice_II_livello(Index_II),
	assertz(rule_II(yes,Goal,CF_Conseguente,Index_I,Index_II)),
	prossimo_indice_II_livello(_),
	azzera_indice_III_livello.
certezza_conseguente(Goal,2,CF_Antecedente,CF_Regola,CF_Conseguente,false) :-
	CF_Conseguente is 1-(CF_Regola*CF_Antecedente),
	ultimo_indice_I_livello(Index_I),
	ultimo_indice_II_livello(Index_II),
	assertz(rule_II(no,Goal,CF_Conseguente,Index_I,Index_II)),
	prossimo_indice_II_livello(_),
	azzera_indice_III_livello.
certezza_conseguente(Goal,3,CF_Antecedente,CF_Regola,CF_Conseguente,true) :-
	CF_Conseguente is CF_Regola*CF_Antecedente,
	ultimo_indice_I_livello(Index_I),
	ultimo_indice_II_livello(Index_II),
	ultimo_indice_III_livello(Index_III),
	assertz(rule_III(yes,Goal,CF_Conseguente,Index_I,Index_II,Index_III)),
	prossimo_indice_III_livello(_),
	azzera_indice_IV_livello.
certezza_conseguente(Goal,3,CF_Antecedente,CF_Regola,CF_Conseguente,false) :-
	CF_Conseguente is 1-(CF_Regola*CF_Antecedente),
	ultimo_indice_I_livello(Index_I),
	ultimo_indice_II_livello(Index_II),
	ultimo_indice_III_livello(Index_III),
	assertz(rule_III(no,Goal,CF_Conseguente,Index_I,Index_II,Index_III)),
	prossimo_indice_III_livello(_),
	azzera_indice_IV_livello.

%	restituisce l'indice disponibile per I livello di inferenza
ultimo_indice_I_livello(1).

%	restituisce l'indice disponibile per II livello di inferenza
ultimo_indice_II_livello(1).

%	restituisce l'indice disponibile per III livello di inferenza
ultimo_indice_III_livello(1).

%	restituisce l'indice disponibile per IV livello di inferenza
ultimo_indice_IV_livello(1).

%	aggiorna l'indice per I livello di inferenza
prossimo_indice_I_livello(Prossimo) :-
        retract(ultimo_indice_I_livello(Ultimo)),
        Prossimo is Ultimo+1,
        assert(ultimo_indice_I_livello(Prossimo)).

%	aggiorna l'indice per II livello di inferenza
prossimo_indice_II_livello(Prossimo) :-
        retract(ultimo_indice_II_livello(Ultimo)),
        Prossimo is Ultimo+1,
        assert(ultimo_indice_II_livello(Prossimo)).

%	aggiorna l'indice per III livello di inferenza
prossimo_indice_III_livello(Prossimo) :-
        retract(ultimo_indice_III_livello(Ultimo)),
        Prossimo is Ultimo+1,
        assert(ultimo_indice_III_livello(Prossimo)).

%	aggiorna l'indice per IV livello di inferenza
prossimo_indice_IV_livello(Prossimo) :-
        retract(ultimo_indice_IV_livello(Ultimo)),
        Prossimo is Ultimo+1,
        assert(ultimo_indice_IV_livello(Prossimo)).

%	azzera l'indice per I livello di inferenza
azzera_indice_I_livello :-
	retract(ultimo_indice_I_livello(_)),
	assert(ultimo_indice_I_livello(1)).

%	azzera l'indice per II livello di inferenza
azzera_indice_II_livello :-
	retract(ultimo_indice_II_livello(_)),
	assert(ultimo_indice_II_livello(1)).

%	azzera l'indice per III livello di inferenza
azzera_indice_III_livello :-
	retract(ultimo_indice_III_livello(_)),
	assert(ultimo_indice_III_livello(1)).

%	azzera l'indice per IV livello di inferenza
azzera_indice_IV_livello :-
	retract(ultimo_indice_IV_livello(_)),
	assert(ultimo_indice_IV_livello(1)).

%	cancella_albero(Goal):
%		cancella l'albero per il goal specificato in input
cancella_albero(Goal) :-
	retractall(rule_I(_,Goal,_,Index_I)),
	retractall(rule_II(_,_,_,Index_I,_)),
	retractall(rule_III(_,_,_,Index_I,_,_)),
	retractall(fact(_,_,_,_,Index_I,_,_,_)),
	azzera_indice_I_livello.

%	cancella_alberi:
%		cancella gli alberi presenti in memoria
cancella_alberi :-
	retractall(rule_I(_,_,_,_)),
	retractall(rule_II(_,_,_,_,_)),
	retractall(rule_III(_,_,_,_,_,_)),
	retractall(fact(_,_,_,_,_,_,_,_)),
	azzera_indice_I_livello.

%	cancella_fatti:
%		cancella i fatti presenti in memoria
cancella_fatti :-
	retractall(known(_,_,_,_)).

% 	white_lines(Numero_Nl):
%		stampa un numero di linee bianche dipendentemente dal valore specificato in input
white_lines(Numero_Nl) :-
	white_line(Numero_Nl,0).

white_line(Numero_Nl,Contatore) :-
	Contatore < Numero_Nl,
	!,
	nl,
	Contatore_Aggiornato is Contatore+1,
	white_line(Numero_Nl,Contatore_Aggiornato).
white_line(Numero_Nl,Contatore).

%	add_element(X,L,L1)
%		aggiunge l'elemento X alla lista L ottenendo L1
add_element(Elemento,Lista,[Elemento|Lista]).

%	delete_element(X,L,L1)
%		elimina l'elemento X dalla lista L ottenendo L1
delete_element(Elemento,[],[]).
delete_element(Elemento,[Elemento|Residuo_Lista],Residuo_Lista) :-
	!.
delete_element(Elemento,[Testa|Coda],[Testa|Residuo_Lista]) :-
	delete_element(Elemento,Coda,Residuo_Lista).
