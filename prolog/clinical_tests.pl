%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		clinical_tests.pl
%
%	description:
%		Validation suite of the knowledge base against the DSM-5-TR criteria.
%		Every case is an original clinical vignette written from the criteria
%		(no case material is taken from DSM-5-TR or from a casebook); the
%		runner answers "no" with certainty 1 to every askable symptom, gives a
%		neutral answer to every multiple-choice question, overlays the
%		answers of the vignette, runs the whole investigation and checks the
%		expected outcome. For every diagnostic goal there are four cases:
%		  typical       a positive vignette, the goal ranks first;
%		  subthreshold  one symptom, count or duration short, goal absent;
%		  exclusion     an exclusion criterion holds, goal absent;
%		  differential  a neighbouring disorder ranks first, goal absent;
%		plus comorbidity, specifier, age-rule and uncertainty cases. A goal is
%		present when its certainty is at least 50%. Every case runs under the
%		three uncertainty methods (cf, fuzzy, fuzzy_membership); the suite
%		ends with a goal x case-type table and exits with status 1 on any
%		failure. Launch with: swipl clinical_tests.pl
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- dynamic last_level_I_index/1, last_level_II_index/1, last_level_III_index/1, last_level_IV_index/1.
:- dynamic language/1.
:- dynamic uncertainty_method/1.
:- dynamic known/4, fact/8, rule_I/4, rule_II/5, rule_III/6.
:- dynamic known_value/2.
:- dynamic result/4.
:- multifile label/3, explanation/3.
:- discontiguous label/3, explanation/3.
:- discontiguous plan/5.

:- style_check(-singleton).
:- style_check(-discontiguous).

:- reconsult('interface_en.pl').
:- reconsult('interface_it.pl').
:- reconsult('bot_io.pl').
:- reconsult('utils.pl').
:- reconsult('uncertainty.pl').
:- reconsult('fuzzy.pl').
:- reconsult('memory.pl').
:- reconsult('ask.pl').
:- reconsult('explanation.pl').
:- reconsult('shell.pl').
:- reconsult('disorders.pl').
:- reconsult('criteria.pl').

%	threshold(T): a goal is present when its certainty is at least T.
threshold(0.5).


%-----------------------------ASKABLE ITEMS / DEFAULTS--------------------------

%	body_member(Body, Goal): true for each goal occurring in a clause body.
body_member((A,B),G) :- !, ( body_member(A,G) ; body_member(B,G) ).
body_member((A;B),G) :- !, ( body_member(A,G) ; body_member(B,G) ).
body_member((A->B),G) :- !, ( body_member(A,G) ; body_member(B,G) ).
body_member(unless_absent(_,G0,_),G) :- !, body_member(G0,G).
body_member(G,G).

%	askable_symptoms(Items): every yes/no item the engine may ask,
%	auto-discovered from the criteria clauses and the single-item criteria.
askable_symptoms(Items) :-
	findall(I,
		( member(P,[symptomatic_manifestation,symptomatic_feature,specific_phobia_type,disorder_nc]),
		  Head =.. [P,_,_,_,_],
		  clause(Head,Body),
		  body_member(Body,Goal),
		  ( Goal = symptom(L,_,_) ; Goal = etiological_evidence(L,_,_) ),
		  is_list(L),
		  member(I,L) ),
		Raw),
	findall(I,single_item_criterion(I),Single),
	append(Raw,Single,All),
	sort(All,Items).

%	A neutral default for every multiple-choice question, so that unanswered
%	ones support no diagnosis.
multiask_defaults([
	attack_type-cued_attack,
	panic_attacks_frequency-one_or_fewer,
	symptoms_duration-less_than_three_days,
	symptoms_onset-no_onset,
	bereavement_time-less_than_six_months,
	anxiety_type-other_anxiety_type,
	phobic_reaction_type-endurance_without_problems
]).

%	The selective specifiers take exactly one value: the default is asserted
%	only when a case does not give one.
selective_defaults([
	insight_level-insight_good_or_fair,
	substance_onset-onset_during_intoxication,
	ocrd_presentation-with_ocd_like_symptoms,
	adjustment_subtype-unspecified_adjustment
]).

%	Crisp values of the fuzzy_membership method, derived from the discrete answers.
months(less_than_three_days,0).
months(three_days_to_one_month,0.5).
months(one_to_three_months,2).
months(three_to_six_months,4).
months(six_months_or_more,12).
attacks(one_or_fewer,1).
attacks(two_to_five,3).
attacks(more_than_five,6).


%----------------------------------VIGNETTES------------------------------------
%	vignette(Name, AgeGroup, Answers): y(Item) answers yes (certainty 1),
%	y(Item,C) yes with certainty C, c(Question,Option) a multiple-choice answer.
%	The vignettes are original, written from the criteria.

distress([y(occupational_distress),y(social_distress)]).

% 9-year-old who cries at every school drop-off, fears that her mother will
% die in an accident, refuses sleepovers and has stomach aches on school
% mornings; six weeks.
vignette(sad_child,child,
	[ y(distress_at_separation_from_attachment_figures), y(worry_about_losing_attachment_figures),
	  y(reluctance_to_go_out_due_to_separation), y(reluctance_to_sleep_away_from_attachment_figures),
	  y(physical_symptoms_on_separation), y(social_distress), y(other_functional_distress),
	  c(symptoms_duration,one_to_three_months) ]).
% The same picture in a 30-year-old, present for over a year.
vignette(sad_adult,adult,
	[ y(distress_at_separation_from_attachment_figures), y(worry_about_losing_attachment_figures),
	  y(fear_of_being_alone), y(reluctance_to_sleep_away_from_attachment_figures),
	  y(occupational_distress), c(symptoms_duration,six_months_or_more) ]).
% 8-year-old who speaks freely at home but has not said a word at school since
% term started two months ago.
vignette(sm_child,child,
	[ y(failure_to_speak_in_specific_social_situations), y(speaks_in_other_situations),
	  y(social_distress), y(other_functional_distress), c(symptoms_duration,one_to_three_months) ]).
% 27-year-old with a year-long fear of a specific stimulus, actively avoided.
vignette(sp_base,adult,
	[ y(marked_fear_of_specific_object_or_situation), y(fear_almost_always_provoked),
	  y(fear_out_of_proportion_to_actual_danger), y(occupational_distress), y(social_distress),
	  c(phobic_reaction_type,avoidance), c(symptoms_duration,six_months_or_more) ]).
% 31-year-old who avoids meetings, parties and eating in public for fear of
% being judged, for two years.
vignette(social_adult,adult,
	[ y(marked_fear_of_social_scrutiny), y(fear_of_negative_evaluation), y(fear_almost_always_provoked),
	  y(fear_out_of_proportion_to_actual_danger), y(occupational_distress), y(social_distress),
	  c(phobic_reaction_type,avoidance), c(symptoms_duration,six_months_or_more) ]).
% 10-year-old who freezes when classmates watch him, for eight months.
vignette(social_child,child,
	[ y(marked_fear_of_social_scrutiny), y(fear_of_negative_evaluation), y(fear_almost_always_provoked),
	  y(fear_out_of_proportion_to_actual_danger), y(anxiety_occurs_in_peer_settings),
	  y(social_distress), y(other_functional_distress),
	  c(phobic_reaction_type,avoidance), c(symptoms_duration,six_months_or_more) ]).
% 34-year-old with attacks "out of the blue", now avoiding the gym for fear of
% another one, for four months.
vignette(panic_adult,adult,
	[ y(abrupt_surge_of_fear_or_discomfort), y(palpitations), y(sweating), y(trembling), y(dyspnea),
	  y(fear_of_dying), y(worry_about_new_panic_attacks), y(maladaptive_behaviour_change_due_to_panic),
	  y(occupational_distress), y(social_distress),
	  c(panic_attacks_frequency,more_than_five), c(attack_type,unexpected_attack),
	  c(symptoms_duration,three_to_six_months) ]).
