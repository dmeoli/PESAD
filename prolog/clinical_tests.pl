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
%		plus comorbidity, specifier, age-rule, boundary and uncertainty cases, and
%		evaluations from facts (test results, see evaluate.pl). A goal is
%		present when its certainty is at least 50%. Every case runs under the
%		uncertainty methods (cf, fuzzy, fuzzy_membership, lukasiewicz,
%		hamacher, einstein); the suite
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
:- reconsult('evaluate.pl').
:- multifile finding/3, finding_evidence/3, childhood_evidence/3.
:- dynamic evaluation_case/4.
:- ( getenv('PESAD_EXTRA_RULES', F) -> reconsult(F) ; true ).

%	threshold(T): a goal is present when its certainty is at least T.
threshold(0.5).


%-----------------------------ASKABLE ITEMS / DEFAULTS--------------------------

%	askable_symptoms(Items): every yes/no item the engine may ask (see
%	askable_items/1 in evaluate.pl).
askable_symptoms(Items) :-
	askable_items(Items).

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
	adjustment_subtype-unspecified_adjustment,
	adhd_severity-severity_mild,
	learning_disorder_severity-severity_mild,
	idd_severity-severity_mild,
	asd_social_communication_support-requiring_support,
	asd_restricted_behaviour_support-requiring_support
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


% Neurodevelopmental disorders.
% 9-year-old with a full-scale IQ of 62 confirmed by the clinical assessment,
% who needs help with dressing, money and school tasks; delays since infancy.
vignette(idd_base,child,
	[ y(intellectual_deficits_on_standardized_testing), y(intellectual_deficits_on_clinical_assessment),
	  y(adaptive_functioning_deficits), y(onset_in_early_developmental_period) ]).
% 5-year-old with few words and short, ungrammatical sentences, well below
% age on a language test; hearing is normal.
vignette(ld_base,preschool,
	[ y(reduced_vocabulary), y(limited_sentence_structure), y(language_abilities_substantially_below_age),
	  y(onset_in_early_developmental_period), y(social_distress), y(other_functional_distress) ]).
% 8-year-old with fluent grammar who greets nobody, talks to teachers as to
% classmates, cannot take turns and takes idioms literally; no restricted
% interests or routines.
vignette(scd_base,child,
	[ y(deficits_in_social_use_of_communication), y(difficulty_adapting_communication_to_context),
	  y(difficulty_following_conversation_rules), y(difficulty_understanding_nonliteral_language),
	  y(onset_in_early_developmental_period), y(social_distress), y(other_functional_distress) ]).
% 7-year-old with little reciprocal conversation, poor eye contact and no
% friends, who lines up objects and insists on the same route, and is
% absorbed by train timetables; signs since age 2.
vignette(autism_base,child,
	[ y(social_emotional_reciprocity_deficits), y(nonverbal_communication_deficits), y(relationship_deficits),
	  y(insistence_on_sameness), y(restricted_fixated_interests), y(onset_in_early_developmental_period),
	  y(social_distress), y(other_functional_distress) ]).
% 9-year-old, careless, distractible and restless at home and at school since
% the first grade: 7 inattention and 6 hyperactivity-impulsivity symptoms.
vignette(adhd_child,child,
	[ y(careless_mistakes), y(difficulty_sustaining_attention), y(does_not_seem_to_listen),
	  y(fails_to_follow_through_on_tasks), y(difficulty_organizing_tasks), y(loses_things_necessary_for_tasks),
	  y(easily_distracted), y(fidgets_or_squirms), y(leaves_seat_when_remaining_seated_is_expected),
	  y(runs_about_or_feels_restless), y(often_on_the_go), y(talks_excessively), y(interrupts_or_intrudes_on_others),
	  y(several_symptoms_before_age_twelve), y(symptoms_in_two_or_more_settings), y(social_distress),
	  y(other_functional_distress), c(symptoms_duration,six_months_or_more) ]).
% 34-year-old who misses deadlines, loses keys and drifts off in meetings, as
% at school; 5 inattention and 2 hyperactivity-impulsivity symptoms.
vignette(adhd_inatt_adult,adult,
	[ y(careless_mistakes), y(difficulty_sustaining_attention), y(difficulty_organizing_tasks),
	  y(loses_things_necessary_for_tasks), y(forgetful_in_daily_activities), y(fidgets_or_squirms),
	  y(talks_excessively), y(several_symptoms_before_age_twelve), y(symptoms_in_two_or_more_settings),
	  y(occupational_distress), y(social_distress), c(symptoms_duration,six_months_or_more) ]).
% 7-year-old who cannot stay seated, climbs the furniture, blurts out answers
% and interrupts, at home and at school; attentive enough with the tasks.
vignette(adhd_hyper_child,child,
	[ y(fidgets_or_squirms), y(leaves_seat_when_remaining_seated_is_expected), y(runs_about_or_feels_restless),
	  y(often_on_the_go), y(blurts_out_answers), y(interrupts_or_intrudes_on_others), y(easily_distracted),
	  y(several_symptoms_before_age_twelve), y(symptoms_in_two_or_more_settings), y(social_distress),
	  y(other_functional_distress), c(symptoms_duration,six_months_or_more) ]).
