%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		evaluate.pl
%
%	description:
%		Evaluation from facts: the knowledge base run without questions, on
%		the answers and test results given at once (the input of the web API
%		POST /evaluate). Facts are of four kinds: an item answered yes or no
%		with a certainty, a choice, a graded number and a finding (a test
%		result, see findings.pl) that becomes evidence for some items. A
%		direct answer to an item overrides the findings; among findings the
%		confirmatory evidence overrides the provisional one, and evidence of
%		the same kind combines by its maximum.
%
%		The goals are evaluated twice. In the lower run every missing datum
%		takes the value against the goal (a missing symptom is absent, a
%		missing exclusion holds); in the upper run it takes the value for
%		the goal, and the provisional evidence counts as missing. The polarity
%		of a datum is reversed under each criterion required false (see the
%		negation clauses in criteria.pl). Every criterion and goal is then met
%		when its lower certainty reaches the threshold, not met when its
%		upper certainty does not, unknown otherwise; the missing data are
%		those the two runs met without an answer.
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- use_module(library(http/json)).

:- thread_local evaluation_bound/1.	% lower | upper, while a run is on
:- thread_local provisional/2.		% provisional(Attribute,Item): screening evidence only
:- thread_local count_evidence/4.	% count_evidence(Count,N,Weight,Kind)
:- thread_local missing_item/3.		% missing_item(Bound,Goal,Item)
:- thread_local evidence/5.		% evidence(Item,Degree,Kind,Source,Index)
:- thread_local count_source/3.		% count_source(Count,Kind,Source)
:- thread_local run_result/4.		% run_result(Bound,Goal,CF,Index_I)
:- thread_local run_node/6.		% run_node(Bound,Goal,Key,TV,CF,Level)
:- thread_local run_tree/4.		% run_tree(Bound,Goal,Text,Tree)

evaluation_threshold(0.5).


%-------------------------------ENGINE HOOKS------------------------------------
%	Called by ask.pl, criteria.pl and fuzzy.pl; they fail outside an evaluation.

%	missing_in_evaluation(Attribute,Item): Item of Attribute has no answer in
%	this run (or only provisional evidence, in the upper run); it is recorded.
missing_in_evaluation(Attribute,Item) :-
	evaluation_bound(Bound),
	(   Attribute == Item
	->  \+ ( known(yes,Attribute,_,_), \+ ( Bound == upper, provisional(Attribute,_) ) )
	;   \+ ( known(_,Attribute,Item,_), \+ ( Bound == upper, provisional(Attribute,Item) ) ) ),
	record_missing(Bound,Item).

record_missing(Bound,Item) :-
	nb_current(pesad_goal,Goal),
	Goal \== none,
	!,
	(   missing_item(Bound,Goal,Item)
	->  true
	;   assertz(missing_item(Bound,Goal,Item)) ).
record_missing(_,_).

%	missing_degree(Degree): the value of a missing datum, 1 when it favours
%	the bound of the run, 0 otherwise.
missing_degree(Degree) :-
	evaluation_bound(Bound),
	current_polarity(Polarity),
	(   ( Bound == upper, Polarity == positive ; Bound == lower, Polarity == negative )
	->  Degree = 1.0
	;   Degree = 0.0 ).

current_polarity(Polarity) :-
	(   nb_current(pesad_polarity,P), P \== []
	->  Polarity = P
	;   Polarity = positive ).

%	negation_hook(Key), negated(Key,Goal): a criterion required false, called
%	during a run, is solved with the polarity reversed (Key guards the clause
%	that reverses it from calling itself).
negation_hook(Key) :-
	evaluation_bound(_),
	\+ ( nb_current(pesad_skip,Skip), Skip == Key ).

negated(Key,Goal) :-
	current_polarity(Polarity),
	opposite(Polarity,Opposite),
	( nb_current(pesad_skip,Skip) -> true ; Skip = none ),
	b_setval(pesad_polarity,Opposite),
	b_setval(pesad_skip,Key),
	once(Goal),
	b_setval(pesad_skip,Skip),
	b_setval(pesad_polarity,Polarity).

