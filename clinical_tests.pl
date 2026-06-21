%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		clinical_tests.pl
%
%	description:
%		A small regression test suite based on clinical vignettes. Each case
%		encodes the answers a clinician would give (as known/4 facts); the
%		runner sets every askable symptom to "no" by default so that the
%		investigation never blocks on input, overlays the positive findings of
%		the case, runs the investigation and checks that the top-ranked
%		diagnosis matches the expected one. Launch with: swipl clinical_tests.pl
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- dynamic last_level_I_index/1, last_level_II_index/1, last_level_III_index/1, last_level_IV_index/1.
:- dynamic language/1.
:- dynamic uncertainty_method/1.
:- dynamic known/4, fact/8, rule_I/4, rule_II/5, rule_III/6.
:- dynamic known_value/2.
:- multifile label/3, explanation/3.
:- discontiguous label/3, explanation/3.

:- style_check(-singleton).
:- style_check(-discontiguous).

:- reconsult('interface_en.pl').
:- reconsult('interface_it.pl').
:- reconsult('utils.pl').
:- reconsult('uncertainty.pl').
:- reconsult('fuzzy.pl').
:- reconsult('memory.pl').
:- reconsult('ask.pl').
:- reconsult('explanation.pl').
:- reconsult('shell.pl').
:- reconsult('disorders.pl').
:- reconsult('criteria.pl').


%	body_member(Body, Goal): true for each goal occurring in a clause body.
body_member((A,B),G) :- !, ( body_member(A,G) ; body_member(B,G) ).
body_member((A;B),G) :- !, ( body_member(A,G) ; body_member(B,G) ).
body_member((A->B),G) :- !, ( body_member(A,G) ; body_member(B,G) ).
body_member(G,G).

%	askable_symptoms(Items): every symptom/etiological item the engine may ask,
%	auto-discovered from the manifestation and feature clauses.
askable_symptoms(Items) :-
	findall(I,
		( member(P,[symptomatic_manifestation,symptomatic_feature,specific_phobia_type,disorder_nc]),
		  Head =.. [P,_,_,_,_],
		  clause(Head,Body),
		  body_member(Body,Goal),
		  ( Goal = symptom(L,_,_) ; Goal = etiological_evidence(L,_,_) ),
		  member(I,L) ),
		Raw),
	sort(Raw,Items).

%	multiask_defaults(Defaults): a neutral default option for every
%	multiple-choice question, so unanswered ones do not support any diagnosis.
multiask_defaults([
	attack_type-cued_attack,
	panic_attacks_frequency-one_or_fewer,
	symptoms_duration-less_than_three_days,
	symptoms_onset-no_onset,
	bereavement_time-less_than_six_months,
	anxiety_type-other_anxiety_type,
	phobic_reaction_type-endurance_without_problems,
	adjustment_subtype-unspecified_adjustment
]).
% Note: insight_level is a SELECTIVE specifier (exactly one value), so it is not
% put among the multiple-choice defaults; run_case asserts a single default value
% only when a case does not specify one.

%	setup_defaults: clears the working memory and asserts the "all absent" baseline.
setup_defaults :-
	retractall(known(_,_,_,_)),
	retractall(known_value(_,_)),
	askable_symptoms(Symptoms),
	forall(member(I,Symptoms), assertz(known(no,symptom,I,0.9))),
	multiask_defaults(Defaults),
	forall(member(A-O,Defaults), assertz(known(yes,A,O,1.0))),
	% default graded values (absent) for the fuzzy-membership method
	assertz(known_value(duration_months,0)),
	assertz(known_value(panic_attacks_count,0)).

%	apply_overrides(Facts): asserts the case-specific answers in front of the
%	defaults (asserta) so they take precedence.
apply_overrides([]).
apply_overrides([F|Fs]) :-
	asserta(F),
	apply_overrides(Fs).


%---------------------------------CLINICAL CASES-------------------------------
%	case(Id, Description, AgeGroup, Overrides, ExpectedTopDiagnosis).

case(panic_disorder, '34-year-old: recurrent unexpected panic attacks, 3 months of anticipatory worry, no substance/medical cause', adult,
	[ known(yes,symptom,abrupt_surge_of_fear_or_discomfort,0.9),
	  known(yes,symptom,palpitations,0.9),
	  known(yes,symptom,sweating,0.8),
	  known(yes,symptom,trembling,0.7),
	  known(yes,symptom,dyspnea,0.9),
	  known(yes,symptom,chest_pain,0.8),
	  known(yes,symptom,fear_of_dying,0.9),
	  known(yes,symptom,fear_of_losing_control,0.6),
	  known(yes,symptom,worry_about_new_panic_attacks,0.9),
	  known(yes,symptom,maladaptive_behaviour_change_due_to_panic,0.7),
	  known(yes,symptom,occupational_distress,0.8),
	  known(yes,symptom,social_distress,0.7),
	  known(yes,panic_attacks_frequency,more_than_five,1.0),
	  known(yes,attack_type,unexpected_attack,1.0),
	  known(yes,symptoms_duration,three_to_six_months,1.0),
	  known_value(duration_months,3),
	  known_value(panic_attacks_count,6) ],
	panic_disorder).