% 28-year-old diagnosed with ADHD at 10, now with 3 inattention and 2
% hyperactivity symptoms that still disturb work.
vignette(adhd_remission,adult,
	[ y(full_adhd_criteria_previously_met), y(careless_mistakes), y(difficulty_organizing_tasks),
	  y(forgetful_in_daily_activities), y(fidgets_or_squirms), y(talks_excessively), y(occupational_distress),
	  c(symptoms_duration,six_months_or_more) ]).
% 10-year-old who reads slowly and guesses words, scores 72 on a reading
% test, after a year of targeted tutoring; IQ in the normal range.
vignette(sld_reading,child,
	[ y(inaccurate_or_slow_word_reading), y(reading_skills_below_age), y(difficulties_persist_despite_interventions),
	  y(learning_difficulties_began_in_school_years), y(other_functional_distress), c(symptoms_duration,six_months_or_more) ]).
% 11-year-old with many spelling and grammar errors, written expression score 74.
vignette(sld_written,child,
	[ y(difficulties_with_spelling), y(difficulties_with_written_expression), y(written_expression_skills_below_age),
	  y(difficulties_persist_despite_interventions), y(learning_difficulties_began_in_school_years),
	  y(other_functional_distress), c(symptoms_duration,six_months_or_more) ]).
% 9-year-old who counts on the fingers and cannot recall number facts, math score 70.
vignette(sld_math,child,
	[ y(difficulties_with_number_sense_or_calculation), y(mathematics_skills_below_age),
	  y(difficulties_persist_despite_interventions), y(learning_difficulties_began_in_school_years),
	  y(other_functional_distress), c(symptoms_duration,six_months_or_more) ]).
% 8-year-old, clumsy, at the 3rd percentile of a motor test, who cannot ride a
% bike or use cutlery like his peers; neurological examination normal.
vignette(dcd_base,child,
	[ y(motor_skills_substantially_below_age), y(clumsy_slow_or_inaccurate_motor_performance),
	  y(motor_deficits_interfere_with_daily_activities), y(onset_in_early_developmental_period) ]).
% 11-year-old with eye blinking, head jerks and throat clearing for two years, from age 7.
vignette(tourette_base,child,
	[ y(multiple_motor_tics), y(motor_tics), y(vocal_tics), y(tics_persisted_more_than_one_year),
	  y(tic_onset_before_age_eighteen) ]).
% 12-year-old with eye blinking only, for three years.
vignette(ptd_motor,child,
	[ y(motor_tics), y(tics_persisted_more_than_one_year), y(tic_onset_before_age_eighteen) ]).
% 13-year-old with sniffing and throat clearing only, for eighteen months.
vignette(ptd_vocal,adolescent,
	[ y(vocal_tics), y(tics_persisted_more_than_one_year), y(tic_onset_before_age_eighteen) ]).
% 6-year-old with eye blinking that began four months ago.
vignette(prov_tic,preschool,
	[ y(motor_tics), y(tic_onset_before_age_eighteen) ]).


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


% Intellectual developmental disorder, by severity
idd_level(intellectual_developmental_disorder_mild,severity_mild,intellectual_developmental_disorder_moderate).
idd_level(intellectual_developmental_disorder_moderate,severity_moderate,intellectual_developmental_disorder_severe).
idd_level(intellectual_developmental_disorder_severe,severity_severe,intellectual_developmental_disorder_profound).
idd_level(intellectual_developmental_disorder_profound,severity_profound,intellectual_developmental_disorder_mild).
idd_level_of(N,L) :- idd_level(N,L,_).

plan(G,typical,'IQ 62 confirmed clinically, adaptive deficits since infancy',[v(idd_base),c(idd_severity,L)],[present(G),top(G)]) :-
	idd_level(G,L,_).
plan(G,subthreshold,'low test score not confirmed by the clinical assessment (A requires both)',[v(idd_base),c(idd_severity,L),-intellectual_deficits_on_clinical_assessment],[absent(G)]) :-
	idd_level(G,L,_).
plan(G,exclusion,'deficits acquired after the developmental period (C): a neurocognitive disorder',[v(idd_base),c(idd_severity,L),-onset_in_early_developmental_period],[absent(G)]) :-
	idd_level(G,L,_).
plan(G,differential,'another severity level',[v(idd_base),c(idd_severity,L2)],[top(N),absent(G)]) :-
	idd_level(G,_,N), idd_level_of(N,L2).

% Language disorder
plan(language_disorder,typical,'5-year-old, small vocabulary and short sentences, well below age',[v(ld_base)],[present(language_disorder),top(language_disorder)]).
plan(language_disorder,subthreshold,'abilities not substantially below age (B)',[v(ld_base),-language_abilities_substantially_below_age],[absent(language_disorder)]).
plan(language_disorder,exclusion,'the difficulties come from a hearing loss (D)',[v(ld_base),y(language_difficulties_attributable_to_sensory_or_medical_condition)],[absent(language_disorder)]).
plan(language_disorder,differential,'intellectual disability explains the language delay (D)',[v(ld_base),v(idd_base),age(preschool),y(language_difficulties_better_explained_by_intellectual_disability)],[top(intellectual_developmental_disorder_mild),absent(language_disorder)]).