% 52-year-old who no longer takes the bus, avoids supermarkets and leaves home
% only with her husband, fearing she could not get out or get help.
vignette(agora_adult,adult,
	[ y(fear_of_public_transport), y(fear_of_queues_or_crowds), y(fear_of_being_outside_home_alone),
	  y(fear_almost_always_provoked), y(fear_out_of_proportion_to_actual_danger),
	  y(occupational_distress), y(social_distress),
	  c(anxiety_type,difficulty_escaping_or_help_unavailable), c(phobic_reaction_type,requires_companion),
	  c(symptoms_duration,six_months_or_more) ]).
% 45-year-old accountant who has worried about work, money and health nearly
% every day for a year, with restlessness, tension and poor sleep.
vignette(gad_adult,adult,
	[ y(excessive_worry_about_several_events), y(worry_more_days_than_not), y(difficulty_controlling_worry),
	  y(restlessness), y(muscle_tension), y(sleep_disturbance), y(occupational_distress), y(social_distress),
	  c(symptoms_duration,six_months_or_more) ]).
% 11-year-old who worries about grades, sports and world events, keyed up
% most days for seven months.
vignette(gad_child,child,
	[ y(excessive_worry_about_several_events), y(worry_more_days_than_not), y(difficulty_controlling_worry),
	  y(restlessness), y(social_distress), y(other_functional_distress),
	  c(symptoms_duration,six_months_or_more) ]).
% 26-year-old with anxiety surges since starting heavy cocaine use.
vignette(sia_base,adult,
	[ y(abrupt_surge_of_fear_or_discomfort), y(palpitations), y(sweating), y(trembling),
	  y(substance_intoxication_or_withdrawal_or_medication_use), y(symptoms_developed_during_or_after_substance_use),
	  y(substance_capable_of_producing_symptoms), y(not_exclusively_during_delirium),
	  y(occupational_distress), y(social_distress) ]).
% 40-year-old with untreated hyperthyroidism and new panic attacks.
vignette(amc_anx,adult,
	[ y(abrupt_surge_of_fear_or_discomfort), y(another_medical_condition),
	  y(disturbance_is_direct_consequence_of_medical_condition), y(not_exclusively_during_delirium),
	  y(occupational_distress), y(social_distress) ]).
% 28-year-old with contamination thoughts he tries to push away and washing
% rituals of over two hours a day.
vignette(ocd_base,adult,
	[ y(recurrent_intrusive_unwanted_thoughts), y(attempts_to_ignore_or_neutralize_thoughts),
	  y(repetitive_behaviours_or_mental_acts), y(acts_aimed_at_reducing_distress),
	  y(more_than_one_hour_per_day), y(occupational_distress), y(social_distress) ]).
% 19-year-old convinced her nose is deformed (others see nothing), checking
% mirrors and asking for reassurance, missing classes.
vignette(bdd_base,adult,
	[ y(preoccupation_with_perceived_appearance_defects), y(mirror_checking), y(reassurance_seeking),
	  y(occupational_distress), y(social_distress) ]).
% 63-year-old whose flat is so full of newspapers and boxes that the kitchen
% cannot be used, distressed at any attempt to throw things away.
vignette(hd_base,adult,
	[ y(difficulty_discarding_possessions), y(distress_associated_with_discarding),
	  y(accumulation_clutters_living_areas), y(social_distress), y(other_functional_distress) ]).
% 17-year-old pulling hair from the scalp, with bald patches, who has tried
% many times to stop.
vignette(tt_base,adolescent,
	[ y(recurrent_pulling_out_of_hair), y(repeated_attempts_to_stop_hair_pulling),
	  y(social_distress), y(other_functional_distress) ]).
% 24-year-old picking at her arms until they bleed, unable to stop.
vignette(ex_base,adult,
	[ y(recurrent_skin_picking_causing_lesions), y(repeated_attempts_to_stop_skin_picking),
	  y(occupational_distress), y(social_distress) ]).
% 30-year-old with checking rituals that began with amphetamine use.
vignette(sio_base,adult,
	[ y(recurrent_intrusive_unwanted_thoughts), y(repetitive_behaviours_or_mental_acts),
	  y(substance_intoxication_or_withdrawal_or_medication_use), y(symptoms_developed_during_or_after_substance_use),
	  y(substance_capable_of_producing_symptoms), y(not_exclusively_during_delirium),
	  y(occupational_distress), y(social_distress) ]).
% 58-year-old with new obsessive-compulsive symptoms after a basal ganglia stroke.
vignette(amc_oc,adult,
	[ y(recurrent_intrusive_unwanted_thoughts), y(repetitive_behaviours_or_mental_acts),
	  y(difficulty_discarding_possessions), y(recurrent_pulling_out_of_hair), y(recurrent_skin_picking_causing_lesions),
	  y(preoccupation_with_perceived_appearance_defects),
	  y(another_medical_condition), y(disturbance_is_direct_consequence_of_medical_condition),
	  y(not_exclusively_during_delirium), y(occupational_distress), y(social_distress) ]).
% 3-year-old adopted from an institution, who neither seeks nor accepts
% comfort and shows little positive affect.
vignette(rad_base,preschool,
	[ y(rarely_seeks_comfort_when_distressed), y(rarely_responds_to_comfort_when_distressed),
	  y(minimal_social_emotional_responsiveness), y(limited_positive_affect), y(rearing_limiting_attachment),
	  y(care_presumed_responsible_for_disturbance), y(disturbance_evident_before_age_five),
	  y(developmental_age_at_least_nine_months) ]).
% 4-year-old after several foster placements, who hugs strangers and would
% leave with any adult.
vignette(dsed_base,preschool,
	[ y(reduced_reticence_with_unfamiliar_adults), y(overly_familiar_behaviour), y(willing_to_go_off_with_strangers),
	  y(repeated_changes_of_caregivers), y(behaviour_not_limited_to_impulsivity),
	  y(care_presumed_responsible_for_disturbance), y(developmental_age_at_least_nine_months) ]).
% 40-year-old assaulted four months ago, with nightmares, avoidance of the
% street, a sense that nobody can be trusted, detachment and hypervigilance.
vignette(ptsd_adult,adult,
	[ y(directly_experiencing_trauma), y(intrusive_memories), y(distressing_dreams),
	  y(avoidance_of_external_trauma_reminders), y(persistent_negative_beliefs), y(detachment_from_others),
	  y(hypervigilance), y(exaggerated_startle_response), y(occupational_distress), y(social_distress),
	  c(symptoms_duration,three_to_six_months) ]).
% 5-year-old who saw a house fire two months ago: frightening dreams, avoids
% the burnt room, tantrums, poor sleep.
vignette(ptsd_preschool,preschool,
	[ y(witnessing_trauma), y(distressing_dreams), y(avoidance_of_external_trauma_reminders),
	  y(irritability_or_aggression), y(sleep_disturbance), y(social_distress),
	  c(symptoms_duration,one_to_three_months) ]).
% 35-year-old car-crash survivor, ten days after the crash.
vignette(asd_base,adult,
	[ y(directly_experiencing_trauma), y(intrusive_memories), y(distressing_dreams), y(dissociative_flashbacks),
	  y(distress_or_physiological_reactions_to_cues), y(altered_sense_of_reality),
	  y(avoidance_of_trauma_thoughts_or_feelings), y(avoidance_of_external_trauma_reminders),
	  y(sleep_disturbance), y(hypervigilance), y(occupational_distress), y(social_distress),
	  c(symptoms_duration,three_days_to_one_month) ]).
% 30-year-old with low mood and tearfulness that began weeks after losing
% his job, for two months.
vignette(adj_base,adult,
	[ y(emotional_or_behavioural_symptoms_after_stressor), y(distress_out_of_proportion_to_stressor),
	  y(occupational_distress), c(symptoms_onset,within_three_months_of_stressor),
	  c(symptoms_duration,one_to_three_months) ]).
% 60-year-old whose husband died fourteen months ago, still yearning for him
% every day, feeling part of herself died, lonely and in pain.
vignette(pgd_adult,adult,
	[ y(intense_yearning_for_the_deceased), y(identity_disruption_since_death), y(intense_emotional_pain),
	  y(intense_loneliness), y(grief_symptoms_nearly_every_day_last_month),
	  y(bereavement_reaction_exceeds_cultural_norms), y(occupational_distress), y(social_distress),
	  c(bereavement_time,twelve_months_or_more) ]).