case(posttraumatic_stress_disorder, '40-year-old assault survivor: re-experiencing, avoidance, negative mood and hyperarousal for 4 months', adult,
	[ known(yes,symptom,directly_experiencing_trauma,0.9),
	  known(yes,symptom,intrusive_memories,0.9),
	  known(yes,symptom,distressing_dreams,0.8),
	  known(yes,symptom,avoidance_of_trauma_thoughts_or_feelings,0.9),
	  known(yes,symptom,avoidance_of_external_trauma_reminders,0.8),
	  known(yes,symptom,persistent_negative_beliefs,0.8),
	  known(yes,symptom,detachment_from_others,0.7),
	  known(yes,symptom,inability_to_feel_positive_emotions,0.7),
	  known(yes,symptom,hypervigilance,0.8),
	  known(yes,symptom,exaggerated_startle_response,0.8),
	  known(yes,symptom,sleep_disturbance,0.7),
	  known(yes,symptom,occupational_distress,0.8),
	  known(yes,symptom,social_distress,0.7),
	  known(yes,symptoms_duration,three_to_six_months,1.0),
	  known_value(duration_months,4) ],
	posttraumatic_stress_disorder).

case(obsessive_compulsive_disorder, '28-year-old: intrusive contamination thoughts with washing rituals over one hour a day, no substance/medical cause', adult,
	[ known(yes,symptom,recurrent_intrusive_unwanted_thoughts,0.9),
	  known(yes,symptom,repetitive_behaviours_or_mental_acts,0.9),
	  known(yes,symptom,more_than_one_hour_per_day,0.9),
	  known(yes,symptom,occupational_distress,0.8),
	  known(yes,symptom,social_distress,0.7),
	  known(yes,insight_level,insight_poor,1.0) ],
	obsessive_compulsive_disorder_with_poor_insight).

case(specific_phobia_animal_type, '22-year-old: marked, out-of-proportion fear of spiders, actively avoided for over a year', adult,
	[ known(yes,symptom,marked_fear_of_specific_object_or_situation,0.9),
	  known(yes,symptom,fear_almost_always_provoked,0.9),
	  known(yes,symptom,fear_out_of_proportion_to_actual_danger,0.9),
	  known(yes,symptom,fear_of_animals,0.9),
	  known(yes,symptom,occupational_distress,0.7),
	  known(yes,symptom,social_distress,0.8),
	  known(yes,phobic_reaction_type,avoidance,1.0),
	  known(yes,symptoms_duration,six_months_or_more,1.0),
	  known_value(duration_months,12) ],
	specific_phobia_animal_type).

case(agoraphobia, '45-year-old: fear and avoidance of public transport and open spaces for fear of not escaping, over 6 months', adult,
	[ known(yes,symptom,fear_of_public_transport,0.9),
	  known(yes,symptom,fear_of_open_spaces,0.8),
	  known(yes,symptom,occupational_distress,0.8),
	  known(yes,symptom,social_distress,0.7),
	  known(yes,anxiety_type,difficulty_escaping_or_help_unavailable,1.0),
	  known(yes,phobic_reaction_type,avoidance,1.0),
	  known(yes,symptoms_duration,six_months_or_more,1.0),
	  known_value(duration_months,8) ],
	agoraphobia).

case(adjustment_disorder, '30-year-old: low mood and difficulty coping within weeks of a job loss', adult,
	[ known(yes,symptom,emotional_or_behavioural_symptoms_after_stressor,0.9),
	  known(yes,symptom,occupational_distress,0.8),
	  known(yes,symptom,social_distress,0.7),
	  known(yes,adjustment_subtype,with_depressed_mood,1.0),
	  known(yes,symptoms_onset,within_three_months_of_stressor,1.0) ],
	adjustment_disorder).

case(substance_induced_anxiety_disorder, '26-year-old: anxiety surges that began during heavy stimulant use, not only during delirium', adult,
	[ known(yes,symptom,abrupt_surge_of_fear_or_discomfort,0.9),
	  known(yes,symptom,substance_intoxication_or_withdrawal_or_medication_use,0.9),
	  known(yes,symptom,symptoms_developed_during_or_after_substance_use,0.9),
	  known(yes,symptom,substance_capable_of_producing_symptoms,0.9),
	  known(yes,symptom,not_exclusively_during_delirium,0.9),
	  known(yes,symptom,occupational_distress,0.8),
	  known(yes,symptom,social_distress,0.7) ],
	substance_induced_anxiety_disorder).

% Borderline case: a marked animal phobia present for only ~5 months, i.e. just
% under the 6-month threshold. The discrete methods (cf, fuzzy) miss the hard
% cut-off and fail to diagnose; the fuzzy_membership method grades the 5-month
% duration at 0.67 of "at least 6 months" and still ranks the phobia first.
case(borderline_specific_phobia, '23-year-old: marked spider phobia, actively avoided, but present for only ~5 months', adult,
	[ known(yes,symptom,marked_fear_of_specific_object_or_situation,0.9),
	  known(yes,symptom,fear_almost_always_provoked,0.9),
	  known(yes,symptom,fear_out_of_proportion_to_actual_danger,0.9),
	  known(yes,symptom,fear_of_animals,0.9),
	  known(yes,symptom,occupational_distress,0.7),
	  known(yes,symptom,social_distress,0.8),
	  known(yes,phobic_reaction_type,avoidance,1.0),
	  known(yes,symptoms_duration,three_to_six_months,1.0),
	  known_value(duration_months,5) ],
	specific_phobia_animal_type).