% Social (pragmatic) communication disorder
plan(social_pragmatic_communication_disorder,typical,'8-year-old, all 4 pragmatic deficits, no restricted interests',[v(scd_base)],[present(social_pragmatic_communication_disorder),top(social_pragmatic_communication_disorder)]).
plan(social_pragmatic_communication_disorder,subthreshold,'3 of the 4 deficits (A requires all)',[v(scd_base),-difficulty_understanding_nonliteral_language],[absent(social_pragmatic_communication_disorder)]).
plan(social_pragmatic_communication_disorder,exclusion,'deficits from low structural language abilities (D)',[v(scd_base),y(pragmatic_deficits_better_explained_by_other_condition)],[absent(social_pragmatic_communication_disorder)]).
plan(social_pragmatic_communication_disorder,differential,'the same deficits with 2 restricted, repetitive behaviours: autism',[v(scd_base),v(autism_base)],[top(autism_spectrum_disorder),absent(social_pragmatic_communication_disorder)]).

% Autism spectrum disorder
plan(autism_spectrum_disorder,typical,'7-year-old, all 3 social deficits, routines and fixated interests',[v(autism_base)],[present(autism_spectrum_disorder),top(autism_spectrum_disorder)]).
plan(autism_spectrum_disorder,subthreshold,'only 1 restricted, repetitive pattern (B requires 2)',[v(autism_base),-restricted_fixated_interests],[absent(autism_spectrum_disorder)]).
plan(autism_spectrum_disorder,exclusion,'social communication not below the developmental level of an intellectual disability (E)',[v(autism_base),y(autistic_features_better_explained_by_intellectual_disability)],[absent(autism_spectrum_disorder)]).
plan(autism_spectrum_disorder,differential,'pragmatic deficits without restricted, repetitive behaviours',[v(scd_base)],[top(social_pragmatic_communication_disorder),absent(autism_spectrum_disorder)]).

%	asd_spec(Goal,Answers,Neighbour): the intellectual / language specifier pairs.
asd_spec(autism_spectrum_disorder_without_intellectual_or_language_impairment,[],autism_spectrum_disorder_with_language_without_intellectual_impairment).
asd_spec(autism_spectrum_disorder_with_intellectual_without_language_impairment,[y(accompanying_intellectual_impairment)],autism_spectrum_disorder_with_intellectual_and_language_impairment).
asd_spec(autism_spectrum_disorder_with_language_without_intellectual_impairment,[y(accompanying_language_impairment)],autism_spectrum_disorder_without_intellectual_or_language_impairment).
asd_spec(autism_spectrum_disorder_with_intellectual_and_language_impairment,[y(accompanying_intellectual_impairment),y(accompanying_language_impairment)],autism_spectrum_disorder_with_intellectual_without_language_impairment).

plan(G,typical,'autism with the reported intellectual and language profile',[v(autism_base)|A],[present(G),top(G)]) :-
	asd_spec(G,A,_).
plan(G,subthreshold,'only 1 restricted, repetitive pattern (B)',S,[absent(G)]) :-
	asd_spec(G,A,_), append([v(autism_base)|A],[-insistence_on_sameness],S).
plan(G,exclusion,'better explained by intellectual disability (E)',S,[absent(G)]) :-
	asd_spec(G,A,_), append([v(autism_base)|A],[y(autistic_features_better_explained_by_intellectual_disability)],S).
plan(G,differential,'another intellectual / language profile',[v(autism_base)|A2],[top(N),absent(G)]) :-
	asd_spec(G,_,N), asd_spec(N,A2,_).

%	asd_level(Goal,Question,Level,Neighbour): the levels of support.
asd_level(autism_spectrum_disorder_social_communication_level_1,asd_social_communication_support,requiring_support,autism_spectrum_disorder_social_communication_level_2).
asd_level(autism_spectrum_disorder_social_communication_level_2,asd_social_communication_support,requiring_substantial_support,autism_spectrum_disorder_social_communication_level_3).
asd_level(autism_spectrum_disorder_social_communication_level_3,asd_social_communication_support,requiring_very_substantial_support,autism_spectrum_disorder_social_communication_level_1).
asd_level(autism_spectrum_disorder_restricted_behaviour_level_1,asd_restricted_behaviour_support,requiring_support,autism_spectrum_disorder_restricted_behaviour_level_2).
asd_level(autism_spectrum_disorder_restricted_behaviour_level_2,asd_restricted_behaviour_support,requiring_substantial_support,autism_spectrum_disorder_restricted_behaviour_level_3).
asd_level(autism_spectrum_disorder_restricted_behaviour_level_3,asd_restricted_behaviour_support,requiring_very_substantial_support,autism_spectrum_disorder_restricted_behaviour_level_1).

plan(G,typical,'autism with the reported level of support',[v(autism_base),c(Q,L)],[present(G),top(G)]) :-
	asd_level(G,Q,L,_).
plan(G,subthreshold,'2 of the 3 social deficits (A requires all)',[v(autism_base),c(Q,L),-relationship_deficits],[absent(G)]) :-
	asd_level(G,Q,L,_).
plan(G,exclusion,'better explained by intellectual disability (E)',[v(autism_base),c(Q,L),y(autistic_features_better_explained_by_intellectual_disability)],[absent(G)]) :-
	asd_level(G,Q,L,_).
plan(G,differential,'another level of support in the same domain',[v(autism_base),c(Q,L2)],[top(N),absent(G)]) :-
	asd_level(G,Q,_,N), asd_level(N,Q,L2,_).

