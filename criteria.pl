%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		criteria.pl
%
%	description:
%		Knowledge base - diagnostic criteria (DSM-5-TR). Sub-disorders
%		(disorder_nc/4), disorder types/specifiers, symptomatic manifestations
%		and features, and the question wrappers that elicit symptoms from the
%		user. Covers the Anxiety, Obsessive-Compulsive and Related, and
%		Trauma- and Stressor-Related chapters.
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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


%===============================ANXIETY DISORDERS===============================

%--------------------------Separation Anxiety Disorder--------------------------
disorder_nc(separation_anxiety_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(excessive_separation_fear,Patient,CF1,true),
	symptomatic_feature(separation_anxiety_duration,Patient,CF2,true),
	symptomatic_manifestation(significant_distress,Patient,CF3,true),
	certainty(separation_anxiety_disorder,2,[CF1,CF2,CF3],0.97,CF,TV).

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
disorder_nc(selective_mutism,Patient,CF,TV) :-
	symptomatic_manifestation(consistent_failure_to_speak,Patient,CF1,true),
	symptomatic_feature(duration_at_least_one_month,Patient,CF2,true),
	symptomatic_manifestation(significant_distress,Patient,CF3,true),
	certainty(selective_mutism,2,[CF1,CF2,CF3],0.97,CF,TV).

symptomatic_manifestation(consistent_failure_to_speak,_,CF,TV) :-
	symptom([failure_to_speak_in_specific_social_situations],1,CF1),
	symptom([speaks_in_other_situations],1,CF2),
	certainty(consistent_failure_to_speak,3,[CF1,CF2],0.98,CF,TV).

%--------------------------------Specific Phobia--------------------------------
disorder_nc(specific_phobia,Patient,CF,TV) :-
	symptomatic_manifestation(specific_phobic_anxiety,Patient,CF1,true),
	symptomatic_manifestation(phobic_avoidance,Patient,CF2,true),
	symptomatic_feature(duration_at_least_six_months,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	certainty(specific_phobia,2,[CF1,CF2,CF3,CF4],0.98,CF,TV).

%	Marked fear/anxiety about a specific object or situation, out of proportion to actual danger.
symptomatic_manifestation(specific_phobic_anxiety,_,CF,TV) :-
	symptom([marked_fear_of_specific_object_or_situation,fear_almost_always_provoked,fear_out_of_proportion_to_actual_danger],3,CF1),
	certainty(specific_phobic_anxiety,3,[CF1],0.98,CF,TV).

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

%----------------------------Social Anxiety Disorder----------------------------
disorder_nc(social_anxiety_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(social_phobic_anxiety,Patient,CF1,true),
	symptomatic_manifestation(phobic_avoidance,Patient,CF2,true),
	symptomatic_feature(duration_at_least_six_months,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	certainty(social_anxiety_disorder,2,[CF1,CF2,CF3,CF4],0.98,CF,TV).

%	Marked fear of social situations involving possible scrutiny, with fear of negative evaluation.
symptomatic_manifestation(social_phobic_anxiety,_,CF,TV) :-
	symptom([marked_fear_of_social_scrutiny,fear_of_negative_evaluation,fear_almost_always_provoked,fear_out_of_proportion_to_actual_danger],4,CF1),
	certainty(social_phobic_anxiety,3,[CF1],0.98,CF,TV).

%--------------------------------Panic Disorder---------------------------------
disorder_nc(panic_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(recurrent_unexpected_panic_attacks,Patient,CF1,true),
	symptomatic_manifestation(panic_consequences_concern,Patient,CF2,true),
	symptomatic_feature(duration_at_least_one_month,Patient,CF3,true),
	certainty(panic_disorder,2,[CF1,CF2,CF3],0.97,CF,TV).

symptomatic_manifestation(recurrent_unexpected_panic_attacks,Patient,CF,TV) :-
	symptomatic_manifestation(panic_attack,Patient,CF1,true),
	panic_attacks_frequency([two_to_five,more_than_five],CF2),
	attack_type([unexpected_attack],CF3),
	certainty(recurrent_unexpected_panic_attacks,3,[CF1,CF2,CF3],0.98,CF,TV).

%	Criterion B: >= 1 month of worry about further attacks and/or maladaptive change of behaviour.
symptomatic_manifestation(panic_consequences_concern,_,CF,TV) :-
	symptom([worry_about_new_panic_attacks,worry_about_panic_consequences,maladaptive_behaviour_change_due_to_panic],1,CF1),
	certainty(panic_consequences_concern,3,[CF1],0.98,CF,TV).

%----------------------------------Agoraphobia----------------------------------
disorder_nc(agoraphobia,Patient,CF,TV) :-
	symptomatic_manifestation(agoraphobic_anxiety,Patient,CF1,true),
	symptomatic_manifestation(phobic_avoidance,Patient,CF2,true),
	symptomatic_feature(duration_at_least_six_months,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	certainty(agoraphobia,2,[CF1,CF2,CF3,CF4],0.98,CF,TV).

%	Criterion A: marked fear of >= 2 of 5 agoraphobic situations; Criterion B: fear of not escaping/getting help.
symptomatic_manifestation(agoraphobic_anxiety,_,CF,TV) :-
	symptom([fear_of_public_transport,fear_of_open_spaces,fear_of_enclosed_places,fear_of_queues_or_crowds,fear_of_being_outside_home_alone],2,CF1),
	anxiety_type([difficulty_escaping_or_help_unavailable],CF2),
	certainty(agoraphobic_anxiety,3,[CF1,CF2],0.98,CF,TV).

%-------------------------Generalized Anxiety Disorder--------------------------
disorder_nc(generalized_anxiety_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(excessive_uncontrollable_worry,Patient,CF1,true),
	symptomatic_manifestation(generalized_anxiety_symptoms,Patient,CF2,true),
	symptomatic_feature(duration_at_least_six_months,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	certainty(generalized_anxiety_disorder,2,[CF1,CF2,CF3,CF4],0.97,CF,TV).

symptomatic_manifestation(excessive_uncontrollable_worry,_,CF,TV) :-
	symptom([excessive_worry_about_several_events],1,CF1),
	symptom([difficulty_controlling_worry],1,CF2),
	certainty(excessive_uncontrollable_worry,3,[CF1,CF2],0.98,CF,TV).

%	Criterion C: >= 3 of 6 symptoms (only 1 required in children).
symptomatic_manifestation(generalized_anxiety_symptoms,child,CF,TV) :-
	!,
	symptom([restlessness,being_easily_fatigued,difficulty_concentrating,irritability,muscle_tension,sleep_disturbance],1,CF1),
	certainty(generalized_anxiety_symptoms,3,[CF1],0.98,CF,TV).
symptomatic_manifestation(generalized_anxiety_symptoms,_,CF,TV) :-
	symptom([restlessness,being_easily_fatigued,difficulty_concentrating,irritability,muscle_tension,sleep_disturbance],3,CF1),
	certainty(generalized_anxiety_symptoms,3,[CF1],0.98,CF,TV).


%==================OBSESSIVE-COMPULSIVE AND RELATED DISORDERS===================

%-------------------------Obsessive-Compulsive Disorder-------------------------
disorder_nc(obsessive_compulsive_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(obsessions_or_compulsions,Patient,CF1,true),
	symptomatic_feature(time_consuming_more_than_one_hour,Patient,CF2,true),
	symptomatic_manifestation(significant_distress,Patient,CF3,true),
	certainty(obsessive_compulsive_disorder,2,[CF1,CF2,CF3],0.97,CF,TV).

%	Presence of obsessions, compulsions, or both.
symptomatic_manifestation(obsessions_or_compulsions,_,CF,TV) :-
	symptom([recurrent_intrusive_unwanted_thoughts,repetitive_behaviours_or_mental_acts],1,CF1),
	certainty(obsessions_or_compulsions,3,[CF1],0.98,CF,TV).

%	Criterion B: obsessions/compulsions are time-consuming (> 1 hour per day).
symptomatic_feature(time_consuming_more_than_one_hour,_,CF,TV) :-
	symptom([more_than_one_hour_per_day],1,CF1),
	certainty(time_consuming_more_than_one_hour,3,[CF1],0.97,CF,TV).

%---------------------------Body Dysmorphic Disorder----------------------------
disorder_nc(body_dysmorphic_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(appearance_preoccupation,Patient,CF1,true),
	symptomatic_manifestation(repetitive_appearance_behaviours,Patient,CF2,true),
	symptomatic_manifestation(significant_distress,Patient,CF3,true),
	certainty(body_dysmorphic_disorder,2,[CF1,CF2,CF3],0.97,CF,TV).

symptomatic_manifestation(appearance_preoccupation,_,CF,TV) :-
	symptom([preoccupation_with_perceived_appearance_defects],1,CF1),
	certainty(appearance_preoccupation,3,[CF1],0.98,CF,TV).

symptomatic_manifestation(repetitive_appearance_behaviours,_,CF,TV) :-
	symptom([mirror_checking,excessive_grooming,skin_picking_for_appearance,reassurance_seeking,comparing_appearance_with_others],1,CF1),
	certainty(repetitive_appearance_behaviours,3,[CF1],0.97,CF,TV).

%-------------------------------Hoarding Disorder-------------------------------
disorder_nc(hoarding_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(hoarding_behaviour,Patient,CF1,true),
	symptomatic_manifestation(significant_distress,Patient,CF2,true),
	certainty(hoarding_disorder,2,[CF1,CF2],0.97,CF,TV).

symptomatic_manifestation(hoarding_behaviour,_,CF,TV) :-
	symptom([difficulty_discarding_possessions,distress_associated_with_discarding,accumulation_clutters_living_areas],3,CF1),
	certainty(hoarding_behaviour,3,[CF1],0.98,CF,TV).

%-------------------------------Trichotillomania--------------------------------
disorder_nc(trichotillomania,Patient,CF,TV) :-
	symptomatic_manifestation(recurrent_hair_pulling,Patient,CF1,true),
	symptomatic_manifestation(significant_distress,Patient,CF2,true),
	certainty(trichotillomania,2,[CF1,CF2],0.98,CF,TV).

symptomatic_manifestation(recurrent_hair_pulling,_,CF,TV) :-
	symptom([recurrent_pulling_out_of_hair],1,CF1),
	symptom([repeated_attempts_to_stop_hair_pulling],1,CF2),
	certainty(recurrent_hair_pulling,3,[CF1,CF2],0.99,CF,TV).

%--------------------------Excoriation (Skin-Picking)---------------------------
disorder_nc(excoriation_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(recurrent_skin_picking,Patient,CF1,true),
	symptomatic_manifestation(significant_distress,Patient,CF2,true),
	certainty(excoriation_disorder,2,[CF1,CF2],0.98,CF,TV).

symptomatic_manifestation(recurrent_skin_picking,_,CF,TV) :-
	symptom([recurrent_skin_picking_causing_lesions],1,CF1),
	symptom([repeated_attempts_to_stop_skin_picking],1,CF2),
	certainty(recurrent_skin_picking,3,[CF1,CF2],0.99,CF,TV).


%====================TRAUMA- AND STRESSOR-RELATED DISORDERS=====================

%-------------------------Reactive Attachment Disorder--------------------------
disorder_nc(reactive_attachment_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(inhibited_attachment_behaviour,Patient,CF1,true),
	symptomatic_manifestation(social_emotional_disturbance,Patient,CF2,true),
	symptomatic_feature(insufficient_care,Patient,CF3,true),
	certainty(reactive_attachment_disorder,2,[CF1,CF2,CF3],0.96,CF,TV).

symptomatic_manifestation(inhibited_attachment_behaviour,_,CF,TV) :-
	symptom([rarely_seeks_comfort_when_distressed,rarely_responds_to_comfort_when_distressed],2,CF1),
	certainty(inhibited_attachment_behaviour,3,[CF1],0.98,CF,TV).

symptomatic_manifestation(social_emotional_disturbance,_,CF,TV) :-
	symptom([minimal_social_emotional_responsiveness,limited_positive_affect,unexplained_irritability_or_fearfulness],2,CF1),
	certainty(social_emotional_disturbance,3,[CF1],0.97,CF,TV).

symptomatic_feature(insufficient_care,_,CF,TV) :-
	symptom([social_neglect_or_deprivation,repeated_changes_of_caregivers,rearing_limiting_attachment],1,CF1),
	certainty(insufficient_care,3,[CF1],0.97,CF,TV).

%--------------------Disinhibited Social Engagement Disorder--------------------
disorder_nc(disinhibited_social_engagement_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(disinhibited_behaviour_with_strangers,Patient,CF1,true),
	symptomatic_feature(insufficient_care,Patient,CF2,true),
	certainty(disinhibited_social_engagement_disorder,2,[CF1,CF2],0.96,CF,TV).

symptomatic_manifestation(disinhibited_behaviour_with_strangers,_,CF,TV) :-
	symptom([reduced_reticence_with_unfamiliar_adults,overly_familiar_behaviour,does_not_check_back_with_caregiver,willing_to_go_off_with_strangers],2,CF1),
	certainty(disinhibited_behaviour_with_strangers,3,[CF1],0.98,CF,TV).

%-------------------------Posttraumatic Stress Disorder-------------------------
%	Preschool subtype (children 6 years and younger): fewer required symptoms, merged clusters.
disorder_nc(posttraumatic_stress_disorder,preschool,CF,TV) :-
	!,
	symptomatic_manifestation(traumatic_exposure,preschool,CF1,true),
	symptomatic_manifestation(intrusion_symptoms,preschool,CF2,true),
	symptomatic_manifestation(avoidance_or_negative_cognitions,preschool,CF3,true),
	symptomatic_manifestation(arousal_alterations,preschool,CF4,true),
	symptomatic_feature(duration_at_least_one_month,preschool,CF5,true),
	certainty(posttraumatic_stress_disorder,2,[CF1,CF2,CF3,CF4,CF5],0.98,CF,TV).
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

%	Combined avoidance + negative cognitions for the preschool subtype (>= 1 of 6).
symptomatic_manifestation(avoidance_or_negative_cognitions,_,CF,TV) :-
	symptom([avoidance_of_trauma_thoughts_or_feelings,avoidance_of_external_trauma_reminders,diminished_interest,detachment_from_others,persistent_negative_emotional_state,reduced_positive_emotions],1,CF1),
	certainty(avoidance_or_negative_cognitions,3,[CF1],0.98,CF,TV).

%	Criterion E: >= 2 of 6 alterations in arousal and reactivity.
symptomatic_manifestation(arousal_alterations,_,CF,TV) :-
	symptom([irritability_or_aggression,reckless_or_self_destructive_behaviour,hypervigilance,exaggerated_startle_response,difficulty_concentrating,sleep_disturbance],2,CF1),
	certainty(arousal_alterations,3,[CF1],0.98,CF,TV).

%-----------------------------Acute Stress Disorder-----------------------------
disorder_nc(acute_stress_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(traumatic_exposure,Patient,CF1,true),
	symptomatic_manifestation(acute_stress_symptoms,Patient,CF2,true),
	symptomatic_feature(duration_three_days_to_one_month,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	certainty(acute_stress_disorder,2,[CF1,CF2,CF3,CF4],0.97,CF,TV).

%	Criterion B: >= 9 of 14 symptoms across intrusion, negative mood, dissociation, avoidance and arousal.
symptomatic_manifestation(acute_stress_symptoms,_,CF,TV) :-
	symptom([intrusive_memories,distressing_dreams,dissociative_flashbacks,distress_at_trauma_cues,reduced_positive_emotions,altered_sense_of_reality,dissociative_amnesia_of_trauma,avoidance_of_trauma_thoughts_or_feelings,avoidance_of_external_trauma_reminders,sleep_disturbance,irritability_or_aggression,hypervigilance,difficulty_concentrating,exaggerated_startle_response],9,CF1),
	certainty(acute_stress_symptoms,3,[CF1],0.97,CF,TV).

%------------------------------Adjustment Disorder------------------------------
disorder_nc(adjustment_disorder,Patient,CF,TV) :-
	symptomatic_manifestation(reaction_to_stressor,Patient,CF1,true),
	symptomatic_feature(adjustment_onset_within_three_months,Patient,CF2,true),
	symptomatic_manifestation(significant_distress,Patient,CF3,true),
	certainty(adjustment_disorder,2,[CF1,CF2,CF3],0.95,CF,TV).

symptomatic_manifestation(reaction_to_stressor,_,CF,TV) :-
	symptom([emotional_or_behavioural_symptoms_after_stressor],1,CF1),
	adjustment_subtype([with_depressed_mood,with_anxiety,with_mixed_anxiety_and_depressed_mood,with_disturbance_of_conduct,with_mixed_disturbance_emotions_conduct,unspecified_adjustment],CF2),
	certainty(reaction_to_stressor,3,[CF1,CF2],0.96,CF,TV).

%---------------------------Prolonged Grief Disorder----------------------------
disorder_nc(prolonged_grief_disorder,Patient,CF,TV) :-
	symptomatic_feature(bereavement_at_least_twelve_months,Patient,CF1,true),
	symptomatic_manifestation(persistent_grief_response,Patient,CF2,true),
	symptomatic_manifestation(grief_associated_symptoms,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	certainty(prolonged_grief_disorder,2,[CF1,CF2,CF3,CF4],0.97,CF,TV).

%	Criterion B: >= 1 of 2 core grief symptoms.
symptomatic_manifestation(persistent_grief_response,_,CF,TV) :-
	symptom([intense_yearning_for_the_deceased,preoccupation_with_the_deceased],1,CF1),
	certainty(persistent_grief_response,3,[CF1],0.98,CF,TV).

%	Criterion C: >= 3 of 8 associated grief symptoms.
symptomatic_manifestation(grief_associated_symptoms,_,CF,TV) :-
	symptom([identity_disruption_since_death,disbelief_about_the_death,avoidance_of_reminders_of_death,intense_emotional_pain,difficulty_reintegrating,emotional_numbness,feeling_life_is_meaningless,intense_loneliness],3,CF1),
	certainty(grief_associated_symptoms,3,[CF1],0.98,CF,TV).


%---------------------------DURATION / ONSET FEATURES---------------------------
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


%---------------------------QUESTIONS TO ASK THE USER---------------------------
attack_type(L,CF) :-
	multiple_ask(attack_type,[unexpected_attack,cued_attack],L,CF).

%	insight_specifier(Level): selective specifier (good-or-fair / poor / absent or
%	delusional) for OCD, body dysmorphic and hoarding disorders. It labels the
%	insight level without gating the presence of the disorder.
insight_specifier(Level) :-
	selective_ask(insight_level,Level,[insight_good_or_fair,insight_poor,insight_absent_or_delusional]).

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
	multiple_ask(phobic_reaction_type,[avoidance,endurance_with_distress,endurance_without_problems],L,CF).

adjustment_subtype(L,CF) :-
	multiple_ask(adjustment_subtype,[with_depressed_mood,with_anxiety,with_mixed_anxiety_and_depressed_mood,with_disturbance_of_conduct,with_mixed_disturbance_emotions_conduct,unspecified_adjustment],L,CF).

symptom(Y,Z,CF) :-
	criterion_ask(symptom,Y,Z,CF).

etiological_evidence(Y,Z,CF) :-
	criterion_ask(symptom,Y,Z,CF).

patient(X) :-
	selective_ask(patient,X,[preschool,child,adolescent,adult]).