case(no_diagnosis, '35-year-old: mild, non-specific work stress only, no syndromal symptoms', adult,
	[ known(yes,symptom,occupational_distress,0.5) ],
	none).


%-----------------------------------TEST RUNNER-------------------------------
%	run_case(Method, Id, Result): runs one case under the given uncertainty method.
run_case(Method, Id, Result) :-
	retractall(uncertainty_method(_)),
	assertz(uncertainty_method(Method)),
	case(Id, Description, Age, Overrides, Expected),
	setup_defaults,
	asserta(known(yes,patient,Age,1.0)),
	apply_overrides(Overrides),
	% a single default insight value, unless the case specifies one
	( known(yes,insight_level,_,_) -> true ; assertz(known(yes,insight_level,insight_good_or_fair,1.0)) ),
	delete_trees,
	investigate_goals(Goals),
	descending_order_goals(Goals, Sorted),
	!,
	Sorted = [goal(Top,Top_CF)|_],
	Top_Pct is round(Top_CF*100),
	( Expected == none
	-> ( Top_CF < 0.30 -> Result = pass, Tag = 'PASS' ; Result = fail, Tag = 'FAIL' ),
	   Expected_Name = 'no strong diagnosis (top < 30%)'
	;  ( Top == Expected -> Result = pass, Tag = 'PASS' ; Result = fail, Tag = 'FAIL' ),
	   decode(Expected, Expected_Name) ),
	nl,
	format('[~w] ~w~n', [Tag, Description]),
	format('      expected: ~w~n', [Expected_Name]),
	format('      ranked differential (top 3):~n', []),
	forall( ( nth1(Rank, Sorted, goal(Goal,CF)), Rank =< 3 ),
		( Pct is round(CF*100), decode(Goal, Goal_Name),
		  format('        ~w) ~w  --  ~w%~n', [Rank, Goal_Name, Pct]) ) ),
	format('      => top diagnosis: ~w (~w%)~n', [Top, Top_Pct]).

%	run_method(Method, Passed-Total): runs every case under one method.
run_method(Method, NP-NT) :-
	nl,
	format('################################################################~n', []),
	format('  UNCERTAINTY METHOD: ~w~n', [Method]),
	format('################################################################~n', []),
	findall(Id, case(Id,_,_,_,_), Ids),
	findall(R, (member(Id,Ids), once(run_case(Method,Id,R))), Results),
	include(==(pass), Results, Passed),
	length(Passed, NP), length(Results, NT),
	nl,
	format('  >> method ~w: ~w/~w cases passed~n', [Method, NP, NT]).

run_tests :-
	assertz(language(en)),
	run_method(cf, CF_NP-CF_NT),
	run_method(fuzzy, FZ_NP-FZ_NT),
	run_method(fuzzy_membership, FM_NP-FM_NT),
	nl,
	format('================================================================~n', []),
	format('  SUMMARY    cf: ~w/~w    fuzzy: ~w/~w    fuzzy_membership: ~w/~w~n',
		[CF_NP, CF_NT, FZ_NP, FZ_NT, FM_NP, FM_NT]),
	format('================================================================~n', []).

%	fuzzy_demo: shows the graded membership values of the fuzzy_membership method
%	(the smooth alternative to the discrete options) over sample crisp inputs.
fuzzy_demo :-
	nl,
	format('################################################################~n', []),
	format('  FUZZY MEMBERSHIP DEMO (graded duration / frequency / insight)~n', []),
	format('################################################################~n', []),
	nl,
	format('  membership of "duration at least 6 months":~n', []),
	forall( member(M,[2,3,4,5,6,8]),
		( duration_membership([six_months_or_more],M,Mu), Pct is round(Mu*100),
		  format('     ~w months  -> ~w%~n', [M,Pct]) ) ),
	nl,
	format('  membership of "recurrent panic attacks (>= 2)":~n', []),
	forall( member(N,[0,1,2,3,5]),
		( frequency_membership([two_to_five,more_than_five],N,Mu), Pct is round(Mu*100),
		  format('     ~w attacks -> ~w%~n', [N,Pct]) ) ),
	nl,
	format('  insight memberships (degree 0 = absent/delusional .. 1 = good):~n', []),
	forall( member(D,[0.0,0.3,0.5,0.7,1.0]),
		( insight_membership(good_or_fair,D,G), insight_membership(poor,D,P), insight_membership(absent_or_delusional,D,A),
		  Gp is round(G*100), Pp is round(P*100), Ap is round(A*100),
		  format('     degree ~w -> good/fair=~w%  poor=~w%  absent=~w%~n', [D,Gp,Pp,Ap]) ) ).

:- initialization((run_tests, fuzzy_demo, halt)).