% ADHD, by presentation
plan(attention_deficit_hyperactivity_disorder_combined_presentation,typical,'9-year-old, 7 inattention and 6 hyperactivity symptoms, home and school',[v(adhd_child)],[present(attention_deficit_hyperactivity_disorder_combined_presentation),top(attention_deficit_hyperactivity_disorder_combined_presentation)]).
plan(attention_deficit_hyperactivity_disorder_combined_presentation,subthreshold,'only 5 hyperactivity symptoms in a child (A2 requires 6)',[v(adhd_child),-talks_excessively],[absent(attention_deficit_hyperactivity_disorder_combined_presentation),present(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation)]).
plan(attention_deficit_hyperactivity_disorder_combined_presentation,exclusion,'the symptoms are better explained by another mental disorder (E)',[v(adhd_child),y(adhd_symptoms_better_explained_by_other_disorder)],[absent(attention_deficit_hyperactivity_disorder_combined_presentation)]).
plan(attention_deficit_hyperactivity_disorder_combined_presentation,differential,'hyperactivity without enough inattention',[v(adhd_hyper_child)],[top(attention_deficit_hyperactivity_disorder_predominantly_hyperactive_impulsive_presentation),absent(attention_deficit_hyperactivity_disorder_combined_presentation)]).
plan(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation,typical,'34-year-old, 5 inattention symptoms (5 suffice from age 17)',[v(adhd_inatt_adult)],[present(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation),top(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation)]).
plan(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation,subthreshold,'adult with 4 inattention symptoms (A1)',[v(adhd_inatt_adult),-forgetful_in_daily_activities],[absent(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation)]).
plan(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation,exclusion,'the inattention occurs only with a substance (E)',[v(adhd_inatt_adult),y(adhd_symptoms_better_explained_by_other_disorder)],[absent(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation)]).
plan(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation,differential,'both domains above threshold: combined',[v(adhd_child)],[top(attention_deficit_hyperactivity_disorder_combined_presentation),absent(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation)]).
plan(attention_deficit_hyperactivity_disorder_predominantly_hyperactive_impulsive_presentation,typical,'7-year-old, 6 hyperactivity symptoms, 1 inattention',[v(adhd_hyper_child)],[present(attention_deficit_hyperactivity_disorder_predominantly_hyperactive_impulsive_presentation),top(attention_deficit_hyperactivity_disorder_predominantly_hyperactive_impulsive_presentation)]).
plan(attention_deficit_hyperactivity_disorder_predominantly_hyperactive_impulsive_presentation,subthreshold,'5 hyperactivity symptoms in a child (A2)',[v(adhd_hyper_child),-blurts_out_answers],[absent(attention_deficit_hyperactivity_disorder_predominantly_hyperactive_impulsive_presentation)]).
plan(attention_deficit_hyperactivity_disorder_predominantly_hyperactive_impulsive_presentation,exclusion,'restlessness only at home: one setting (C)',[v(adhd_hyper_child),-symptoms_in_two_or_more_settings],[absent(attention_deficit_hyperactivity_disorder_predominantly_hyperactive_impulsive_presentation)]).
plan(attention_deficit_hyperactivity_disorder_predominantly_hyperactive_impulsive_presentation,differential,'both domains above threshold: combined',[v(adhd_child)],[top(attention_deficit_hyperactivity_disorder_combined_presentation),absent(attention_deficit_hyperactivity_disorder_predominantly_hyperactive_impulsive_presentation)]).
plan(attention_deficit_hyperactivity_disorder_in_partial_remission,typical,'ADHD in childhood, 3 + 2 symptoms now, still impairing',[v(adhd_remission)],[present(attention_deficit_hyperactivity_disorder_in_partial_remission),top(attention_deficit_hyperactivity_disorder_in_partial_remission)]).
plan(attention_deficit_hyperactivity_disorder_in_partial_remission,subthreshold,'the residual symptoms no longer impair',[v(adhd_remission),-occupational_distress],[absent(attention_deficit_hyperactivity_disorder_in_partial_remission)]).
plan(attention_deficit_hyperactivity_disorder_in_partial_remission,exclusion,'full criteria were never met',[v(adhd_remission),-full_adhd_criteria_previously_met],[absent(attention_deficit_hyperactivity_disorder_in_partial_remission)]).
plan(attention_deficit_hyperactivity_disorder_in_partial_remission,differential,'full criteria met again in the last 6 months',[v(adhd_inatt_adult),y(full_adhd_criteria_previously_met)],[top(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation),absent(attention_deficit_hyperactivity_disorder_in_partial_remission)]).

% ADHD, by severity
adhd_level(attention_deficit_hyperactivity_disorder_mild,severity_mild,attention_deficit_hyperactivity_disorder_moderate).
adhd_level(attention_deficit_hyperactivity_disorder_moderate,severity_moderate,attention_deficit_hyperactivity_disorder_severe).
adhd_level(attention_deficit_hyperactivity_disorder_severe,severity_severe,attention_deficit_hyperactivity_disorder_mild).

plan(G,typical,'combined ADHD of the reported severity',[v(adhd_child),c(adhd_severity,L)],[present(G),top(G)]) :-
	adhd_level(G,L,_).
plan(G,subthreshold,'the symptoms began after age 12 (B)',[v(adhd_child),c(adhd_severity,L),-several_symptoms_before_age_twelve],[absent(G)]) :-
	adhd_level(G,L,_).
plan(G,exclusion,'better explained by another mental disorder (E)',[v(adhd_child),c(adhd_severity,L),y(adhd_symptoms_better_explained_by_other_disorder)],[absent(G)]) :-
	adhd_level(G,L,_).
