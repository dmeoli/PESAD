%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		criteria.pl
%
%	description:
%		Knowledge base - diagnostic criteria (DSM-5-TR). Sub-disorders
%		(disorder_nc/4), disorder types/specifiers, symptomatic manifestations
%		and features, and the question wrappers that elicit symptoms from the
%		user. Covers the Anxiety, Obsessive-Compulsive and Related, and
%		Trauma- and Stressor-Related chapters. Each lettered criterion is
%		referred to in the comments by its letter; the wording is our own
%		paraphrase (see doc/criteria_sheet_*.md).
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%	unless_absent(Antecedent_CFs,Goal,CFs):
%		calls Goal (which binds the certainties CFs) only when none of the
%		certainties already computed for the rule is zero; otherwise the rule
%		cannot hold anyway, so CFs are set to 0 without asking the user the
%		exclusion or specifier questions of a disorder that is absent.
unless_absent(Antecedent_CFs,_,CFs) :-
	member(CF,Antecedent_CFs),
	CF =:= 0,
	!,
	maplist(=(0.0),CFs).
unless_absent(_,Goal,_) :-
	call(Goal).


%-----------------------SHARED MANIFESTATIONS / FEATURES------------------------

%	Panic attack: an abrupt surge of intense fear/discomfort with >= 4 of 13 symptoms (DSM-5-TR).
symptomatic_manifestation(panic_attack,_,CF,TV) :-
	symptom([abrupt_surge_of_fear_or_discomfort],1,CF1),
	symptom([palpitations,sweating,trembling,dyspnea,choking,chest_pain,nausea,lightheadedness,chills_or_hot_flushes,paresthesias,derealization_or_depersonalization,fear_of_losing_control,fear_of_dying],4,CF2),
	certainty(panic_attack,3,[CF1,CF2],0.98,CF,TV).

%	Clinically significant distress or functional impairment (a criterion shared by almost every disorder).
symptomatic_manifestation(significant_distress,_,CF,TV) :-
	symptom([occupational_distress,social_distress,other_functional_distress],1,CF1),
	certainty(significant_distress,3,[CF1],0.97,CF,TV).

%	Substance/medication etiology (Criterion B for the induced disorders):
%	(1) the symptoms developed during or soon after intoxication, withdrawal or medication exposure, and
%	(2) the involved substance/medication is capable of producing those symptoms.
symptomatic_feature(substance_etiology,_,CF,TV) :-
	symptom([substance_intoxication_or_withdrawal_or_medication_use],1,CF1),
	etiological_evidence([symptoms_developed_during_or_after_substance_use],1,CF2),
	symptom([substance_capable_of_producing_symptoms],1,CF3),
	certainty(substance_etiology,3,[CF1,CF2,CF3],0.92,CF,TV).

%	Medical-condition etiology (Criterion B): the disturbance is the direct
%	pathophysiological consequence of another medical condition.
symptomatic_feature(medical_etiology,_,CF,TV) :-
	symptom([another_medical_condition],1,CF1),
	etiological_evidence([disturbance_is_direct_consequence_of_medical_condition],1,CF2),
	certainty(medical_etiology,3,[CF1,CF2],0.92,CF,TV).

%	Criterion D of the induced/medical disorders: the disturbance does not occur
%	exclusively during the course of a delirium.
symptomatic_feature(not_delirium_bound,_,CF,TV) :-
	symptom([not_exclusively_during_delirium],1,CF1),
	certainty(not_delirium_bound,3,[CF1],1.0,CF,TV).

%	Age gate of the attachment disorders, whose criteria refer to a child:
%	true for every age group but adults (no question is asked).
symptomatic_feature(child_patient,Patient,CF,TV) :-
	( Patient == adult -> CF1 = 0.0 ; CF1 = 1.0 ),
	certainty(child_patient,3,[CF1],1.0,CF,TV).

%	Criterion A presentations of the induced/medical disorders.
%	Anxiety presentation: panic attacks or anxiety predominate.
symptomatic_manifestation(predominant_anxiety,_,CF,TV) :-
	symptom([abrupt_surge_of_fear_or_discomfort,excessive_worry_about_several_events],1,CF1),
	certainty(predominant_anxiety,3,[CF1],0.97,CF,TV).

%	Obsessive-compulsive presentation: obsessions, compulsions, appearance
%	preoccupations, hoarding or body-focused repetitive behaviours predominate.
symptomatic_manifestation(predominant_oc_presentation,_,CF,TV) :-
	symptom([recurrent_intrusive_unwanted_thoughts,repetitive_behaviours_or_mental_acts,preoccupation_with_perceived_appearance_defects,difficulty_discarding_possessions,recurrent_pulling_out_of_hair,recurrent_skin_picking_causing_lesions],1,CF1),
	certainty(predominant_oc_presentation,3,[CF1],0.97,CF,TV).

%	Associated alteration that is substance-induced (used as an exclusion in primary disorders).
disorder_nc(associated_substance_induced_alteration,Patient,CF,TV) :-
	symptomatic_feature(substance_etiology,Patient,CF1,true),
	symptomatic_manifestation(significant_distress,Patient,CF2,true),
	certainty(associated_substance_induced_alteration,2,[CF1,CF2],0.95,CF,TV).

%	Associated alteration due to another medical condition (used as an exclusion in primary disorders).
disorder_nc(associated_general_medical_condition,Patient,CF,TV) :-
	symptomatic_feature(medical_etiology,Patient,CF1,true),
	symptomatic_manifestation(significant_distress,Patient,CF2,true),
	certainty(associated_general_medical_condition,2,[CF1,CF2],0.95,CF,TV).

%	Single-question criteria: each one is answered by one question about the
%	item with the same name. Most are the "not better explained by another
%	mental disorder" exclusions, used with truth value false; the others are
%	single-item criteria and the yes/no specifiers, used with truth value true.
symptomatic_feature(Item,_,CF,TV) :-
	single_item_criterion(Item),
	symptom([Item],1,CF1),
	certainty(Item,3,[CF1],1.0,CF,TV).