opposite(positive,negative).
opposite(negative,positive).

%	count_evidence_for(Count,N,Weight): a symptom count to use in place of
%	the items (confirmatory first; a provisional one is ignored by the upper run).
count_evidence_for(Count,N,Weight) :-
	count_evidence(Count,N,Weight,confirmatory),
	!.
count_evidence_for(Count,N,Weight) :-
	\+ evaluation_bound(upper),
	count_evidence(Count,N,Weight,provisional),
	!.


%--------------------------------ASKABLE DATA-----------------------------------

%	askable_item(Item): every yes/no item the knowledge base may ask,
%	discovered from the criteria clauses, plus the item lists and the
%	single-item criteria.
askable_item(Item) :-
	askable_items(Items),
	memberchk(Item,Items).

%	askable_items(Items): computed once, then cached (the knowledge base is static).
:- dynamic askable_cache/1.
askable_items(Items) :-
	askable_cache(Items),
	!.
askable_items(Items) :-
	discover_askable_items(Items),
	assertz(askable_cache(Items)).

discover_askable_items(Items) :-
	findall(I,
		( member(P/N,[symptomatic_manifestation/4,symptomatic_feature/4,specific_phobia_type/4,disorder_nc/4,academic_domain_certainty/3]),
		  functor(Head,P,N),
		  clause(Head,Body),
		  body_goal(Body,Goal),
		  ( Goal = symptom(L,_,_) ; Goal = etiological_evidence(L,_,_) ; Goal = symptom_count(_,L,_,_) ),
		  is_list(L),
		  member(I,L),
		  atom(I) ),
		Raw),
	findall(L,( adhd_inattention_items(L) ; adhd_hyperactivity_items(L) ),Ls0),
	findall(L,( academic_domain(_,S,B), L = [B|S] ),Ls1),
	append(Ls0,Ls1,Ls),
	append(Ls,Listed),
	findall(I,single_item_criterion(I),Single),
	append([Raw,Listed,Single],All),
	sort(All,Items).

%	body_goal(Body,Goal): each goal of a clause body.
body_goal((A,B),G) :- !, ( body_goal(A,G) ; body_goal(B,G) ).
body_goal((A;B),G) :- !, ( body_goal(A,G) ; body_goal(B,G) ).
body_goal((A->B),G) :- !, ( body_goal(A,G) ; body_goal(B,G) ).
body_goal(unless_absent(_,G0,_),G) :- !, body_goal(G0,G).
body_goal(G,G).

%	choice_question(Question,Options): the multiple-choice and selective
%	questions, from their wrappers in criteria.pl (the age is given apart).
choice_question(Question,Options) :-
	member(Wrapper,[attack_type(_,_),insight_specifier(_),onset_specifier(_),presentation_specifier(_),adjustment_subtype(_),panic_attacks_frequency(_,_),symptoms_duration(_,_),symptoms_onset(_,_),bereavement_time(_,_),anxiety_type(_,_),phobic_reaction_type(_,_),adhd_severity(_),learning_disorder_severity(_),idd_severity(_),asd_support(_,_)]),
	clause(Wrapper,Body),
	body_goal(Body,Ask),
	( Ask = multiple_ask(Question,Options,_,_) ; Ask = selective_ask(Question,_,Options) ),
	is_list(Options).

graded_variable(duration_months).
graded_variable(panic_attacks_count).

%	age_band(Years,Band): the age band of the consultation.
age_band(Y,preschool) :- Y =< 6, !.
age_band(Y,child) :- Y < 13, !.
age_band(Y,adolescent) :- Y < 18, !.
age_band(_,adult).


%-------------------------------LOADING THE FACTS-------------------------------

%	load_request(Request): the age and the facts of the request, as the
%	working memory of the engine. Throws evaluation_error(Index,Message).
load_request(Request) :-
	load_age(Request),
	( get_dict(facts,Request,Facts) -> true ; Facts = [] ),
	( is_list(Facts) -> true ; throw(evaluation_error(null,'facts must be a list')) ),
	forall(nth0(Index,Facts,Fact), load_fact(Index,Fact)),
	resolve_evidence.