plan(G,differential,'another severity',[v(adhd_child),c(adhd_severity,L2)],[top(N),absent(G)]) :-
	adhd_level(G,_,N), adhd_level(N,L2,_).

% Specific learning disorder, by domain
sld_domain(specific_learning_disorder_with_impairment_in_reading,sld_reading,specific_learning_disorder_with_impairment_in_mathematics,sld_math).
sld_domain(specific_learning_disorder_with_impairment_in_written_expression,sld_written,specific_learning_disorder_with_impairment_in_reading,sld_reading).
sld_domain(specific_learning_disorder_with_impairment_in_mathematics,sld_math,specific_learning_disorder_with_impairment_in_written_expression,sld_written).

plan(G,typical,'difficulties of the domain, standardized score well below age, despite tutoring',[v(V)],[present(G),top(G)]) :-
	sld_domain(G,V,_,_).
plan(G,subthreshold,'difficulties for only 4 months (A requires 6)',[v(V),c(symptoms_duration,three_to_six_months)],[absent(G)]) :-
	sld_domain(G,V,_,_).
plan(G,exclusion,'inadequate instruction in the language of the school (D)',[v(V),y(learning_difficulties_better_accounted_for_by_other_factors)],[absent(G)]) :-
	sld_domain(G,V,_,_).
plan(G,differential,'another academic domain',[v(V2)],[top(N),absent(G)]) :-
	sld_domain(G,_,N,V2).

% Specific learning disorder, by severity
sld_level(specific_learning_disorder_mild,severity_mild,specific_learning_disorder_moderate).
sld_level(specific_learning_disorder_moderate,severity_moderate,specific_learning_disorder_severe).
sld_level(specific_learning_disorder_severe,severity_severe,specific_learning_disorder_mild).

plan(G,typical,'reading disorder of the reported severity',[v(sld_reading),c(learning_disorder_severity,L)],[present(G),top(G)]) :-
	sld_level(G,L,_).
plan(G,subthreshold,'reading difficulties not below age on testing (B)',[v(sld_reading),c(learning_disorder_severity,L),-reading_skills_below_age],[absent(G)]) :-
	sld_level(G,L,_).
plan(G,exclusion,'the difficulties are those of an intellectual disability (D)',[v(sld_reading),c(learning_disorder_severity,L),y(learning_difficulties_explained_by_intellectual_disability)],[absent(G)]) :-
	sld_level(G,L,_).
plan(G,differential,'another severity',[v(sld_reading),c(learning_disorder_severity,L2)],[top(N),absent(G)]) :-
	sld_level(G,_,N), sld_level(N,L2,_).

% Developmental coordination disorder
plan(developmental_coordination_disorder,typical,'8-year-old, clumsy, 3rd percentile on a motor test',[v(dcd_base)],[present(developmental_coordination_disorder),top(developmental_coordination_disorder)]).
plan(developmental_coordination_disorder,subthreshold,'clumsy but without interference in daily life (B)',[v(dcd_base),-motor_deficits_interfere_with_daily_activities],[absent(developmental_coordination_disorder)]).
plan(developmental_coordination_disorder,exclusion,'cerebral palsy (D)',[v(dcd_base),y(motor_deficits_due_to_neurological_condition)],[absent(developmental_coordination_disorder)]).
plan(developmental_coordination_disorder,differential,'motor delay explained by intellectual disability (D)',[v(dcd_base),v(idd_base),y(motor_deficits_explained_by_intellectual_disability_or_visual_impairment)],[top(intellectual_developmental_disorder_mild),absent(developmental_coordination_disorder)]).