%	Exclusions ("better explained by", "attributable to"), required false.
single_item_criterion(separation_fear_better_explained_by_other_disorder).	% SAD D
single_item_criterion(failure_to_speak_due_to_language_knowledge).		% SM D
single_item_criterion(mutism_better_explained_by_other_disorder).		% SM E
single_item_criterion(phobia_better_explained_by_other_disorder).		% SP G
single_item_criterion(social_fear_better_explained_by_other_disorder).	% SAD I
single_item_criterion(fear_accounted_for_by_medical_condition).		% SocAD J, Agoraphobia H
single_item_criterion(panic_better_explained_by_other_disorder).		% PD D
single_item_criterion(agoraphobia_better_explained_by_other_disorder).	% Agoraphobia I
single_item_criterion(worry_better_explained_by_other_disorder).		% GAD F
single_item_criterion(independent_disorder_evidence).			% induced disorders C
single_item_criterion(disturbance_better_explained_by_other_mental_disorder).	% due-to-AMC C
single_item_criterion(oc_symptoms_better_explained_by_other_disorder).	% OCD D
single_item_criterion(appearance_concern_better_explained_by_eating_disorder).	% BDD D
single_item_criterion(hoarding_better_explained_by_other_disorder).	% HD F
single_item_criterion(hair_pulling_better_explained_by_other_disorder).	% TTM E
single_item_criterion(skin_picking_better_explained_by_other_disorder).	% excoriation E
single_item_criterion(criteria_met_for_autism_spectrum_disorder).	% RAD E
single_item_criterion(better_explained_by_brief_psychotic_disorder).	% ASD E
single_item_criterion(stress_reaction_meets_criteria_for_another_disorder).	% AjD C
single_item_criterion(symptoms_represent_normal_bereavement).		% AjD D
single_item_criterion(symptoms_persist_beyond_six_months_after_stressor_ends).	% AjD E
single_item_criterion(grief_better_explained_by_other_disorder).	% PGD F
%	Single-item criteria, required true.
single_item_criterion(worry_more_days_than_not).			% GAD A
single_item_criterion(anxiety_occurs_in_peer_settings).		% SocAD A, note for children
single_item_criterion(care_presumed_responsible_for_disturbance).	% RAD D, DSED D
single_item_criterion(disturbance_evident_before_age_five).		% RAD F
single_item_criterion(developmental_age_at_least_nine_months).	% RAD G, DSED E
single_item_criterion(behaviour_not_limited_to_impulsivity).		% DSED B
single_item_criterion(grief_symptoms_nearly_every_day_last_month).	% PGD B, C
single_item_criterion(bereavement_reaction_exceeds_cultural_norms).	% PGD E
%	Yes/no specifiers, required true.
single_item_criterion(fear_restricted_to_public_performance).	% SocAD, performance only
single_item_criterion(history_of_tic_disorder).			% OCD, tic-related
single_item_criterion(preoccupied_with_insufficient_muscularity).	% BDD, with muscle dysmorphia
single_item_criterion(excessive_acquisition_of_unneeded_items).	% HD, with excessive acquisition
single_item_criterion(disorder_present_more_than_twelve_months).	% RAD/DSED, persistent
single_item_criterion(all_symptoms_at_relatively_high_levels).	% RAD/DSED, severe
single_item_criterion(full_criteria_not_met_until_six_months_after_event).	% PTSD, with delayed expression


%===============================ANXIETY DISORDERS===============================