load_age(Request) :-
	(   get_dict(age,Request,Age), Age \== null
	->  ( number(Age), Age >= 0, Age =< 120 -> true ; throw(evaluation_error(null,'age must be a number of years')) ),
	    age_band(Age,Band0),
	    assertz(known_value(age_years,Age))
	;   true ),
	(   get_dict(age_band,Request,Band1), Band1 \== null
	->  ( memberchk(Band1,[preschool,child,adolescent,adult]) -> true ; throw(evaluation_error(null,'unknown age_band')) ),
	    ( var(Band0) -> true ; Band0 == Band1 -> true ; throw(evaluation_error(null,'age and age_band disagree')) ),
	    Band = Band1
	;   nonvar(Band0)
	->  Band = Band0
	;   throw(evaluation_error(null,'age or age_band is required')) ),
	assertz(known(yes,patient,Band,1.0)).

%	load_fact(Index,Fact): one fact of the request.
load_fact(Index,Fact) :-
	is_dict(Fact),
	dict_pairs(Fact,_,Pairs),
	pairs_keys(Pairs,Keys),
	include([K]>>memberchk(K,[item,choice,number,finding]),Keys,[Kind]),
	!,
	get_dict(Kind,Fact,Id),
	( get_dict(value,Fact,Value) -> true ; throw(evaluation_error(Index,'value is required')) ),
	( get_dict(certainty,Fact,C) -> true ; C = 1.0 ),
	( number(C), C >= 0, C =< 1 -> true ; throw(evaluation_error(Index,'certainty must be in [0,1]')) ),
	load_fact(Kind,Index,Id,Value,C).
load_fact(Index,_) :-
	throw(evaluation_error(Index,'a fact has exactly one of item, choice, number, finding')).

load_fact(item,Index,Item,Value,C) :-
	( atom(Item), askable_item(Item) -> true ; throw(evaluation_error(Index,'unknown item')) ),
	( Value == true -> Degree = C ; Value == false -> Degree is 1-C ; throw(evaluation_error(Index,'an item value is true or false')) ),
	assertz(evidence(Item,Degree,direct,item,Index)).
load_fact(choice,Index,Question,Option,C) :-
	( atom(Question), choice_question(Question,Options) -> true ; throw(evaluation_error(Index,'unknown choice question')) ),
	( atom(Option), memberchk(Option,Options) -> true ; throw(evaluation_error(Index,'not an option of the question')) ),
	retractall(known(_,Question,_,_)),
	assertz(known(yes,Question,Option,C)).
load_fact(number,Index,Variable,N,_) :-
	( graded_variable(Variable) -> true ; throw(evaluation_error(Index,'unknown graded variable')) ),
	( number(N), N >= 0 -> true ; throw(evaluation_error(Index,'a graded value is a number >= 0')) ),
	retractall(known_value(Variable,_)),
	assertz(known_value(Variable,N)).
load_fact(finding,Index,Id,Value,_) :-
	( atom(Id), finding(Id,Type,_) -> true ; throw(evaluation_error(Index,'unknown finding')) ),
	( valid_value(Type,Value) -> true ; throw(evaluation_error(Index,'value out of the range of the finding')) ),
	forall(finding_evidence(Id,Value,E), add_evidence(E,Id,Index)).

valid_value(integer(Min,Max),V) :- integer(V), V >= Min, V =< Max.
valid_value(number(Min,Max),V) :- number(V), V >= Min, V =< Max.
valid_value(boolean,V) :- memberchk(V,[true,false]).

add_evidence(item(Item,Degree,Kind),Id,Index) :-
	assertz(evidence(Item,Degree,Kind,Id,Index)).
add_evidence(count(Count,N,Weight,Kind),Id,_) :-
	assertz(count_evidence(Count,N,Weight,Kind)),
	assertz(count_source(Count,Kind,Id)).