% Tic disorders
plan(tourettes_disorder,typical,'motor and vocal tics for two years, from age 7',[v(tourette_base)],[present(tourettes_disorder),top(tourettes_disorder)]).
plan(tourettes_disorder,subthreshold,'a single motor tic with a vocal tic (A requires multiple motor tics)',[v(tourette_base),-multiple_motor_tics],[absent(tourettes_disorder)]).
plan(tourettes_disorder,exclusion,'tics caused by a stimulant (D)',[v(tourette_base),y(substance_intoxication_or_withdrawal_or_medication_use),y(symptoms_developed_during_or_after_substance_use),y(substance_capable_of_producing_symptoms),y(social_distress)],[absent(tourettes_disorder)]).
plan(tourettes_disorder,differential,'the same tics for less than 1 year: provisional',[v(tourette_base),-tics_persisted_more_than_one_year],[top(provisional_tic_disorder),absent(tourettes_disorder)]).
plan(persistent_tic_disorder_with_motor_tics_only,typical,'eye blinking only, for three years',[v(ptd_motor)],[present(persistent_tic_disorder_with_motor_tics_only),top(persistent_tic_disorder_with_motor_tics_only)]).
plan(persistent_tic_disorder_with_motor_tics_only,subthreshold,'tics that began at age 19 (C)',[v(ptd_motor),age(adult),-tic_onset_before_age_eighteen],[absent(persistent_tic_disorder_with_motor_tics_only)]).
plan(persistent_tic_disorder_with_motor_tics_only,exclusion,'Tourette''s disorder in the past (E)',[v(ptd_motor),y(criteria_ever_met_for_tourettes_disorder)],[absent(persistent_tic_disorder_with_motor_tics_only)]).
plan(persistent_tic_disorder_with_motor_tics_only,differential,'vocal tics only',[v(ptd_vocal)],[top(persistent_tic_disorder_with_vocal_tics_only),absent(persistent_tic_disorder_with_motor_tics_only)]).
plan(persistent_tic_disorder_with_vocal_tics_only,typical,'sniffing and throat clearing for eighteen months',[v(ptd_vocal)],[present(persistent_tic_disorder_with_vocal_tics_only),top(persistent_tic_disorder_with_vocal_tics_only)]).
plan(persistent_tic_disorder_with_vocal_tics_only,subthreshold,'vocal tics for less than 1 year (B)',[v(ptd_vocal),-tics_persisted_more_than_one_year],[absent(persistent_tic_disorder_with_vocal_tics_only)]).
plan(persistent_tic_disorder_with_vocal_tics_only,exclusion,'Tourette''s disorder in the past (E)',[v(ptd_vocal),y(criteria_ever_met_for_tourettes_disorder)],[absent(persistent_tic_disorder_with_vocal_tics_only)]).
plan(persistent_tic_disorder_with_vocal_tics_only,differential,'motor tics only',[v(ptd_motor)],[top(persistent_tic_disorder_with_motor_tics_only),absent(persistent_tic_disorder_with_vocal_tics_only)]).
plan(provisional_tic_disorder,typical,'eye blinking for four months',[v(prov_tic)],[present(provisional_tic_disorder),top(provisional_tic_disorder)]).
plan(provisional_tic_disorder,subthreshold,'tics that began at age 20 (C)',[v(prov_tic),age(adult),-tic_onset_before_age_eighteen],[absent(provisional_tic_disorder)]).
plan(provisional_tic_disorder,exclusion,'a persistent tic disorder in the past (E)',[v(prov_tic),y(criteria_ever_met_for_persistent_tic_disorder)],[absent(provisional_tic_disorder)]).
plan(provisional_tic_disorder,differential,'tics for more than 1 year: persistent',[v(ptd_motor)],[top(persistent_tic_disorder_with_motor_tics_only),absent(provisional_tic_disorder)]).


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

% neurodevelopmental comorbidity and differentials (also across chapters)
extra(adhd_and_asd,comorbidity,'autism with combined ADHD (both diagnosed since DSM-5)',[v(autism_base),v(adhd_child)],[present(autism_spectrum_disorder),present(attention_deficit_hyperactivity_disorder_combined_presentation)]).
extra(asd_not_scd,differential,'pragmatic deficits with autistic social deficits and 2 restricted patterns: autism, not SCD',[v(scd_base),v(autism_base)],[present(autism_spectrum_disorder),absent(social_pragmatic_communication_disorder)]).
extra(scd_not_asd,differential,'pragmatic deficits without restricted patterns: SCD, not autism',[v(scd_base),y(social_emotional_reciprocity_deficits),y(nonverbal_communication_deficits),y(relationship_deficits)],[present(social_pragmatic_communication_disorder),absent(autism_spectrum_disorder)]).
extra(ptsd_not_adhd,differential,'adult with PTSD and inattention that began after the trauma: PTSD, not ADHD (B)',[v(ptsd_adult),y(difficulty_sustaining_attention),y(easily_distracted),y(forgetful_in_daily_activities),y(careless_mistakes),y(difficulty_organizing_tasks),y(symptoms_in_two_or_more_settings),c(symptoms_duration,six_months_or_more)],[present(posttraumatic_stress_disorder),absent(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation)]).
extra(gad_not_adhd,differential,'worried adult, restless and unfocused only through the worry: GAD, not ADHD (E)',[v(gad_adult),y(difficulty_sustaining_attention),y(easily_distracted),y(forgetful_in_daily_activities),y(careless_mistakes),y(difficulty_organizing_tasks),y(several_symptoms_before_age_twelve),y(symptoms_in_two_or_more_settings),y(adhd_symptoms_better_explained_by_other_disorder)],[present(generalized_anxiety_disorder),absent(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation)]).
extra(adhd_and_gad,comorbidity,'adult ADHD since childhood with a separate generalized anxiety',[v(gad_adult),v(adhd_inatt_adult)],[present(generalized_anxiety_disorder),present(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation)]).
extra(sld_not_idd,differential,'reading difficulties with an intellectual disability that accounts for them: IDD, not SLD (D)',[v(idd_base),v(sld_reading),y(learning_difficulties_explained_by_intellectual_disability)],[present(intellectual_developmental_disorder_mild),absent(specific_learning_disorder_with_impairment_in_reading)]).
extra(sld_with_idd,comorbidity,'reading difficulties in excess of a mild intellectual disability: both',[v(idd_base),v(sld_reading)],[present(intellectual_developmental_disorder_mild),present(specific_learning_disorder_with_impairment_in_reading)]).
extra(asd_with_idd,comorbidity,'autism with intellectual disability, social communication below the developmental level',[v(autism_base),v(idd_base),y(accompanying_intellectual_impairment)],[present(intellectual_developmental_disorder_mild),present(autism_spectrum_disorder_with_intellectual_without_language_impairment)]).
extra(tourette_not_persistent,differential,'motor and vocal tics: Tourette''s, neither persistent specifier',[v(tourette_base)],[present(tourettes_disorder),absent(persistent_tic_disorder_with_motor_tics_only),absent(persistent_tic_disorder_with_vocal_tics_only)]).