%------------------------------PER-GOAL TEST PLANS------------------------------
%	plan(Goal, Type, Description, Spec, Expectations): Spec is a list of
%	v(Vignette) (start from a vignette), age(A), Answer (add or override)
%	and -Item (drop the yes answer to Item). Expectations are present(G),
%	absent(G), top(G) (G is present and ranks first, ties allowed),
%	ranks_first(G) (first, whatever its certainty) and when(Methods,E).

% Specific phobia types: the stimulus items of each type, and the neighbour
% type used as the differential.
sp_type(specific_phobia_animal_type,fear_of_animals,specific_phobia_other_type).
sp_type(specific_phobia_natural_environment_type,fear_of_natural_environment,specific_phobia_animal_type).
sp_type(specific_phobia_blood_injection_injury_type,fear_of_blood_injection_injury,specific_phobia_situational_type).
sp_type(specific_phobia_situational_type,fear_of_situations,specific_phobia_blood_injection_injury_type).
sp_type(specific_phobia_other_type,fear_of_other_stimuli,specific_phobia_natural_environment_type).

plan(G,typical,'specific phobia, year-long fear of the stimulus, avoided',[v(sp_base),y(I)],[present(G),top(G)]) :-
	sp_type(G,I,_).
plan(G,subthreshold,'specific phobia present for only 4 months (E: typically >= 6)',[v(sp_base),y(I),c(symptoms_duration,three_to_six_months)],[absent(G)]) :-
	sp_type(G,I,_).
plan(G,exclusion,'fear better explained by another disorder (G)',[v(sp_base),y(I),y(phobia_better_explained_by_other_disorder)],[absent(G)]) :-
	sp_type(G,I,_).
plan(G,differential,'phobia of another stimulus type',[v(sp_base),y(I2)],[top(N),absent(G)]) :-
	sp_type(G,_,N), sp_type(N,I2,_).

% Separation anxiety disorder
plan(separation_anxiety_disorder,typical,'9-year-old, 5 of 8 separation fears, 6 weeks',[v(sad_child)],[present(separation_anxiety_disorder),top(separation_anxiety_disorder)]).
plan(separation_anxiety_disorder,subthreshold,'only 2 of the 8 separation fears (A: >= 3)',[v(sad_child),-worry_about_losing_attachment_figures,-reluctance_to_sleep_away_from_attachment_figures,-physical_symptoms_on_separation],[absent(separation_anxiety_disorder)]).
plan(separation_anxiety_disorder,exclusion,'separation fear explained by another disorder (D)',[v(sad_child),y(separation_fear_better_explained_by_other_disorder)],[absent(separation_anxiety_disorder)]).
plan(separation_anxiety_disorder,differential,'child with worries about many events: generalized anxiety',[v(gad_child)],[top(generalized_anxiety_disorder),absent(separation_anxiety_disorder)]).

% Selective mutism
plan(selective_mutism,typical,'8-year-old silent at school for 2 months, speaks at home',[v(sm_child)],[present(selective_mutism),top(selective_mutism)]).
plan(selective_mutism,subthreshold,'silent only in the first weeks of school (C: >= 1 month)',[v(sm_child),c(symptoms_duration,three_days_to_one_month)],[absent(selective_mutism)]).
plan(selective_mutism,exclusion,'newly immigrated child not yet fluent in the language (D)',[v(sm_child),y(failure_to_speak_due_to_language_knowledge)],[absent(selective_mutism)]).
plan(selective_mutism,differential,'child who speaks but fears peer evaluation: social anxiety',[v(social_child)],[top(social_anxiety_disorder),absent(selective_mutism)]).

% Social anxiety disorder and its performance-only specifier
plan(social_anxiety_disorder,typical,'31-year-old avoiding social scrutiny for 2 years',[v(social_adult)],[present(social_anxiety_disorder),top(social_anxiety_disorder)]).
plan(social_anxiety_disorder,subthreshold,'social fear for only 4 months (F: typically >= 6)',[v(social_adult),c(symptoms_duration,three_to_six_months)],[absent(social_anxiety_disorder)]).
plan(social_anxiety_disorder,exclusion,'fear explained by another disorder, e.g. body dysmorphic disorder (I)',[v(social_adult),y(social_fear_better_explained_by_other_disorder)],[absent(social_anxiety_disorder)]).
plan(social_anxiety_disorder,differential,'unexpected panic attacks with anticipatory worry: panic disorder',[v(panic_adult)],[top(panic_disorder),absent(social_anxiety_disorder)]).
plan(social_anxiety_disorder_performance_only,typical,'fear restricted to public speaking',[v(social_adult),y(fear_restricted_to_public_performance)],[present(social_anxiety_disorder_performance_only),top(social_anxiety_disorder_performance_only)]).
plan(social_anxiety_disorder_performance_only,subthreshold,'public-speaking fear for only 4 months',[v(social_adult),y(fear_restricted_to_public_performance),c(symptoms_duration,three_to_six_months)],[absent(social_anxiety_disorder_performance_only)]).
plan(social_anxiety_disorder_performance_only,exclusion,'public-speaking fear related to a stammer-causing medical condition, not excessive (J)',[v(social_adult),y(fear_restricted_to_public_performance),y(fear_accounted_for_by_medical_condition)],[absent(social_anxiety_disorder_performance_only)]).
plan(social_anxiety_disorder_performance_only,differential,'fear of all social situations: no performance-only specifier',[v(social_adult)],[top(social_anxiety_disorder),absent(social_anxiety_disorder_performance_only)]).

% Panic disorder
plan(panic_disorder,typical,'34-year-old, recurrent unexpected attacks, 4 months of worry',[v(panic_adult)],[present(panic_disorder),top(panic_disorder)]).
plan(panic_disorder,subthreshold,'limited-symptom attacks: 3 of 13 symptoms (A: >= 4)',[v(panic_adult),-sweating,-trembling],[absent(panic_disorder)]).
plan(panic_disorder,exclusion,'attacks caused by hyperthyroidism (C)',[v(panic_adult),y(another_medical_condition),y(disturbance_is_direct_consequence_of_medical_condition),y(not_exclusively_during_delirium)],[absent(panic_disorder),top(anxiety_disorder_due_to_another_medical_condition)]).
plan(panic_disorder,differential,'attacks cued only by feared social situations: social anxiety',[v(social_adult),y(abrupt_surge_of_fear_or_discomfort),y(palpitations),y(sweating),y(trembling),y(dyspnea),y(worry_about_new_panic_attacks),c(panic_attacks_frequency,two_to_five),c(attack_type,cued_attack)],[top(social_anxiety_disorder),absent(panic_disorder)]).

% Agoraphobia
plan(agoraphobia,typical,'52-year-old fearing buses, crowds and going out alone',[v(agora_adult)],[present(agoraphobia),top(agoraphobia)]).
plan(agoraphobia,subthreshold,'fear of a single agoraphobic situation (A: >= 2 of 5)',[v(agora_adult),-fear_of_queues_or_crowds,-fear_of_being_outside_home_alone],[absent(agoraphobia)]).
plan(agoraphobia,exclusion,'avoidance proportionate to inflammatory bowel disease (H)',[v(agora_adult),y(fear_accounted_for_by_medical_condition)],[absent(agoraphobia)]).
plan(agoraphobia,differential,'fear confined to flying: specific phobia, situational type',[v(sp_base),y(fear_of_situations),y(fear_of_public_transport)],[top(specific_phobia_situational_type),absent(agoraphobia)]).