add_evidence(childhood(N),Id,Index) :-
	assertz(evidence(childhood_count,N,count,Id,Index)).
add_evidence(informant(B),Id,Index) :-
	assertz(evidence(informant,B,record,Id,Index)).
add_evidence(choice(Question,Option),_,_) :-
	( known(yes,Question,_,_) -> true ; assertz(known(yes,Question,Option,1.0)) ).
add_evidence(value(Variable,N),_,_) :-
	( known_value(Variable,_) -> true ; assertz(known_value(Variable,N)) ).

%	resolve_evidence: one answer per item (direct, then confirmatory, then
%	provisional, each by its maximum); the childhood counts become criterion B
%	of ADHD.
resolve_evidence :-
	(   aggregate_all(sum(N),evidence(childhood_count,N,count,_,_),Total),
	    evidence(childhood_count,_,count,_,_)
	->  ( evidence(informant,B,record,_,_) -> true ; B = none ),
	    childhood_evidence(Total,B,Degree),
	    assertz(evidence(several_symptoms_before_age_twelve,Degree,confirmatory,diva5_childhood,null))
	;   true ),
	findall(I,( evidence(I,_,K,_,_), memberchk(K,[direct,confirmatory,provisional]), askable_item(I) ),Is0),
	sort(Is0,Items),
	forall(member(Item,Items), resolve_item(Item)).

resolve_item(Item) :-
	member(Kind,[direct,confirmatory,provisional]),
	aggregate_all(max(D),evidence(Item,D,Kind,_,_),Degree),
	!,
	retractall(known(_,symptom,Item,_)),
	assertz(known(yes,symptom,Item,Degree)),
	( Kind == provisional -> assertz(provisional(symptom,Item)) ; true ).


%---------------------------------THE TWO RUNS----------------------------------

%	run_bound(Bound): every goal under Bound, recording its certainty, the
%	certainties of its criteria, its proof tree and its missing data.
run_bound(Bound) :-
	retractall(evaluation_bound(_)),
	assertz(evaluation_bound(Bound)),
	delete_trees,
	nb_setval(pesad_polarity,positive),
	nb_setval(pesad_skip,none),
	known(yes,patient,Patient,_),
	goals_list(Goals),
	forall(member(Goal,Goals), run_goal(Bound,Patient,Goal)),
	nb_setval(pesad_goal,none),
	retractall(evaluation_bound(_)).

run_goal(Bound,Patient,Goal) :-
	nb_setval(pesad_goal,Goal),
	last_level_I_index(Index),
	reset_level_II_index,
	reset_level_III_index,
	(   disorder(Goal,Patient,CF)
	->  assertz(run_result(Bound,Goal,CF,Index)),
	    record_nodes(Bound,Goal,Index),
	    record_tree(Bound,Goal)
	;   assertz(run_result(Bound,Goal,0.0,none)),
	    retractall(rule_II(_,_,_,Index,_)),
	    retractall(rule_III(_,_,_,Index,_,_)),
	    retractall(fact(_,_,_,_,Index,_,_,_)) ).

%	record_nodes(Bound,Goal,Index): the criteria of the proof tree of Goal,
%	keyed by parent and name (a level-III node without a level-II parent is
%	a specifier called by the goal itself).
record_nodes(Bound,Goal,I) :-
	forall(rule_II(TV,Name,CF,I,_),
		assertz(run_node(Bound,Goal,Goal/Name,TV,CF,2))),
	forall(rule_III(TV,Name,CF,I,II,_),
		( ( rule_II(_,Parent,_,I,II) -> true ; Parent = Goal ),
		  assertz(run_node(Bound,Goal,Parent/Name,TV,CF,3)) )).

record_tree(Bound,Goal) :-
	(   with_output_to(string(Text),print_tree(Goal)) -> true ; Text = "" ),
	(   rule_I(TV,Goal,CF,I)
	->  tree_dict(I,Goal,TV,CF,Tree)
	;   Tree = null ),
	assertz(run_tree(Bound,Goal,Text,Tree)).