% neurodevelopmental age rules
extra(adhd_five_symptoms_child,age_rule,'child with 5 inattention symptoms (A1 requires 6 under age 17)',[v(adhd_inatt_adult),age(child)],[absent(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation)]).
extra(adhd_five_symptoms_at_17,age_rule,'17-year-old with 5 inattention symptoms (5 suffice from age 17)',[v(adhd_inatt_adult),age(adolescent),value(age_years,17)],[present(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation)]).
extra(adhd_five_symptoms_at_16,age_rule,'16-year-old with the same 5 symptoms',[v(adhd_inatt_adult),age(adolescent),value(age_years,16)],[absent(attention_deficit_hyperactivity_disorder_predominantly_inattentive_presentation)]).
extra(sld_adult_history,age_rule,'adult without a recent test but with a documented history (B, from age 17)',[v(sld_reading),age(adult),-reading_skills_below_age,y(documented_history_of_impairing_learning_difficulties)],[present(specific_learning_disorder_with_impairment_in_reading)]).
extra(sld_child_history,age_rule,'child with a documented history but no standardized test (B)',[v(sld_reading),-reading_skills_below_age,y(documented_history_of_impairing_learning_difficulties)],[absent(specific_learning_disorder_with_impairment_in_reading)]).

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
	% under Lukasiewicz the doubts of the premises add up and the conjunction falls to 0
	[when([cf,fuzzy,fuzzy_membership,hamacher,einstein],ranks_first(posttraumatic_stress_disorder)),
	 when([lukasiewicz],absent(posttraumatic_stress_disorder))]).
extra(borderline_phobia,uncertainty,'spider phobia for 5 months: only the graded duration still supports it',
	[v(sp_base),y(fear_of_animals),c(symptoms_duration,three_to_six_months),value(duration_months,5)],
	[when([cf,fuzzy],absent(specific_phobia_animal_type)),when([fuzzy_membership],top(specific_phobia_animal_type))]).
extra(no_diagnosis,uncertainty,'mild non-specific work stress only',[y(occupational_distress,0.5)],[none]).


%------------------------------BOUNDARY CASES-----------------------------------
%	boundary(Criterion, Goal, Vignette, Items, M): an "at least M of Items"
%	criterion of Goal, tested at its threshold. Two cases each: the vignette
%	with exactly the first M items (Goal present) and with the first M-1
%	(Goal absent); the other items of the criterion are answered no. The
%	first items are chosen so that no other criterion of Goal depends on them.
boundary(panic_attack,panic_disorder,panic_adult,
	[palpitations,sweating,trembling,dyspnea,choking,chest_pain,nausea,lightheadedness,chills_or_hot_flushes,paresthesias,derealization_or_depersonalization,fear_of_losing_control,fear_of_dying],4).
boundary(panic_consequences_concern,panic_disorder,panic_adult,
	[worry_about_new_panic_attacks,worry_about_panic_consequences,maladaptive_behaviour_change_due_to_panic],1).
boundary(excessive_separation_fear,separation_anxiety_disorder,sad_child,
	[distress_at_separation_from_attachment_figures,worry_about_losing_attachment_figures,worry_an_event_causes_separation,reluctance_to_go_out_due_to_separation,fear_of_being_alone,reluctance_to_sleep_away_from_attachment_figures,nightmares_about_separation,physical_symptoms_on_separation],3).
boundary(specific_phobic_anxiety,specific_phobia_animal_type,sp_animal,
	[marked_fear_of_specific_object_or_situation,fear_almost_always_provoked,fear_out_of_proportion_to_actual_danger],3).
boundary(social_phobic_anxiety_child,social_anxiety_disorder,social_child,
	[marked_fear_of_social_scrutiny,fear_of_negative_evaluation,fear_almost_always_provoked,fear_out_of_proportion_to_actual_danger],4).
boundary(social_phobic_anxiety_adult,social_anxiety_disorder,social_adult,
	[marked_fear_of_social_scrutiny,fear_of_negative_evaluation,fear_almost_always_provoked,fear_out_of_proportion_to_actual_danger],4).
boundary(agoraphobic_situations,agoraphobia,agora_adult,
	[fear_of_public_transport,fear_of_open_spaces,fear_of_enclosed_places,fear_of_queues_or_crowds,fear_of_being_outside_home_alone],2).
boundary(agoraphobic_fear,agoraphobia,agora_adult,
	[fear_almost_always_provoked,fear_out_of_proportion_to_actual_danger],2).
boundary(repetitive_appearance_behaviours,body_dysmorphic_disorder_with_good_or_fair_insight,bdd_base,
	[mirror_checking,excessive_grooming,skin_picking_for_appearance,reassurance_seeking,comparing_appearance_with_others],1).
boundary(inhibited_attachment_behaviour,reactive_attachment_disorder,rad_base,
	[rarely_seeks_comfort_when_distressed,rarely_responds_to_comfort_when_distressed],2).
boundary(disinhibited_behaviour_with_strangers,disinhibited_social_engagement_disorder,dsed_base,
	[reduced_reticence_with_unfamiliar_adults,overly_familiar_behaviour,does_not_check_back_with_caregiver,willing_to_go_off_with_strangers],2).
boundary(arousal_alterations,posttraumatic_stress_disorder,ptsd_adult,
	[hypervigilance,exaggerated_startle_response,irritability_or_aggression,reckless_or_self_destructive_behaviour,difficulty_concentrating,sleep_disturbance],2).