% Generalized anxiety disorder
plan(generalized_anxiety_disorder,typical,'45-year-old worrying about many things for a year',[v(gad_adult)],[present(generalized_anxiety_disorder),top(generalized_anxiety_disorder)]).
plan(generalized_anxiety_disorder,subthreshold,'adult with 2 of 6 associated symptoms (C: >= 3)',[v(gad_adult),-sleep_disturbance],[absent(generalized_anxiety_disorder)]).
plan(generalized_anxiety_disorder,exclusion,'worry caused by hyperthyroidism (E)',[v(gad_adult),y(another_medical_condition),y(disturbance_is_direct_consequence_of_medical_condition),y(not_exclusively_during_delirium)],[absent(generalized_anxiety_disorder),top(anxiety_disorder_due_to_another_medical_condition)]).
plan(generalized_anxiety_disorder,differential,'2 months of worry after a job loss: adjustment disorder with anxiety',[v(gad_adult),c(symptoms_duration,one_to_three_months),y(emotional_or_behavioural_symptoms_after_stressor),c(symptoms_onset,within_three_months_of_stressor),c(adjustment_subtype,with_anxiety)],[top(adjustment_disorder_with_anxiety),absent(generalized_anxiety_disorder)]).

% Substance/medication-induced disorders, by onset specifier
onset_goal(substance_induced_anxiety_disorder_with_onset_during_intoxication,sia_base,onset_during_intoxication,substance_induced_anxiety_disorder_with_onset_during_withdrawal).
onset_goal(substance_induced_anxiety_disorder_with_onset_during_withdrawal,sia_base,onset_during_withdrawal,substance_induced_anxiety_disorder_with_onset_after_medication_use).
onset_goal(substance_induced_anxiety_disorder_with_onset_after_medication_use,sia_base,onset_after_medication_use,substance_induced_anxiety_disorder_with_onset_during_intoxication).
onset_goal(substance_induced_ocrd_with_onset_during_intoxication,sio_base,onset_during_intoxication,substance_induced_ocrd_with_onset_during_withdrawal).
onset_goal(substance_induced_ocrd_with_onset_during_withdrawal,sio_base,onset_during_withdrawal,substance_induced_ocrd_with_onset_after_medication_use).
onset_goal(substance_induced_ocrd_with_onset_after_medication_use,sio_base,onset_after_medication_use,substance_induced_ocrd_with_onset_during_intoxication).

plan(G,typical,'symptoms that began with a substance capable of causing them',[v(V),c(substance_onset,O)],[present(G),top(G)]) :-
	onset_goal(G,V,O,_).
plan(G,subthreshold,'the substance cannot produce these symptoms (B2)',[v(V),c(substance_onset,O),-substance_capable_of_producing_symptoms],[absent(G)]) :-
	onset_goal(G,V,O,_).
plan(G,exclusion,'symptoms preceded the use: independent disorder (C)',[v(V),c(substance_onset,O),y(independent_disorder_evidence)],[absent(G)]) :-
	onset_goal(G,V,O,_).
plan(G,differential,'another onset specifier',[v(V),c(substance_onset,O2)],[top(N),absent(G)]) :-
	onset_goal(G,V,_,N), onset_goal(N,_,O2,_).

% Anxiety disorder due to another medical condition
plan(anxiety_disorder_due_to_another_medical_condition,typical,'panic attacks from untreated hyperthyroidism',[v(amc_anx)],[present(anxiety_disorder_due_to_another_medical_condition),top(anxiety_disorder_due_to_another_medical_condition)]).
plan(anxiety_disorder_due_to_another_medical_condition,subthreshold,'no evidence of a direct physiological link (B)',[v(amc_anx),-disturbance_is_direct_consequence_of_medical_condition],[absent(anxiety_disorder_due_to_another_medical_condition)]).
plan(anxiety_disorder_due_to_another_medical_condition,exclusion,'anxiety only during a delirium (D)',[v(amc_anx),-not_exclusively_during_delirium],[absent(anxiety_disorder_due_to_another_medical_condition)]).
plan(anxiety_disorder_due_to_another_medical_condition,differential,'anxiety from cocaine instead: substance-induced',[v(sia_base)],[top(substance_induced_anxiety_disorder_with_onset_during_intoxication),absent(anxiety_disorder_due_to_another_medical_condition)]).

% OCD, BDD and hoarding by insight level
insight_goal(obsessive_compulsive_disorder_with_good_or_fair_insight,ocd_base,insight_good_or_fair,obsessive_compulsive_disorder_with_poor_insight).
insight_goal(obsessive_compulsive_disorder_with_poor_insight,ocd_base,insight_poor,obsessive_compulsive_disorder_with_absent_insight).
insight_goal(obsessive_compulsive_disorder_with_absent_insight,ocd_base,insight_absent_or_delusional,obsessive_compulsive_disorder_with_good_or_fair_insight).
insight_goal(body_dysmorphic_disorder_with_good_or_fair_insight,bdd_base,insight_good_or_fair,body_dysmorphic_disorder_with_poor_insight).
insight_goal(body_dysmorphic_disorder_with_poor_insight,bdd_base,insight_poor,body_dysmorphic_disorder_with_absent_insight).
insight_goal(body_dysmorphic_disorder_with_absent_insight,bdd_base,insight_absent_or_delusional,body_dysmorphic_disorder_with_good_or_fair_insight).
insight_goal(hoarding_disorder_with_good_or_fair_insight,hd_base,insight_good_or_fair,hoarding_disorder_with_poor_insight).
insight_goal(hoarding_disorder_with_poor_insight,hd_base,insight_poor,hoarding_disorder_with_absent_insight).
insight_goal(hoarding_disorder_with_absent_insight,hd_base,insight_absent_or_delusional,hoarding_disorder_with_good_or_fair_insight).

%	What makes each of the three disorders one criterion short, and an exclusion that applies.
insight_short(ocd_base,'thoughts not resisted and acts not aimed at distress: neither obsessions nor compulsions (A)',[-attempts_to_ignore_or_neutralize_thoughts,-acts_aimed_at_reducing_distress]).
insight_short(bdd_base,'appearance preoccupation without repetitive behaviours (B)',[-mirror_checking,-reassurance_seeking]).
insight_short(hd_base,'difficulty discarding without clutter of living areas (C)',[-accumulation_clutters_living_areas]).
insight_excluded(ocd_base,'symptoms explained by another disorder, e.g. guilty ruminations in depression (D)',[y(oc_symptoms_better_explained_by_other_disorder)]).
insight_excluded(bdd_base,'concern with body weight in an eating disorder (D)',[y(appearance_concern_better_explained_by_eating_disorder)]).
insight_excluded(hd_base,'hoarding after a brain injury (E)',[y(another_medical_condition),y(disturbance_is_direct_consequence_of_medical_condition)]).

plan(G,typical,'full criteria, with the insight level of the goal',[v(V),c(insight_level,L)],[present(G),top(G)]) :-
	insight_goal(G,V,L,_).
plan(G,subthreshold,D,[v(V),c(insight_level,L)|Mods],[absent(G)]) :-
	insight_goal(G,V,L,_), insight_short(V,D,Mods).
plan(G,exclusion,D,[v(V),c(insight_level,L)|Mods],[absent(G)]) :-
	insight_goal(G,V,L,_), insight_excluded(V,D,Mods).
plan(G,differential,'same disorder with another insight level',[v(V),c(insight_level,L2)],[top(N),absent(G)]) :-
	insight_goal(G,V,_,N), insight_goal(N,_,L2,_).

% Yes/no specifiers of OCD, BDD and hoarding
yes_no_specifier(obsessive_compulsive_disorder_tic_related,ocd_base,history_of_tic_disorder,obsessive_compulsive_disorder_with_good_or_fair_insight).
yes_no_specifier(body_dysmorphic_disorder_with_muscle_dysmorphia,bdd_base,preoccupied_with_insufficient_muscularity,body_dysmorphic_disorder_with_good_or_fair_insight).
yes_no_specifier(hoarding_disorder_with_excessive_acquisition,hd_base,excessive_acquisition_of_unneeded_items,hoarding_disorder_with_good_or_fair_insight).

plan(G,typical,'full criteria with the specifier',[v(V),y(I)],[present(G),top(G)]) :-
	yes_no_specifier(G,V,I,_).
plan(G,subthreshold,D,[v(V),y(I)|Mods],[absent(G)]) :-
	yes_no_specifier(G,V,I,_), insight_short(V,D,Mods).
plan(G,exclusion,D,[v(V),y(I)|Mods],[absent(G)]) :-
	yes_no_specifier(G,V,I,_), insight_excluded(V,D,Mods).