%	tree_dict(...): the proof tree as nested dicts (goal, criteria, facts).
tree_dict(I,Goal,TV,CF,_{id:Goal,name:Name,required:Req,certainty:C,children:Children}) :-
	node_name(Goal,Name),
	tv_required(TV,Req),
	round3(CF,C),
	findall(Child,
		( rule_II(TV2,N2,CF2,I,II),
		  findall(G3,
			( rule_III(TV3,N3,CF3,I,II,III), level3_dict(I,II,III,N3,TV3,CF3,G3) ),
			C3),
		  node_name(N2,L2), tv_required(TV2,R2), round3(CF2,C2),
		  Child = _{id:N2,name:L2,required:R2,certainty:C2,children:C3} ),
		Level2),
	findall(G3,
		( rule_III(TV3,N3,CF3,I,II,III), \+ rule_II(_,_,_,I,II),
		  level3_dict(I,II,III,N3,TV3,CF3,G3) ),
		Orphans),
	append(Level2,Orphans,Children).

level3_dict(I,II,III,N3,TV3,CF3,_{id:N3,name:L3,required:R3,certainty:C3,children:Facts}) :-
	node_name(N3,L3), tv_required(TV3,R3), round3(CF3,C3),
	findall(_{id:Item,name:L4,certainty:C4,source:Source},
		( fact(Answer,_,Item,CF4,I,II,III,_),
		  node_name(Item,L4), round3(CF4,C4),
		  ( Answer == missing -> Source = missing ; Source = stated ) ),
		Facts).

node_name(Key,Name) :-
	decode(Key,Text),
	atom_string(Text,Name).

tv_required(yes,true).
tv_required(no,false).

round3(X,Y) :-
	Y is round(X*1000)/1000.


%----------------------------------THE RESULT-----------------------------------

%	evaluate(Request,Response): the evaluation of a request (a dict, as parsed
%	from JSON), see the README for the contract.
evaluate(Request,Response) :-
	request_language(Request,Lang),
	request_method(Request,Method),
	retractall(language(_)),
	assertz(language(Lang)),
	retractall(uncertainty_method(_)),
	assertz(uncertainty_method(Method)),
	request_membership(Request,Membership),
	retractall(membership_mode(_)),
	assertz(membership_mode(Membership)),
	reset_evaluation,
	load_request(Request),
	request_goals(Request,Goals),
	run_bound(lower),
	run_bound(upper),
	known(yes,patient,Band,_),
	findall(G,( member(Goal,Goals), goal_result(Goal,G) ),Results),
	derived_facts(Derived),
	evaluation_threshold(T),
	decode(disclaimer,Disclaimer),
	Response = _{lang:Lang, backend:Method, age_band:Band, threshold:T,
		     derived:Derived, goals:Results, disclaimer:Disclaimer}.

request_language(Request,Lang) :-
	( get_dict(lang,Request,Lang) -> true ; Lang = en ),
	( memberchk(Lang,[en,it]) -> true ; throw(evaluation_error(null,'lang is en or it')) ).

request_method(Request,Method) :-
	( get_dict(backend,Request,Method) -> true ; Method = cf ),
	( method_t_norm(Method,_) -> true ; throw(evaluation_error(null,'unknown backend')) ).

request_membership(Request,Mode) :-
	( get_dict(membership,Request,Mode) -> true ; Mode = soft ),
	( memberchk(Mode,[soft,hard]) -> true ; throw(evaluation_error(null,'membership is soft or hard')) ).

%	request_goals(Request,Goals): the goals asked for, by identifier or by
%	chapter (the neurodevelopmental chapter by default).
request_goals(Request,Goals) :-
	get_dict(goals,Request,Goals),
	Goals \== null,
	!,
	goals_list(All),
	( is_list(Goals), forall(member(G,Goals), memberchk(G,All)) -> true ; throw(evaluation_error(null,'unknown goal')) ).