%-------------------------Separation Anxiety Disorder---------------------------
disorder_nc(separation_anxiety_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(excessive_separation_fear,Patient,CF1,true),
	symptomatic_feature(separation_anxiety_duration,Patient,CF2,true),
	symptomatic_manifestation(significant_distress,Patient,CF3,true),
	unless_absent([CF1,CF2,CF3],
		symptomatic_feature(separation_fear_better_explained_by_other_disorder,Patient,CF4,false),[CF4]),
	certainty(separation_anxiety_disorder,2,[CF1,CF2,CF3,CF4],0.97,CF,TV).

%	Criterion A: >= 3 of 8 developmentally inappropriate separation-fear manifestations.
symptomatic_manifestation(excessive_separation_fear,_,CF,TV) :-
	symptom([distress_at_separation_from_attachment_figures,worry_about_losing_attachment_figures,worry_an_event_causes_separation,reluctance_to_go_out_due_to_separation,fear_of_being_alone,reluctance_to_sleep_away_from_attachment_figures,nightmares_about_separation,physical_symptoms_on_separation],3,CF1),
	certainty(excessive_separation_fear,3,[CF1],0.98,CF,TV).

%	Criterion B: >= 4 weeks in children/adolescents, typically >= 6 months in adults.
symptomatic_feature(separation_anxiety_duration,adult,CF,TV) :-
	!,
	symptoms_duration([six_months_or_more],CF1),
	certainty(separation_anxiety_duration,3,[CF1],1.0,CF,TV).
symptomatic_feature(separation_anxiety_duration,_,CF,TV) :-
	symptoms_duration([one_to_three_months,three_to_six_months,six_months_or_more],CF1),
	certainty(separation_anxiety_duration,3,[CF1],1.0,CF,TV).

%-------------------------------Selective Mutism--------------------------------
%	A (failure to speak despite speaking elsewhere), B (interference),
%	C (>= 1 month), D (not due to the spoken language), E (not better explained).
disorder_nc(selective_mutism,Patient,CF,TV) :-
	symptomatic_manifestation(consistent_failure_to_speak,Patient,CF1,true),
	symptomatic_manifestation(significant_distress,Patient,CF2,true),
	symptomatic_feature(duration_at_least_one_month,Patient,CF3,true),
	unless_absent([CF1,CF2,CF3],
		( symptomatic_feature(failure_to_speak_due_to_language_knowledge,Patient,CF4,false),
		  symptomatic_feature(mutism_better_explained_by_other_disorder,Patient,CF5,false) ),[CF4,CF5]),
	certainty(selective_mutism,2,[CF1,CF2,CF3,CF4,CF5],0.97,CF,TV).

symptomatic_manifestation(consistent_failure_to_speak,_,CF,TV) :-
	symptom([failure_to_speak_in_specific_social_situations],1,CF1),
	symptom([speaks_in_other_situations],1,CF2),
	certainty(consistent_failure_to_speak,3,[CF1,CF2],0.98,CF,TV).

%-------------------------------Specific Phobia---------------------------------
%	A, B, D (phobic anxiety), C (avoidance), E (>= 6 months), F (distress),
%	G (not better explained by another mental disorder).
disorder_nc(specific_phobia,Patient,CF,TV) :-
	symptomatic_manifestation(specific_phobic_anxiety,Patient,CF1,true),
	symptomatic_manifestation(phobic_avoidance,Patient,CF2,true),
	symptomatic_feature(duration_at_least_six_months,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	unless_absent([CF1,CF2,CF3,CF4],
		symptomatic_feature(phobia_better_explained_by_other_disorder,Patient,CF5,false),[CF5]),
	certainty(specific_phobia,2,[CF1,CF2,CF3,CF4,CF5],0.98,CF,TV).

%	Marked fear/anxiety about a specific object or situation (A), almost always
%	provoked (B), out of proportion to actual danger (D).
symptomatic_manifestation(specific_phobic_anxiety,_,CF,TV) :-
	symptom([marked_fear_of_specific_object_or_situation,fear_almost_always_provoked,fear_out_of_proportion_to_actual_danger],3,CF1),
	certainty(specific_phobic_anxiety,3,[CF1],0.98,CF,TV).

%	Avoided or endured with intense fear (specific phobia C, social anxiety D).
symptomatic_manifestation(phobic_avoidance,_,CF,TV) :-
	phobic_reaction_type([avoidance,endurance_with_distress],CF1),
	certainty(phobic_avoidance,3,[CF1],0.99,CF,TV).

%	Specific phobia stimulus types (separately coded specifiers).
specific_phobia_type(animal_type,_,CF,TV) :-
	symptom([fear_of_animals],1,CF1),
	certainty(animal_type,2,[CF1],0.99,CF,TV).
specific_phobia_type(natural_environment_type,_,CF,TV) :-
	symptom([fear_of_natural_environment],1,CF1),
	certainty(natural_environment_type,2,[CF1],0.99,CF,TV).
specific_phobia_type(blood_injection_injury_type,_,CF,TV) :-
	symptom([fear_of_blood_injection_injury],1,CF1),
	certainty(blood_injection_injury_type,2,[CF1],0.99,CF,TV).
specific_phobia_type(situational_type,_,CF,TV) :-
	symptom([fear_of_situations],1,CF1),
	certainty(situational_type,2,[CF1],0.99,CF,TV).
specific_phobia_type(other_type,_,CF,TV) :-
	symptom([fear_of_other_stimuli],1,CF1),
	certainty(other_type,2,[CF1],0.99,CF,TV).

%---------------------------Social Anxiety Disorder-----------------------------
%	A, B, C, E (social anxiety), D (avoidance), F (>= 6 months), G (distress),
%	I (not better explained), J (not accounted for by a medical condition);
%	H (substance/medical) is applied in disorders.pl.
disorder_nc(social_anxiety_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(social_phobic_anxiety,Patient,CF1,true),
	symptomatic_manifestation(phobic_avoidance,Patient,CF2,true),
	symptomatic_feature(duration_at_least_six_months,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	unless_absent([CF1,CF2,CF3,CF4],
		( symptomatic_feature(social_fear_better_explained_by_other_disorder,Patient,CF5,false),
		  symptomatic_feature(fear_accounted_for_by_medical_condition,Patient,CF6,false) ),[CF5,CF6]),
	certainty(social_anxiety_disorder,2,[CF1,CF2,CF3,CF4,CF5,CF6],0.98,CF,TV).

%	Marked fear of social situations involving possible scrutiny, with fear of
%	negative evaluation; in children it must also occur in peer settings.
symptomatic_manifestation(social_phobic_anxiety,Patient,CF,TV) :-
	memberchk(Patient,[preschool,child]),
	!,
	symptom([marked_fear_of_social_scrutiny,fear_of_negative_evaluation,fear_almost_always_provoked,fear_out_of_proportion_to_actual_danger],4,CF1),
	symptomatic_feature(anxiety_occurs_in_peer_settings,Patient,CF2,true),
	certainty(social_phobic_anxiety,3,[CF1,CF2],0.98,CF,TV).
symptomatic_manifestation(social_phobic_anxiety,_,CF,TV) :-
	symptom([marked_fear_of_social_scrutiny,fear_of_negative_evaluation,fear_almost_always_provoked,fear_out_of_proportion_to_actual_danger],4,CF1),
	certainty(social_phobic_anxiety,3,[CF1],0.98,CF,TV).

%--------------------------------Panic Disorder---------------------------------
%	A (recurrent unexpected attacks), B (>= 1 month of concern or behaviour
%	change), D (not better explained); C (substance/medical) in disorders.pl.
disorder_nc(panic_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(recurrent_unexpected_panic_attacks,Patient,CF1,true),
	symptomatic_manifestation(panic_consequences_concern,Patient,CF2,true),
	symptomatic_feature(duration_at_least_one_month,Patient,CF3,true),
	unless_absent([CF1,CF2,CF3],
		symptomatic_feature(panic_better_explained_by_other_disorder,Patient,CF4,false),[CF4]),
	certainty(panic_disorder,2,[CF1,CF2,CF3,CF4],0.97,CF,TV).

symptomatic_manifestation(recurrent_unexpected_panic_attacks,Patient,CF,TV) :-
	symptomatic_manifestation(panic_attack,Patient,CF1,true),
	panic_attacks_frequency([two_to_five,more_than_five],CF2),
	attack_type([unexpected_attack],CF3),
	certainty(recurrent_unexpected_panic_attacks,3,[CF1,CF2,CF3],0.98,CF,TV).

%	Criterion B: >= 1 month of worry about further attacks and/or maladaptive change of behaviour.
symptomatic_manifestation(panic_consequences_concern,_,CF,TV) :-
	symptom([worry_about_new_panic_attacks,worry_about_panic_consequences,maladaptive_behaviour_change_due_to_panic],1,CF1),
	certainty(panic_consequences_concern,3,[CF1],0.98,CF,TV).

%---------------------------------Agoraphobia-----------------------------------
%	A, B, C, E (agoraphobic anxiety), D (avoidance, companion or endurance),
%	F (>= 6 months), G (distress), H (excessive for a medical condition),
%	I (not better explained by another mental disorder).
disorder_nc(agoraphobia,Patient,CF,TV) :-
	symptomatic_manifestation(agoraphobic_anxiety,Patient,CF1,true),
	symptomatic_manifestation(agoraphobic_avoidance,Patient,CF2,true),
	symptomatic_feature(duration_at_least_six_months,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	unless_absent([CF1,CF2,CF3,CF4],
		( symptomatic_feature(fear_accounted_for_by_medical_condition,Patient,CF5,false),
		  symptomatic_feature(agoraphobia_better_explained_by_other_disorder,Patient,CF6,false) ),[CF5,CF6]),
	certainty(agoraphobia,2,[CF1,CF2,CF3,CF4,CF5,CF6],0.98,CF,TV).

%	Criterion A: marked fear of >= 2 of 5 agoraphobic situations; B: fear of not
%	escaping or not getting help; C: almost always provoked; E: out of proportion.
symptomatic_manifestation(agoraphobic_anxiety,_,CF,TV) :-
	symptom([fear_of_public_transport,fear_of_open_spaces,fear_of_enclosed_places,fear_of_queues_or_crowds,fear_of_being_outside_home_alone],2,CF1),
	anxiety_type([difficulty_escaping_or_help_unavailable],CF2),
	symptom([fear_almost_always_provoked,fear_out_of_proportion_to_actual_danger],2,CF3),
	certainty(agoraphobic_anxiety,3,[CF1,CF2,CF3],0.98,CF,TV).

%	Criterion D: actively avoided, require a companion, or endured with intense fear.
symptomatic_manifestation(agoraphobic_avoidance,_,CF,TV) :-
	phobic_reaction_type([avoidance,requires_companion,endurance_with_distress],CF1),
	certainty(agoraphobic_avoidance,3,[CF1],0.99,CF,TV).

%-------------------------Generalized Anxiety Disorder--------------------------
%	A, B (worry), C (associated symptoms), A (>= 6 months), D (distress),
%	F (not better explained); E (substance/medical) in disorders.pl.
disorder_nc(generalized_anxiety_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(excessive_uncontrollable_worry,Patient,CF1,true),
	symptomatic_manifestation(generalized_anxiety_symptoms,Patient,CF2,true),
	symptomatic_feature(duration_at_least_six_months,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	unless_absent([CF1,CF2,CF3,CF4],
		symptomatic_feature(worry_better_explained_by_other_disorder,Patient,CF5,false),[CF5]),
	certainty(generalized_anxiety_disorder,2,[CF1,CF2,CF3,CF4,CF5],0.97,CF,TV).

%	Criteria A and B: excessive worry about a number of events, more days than
%	not, which the individual finds difficult to control.
symptomatic_manifestation(excessive_uncontrollable_worry,Patient,CF,TV) :-
	symptom([excessive_worry_about_several_events],1,CF1),
	symptomatic_feature(worry_more_days_than_not,Patient,CF2,true),
	symptom([difficulty_controlling_worry],1,CF3),
	certainty(excessive_uncontrollable_worry,3,[CF1,CF2,CF3],0.98,CF,TV).

%	Criterion C: >= 3 of 6 symptoms (only 1 required in children).
symptomatic_manifestation(generalized_anxiety_symptoms,Patient,CF,TV) :-
	memberchk(Patient,[preschool,child]),
	!,
	symptom([restlessness,being_easily_fatigued,difficulty_concentrating,irritability,muscle_tension,sleep_disturbance],1,CF1),
	certainty(generalized_anxiety_symptoms,3,[CF1],0.98,CF,TV).
symptomatic_manifestation(generalized_anxiety_symptoms,_,CF,TV) :-
	symptom([restlessness,being_easily_fatigued,difficulty_concentrating,irritability,muscle_tension,sleep_disturbance],3,CF1),
	certainty(generalized_anxiety_symptoms,3,[CF1],0.98,CF,TV).

%------------------Substance/Medication-Induced Anxiety Disorder----------------
%	A (anxiety predominates), B (substance etiology), C (no evidence of an
%	independent disorder), D (not only during delirium), E (distress).
disorder_nc(substance_induced_anxiety_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(predominant_anxiety,Patient,CF1,true),
	symptomatic_feature(substance_etiology,Patient,CF2,true),
	symptomatic_feature(not_delirium_bound,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	unless_absent([CF1,CF2,CF3,CF4],
		symptomatic_feature(independent_disorder_evidence,Patient,CF5,false),[CF5]),
	certainty(substance_induced_anxiety_disorder,2,[CF1,CF2,CF3,CF4,CF5],0.90,CF,TV).

%---------------Anxiety Disorder Due to Another Medical Condition---------------
%	A, B (medical etiology), C (not better explained), D (not only during
%	delirium), E (distress).
disorder_nc(anxiety_disorder_due_to_another_medical_condition,Patient,CF,TV) :-
	symptomatic_manifestation(predominant_anxiety,Patient,CF1,true),
	symptomatic_feature(medical_etiology,Patient,CF2,true),
	symptomatic_feature(not_delirium_bound,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	unless_absent([CF1,CF2,CF3,CF4],
		symptomatic_feature(disturbance_better_explained_by_other_mental_disorder,Patient,CF5,false),[CF5]),
	certainty(anxiety_disorder_due_to_another_medical_condition,2,[CF1,CF2,CF3,CF4,CF5],0.90,CF,TV).


%==================OBSESSIVE-COMPULSIVE AND RELATED DISORDERS===================

%------------------------Obsessive-Compulsive Disorder--------------------------
%	A (obsessions, compulsions or both), B (time-consuming or distressing),
%	D (not better explained); C (substance/medical) in disorders.pl.
disorder_nc(obsessive_compulsive_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(obsessions_or_compulsions,Patient,CF1,true),
	symptomatic_feature(time_consuming_or_distressing,Patient,CF2,true),
	unless_absent([CF1,CF2],
		symptomatic_feature(oc_symptoms_better_explained_by_other_disorder,Patient,CF3,false),[CF3]),
	certainty(obsessive_compulsive_disorder,2,[CF1,CF2,CF3],0.97,CF,TV).

%	Criterion A: obsessions or compulsions, whichever is more certain.
symptomatic_manifestation(obsessions_or_compulsions,Patient,CF,TV) :-
	symptomatic_manifestation(obsessions,Patient,CF1,true),
	symptomatic_manifestation(compulsions,Patient,CF2,true),
	CF3 is max(CF1,CF2),
	certainty(obsessions_or_compulsions,3,[CF3],0.99,CF,TV).

%	Obsessions: (1) recurrent intrusive unwanted thoughts, urges or images and
%	(2) attempts to ignore, suppress or neutralize them.
symptomatic_manifestation(obsessions,_,CF,TV) :-
	symptom([recurrent_intrusive_unwanted_thoughts,attempts_to_ignore_or_neutralize_thoughts],2,CF1),
	certainty(obsessions,3,[CF1],0.98,CF,TV).

%	Compulsions: (1) repetitive behaviours or mental acts the individual feels
%	driven to perform and (2) aimed at reducing distress, unrealistically or excessively.
symptomatic_manifestation(compulsions,_,CF,TV) :-
	symptom([repetitive_behaviours_or_mental_acts,acts_aimed_at_reducing_distress],2,CF1),
	certainty(compulsions,3,[CF1],0.98,CF,TV).

%	Criterion B: time-consuming (e.g., > 1 hour per day) OR clinically significant distress or impairment.
symptomatic_feature(time_consuming_or_distressing,_,CF,TV) :-
	symptom([more_than_one_hour_per_day,occupational_distress,social_distress,other_functional_distress],1,CF1),
	certainty(time_consuming_or_distressing,3,[CF1],0.97,CF,TV).

%---------------------------Body Dysmorphic Disorder----------------------------
%	A (preoccupation), B (repetitive behaviours), C (distress), D (not better
%	explained by an eating disorder); no substance/medical criterion.
disorder_nc(body_dysmorphic_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(appearance_preoccupation,Patient,CF1,true),
	symptomatic_manifestation(repetitive_appearance_behaviours,Patient,CF2,true),
	symptomatic_manifestation(significant_distress,Patient,CF3,true),
	unless_absent([CF1,CF2,CF3],
		symptomatic_feature(appearance_concern_better_explained_by_eating_disorder,Patient,CF4,false),[CF4]),
	certainty(body_dysmorphic_disorder,2,[CF1,CF2,CF3,CF4],0.97,CF,TV).

symptomatic_manifestation(appearance_preoccupation,_,CF,TV) :-
	symptom([preoccupation_with_perceived_appearance_defects],1,CF1),
	certainty(appearance_preoccupation,3,[CF1],0.98,CF,TV).

symptomatic_manifestation(repetitive_appearance_behaviours,_,CF,TV) :-
	symptom([mirror_checking,excessive_grooming,skin_picking_for_appearance,reassurance_seeking,comparing_appearance_with_others],1,CF1),
	certainty(repetitive_appearance_behaviours,3,[CF1],0.97,CF,TV).

%------------------------------Hoarding Disorder--------------------------------
%	A, B, C (hoarding behaviour), D (distress), F (not better explained);
%	E (medical condition only) in disorders.pl.
disorder_nc(hoarding_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(hoarding_behaviour,Patient,CF1,true),
	symptomatic_manifestation(significant_distress,Patient,CF2,true),
	unless_absent([CF1,CF2],
		symptomatic_feature(hoarding_better_explained_by_other_disorder,Patient,CF3,false),[CF3]),
	certainty(hoarding_disorder,2,[CF1,CF2,CF3],0.97,CF,TV).

symptomatic_manifestation(hoarding_behaviour,_,CF,TV) :-
	symptom([difficulty_discarding_possessions,distress_associated_with_discarding,accumulation_clutters_living_areas],3,CF1),
	certainty(hoarding_behaviour,3,[CF1],0.98,CF,TV).

%-------------------------------Trichotillomania--------------------------------
%	A, B (hair pulling and attempts to stop), C (distress), E (not better
%	explained); D (medical condition only) in disorders.pl.
disorder_nc(trichotillomania,Patient,CF,TV) :-
	symptomatic_manifestation(recurrent_hair_pulling,Patient,CF1,true),
	symptomatic_manifestation(significant_distress,Patient,CF2,true),
	unless_absent([CF1,CF2],
		symptomatic_feature(hair_pulling_better_explained_by_other_disorder,Patient,CF3,false),[CF3]),
	certainty(trichotillomania,2,[CF1,CF2,CF3],0.98,CF,TV).

symptomatic_manifestation(recurrent_hair_pulling,_,CF,TV) :-
	symptom([recurrent_pulling_out_of_hair],1,CF1),
	symptom([repeated_attempts_to_stop_hair_pulling],1,CF2),
	certainty(recurrent_hair_pulling,3,[CF1,CF2],0.99,CF,TV).

%--------------------------Excoriation (Skin-Picking)---------------------------
%	A, B (skin picking and attempts to stop), C (distress), E (not better
%	explained); D (substance/medical) in disorders.pl.
disorder_nc(excoriation_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(recurrent_skin_picking,Patient,CF1,true),
	symptomatic_manifestation(significant_distress,Patient,CF2,true),
	unless_absent([CF1,CF2],
		symptomatic_feature(skin_picking_better_explained_by_other_disorder,Patient,CF3,false),[CF3]),
	certainty(excoriation_disorder,2,[CF1,CF2,CF3],0.98,CF,TV).

symptomatic_manifestation(recurrent_skin_picking,_,CF,TV) :-
	symptom([recurrent_skin_picking_causing_lesions],1,CF1),
	symptom([repeated_attempts_to_stop_skin_picking],1,CF2),
	certainty(recurrent_skin_picking,3,[CF1,CF2],0.99,CF,TV).

%-------Substance/Medication-Induced Obsessive-Compulsive and Related Disorder------
disorder_nc(substance_induced_ocrd,Patient,CF,TV) :-
	symptomatic_manifestation(predominant_oc_presentation,Patient,CF1,true),
	symptomatic_feature(substance_etiology,Patient,CF2,true),
	symptomatic_feature(not_delirium_bound,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	unless_absent([CF1,CF2,CF3,CF4],
		symptomatic_feature(independent_disorder_evidence,Patient,CF5,false),[CF5]),
	certainty(substance_induced_ocrd,2,[CF1,CF2,CF3,CF4,CF5],0.88,CF,TV).

%----Obsessive-Compulsive and Related Disorder Due to Another Medical Condition----
disorder_nc(ocrd_due_to_another_medical_condition,Patient,CF,TV) :-
	symptomatic_manifestation(predominant_oc_presentation,Patient,CF1,true),
	symptomatic_feature(medical_etiology,Patient,CF2,true),
	symptomatic_feature(not_delirium_bound,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	unless_absent([CF1,CF2,CF3,CF4],
		symptomatic_feature(disturbance_better_explained_by_other_mental_disorder,Patient,CF5,false),[CF5]),
	certainty(ocrd_due_to_another_medical_condition,2,[CF1,CF2,CF3,CF4,CF5],0.88,CF,TV).


%====================TRAUMA- AND STRESSOR-RELATED DISORDERS=====================

%-------------------------Reactive Attachment Disorder--------------------------
%	A (inhibited attachment), B (social/emotional disturbance), C (insufficient
%	care), D (care responsible), E (not autism spectrum disorder), F (evident
%	before age 5), G (developmental age >= 9 months); criteria for a child.
disorder_nc(reactive_attachment_disorder,Patient,CF,TV) :-
	symptomatic_feature(child_patient,Patient,CF1,true),
	symptomatic_manifestation(inhibited_attachment_behaviour,Patient,CF2,true),
	symptomatic_manifestation(social_emotional_disturbance,Patient,CF3,true),
	symptomatic_feature(insufficient_care,Patient,CF4,true),
	unless_absent([CF1,CF2,CF3,CF4],
		( symptomatic_feature(care_presumed_responsible_for_disturbance,Patient,CF5,true),
		  symptomatic_feature(criteria_met_for_autism_spectrum_disorder,Patient,CF6,false),
		  symptomatic_feature(disturbance_evident_before_age_five,Patient,CF7,true),
		  symptomatic_feature(developmental_age_at_least_nine_months,Patient,CF8,true) ),[CF5,CF6,CF7,CF8]),
	certainty(reactive_attachment_disorder,2,[CF1,CF2,CF3,CF4,CF5,CF6,CF7,CF8],0.96,CF,TV).

symptomatic_manifestation(inhibited_attachment_behaviour,_,CF,TV) :-
	symptom([rarely_seeks_comfort_when_distressed,rarely_responds_to_comfort_when_distressed],2,CF1),
	certainty(inhibited_attachment_behaviour,3,[CF1],0.98,CF,TV).

symptomatic_manifestation(social_emotional_disturbance,_,CF,TV) :-
	symptom([minimal_social_emotional_responsiveness,limited_positive_affect,unexplained_irritability_or_fearfulness],2,CF1),
	certainty(social_emotional_disturbance,3,[CF1],0.97,CF,TV).

symptomatic_feature(insufficient_care,_,CF,TV) :-
	symptom([social_neglect_or_deprivation,repeated_changes_of_caregivers,rearing_limiting_attachment],1,CF1),
	certainty(insufficient_care,3,[CF1],0.97,CF,TV).

%-------------------Disinhibited Social Engagement Disorder---------------------
%	A (>= 2 of 4 behaviours), B (not limited to impulsivity), C (insufficient
%	care), D (care responsible), E (developmental age >= 9 months).
disorder_nc(disinhibited_social_engagement_disorder,Patient,CF,TV) :-
	symptomatic_feature(child_patient,Patient,CF1,true),
	symptomatic_manifestation(disinhibited_behaviour_with_strangers,Patient,CF2,true),
	symptomatic_feature(insufficient_care,Patient,CF3,true),
	unless_absent([CF1,CF2,CF3],
		( symptomatic_feature(behaviour_not_limited_to_impulsivity,Patient,CF4,true),
		  symptomatic_feature(care_presumed_responsible_for_disturbance,Patient,CF5,true),
		  symptomatic_feature(developmental_age_at_least_nine_months,Patient,CF6,true) ),[CF4,CF5,CF6]),
	certainty(disinhibited_social_engagement_disorder,2,[CF1,CF2,CF3,CF4,CF5,CF6],0.96,CF,TV).

symptomatic_manifestation(disinhibited_behaviour_with_strangers,_,CF,TV) :-
	symptom([reduced_reticence_with_unfamiliar_adults,overly_familiar_behaviour,does_not_check_back_with_caregiver,willing_to_go_off_with_strangers],2,CF1),
	certainty(disinhibited_behaviour_with_strangers,3,[CF1],0.98,CF,TV).

%------------------------Posttraumatic Stress Disorder--------------------------
%	Children 6 years and younger: three exposure routes (A), one intrusion (B),
%	one avoidance or negative cognition from a merged list (C), two of five
%	arousal symptoms (D), > 1 month (E), distress in relationships or school (F).
disorder_nc(posttraumatic_stress_disorder,preschool,CF,TV) :-
	!,
	symptomatic_manifestation(preschool_traumatic_exposure,preschool,CF1,true),
	symptomatic_manifestation(intrusion_symptoms,preschool,CF2,true),
	symptomatic_manifestation(avoidance_or_negative_cognitions,preschool,CF3,true),
	symptomatic_manifestation(preschool_arousal_alterations,preschool,CF4,true),
	symptomatic_feature(duration_at_least_one_month,preschool,CF5,true),
	symptomatic_manifestation(significant_distress,preschool,CF6,true),
	certainty(posttraumatic_stress_disorder,2,[CF1,CF2,CF3,CF4,CF5,CF6],0.98,CF,TV).
%	Adults, adolescents and children older than 6 years: criteria A to G.
disorder_nc(posttraumatic_stress_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(traumatic_exposure,Patient,CF1,true),
	symptomatic_manifestation(intrusion_symptoms,Patient,CF2,true),
	symptomatic_manifestation(persistent_avoidance,Patient,CF3,true),
	symptomatic_manifestation(negative_cognitions_and_mood,Patient,CF4,true),
	symptomatic_manifestation(arousal_alterations,Patient,CF5,true),
	symptomatic_feature(duration_at_least_one_month,Patient,CF6,true),
	symptomatic_manifestation(significant_distress,Patient,CF7,true),
	certainty(posttraumatic_stress_disorder,2,[CF1,CF2,CF3,CF4,CF5,CF6,CF7],0.98,CF,TV).

%	Criterion A: exposure to actual/threatened death, serious injury or sexual violence.
symptomatic_manifestation(traumatic_exposure,_,CF,TV) :-
	symptom([directly_experiencing_trauma,witnessing_trauma,learning_of_trauma_to_close_person,repeated_exposure_to_trauma_details],1,CF1),
	certainty(traumatic_exposure,3,[CF1],0.99,CF,TV).

%	Criterion A for children 6 years and younger: no repeated-exposure route.
symptomatic_manifestation(preschool_traumatic_exposure,_,CF,TV) :-
	symptom([directly_experiencing_trauma,witnessing_trauma,learning_of_trauma_to_close_person],1,CF1),
	certainty(preschool_traumatic_exposure,3,[CF1],0.99,CF,TV).

%	Criterion B: >= 1 of 5 intrusion symptoms.
symptomatic_manifestation(intrusion_symptoms,_,CF,TV) :-
	symptom([intrusive_memories,distressing_dreams,dissociative_flashbacks,distress_at_trauma_cues,physiological_reactions_to_cues],1,CF1),
	certainty(intrusion_symptoms,3,[CF1],0.98,CF,TV).

%	Criterion C: >= 1 of 2 avoidance symptoms.
symptomatic_manifestation(persistent_avoidance,_,CF,TV) :-
	symptom([avoidance_of_trauma_thoughts_or_feelings,avoidance_of_external_trauma_reminders],1,CF1),
	certainty(persistent_avoidance,3,[CF1],0.98,CF,TV).

%	Criterion D: >= 2 of 7 negative alterations in cognitions and mood.
symptomatic_manifestation(negative_cognitions_and_mood,_,CF,TV) :-
	symptom([dissociative_amnesia_of_trauma,persistent_negative_beliefs,distorted_blame,persistent_negative_emotional_state,diminished_interest,detachment_from_others,inability_to_feel_positive_emotions],2,CF1),
	certainty(negative_cognitions_and_mood,3,[CF1],0.98,CF,TV).

%	Criterion C for children 6 years and younger: >= 1 of 6, the avoidance of
%	reminders (activities, places, people, conversations) or a negative
%	alteration in cognitions (negative emotional states, diminished interest
%	or constricted play, social withdrawal, reduced positive emotions).
symptomatic_manifestation(avoidance_or_negative_cognitions,_,CF,TV) :-
	symptom([avoidance_of_external_trauma_reminders,persistent_negative_emotional_state,diminished_interest,detachment_from_others,reduced_positive_emotions],1,CF1),
	certainty(avoidance_or_negative_cognitions,3,[CF1],0.98,CF,TV).

%	Criterion E: >= 2 of 6 alterations in arousal and reactivity.
symptomatic_manifestation(arousal_alterations,_,CF,TV) :-
	symptom([irritability_or_aggression,reckless_or_self_destructive_behaviour,hypervigilance,exaggerated_startle_response,difficulty_concentrating,sleep_disturbance],2,CF1),
	certainty(arousal_alterations,3,[CF1],0.98,CF,TV).

%	Criterion D for children 6 years and younger: >= 2 of 5 (no reckless behaviour).
symptomatic_manifestation(preschool_arousal_alterations,_,CF,TV) :-
	symptom([irritability_or_aggression,hypervigilance,exaggerated_startle_response,difficulty_concentrating,sleep_disturbance],2,CF1),
	certainty(preschool_arousal_alterations,3,[CF1],0.98,CF,TV).

%	Specifier "with dissociative symptoms": persistent or recurrent
%	depersonalization or derealization.
symptomatic_feature(dissociative_symptoms,_,CF,TV) :-
	symptom([persistent_depersonalization,persistent_derealization],1,CF1),
	certainty(dissociative_symptoms,3,[CF1],1.0,CF,TV).

%----------------------------Acute Stress Disorder------------------------------
%	A (exposure), B (>= 9 of 14 symptoms), C (3 days to 1 month), D (distress),
%	E (not better explained by brief psychotic disorder); the substance/medical
%	part of E is applied in disorders.pl.
disorder_nc(acute_stress_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(traumatic_exposure,Patient,CF1,true),
	symptomatic_manifestation(acute_stress_symptoms,Patient,CF2,true),
	symptomatic_feature(duration_three_days_to_one_month,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	unless_absent([CF1,CF2,CF3,CF4],
		symptomatic_feature(better_explained_by_brief_psychotic_disorder,Patient,CF5,false),[CF5]),
	certainty(acute_stress_disorder,2,[CF1,CF2,CF3,CF4,CF5],0.97,CF,TV).

%	Criterion B: >= 9 of 14 symptoms across intrusion, negative mood,
%	dissociation, avoidance and arousal (item 4 joins distress and
%	physiological reactions to cues in a single symptom).
symptomatic_manifestation(acute_stress_symptoms,_,CF,TV) :-
	symptom([intrusive_memories,distressing_dreams,dissociative_flashbacks,distress_or_physiological_reactions_to_cues,inability_to_feel_positive_emotions,altered_sense_of_reality,dissociative_amnesia_of_trauma,avoidance_of_trauma_thoughts_or_feelings,avoidance_of_external_trauma_reminders,sleep_disturbance,irritability_or_aggression,hypervigilance,difficulty_concentrating,exaggerated_startle_response],9,CF1),
	certainty(acute_stress_symptoms,3,[CF1],0.97,CF,TV).

%-----------------------------Adjustment Disorders------------------------------
%	A (symptoms within 3 months of a stressor), B (marked distress or
%	impairment), C (no other mental disorder), D (not normal bereavement nor
%	prolonged grief), E (not persisting > 6 months after the stressor ends).
disorder_nc(adjustment_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(reaction_to_stressor,Patient,CF1,true),
	symptomatic_feature(adjustment_onset_within_three_months,Patient,CF2,true),
	symptomatic_manifestation(adjustment_clinical_significance,Patient,CF3,true),
	unless_absent([CF1,CF2,CF3],
		( symptomatic_feature(stress_reaction_meets_criteria_for_another_disorder,Patient,CF4,false),
		  symptomatic_feature(symptoms_represent_normal_bereavement,Patient,CF5,false),
		  symptomatic_feature(symptoms_persist_beyond_six_months_after_stressor_ends,Patient,CF6,false) ),[CF4,CF5,CF6]),
	certainty(adjustment_disorder,2,[CF1,CF2,CF3,CF4,CF5,CF6],0.95,CF,TV).

symptomatic_manifestation(reaction_to_stressor,_,CF,TV) :-
	symptom([emotional_or_behavioural_symptoms_after_stressor],1,CF1),
	certainty(reaction_to_stressor,3,[CF1],0.96,CF,TV).

%	Criterion B: marked distress out of proportion to the stressor, or significant impairment.
symptomatic_manifestation(adjustment_clinical_significance,_,CF,TV) :-
	symptom([distress_out_of_proportion_to_stressor,occupational_distress,social_distress,other_functional_distress],1,CF1),
	certainty(adjustment_clinical_significance,3,[CF1],0.97,CF,TV).

%	Course specifiers: acute (< 6 months) or persistent (>= 6 months).
symptomatic_feature(adjustment_acute_course,_,CF,TV) :-
	symptoms_duration([less_than_three_days,three_days_to_one_month,one_to_three_months,three_to_six_months],CF1),
	certainty(adjustment_acute_course,3,[CF1],1.0,CF,TV).
symptomatic_feature(adjustment_persistent_course,_,CF,TV) :-
	symptoms_duration([six_months_or_more],CF1),
	certainty(adjustment_persistent_course,3,[CF1],1.0,CF,TV).

%---------------------------Prolonged Grief Disorder----------------------------
%	A (death >= 12 months ago, >= 6 months in youth), B (>= 1 of 2), C (>= 3
%	of 8), B/C (nearly every day for the last month), D (distress), E (beyond
%	cultural norms), F (not better explained); the substance/medical part of F
%	is applied in disorders.pl.
disorder_nc(prolonged_grief_disorder,Patient,CF,TV) :-
	symptomatic_feature(bereavement_at_least_twelve_months,Patient,CF1,true),
	symptomatic_manifestation(persistent_grief_response,Patient,CF2,true),
	symptomatic_manifestation(grief_associated_symptoms,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	unless_absent([CF1,CF2,CF3,CF4],
		( symptomatic_feature(grief_symptoms_nearly_every_day_last_month,Patient,CF5,true),
		  symptomatic_feature(bereavement_reaction_exceeds_cultural_norms,Patient,CF6,true),
		  symptomatic_feature(grief_better_explained_by_other_disorder,Patient,CF7,false) ),[CF5,CF6,CF7]),
	certainty(prolonged_grief_disorder,2,[CF1,CF2,CF3,CF4,CF5,CF6,CF7],0.97,CF,TV).

%	Criterion B: >= 1 of 2 core grief symptoms.
symptomatic_manifestation(persistent_grief_response,_,CF,TV) :-
	symptom([intense_yearning_for_the_deceased,preoccupation_with_the_deceased],1,CF1),
	certainty(persistent_grief_response,3,[CF1],0.98,CF,TV).

%	Criterion C: >= 3 of 8 associated grief symptoms.
symptomatic_manifestation(grief_associated_symptoms,_,CF,TV) :-
	symptom([identity_disruption_since_death,disbelief_about_the_death,avoidance_of_reminders_of_death,intense_emotional_pain,difficulty_reintegrating,emotional_numbness,feeling_life_is_meaningless,intense_loneliness],3,CF1),
	certainty(grief_associated_symptoms,3,[CF1],0.98,CF,TV).


%--------------------------DURATION / ONSET FEATURES----------------------------
symptomatic_feature(duration_at_least_one_month,_,CF,TV) :-
	symptoms_duration([one_to_three_months,three_to_six_months,six_months_or_more],CF1),
	certainty(duration_at_least_one_month,3,[CF1],1.0,CF,TV).

symptomatic_feature(duration_at_least_six_months,_,CF,TV) :-
	symptoms_duration([six_months_or_more],CF1),
	certainty(duration_at_least_six_months,3,[CF1],1.0,CF,TV).

symptomatic_feature(duration_three_days_to_one_month,_,CF,TV) :-
	symptoms_duration([three_days_to_one_month],CF1),
	certainty(duration_three_days_to_one_month,3,[CF1],1.0,CF,TV).

symptomatic_feature(adjustment_onset_within_three_months,_,CF,TV) :-
	symptoms_onset([within_three_months_of_stressor],CF1),
	certainty(adjustment_onset_within_three_months,3,[CF1],1.0,CF,TV).

symptomatic_feature(bereavement_at_least_twelve_months,adult,CF,TV) :-
	!,
	bereavement_time([twelve_months_or_more],CF1),
	certainty(bereavement_at_least_twelve_months,3,[CF1],1.0,CF,TV).
symptomatic_feature(bereavement_at_least_twelve_months,_,CF,TV) :-
	bereavement_time([six_to_twelve_months,twelve_months_or_more],CF1),
	certainty(bereavement_at_least_twelve_months,3,[CF1],1.0,CF,TV).


%--------------------------QUESTIONS TO ASK THE USER----------------------------
attack_type(L,CF) :-
	multiple_ask(attack_type,[unexpected_attack,cued_attack],L,CF).

%	insight_specifier(Level): selective specifier (good-or-fair / poor / absent or
%	delusional) for OCD, body dysmorphic and hoarding disorders. It labels the
%	insight level without gating the presence of the disorder.
insight_specifier(Level) :-
	selective_ask(insight_level,Level,[insight_good_or_fair,insight_poor,insight_absent_or_delusional]).

%	onset_specifier(Onset): selective onset specifier of the substance/medication-induced disorders.
onset_specifier(Onset) :-
	selective_ask(substance_onset,Onset,[onset_during_intoxication,onset_during_withdrawal,onset_after_medication_use]).

%	presentation_specifier(Presentation): selective specifier of the
%	obsessive-compulsive and related disorder due to another medical condition.
presentation_specifier(Presentation) :-
	selective_ask(ocrd_presentation,Presentation,[with_ocd_like_symptoms,with_appearance_preoccupations,with_hoarding_symptoms,with_hair_pulling_symptoms,with_skin_picking_symptoms]).

%	adjustment_subtype(Subtype): selective subtype of the adjustment disorders (separately coded).
adjustment_subtype(Subtype) :-
	selective_ask(adjustment_subtype,Subtype,[with_depressed_mood,with_anxiety,with_mixed_anxiety_and_depressed_mood,with_disturbance_of_conduct,with_mixed_disturbance_emotions_conduct,unspecified_adjustment]).

panic_attacks_frequency(L,CF) :-
	current_uncertainty_method(fuzzy_membership),
	!,
	graded_value(panic_attacks_count,Count),
	frequency_membership(L,Count,CF).
panic_attacks_frequency(L,CF) :-
	multiple_ask(panic_attacks_frequency,[one_or_fewer,two_to_five,more_than_five],L,CF).

symptoms_duration(L,CF) :-
	current_uncertainty_method(fuzzy_membership),
	!,
	graded_value(duration_months,Months),
	duration_membership(L,Months,CF).
symptoms_duration(L,CF) :-
	multiple_ask(symptoms_duration,[less_than_three_days,three_days_to_one_month,one_to_three_months,three_to_six_months,six_months_or_more],L,CF).

symptoms_onset(L,CF) :-
	multiple_ask(symptoms_onset,[within_three_months_of_stressor,more_than_three_months_after_stressor,no_onset],L,CF).

bereavement_time(L,CF) :-
	multiple_ask(bereavement_time,[less_than_six_months,six_to_twelve_months,twelve_months_or_more],L,CF).

anxiety_type(L,CF) :-
	multiple_ask(anxiety_type,[difficulty_escaping_or_help_unavailable,health_danger,apprehensive_expectation,other_anxiety_type],L,CF).

phobic_reaction_type(L,CF) :-
	multiple_ask(phobic_reaction_type,[avoidance,requires_companion,endurance_with_distress,endurance_without_problems],L,CF).

symptom(Y,Z,CF) :-
	criterion_ask(symptom,Y,Z,CF).

etiological_evidence(Y,Z,CF) :-
	criterion_ask(symptom,Y,Z,CF).

patient(X) :-
	selective_ask(patient,X,[preschool,child,adolescent,adult]).