plan(G,differential,'full criteria without the specifier',[v(V)],[top(N),absent(G)]) :-
	yes_no_specifier(G,V,_,N).

% Trichotillomania
plan(trichotillomania,typical,'17-year-old with hair loss, repeated attempts to stop',[v(tt_base)],[present(trichotillomania),top(trichotillomania)]).
plan(trichotillomania,subthreshold,'no attempt to decrease or stop (B)',[v(tt_base),-repeated_attempts_to_stop_hair_pulling],[absent(trichotillomania)]).
plan(trichotillomania,exclusion,'hair loss from a dermatological condition (D)',[v(tt_base),y(another_medical_condition),y(disturbance_is_direct_consequence_of_medical_condition)],[absent(trichotillomania)]).
plan(trichotillomania,differential,'pulling to fix a perceived flaw: body dysmorphic disorder',[v(bdd_base),y(recurrent_pulling_out_of_hair),y(repeated_attempts_to_stop_hair_pulling),y(hair_pulling_better_explained_by_other_disorder)],[top(body_dysmorphic_disorder_with_good_or_fair_insight),absent(trichotillomania)]).

% Excoriation disorder
plan(excoriation_disorder,typical,'24-year-old picking with lesions, tried to stop',[v(ex_base)],[present(excoriation_disorder),top(excoriation_disorder)]).
plan(excoriation_disorder,subthreshold,'picking without skin lesions (A)',[v(ex_base),-recurrent_skin_picking_causing_lesions],[absent(excoriation_disorder)]).
plan(excoriation_disorder,exclusion,'picking during cocaine intoxication (D): substance-induced',[v(ex_base),y(substance_intoxication_or_withdrawal_or_medication_use),y(symptoms_developed_during_or_after_substance_use),y(substance_capable_of_producing_symptoms),y(not_exclusively_during_delirium)],[absent(excoriation_disorder),top(substance_induced_ocrd_with_onset_during_intoxication)]).
plan(excoriation_disorder,differential,'picking to remove perceived blemishes: body dysmorphic disorder',[v(bdd_base),y(recurrent_skin_picking_causing_lesions),y(repeated_attempts_to_stop_skin_picking),y(skin_picking_for_appearance),y(skin_picking_better_explained_by_other_disorder)],[top(body_dysmorphic_disorder_with_good_or_fair_insight),absent(excoriation_disorder)]).

% OCRD due to another medical condition, by presentation specifier
presentation_goal(ocrd_due_to_another_medical_condition_with_ocd_like_symptoms,with_ocd_like_symptoms,ocrd_due_to_another_medical_condition_with_hoarding_symptoms).
presentation_goal(ocrd_due_to_another_medical_condition_with_appearance_preoccupations,with_appearance_preoccupations,ocrd_due_to_another_medical_condition_with_ocd_like_symptoms).
presentation_goal(ocrd_due_to_another_medical_condition_with_hoarding_symptoms,with_hoarding_symptoms,ocrd_due_to_another_medical_condition_with_hair_pulling_symptoms).
presentation_goal(ocrd_due_to_another_medical_condition_with_hair_pulling_symptoms,with_hair_pulling_symptoms,ocrd_due_to_another_medical_condition_with_skin_picking_symptoms).
presentation_goal(ocrd_due_to_another_medical_condition_with_skin_picking_symptoms,with_skin_picking_symptoms,ocrd_due_to_another_medical_condition_with_appearance_preoccupations).

plan(G,typical,'symptoms after a stroke, with the presentation of the goal',[v(amc_oc),c(ocrd_presentation,P)],[present(G),top(G)]) :-
	presentation_goal(G,P,_).
plan(G,subthreshold,'no evidence of a direct physiological link (B)',[v(amc_oc),c(ocrd_presentation,P),-disturbance_is_direct_consequence_of_medical_condition],[absent(G)]) :-
	presentation_goal(G,P,_).
plan(G,exclusion,'symptoms only during a delirium (D)',[v(amc_oc),c(ocrd_presentation,P),-not_exclusively_during_delirium],[absent(G)]) :-
	presentation_goal(G,P,_).
plan(G,differential,'another predominant presentation',[v(amc_oc),c(ocrd_presentation,P2)],[top(N),absent(G)]) :-
	presentation_goal(G,_,N), presentation_goal(N,P2,_).

% Reactive attachment disorder and disinhibited social engagement disorder
plan(reactive_attachment_disorder,typical,'3-year-old adopted from an institution, inhibited and withdrawn',[v(rad_base)],[present(reactive_attachment_disorder),top(reactive_attachment_disorder)]).
plan(reactive_attachment_disorder,subthreshold,'only 1 of the 3 social-emotional disturbances (B: >= 2)',[v(rad_base),-limited_positive_affect],[absent(reactive_attachment_disorder)]).
plan(reactive_attachment_disorder,exclusion,'criteria for autism spectrum disorder are met (E)',[v(rad_base),y(criteria_met_for_autism_spectrum_disorder)],[absent(reactive_attachment_disorder)]).
plan(reactive_attachment_disorder,differential,'indiscriminate approach to strangers: disinhibited social engagement',[v(dsed_base)],[top(disinhibited_social_engagement_disorder),absent(reactive_attachment_disorder)]).
plan(disinhibited_social_engagement_disorder,typical,'4-year-old after foster placements, goes off with strangers',[v(dsed_base)],[present(disinhibited_social_engagement_disorder),top(disinhibited_social_engagement_disorder)]).
plan(disinhibited_social_engagement_disorder,subthreshold,'only 1 of the 4 disinhibited behaviours (A: >= 2)',[v(dsed_base),-overly_familiar_behaviour,-willing_to_go_off_with_strangers],[absent(disinhibited_social_engagement_disorder)]).
plan(disinhibited_social_engagement_disorder,exclusion,'behaviour limited to ADHD impulsivity (B)',[v(dsed_base),-behaviour_not_limited_to_impulsivity],[absent(disinhibited_social_engagement_disorder)]).
plan(disinhibited_social_engagement_disorder,differential,'withdrawn, comfort-avoiding child: reactive attachment disorder',[v(rad_base)],[top(reactive_attachment_disorder),absent(disinhibited_social_engagement_disorder)]).

attachment_specifier(reactive_attachment_disorder_persistent,rad_base,disorder_present_more_than_twelve_months,reactive_attachment_disorder).
attachment_specifier(reactive_attachment_disorder_severe,rad_base,all_symptoms_at_relatively_high_levels,reactive_attachment_disorder).
attachment_specifier(disinhibited_social_engagement_disorder_persistent,dsed_base,disorder_present_more_than_twelve_months,disinhibited_social_engagement_disorder).
attachment_specifier(disinhibited_social_engagement_disorder_severe,dsed_base,all_symptoms_at_relatively_high_levels,disinhibited_social_engagement_disorder).
attachment_short(rad_base,'only 1 social-emotional disturbance (B)',[-limited_positive_affect]).
attachment_short(dsed_base,'only 1 disinhibited behaviour (A)',[-overly_familiar_behaviour,-willing_to_go_off_with_strangers]).
attachment_excluded(rad_base,'autism spectrum disorder (E)',[y(criteria_met_for_autism_spectrum_disorder)]).
attachment_excluded(dsed_base,'impulsivity only (B)',[-behaviour_not_limited_to_impulsivity]).

plan(G,typical,'full criteria with the specifier',[v(V),y(I)],[present(G),top(G)]) :-
	attachment_specifier(G,V,I,_).
plan(G,subthreshold,D,[v(V),y(I)|Mods],[absent(G)]) :-
	attachment_specifier(G,V,I,_), attachment_short(V,D,Mods).
plan(G,exclusion,D,[v(V),y(I)|Mods],[absent(G)]) :-
	attachment_specifier(G,V,I,_), attachment_excluded(V,D,Mods).
plan(G,differential,'full criteria without the specifier',[v(V)],[top(N),absent(G)]) :-
	attachment_specifier(G,V,_,N).