request_goals(Request,Goals) :-
	( get_dict(chapters,Request,Chapters), Chapters \== null -> true ; Chapters = [neurodevelopmental] ),
	( is_list(Chapters), forall(member(C,Chapters), chapter_first_goal(C,_)) -> true ; throw(evaluation_error(null,'unknown chapter')) ),
	goals_list(All),
	include([G]>>( goal_chapter(G,C), memberchk(C,Chapters) ),All,Goals).

reset_evaluation :-
	retractall(known(_,_,_,_)),
	retractall(known_value(_,_)),
	retractall(provisional(_,_)),
	retractall(count_evidence(_,_,_,_)),
	retractall(count_source(_,_,_)),
	retractall(missing_item(_,_,_)),
	retractall(evidence(_,_,_,_,_)),
	retractall(run_result(_,_,_,_)),
	retractall(run_node(_,_,_,_,_,_)),
	retractall(run_tree(_,_,_,_)),
	retractall(evaluation_bound(_)),
	forall(member(P,[last_level_I_index,last_level_II_index,last_level_III_index,last_level_IV_index]),
		( T0 =.. [P,_], retractall(T0), T =.. [P,1], assertz(T) )),
	delete_trees.

%	goal_result(Goal,Result): one goal of the response.
goal_result(Goal,_{id:Goal, name:Name, icd10cm:ICD10, icd11:ICD11, chapter:Chapter,
		   status:Status, certainty:Lower, upper:Upper,
		   criteria:Criteria, missing:Missing, explanation:Text, tree:Tree,
		   differentials:Differentials}) :-
	node_name(Goal,Name),
	disorder_codes(Goal,ICD10,ICD11),
	goal_chapter(Goal,Chapter),
	goal_bounds(Goal,Lower,Upper),
	bounds_status(Lower,Upper,present,absent,undetermined,Status),
	goal_criteria(Goal,Criteria),
	goal_missing(Goal,Missing),
	( run_tree(lower,Goal,Text,Tree) -> true ; Text = "", Tree = null ),
	goal_differentials(Goal,Differentials).

goal_bounds(Goal,Lower,Upper) :-
	run_result(lower,Goal,L,_),
	run_result(upper,Goal,U,_),
	round3(L,Lower),
	round3(max(L,U),Upper).

bounds_status(Lower,Upper,Met,NotMet,Unknown,Status) :-
	evaluation_threshold(T),
	(   Lower >= T -> Status = Met
	;   Upper < T  -> Status = NotMet
	;   Status = Unknown ).

%	goal_criteria(Goal,Criteria): the criteria met, not met or unknown, in
%	the order of the proof tree.
goal_criteria(Goal,Criteria) :-
	findall(Key-Level,( member(B,[upper,lower]), run_node(B,Goal,Key,_,_,Level) ),Keys0),
	list_to_set(Keys0,Keys),
	findall(C,( member(Key-Level,Keys), criterion_result(Goal,Key,Level,C) ),Criteria).

criterion_result(Goal,Parent/Name,Level,
		 _{id:Name, name:Label, parent:Parent, level:Level, required:Req,
		   status:Status, certainty:Lower, upper:Upper}) :-
	( run_node(lower,Goal,Parent/Name,TVl,L0,Level) -> true ; L0 = 0.0 ),
	round3(L0,Lower),
	(   run_node(upper,Goal,Parent/Name,TV,U0,Level)
	->  round3(max(L0,U0),Upper),
	    bounds_status(Lower,Upper,met,not_met,unknown,Status)
	;   TV = TVl,
	    Upper = Lower,
	    Status = not_assessed ),
	tv_required(TV,Req),
	node_name(Name,Label).

%	goal_missing(Goal,Missing): the data that the two runs found missing.
goal_missing(Goal,Missing) :-
	findall(Item,missing_item(_,Goal,Item),Items0),
	list_to_set(Items0,Items),
	findall(_{id:Item,text:Text,kind:Kind},
		( member(Item,Items),
		  missing_kind(Item,Kind),
		  question_text(Item,Text0), atom_string(Text0,Text) ),
		Missing).