boundary(preschool_arousal_alterations,posttraumatic_stress_disorder,ptsd_preschool,
	[hypervigilance,exaggerated_startle_response,irritability_or_aggression,difficulty_concentrating,sleep_disturbance],2).
boundary(adjustment_clinical_significance,adjustment_disorder_unspecified,adj_base,
	[distress_out_of_proportion_to_stressor,occupational_distress,social_distress,other_functional_distress],1).
boundary(grief_associated_symptoms,prolonged_grief_disorder,pgd_adult,
	[identity_disruption_since_death,disbelief_about_the_death,avoidance_of_reminders_of_death,intense_emotional_pain,difficulty_reintegrating,emotional_numbness,feeling_life_is_meaningless,intense_loneliness],3).
boundary(language_acquisition_deficits,language_disorder,ld_base,
	[reduced_vocabulary,limited_sentence_structure,impaired_discourse],1).
boundary(motor_coordination_deficits,developmental_coordination_disorder,dcd_base,
	[motor_skills_substantially_below_age,clumsy_slow_or_inaccurate_motor_performance],2).

vignette(sp_animal,Age,Answers) :-
	vignette(sp_base,Age,Answers0),
	append(Answers0,[y(fear_of_animals)],Answers).

extra(Id,boundary,D,Spec,[Expectation]) :-
	boundary(Criterion,Goal,V,Items,M),
	M1 is M-1,
	member(K-Where-Expectation,[M-at-present(Goal),M1-below-absent(Goal)]),
	atomic_list_concat([Criterion,'_',Where],Id),
	format(atom(D),'~w with ~w of its items (threshold ~w)',[Criterion,K,M]),
	length(Kept,K),
	append(Kept,_,Items),
	findall(-I,member(I,Items),Removed),
	findall(y(I),member(I,Kept),Added),
	append([[v(V)],Removed,Added],Spec).

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

methods([cf,fuzzy,fuzzy_membership,lukasiewicz,hamacher,einstein]).

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


%----------------------------EVALUATION FROM FACTS------------------------------
% Prisma-specific evaluation_case/4 facts (test-result cases) live in the
% private PrismaMD repository and are loaded via PESAD_EXTRA_RULES.

run_evaluation(Method,Request,Response) :-
	put_dict(_{lang:en, backend:Method},Request,Request1),
	catch(evaluate(Request1,Response),evaluation_error(Index,Message),Response = error(Index,Message)).

check_evaluation(error(I,_),error(I)) :- !.
check_evaluation(error(_,_),_) :- !, fail.
check_evaluation(R,status(G,S)) :- !,
	member(X,R.goals), X.id == G, !, X.status == S.
check_evaluation(R,criterion(G,C,S)) :- !,
	member(X,R.goals), X.id == G, !,
	member(Y,X.criteria), Y.id == C, !, Y.status == S.
check_evaluation(R,missing(G,I)) :- !,
	member(X,R.goals), X.id == G, !,
	member(Y,X.missing), Y.id == I, !.

report_evaluation_failure(M,Id,D,E,R) :-
	format('~n[FAIL] (~w) ~w: ~w~n      expected: ~w~n',[M,Id,D,E]),
	(   R = error(I,Msg)
	->  format('      error ~w: ~w~n',[I,Msg])
	;   forall(( member(X,R.goals), member(Exp,E), arg(1,Exp,G), X.id == G ),
		format('      ~w: ~w [~w, ~w]~n',[X.id,X.status,X.certainty,X.upper])) ).

run_evaluations :-
	methods(Methods),
	forall(( evaluation_case(Id,D,Request,E), member(M,Methods) ),
		( run_evaluation(M,Request,R),
		  ( forall(member(X,E), check_evaluation(R,X)) -> Res = pass ; Res = fail, report_evaluation_failure(M,Id,D,E,R) ),
		  assertz(result(Id,none-evaluate,M,Res)) )).


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
	findall(K,( member(K,Goals) ; member(K,Items) ), Keys0),
	findall(N,( member(P,[symptomatic_manifestation,symptomatic_feature,disorder_nc]), H =.. [P,N,_,_,_], clause(H,_), atom(N) ),Nodes),
	findall(Q,choice_question(Q,_),Questions),
	findall(O,( choice_question(_,Os), member(O,Os) ),Options),
	append([Keys0,Nodes,Questions,Options,[inattention_symptom_count,hyperactivity_impulsivity_symptom_count,missing_label]],Keys),
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
	methods(Ms),
	atomic_list_concat(Ms,' | ',Header),
	format('~n| other case | type | ~w |~n',[Header]),
	length(Ms,N),
	length(Dashes,N),
	maplist(=('---'),Dashes),
	atomic_list_concat(Dashes,' | ',Rule),
	format('| --- | --- | ~w |~n',[Rule]),
	forall(( extra(Id,T,_,_,_) ; evaluation_case(Id,_,_,_), T = evaluate ),
		( findall(R,( member(M,Ms), result(Id,none-T,M,R) ),Rs),
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
	run_evaluations,
	report_table,
	format('~n================================================================~n'),
	summary(Failed),
	length(Errors,NE),
	format('  consistency errors: ~w~n',[NE]),
	format('================================================================~n'),
	( Failed =:= 0, NE =:= 0 -> halt(0) ; halt(1) ).

:- initialization(run_tests).