% Posttraumatic stress disorder and its specifiers
plan(posttraumatic_stress_disorder,typical,'40-year-old assaulted 4 months ago, all four clusters',[v(ptsd_adult)],[present(posttraumatic_stress_disorder),top(posttraumatic_stress_disorder)]).
plan(posttraumatic_stress_disorder,subthreshold,'only 1 negative alteration in cognitions and mood (D: >= 2)',[v(ptsd_adult),-detachment_from_others],[absent(posttraumatic_stress_disorder)]).
plan(posttraumatic_stress_disorder,exclusion,'symptoms from a traumatic brain injury (H)',[v(ptsd_adult),y(another_medical_condition),y(disturbance_is_direct_consequence_of_medical_condition)],[absent(posttraumatic_stress_disorder)]).
plan(posttraumatic_stress_disorder,differential,'10 days after the trauma: acute stress disorder',[v(asd_base),y(persistent_negative_beliefs),y(detachment_from_others)],[top(acute_stress_disorder),absent(posttraumatic_stress_disorder)]).

ptsd_specifier(posttraumatic_stress_disorder_with_dissociative_symptoms,persistent_derealization).
ptsd_specifier(posttraumatic_stress_disorder_with_delayed_expression,full_criteria_not_met_until_six_months_after_event).
plan(G,typical,'PTSD with the specifier',[v(ptsd_adult),y(I)],[present(G),top(G)]) :-
	ptsd_specifier(G,I).
plan(G,subthreshold,'specifier present but D one symptom short',[v(ptsd_adult),y(I),-detachment_from_others],[absent(G)]) :-
	ptsd_specifier(G,I).
plan(G,exclusion,'specifier present but symptoms from a brain injury (H)',[v(ptsd_adult),y(I),y(another_medical_condition),y(disturbance_is_direct_consequence_of_medical_condition)],[absent(G)]) :-
	ptsd_specifier(G,I).
plan(G,differential,'PTSD without the specifier',[v(ptsd_adult)],[top(posttraumatic_stress_disorder),absent(G)]) :-
	ptsd_specifier(G,_).

% Acute stress disorder
plan(acute_stress_disorder,typical,'car-crash survivor 10 days later, 9 of 14 symptoms',[v(asd_base)],[present(acute_stress_disorder),top(acute_stress_disorder)]).
plan(acute_stress_disorder,subthreshold,'8 of 14 symptoms (B: >= 9)',[v(asd_base),-hypervigilance],[absent(acute_stress_disorder)]).
plan(acute_stress_disorder,exclusion,'better explained by a brief psychotic disorder (E)',[v(asd_base),y(better_explained_by_brief_psychotic_disorder)],[absent(acute_stress_disorder)]).
plan(acute_stress_disorder,differential,'symptoms lasting 2 months with all clusters: PTSD',[v(asd_base),y(persistent_negative_beliefs),y(detachment_from_others),c(symptoms_duration,one_to_three_months)],[top(posttraumatic_stress_disorder),absent(acute_stress_disorder)]).

% Adjustment disorders, by subtype and course
adjustment_goal(adjustment_disorder_with_depressed_mood,with_depressed_mood,adjustment_disorder_with_anxiety).
adjustment_goal(adjustment_disorder_with_anxiety,with_anxiety,adjustment_disorder_with_mixed_anxiety_and_depressed_mood).
adjustment_goal(adjustment_disorder_with_mixed_anxiety_and_depressed_mood,with_mixed_anxiety_and_depressed_mood,adjustment_disorder_with_disturbance_of_conduct).
adjustment_goal(adjustment_disorder_with_disturbance_of_conduct,with_disturbance_of_conduct,adjustment_disorder_with_mixed_disturbance_of_emotions_and_conduct).
adjustment_goal(adjustment_disorder_with_mixed_disturbance_of_emotions_and_conduct,with_mixed_disturbance_emotions_conduct,adjustment_disorder_unspecified).
adjustment_goal(adjustment_disorder_unspecified,unspecified_adjustment,adjustment_disorder_with_depressed_mood).

plan(G,typical,'symptoms within weeks of a job loss, with the subtype of the goal',[v(adj_base),c(adjustment_subtype,S)],[present(G),top(G)]) :-
	adjustment_goal(G,S,_).
plan(G,subthreshold,'onset more than 3 months after the stressor (A)',[v(adj_base),c(adjustment_subtype,S),c(symptoms_onset,more_than_three_months_after_stressor)],[absent(G)]) :-
	adjustment_goal(G,S,_).
plan(G,exclusion,'the reaction meets the criteria of another mental disorder (C)',[v(adj_base),c(adjustment_subtype,S),y(stress_reaction_meets_criteria_for_another_disorder)],[absent(G)]) :-
	adjustment_goal(G,S,_).
plan(G,differential,'another predominant presentation',[v(adj_base),c(adjustment_subtype,S2)],[top(N),absent(G)]) :-
	adjustment_goal(G,_,N), adjustment_goal(N,S2,_).
plan(adjustment_disorder_acute,typical,'symptoms for 2 months',[v(adj_base)],[present(adjustment_disorder_acute),top(adjustment_disorder_acute)]).
plan(adjustment_disorder_acute,subthreshold,'onset more than 3 months after the stressor (A)',[v(adj_base),c(symptoms_onset,more_than_three_months_after_stressor)],[absent(adjustment_disorder_acute)]).
plan(adjustment_disorder_acute,exclusion,'the symptoms are a normal bereavement (D)',[v(adj_base),y(symptoms_represent_normal_bereavement)],[absent(adjustment_disorder_acute)]).
plan(adjustment_disorder_acute,differential,'symptoms for 8 months under a chronic stressor: persistent',[v(adj_base),c(symptoms_duration,six_months_or_more)],[top(adjustment_disorder_persistent),absent(adjustment_disorder_acute)]).
plan(adjustment_disorder_persistent,typical,'symptoms for 8 months under a chronic stressor',[v(adj_base),c(symptoms_duration,six_months_or_more)],[present(adjustment_disorder_persistent),top(adjustment_disorder_persistent)]).
plan(adjustment_disorder_persistent,subthreshold,'no marked distress nor impairment (B)',[v(adj_base),c(symptoms_duration,six_months_or_more),-distress_out_of_proportion_to_stressor,-occupational_distress],[absent(adjustment_disorder_persistent)]).
plan(adjustment_disorder_persistent,exclusion,'symptoms outlast the end of the stressor by more than 6 months (E)',[v(adj_base),c(symptoms_duration,six_months_or_more),y(symptoms_persist_beyond_six_months_after_stressor_ends)],[absent(adjustment_disorder_persistent)]).
plan(adjustment_disorder_persistent,differential,'symptoms for 2 months: acute',[v(adj_base)],[top(adjustment_disorder_acute),absent(adjustment_disorder_persistent)]).

% Prolonged grief disorder
plan(prolonged_grief_disorder,typical,'60-year-old widow, 14 months after the death',[v(pgd_adult)],[present(prolonged_grief_disorder),top(prolonged_grief_disorder)]).
plan(prolonged_grief_disorder,subthreshold,'adult bereaved 9 months ago (A: >= 12 months)',[v(pgd_adult),c(bereavement_time,six_to_twelve_months)],[absent(prolonged_grief_disorder)]).
plan(prolonged_grief_disorder,exclusion,'grief better explained by major depressive disorder (F)',[v(pgd_adult),y(grief_better_explained_by_other_disorder)],[absent(prolonged_grief_disorder)]).
plan(prolonged_grief_disorder,differential,'witnessed violent death with full PTSD that explains the picture',[v(pgd_adult),v(ptsd_adult),y(grief_better_explained_by_other_disorder)],[top(posttraumatic_stress_disorder),absent(prolonged_grief_disorder)]).


%---------------------------------OTHER CASES-----------------------------------
%	extra(Id, Type, Description, Spec, Expectations).