missing_kind(Item,item) :- askable_item(Item), !.
missing_kind(Item,number) :- graded_variable(Item), !.
missing_kind(_,choice).

%	goal_differentials(Goal,Differentials): for each disorder to rule out,
%	its goal with the highest certainty and its status.
goal_differentials(Goal,Differentials) :-
	(   family(Family,Goal), differentials(Family,Families)
	->  findall(D,( member(F,Families), family_best(F,D) ),Differentials)
	;   Differentials = [] ).

family_best(Family,_{family:Family, id:Best, name:Name, status:Status, certainty:Lower, upper:Upper}) :-
	findall(G-(L-U),( family(Family,G), goal_bounds(G,L,U) ),[G0-B0|Bounds]),
	foldl([G1-B1,Ga-Ba,Gb-Bb]>>( B1 @> Ba -> Gb-Bb = G1-B1 ; Gb-Bb = Ga-Ba ),Bounds,G0-B0,Best-(Lower-Upper)),
	bounds_status(Lower,Upper,present,absent,undetermined,Status),
	node_name(Best,Name).

%	derived_facts(Derived): the answers that the findings produced.
derived_facts(Derived) :-
	findall(_{item:Item, value:D, kind:Kind, source:Sources},
		( known(yes,symptom,Item,D0),
		  \+ evidence(Item,_,direct,_,_),
		  once(evidence(Item,_,_,_,_)),
		  round3(D0,D),
		  ( provisional(symptom,Item) -> Kind = provisional ; Kind = confirmatory ),
		  findall(S,evidence(Item,_,_,S,_),Ss0), sort(Ss0,Sources) ),
		Derived0),
	findall(_{item:Count, value:N, kind:Kind, source:[Source]},
		( count_evidence(Count,N,_,Kind), count_source(Count,Kind,Source) ),
		Counts),
	append(Derived0,Counts,Derived).


%-------------------------------JSON ENTRY POINT--------------------------------

%	pesad_evaluate(+JSON,-Out): the evaluation of the JSON request in a thread
%	of its own (so that its working memory is private), as a JSON string.
%	An invalid request gives {"error": Message, "index": Index}.
pesad_evaluate(JSON,Out) :-
	message_queue_create(Queue),
	thread_create(evaluation_worker(JSON,Queue),Id,[stack_limit(536870912)]),
	thread_get_message(Queue,result(Dict)),
	thread_join(Id,_),
	message_queue_destroy(Queue),
	atom_json_dict(Out,Dict,[as(string),width(0)]).

evaluation_worker(JSON,Queue) :-
	(   catch(( atom_json_dict(JSON,Request,[value_string_as(atom)]),
		    evaluate(Request,Dict) ),
		  Error,
		  error_dict(Error,Dict))
	->  true
	;   Dict = _{error:"evaluation failed", index:null} ),
	thread_send_message(Queue,result(Dict)).

error_dict(evaluation_error(Index,Message),_{error:Message,index:Index}) :- !.
error_dict(error(syntax_error(_),_),_{error:"invalid JSON",index:null}) :- !.
error_dict(Error,_{error:Text,index:null}) :-
	format(string(Text),'internal error: ~q',[Error]).

%	findings_catalogue(-Out): the findings accepted, as a JSON string.
findings_catalogue(Out) :-
	findall(_{id:Id, type:T, min:Min, max:Max, description:D},
		( finding(Id,Type,D0), atom_string(D0,D),
		  ( Type = integer(Min,Max) -> T = integer
		  ; Type = number(Min,Max) -> T = number
		  ; T = boolean, Min = null, Max = null ) ),
		Findings),
	askable_items(Items),
	findall(_{id:Q, options:Os},choice_question(Q,Os),Choices),
	findall(V,graded_variable(V),Numbers),
	atom_json_dict(Out,_{findings:Findings, items:Items, choices:Choices, numbers:Numbers},[as(string),width(0)]).