% comorbidity: two diagnoses both expected
extra(panic_and_agoraphobia,comorbidity,'panic disorder and agoraphobia are both assigned (agoraphobia note)',[v(panic_adult),v(agora_adult)],[present(panic_disorder),present(agoraphobia)]).
extra(two_phobia_types,comorbidity,'snakes and flying: both specific phobia codes',[v(sp_base),y(fear_of_animals),y(fear_of_situations)],[present(specific_phobia_animal_type),present(specific_phobia_situational_type)]).
extra(mutism_and_social_anxiety,comorbidity,'selective mutism with social anxiety in a child',[v(sm_child),v(social_child)],[present(selective_mutism),present(social_anxiety_disorder)]).
extra(trichotillomania_and_excoriation,comorbidity,'hair pulling and skin picking',[v(tt_base),v(ex_base),age(adult)],[present(trichotillomania),present(excoriation_disorder)]).
extra(gad_and_social_anxiety,comorbidity,'generalized worry and social fear',[v(gad_adult),v(social_adult)],[present(generalized_anxiety_disorder),present(social_anxiety_disorder)]).
extra(ocd_and_tic_related,comorbidity,'OCD with poor insight and a tic history',[v(ocd_base),c(insight_level,insight_poor),y(history_of_tic_disorder)],[present(obsessive_compulsive_disorder_with_poor_insight),present(obsessive_compulsive_disorder_tic_related),absent(obsessive_compulsive_disorder_with_good_or_fair_insight)]).

% specifier: base present and specifier absent when it is not reported
extra(ptsd_without_specifiers,specifier,'PTSD reported without dissociation or delay',[v(ptsd_adult)],[present(posttraumatic_stress_disorder),absent(posttraumatic_stress_disorder_with_dissociative_symptoms),absent(posttraumatic_stress_disorder_with_delayed_expression)]).
extra(ptsd_both_specifiers,specifier,'PTSD with depersonalization and delayed expression',[v(ptsd_adult),y(persistent_depersonalization),y(full_criteria_not_met_until_six_months_after_event)],[present(posttraumatic_stress_disorder_with_dissociative_symptoms),present(posttraumatic_stress_disorder_with_delayed_expression)]).
extra(rad_persistent_severe,specifier,'RAD for 18 months, all symptoms at high levels',[v(rad_base),y(disorder_present_more_than_twelve_months),y(all_symptoms_at_relatively_high_levels)],[present(reactive_attachment_disorder_persistent),present(reactive_attachment_disorder_severe)]).
extra(social_without_performance,specifier,'social anxiety without the performance-only specifier',[v(social_adult)],[present(social_anxiety_disorder),absent(social_anxiety_disorder_performance_only)]).
extra(bdd_muscle_poor_insight,specifier,'muscle dysmorphia with poor insight',[v(bdd_base),c(insight_level,insight_poor),y(preoccupied_with_insufficient_muscularity)],[present(body_dysmorphic_disorder_with_poor_insight),present(body_dysmorphic_disorder_with_muscle_dysmorphia)]).
extra(ocd_time_without_distress,specifier,'OCD over 1 hour a day without reported distress (B is a disjunction)',[v(ocd_base),-occupational_distress,-social_distress],[present(obsessive_compulsive_disorder_with_good_or_fair_insight)]).
extra(ocd_neither_time_nor_distress,subthreshold,'OCD neither time-consuming nor distressing (B)',[v(ocd_base),-more_than_one_hour_per_day,-occupational_distress,-social_distress],[absent(obsessive_compulsive_disorder_with_good_or_fair_insight)]).
extra(ocd_compulsions_only,specifier,'compulsions without obsessions still satisfy A',[v(ocd_base),-recurrent_intrusive_unwanted_thoughts],[present(obsessive_compulsive_disorder_with_good_or_fair_insight)]).

% age rules
extra(sad_adult_short,age_rule,'adult with 3 months of separation fear (B: typically >= 6 months in adults)',[v(sad_adult),c(symptoms_duration,one_to_three_months)],[absent(separation_anxiety_disorder)]).
extra(sad_adult_long,age_rule,'adult with separation fear for over a year',[v(sad_adult)],[present(separation_anxiety_disorder)]).
extra(gad_child_one_symptom,age_rule,'child with 1 associated symptom (C: one item in children)',[v(gad_child)],[present(generalized_anxiety_disorder)]).
extra(gad_adult_one_symptom,age_rule,'adult with the same single associated symptom',[v(gad_child),age(adult)],[absent(generalized_anxiety_disorder)]).
extra(social_child_no_peers,age_rule,'child anxious only with adults, not with peers (A note)',[v(social_child),-anxiety_occurs_in_peer_settings],[absent(social_anxiety_disorder)]).
extra(ptsd_preschool,age_rule,'5-year-old, preschool criteria (merged C, 2 of 5 arousal)',[v(ptsd_preschool)],[present(posttraumatic_stress_disorder)]).
extra(ptsd_preschool_rules_in_child,age_rule,'the same picture at 8 years does not meet criteria D and E',[v(ptsd_preschool),age(child)],[absent(posttraumatic_stress_disorder)]).
extra(ptsd_preschool_media_exposure,age_rule,'preschool exposure only through repeated details is not a route (A)',[v(ptsd_preschool),-witnessing_trauma,y(repeated_exposure_to_trauma_details)],[absent(posttraumatic_stress_disorder)]).
extra(pgd_adolescent_nine_months,age_rule,'adolescent bereaved 9 months ago (A: >= 6 months in youth)',[v(pgd_adult),age(adolescent),c(bereavement_time,six_to_twelve_months)],[present(prolonged_grief_disorder)]).
extra(rad_in_adult,age_rule,'attachment criteria refer to a child',[v(rad_base),age(adult)],[absent(reactive_attachment_disorder)]).
extra(rad_after_age_five,age_rule,'disturbance not evident before age 5 (F)',[v(rad_base),age(child),-disturbance_evident_before_age_five],[absent(reactive_attachment_disorder)]).

% uncertainty: graded answers and the fuzzy-membership duration
extra(uncertain_panic,uncertainty,'panic disorder with graded answers (0.6-0.9)',
	[ y(abrupt_surge_of_fear_or_discomfort,0.9), y(palpitations,0.9), y(sweating,0.8), y(trembling,0.7), y(dyspnea,0.9),
	  y(chest_pain,0.8), y(fear_of_dying,0.9), y(fear_of_losing_control,0.6), y(worry_about_new_panic_attacks,0.9),
	  y(maladaptive_behaviour_change_due_to_panic,0.7), y(occupational_distress,0.8), y(social_distress,0.7),
	  c(panic_attacks_frequency,more_than_five), c(attack_type,unexpected_attack), c(symptoms_duration,three_to_six_months) ],
	[ranks_first(panic_disorder)]).
extra(uncertain_ptsd,uncertainty,'PTSD with graded answers (0.7-0.9)',
	[ y(directly_experiencing_trauma,0.9), y(intrusive_memories,0.9), y(distressing_dreams,0.8),
	  y(avoidance_of_trauma_thoughts_or_feelings,0.9), y(avoidance_of_external_trauma_reminders,0.8),
	  y(persistent_negative_beliefs,0.8), y(detachment_from_others,0.7), y(inability_to_feel_positive_emotions,0.7),
	  y(hypervigilance,0.8), y(exaggerated_startle_response,0.8), y(sleep_disturbance,0.7),
	  y(occupational_distress,0.8), y(social_distress,0.7), c(symptoms_duration,three_to_six_months) ],
	[ranks_first(posttraumatic_stress_disorder)]).
extra(borderline_phobia,uncertainty,'spider phobia for 5 months: only the graded duration still supports it',
	[v(sp_base),y(fear_of_animals),c(symptoms_duration,three_to_six_months),value(duration_months,5)],
	[when([cf,fuzzy],absent(specific_phobia_animal_type)),when([fuzzy_membership],top(specific_phobia_animal_type))]).
extra(no_diagnosis,uncertainty,'mild non-specific work stress only',[y(occupational_distress,0.5)],[none]).


%--------------------------------CASE EXPANSION---------------------------------
%	case(Id, Goal, Type, Description, Age, Answers, Expectations)
case(G-T,G,T,D,Age,Answers,E) :-
	plan(G,T,D,Spec,E),
	expand(Spec,Age,Answers).
case(Id,none,T,D,Age,Answers,E) :-
	extra(Id,T,D,Spec,E),
	expand(Spec,Age,Answers).

%	expand(Spec, Age, Answers): the answers of a spec, later items overriding earlier ones.
expand(Spec,Age,Answers) :-
	foldl(apply_spec,Spec,s(adult,[]),s(Age,Rev)),
	reverse(Rev,Answers).

apply_spec(v(V),s(_,A0),s(Age,A)) :-
	vignette(V,Age,Facts),
	foldl(add_answer,Facts,A0,A).
apply_spec(age(Age),s(_,A),s(Age,A)) :- !.
apply_spec(-Item,s(Age,A0),s(Age,A)) :- !,
	exclude(answer_of(Item),A0,A).
apply_spec(F,s(Age,A0),s(Age,A)) :-
	add_answer(F,A0,A).

add_answer(F,A0,[F|A]) :-
	answer_key(F,K),
	exclude(same_key(K),A0,A).

answer_key(y(I),y(I)).
answer_key(y(I,_),y(I)).
answer_key(c(Q,_),c(Q)).
answer_key(value(V,_),value(V)).

same_key(K,F) :- answer_key(F,K).
answer_of(Item,F) :- answer_key(F,y(Item)).


%---------------------------------TEST RUNNER-----------------------------------

%	setup(Age, Answers): clears the working memory and asserts the defaults
%	with the answers of the case on top.
setup(Age,Answers) :-
	retractall(known(_,_,_,_)),
	retractall(known_value(_,_)),
	askable_symptoms(Symptoms),
	forall(member(I,Symptoms), assertz(known(no,symptom,I,1.0))),
	assertz(known(yes,patient,Age,1.0)),
	multiask_defaults(Defaults),
	forall(member(Q-O,Defaults), ( memberchk(c(Q,_),Answers) -> true ; assertz(known(yes,Q,O,1.0)) )),
	selective_defaults(Selective),
	forall(member(Q-O,Selective), ( memberchk(c(Q,_),Answers) -> true ; assertz(known(yes,Q,O,1.0)) )),
	forall(member(F,Answers), assert_answer(F)),
	( known_value(duration_months,_) -> true
	; known(yes,symptoms_duration,D,_), months(D,M), assertz(known_value(duration_months,M)) ),
	( known_value(panic_attacks_count,_) -> true
	; known(yes,panic_attacks_frequency,P,_), attacks(P,N), assertz(known_value(panic_attacks_count,N)) ).

assert_answer(y(I)) :- assert_answer(y(I,1.0)).
assert_answer(y(I,C)) :- retractall(known(_,symptom,I,_)), asserta(known(yes,symptom,I,C)).
assert_answer(c(Q,O)) :- asserta(known(yes,Q,O,1.0)).
assert_answer(value(V,X)) :- assertz(known_value(V,X)).

%	run_case(Method, Id, Ranked): runs one case and returns the ranked goals.
run_case(Method,Age,Answers,Sorted) :-
	retractall(uncertainty_method(_)),
	assertz(uncertainty_method(Method)),
	setup(Age,Answers),
	delete_trees,
	investigate_goals(Goals),
	descending_order_goals(Goals,Sorted),
	!.

goal_cf(G,Ranked,CF) :- ( memberchk(goal(G,CF0),Ranked) -> CF = CF0 ; CF = 0.0 ).

%	check(Method, Ranked, Expectation)
check(M,R,when(Ms,E)) :- !, ( memberchk(M,Ms) -> check(M,R,E) ; true ).
check(_,R,present(G)) :- !, threshold(T), goal_cf(G,R,CF), CF >= T.
check(_,R,absent(G)) :- !, threshold(T), goal_cf(G,R,CF), CF < T.
check(_,R,top(G)) :- !,
	goal_cf(G,R,CF), threshold(T), CF >= T,
	R = [goal(_,Max)|_], CF >= Max - 1.0e-9.
check(_,R,ranks_first(G)) :- !,
	goal_cf(G,R,CF), CF > 0,
	R = [goal(_,Max)|_], CF >= Max - 1.0e-9.
check(_,R,none) :- threshold(T), ( R = [goal(_,Max)|_] -> Max < T ; true ).

methods([cf,fuzzy,fuzzy_membership]).

%	run_all: runs every case under every method, printing the failures.
run_all :-
	retractall(result(_,_,_,_)),
	methods(Methods),
	forall(( case(Id,G,T,D,Age,Answers,E), member(M,Methods) ),
		( run_case(M,Age,Answers,Ranked),
		  ( forall(member(X,E), check(M,Ranked,X)) -> R = pass ; R = fail, report_failure(M,Id,D,E,Ranked) ),
		  assertz(result(Id,G-T,M,R)) )).

report_failure(M,Id,D,E,Ranked) :-
	format('~n[FAIL] (~w) ~w: ~w~n      expected: ~w~n      ranked:~n',[M,Id,D,E]),
	forall(( nth1(K,Ranked,goal(G,CF)), K =< 4 ),
		( P is round(CF*100), format('        ~w) ~w  ~w%~n',[K,G,P]) )).


%-----------------------------CONSISTENCY CHECKS--------------------------------
%	Every goal has a label in both languages, both codes and the four case
%	types; every askable item and question has a label in both languages.
consistency_errors(Errors) :-
	goals_list(Goals),
	findall(E,
		( member(G,Goals), member(T,[typical,subthreshold,exclusion,differential]),
		  \+ plan(G,T,_,_,_), E = missing_case(G,T) ),
		E1),
	askable_symptoms(Items),
	findall(K,( member(G,Goals) ; member(G,Items) ), Keys0),
	append(Keys0,[insight_level,substance_onset,ocrd_presentation,adjustment_subtype,symptoms_duration,phobic_reaction_type],Keys),
	findall(missing_label(L,K),( member(K,Keys), member(L,[en,it]), \+ label(L,K,_) ),E2),
	findall(missing_vignette(V),( plan(_,_,_,S,_), member(v(V),S), \+ vignette(V,_,_) ),E3),
	append([E1,E2,E3],Errors).


%------------------------------------REPORT-------------------------------------
type_column(typical,'typical').
type_column(subthreshold,'subthr.').
type_column(exclusion,'exclusion').
type_column(differential,'differ.').

cell(G,T,Cell) :-
	methods(Ms),
	findall(R,( member(M,Ms), result(_,G-T,M,R) ),Rs),
	( Rs == [] -> Cell = '-'
	; memberchk(fail,Rs) -> Cell = 'FAIL'
	; Cell = 'pass' ).

report_table :-
	format('~n~w~n',['| goal | typical | subthreshold | exclusion | differential |']),
	format('~w~n',['| --- | --- | --- | --- | --- |']),
	goals_list(Goals),
	forall(member(G,Goals),
		( maplist(cell(G),[typical,subthreshold,exclusion,differential],Cs),
		  atomic_list_concat(Cs,' | ',Row),
		  format('| ~w | ~w |~n',[G,Row]) )),
	format('~n~w~n',['| other case | type | cf | fuzzy | fuzzy_membership |']),
	format('~w~n',['| --- | --- | --- | --- | --- |']),
	forall(extra(Id,T,_,_,_),
		( findall(R,( member(M,[cf,fuzzy,fuzzy_membership]), result(Id,none-T,M,R) ),Rs),
		  atomic_list_concat(Rs,' | ',Row),
		  format('| ~w | ~w | ~w |~n',[Id,T,Row]) )).

summary(Failed) :-
	methods(Ms),
	forall(member(M,Ms),
		( aggregate_all(count,result(_,_,M,_),N), aggregate_all(count,result(_,_,M,pass),P),
		  format('  ~w: ~w/~w cases passed~n',[M,P,N]) )),
	aggregate_all(count,result(_,_,_,fail),Failed).

run_tests :-
	assertz(language(en)),
	consistency_errors(Errors),
	forall(member(E,Errors),format('[FAIL] consistency: ~w~n',[E])),
	run_all,
	report_table,
	format('~n================================================================~n'),
	summary(Failed),
	length(Errors,NE),
	format('  consistency errors: ~w~n',[NE]),
	format('================================================================~n'),
	( Failed =:= 0, NE =:= 0 -> halt(0) ; halt(1) ).

:- initialization(run_tests).
