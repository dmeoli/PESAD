%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		disorders.pl
%
%	description:
%		Knowledge base - codable disorders (DSM-5-TR) across the Anxiety,
%		Obsessive-Compulsive and Related, and Trauma- and Stressor-Related
%		chapters. Each disorder/3 rule is a diagnostic goal combining
%		sub-disorders, types, specifiers and exclusions; also holds the entry
%		points solve_goal/2, investigate_goals/1, the goals list and the
%		ICD-10-CM / ICD-11 codes of every goal.
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Control diagnosis on a single disorder
solve_goal(Y,CF) :-
	patient(X),
	disorder(Y,X,CF).

% Investigative diagnosis on multiple disorders
investigate_goals(L) :-
	patient(X),
	findall(goal(Y,CF),disorder(Y,X,CF),L).

%	exclude_substance_and_medical(Patient,CF_Substance,CF_Medical):
%		shared exclusion - the disturbance is not attributable to a substance
%		or to another medical condition (both required to be false).
exclude_substance_and_medical(Patient,CF_Substance,CF_Medical) :-
	disorder_nc(associated_substance_induced_alteration,Patient,CF_Substance,false),
	disorder_nc(associated_general_medical_condition,Patient,CF_Medical,false).

%	exclude_medical(Patient,CF_Medical):
%		the disturbance is not attributable to another medical condition (the
%		criteria of hoarding disorder and trichotillomania name no substance).
exclude_medical(Patient,CF_Medical) :-
	disorder_nc(associated_general_medical_condition,Patient,CF_Medical,false).

%	primary(Disorder,Patient,CF1,CF2,CF3): the criteria of Disorder (CF1) and
%	the substance/medical exclusion (CF2, CF3), asked only if CF1 is not zero.
primary(Disorder,Patient,CF1,CF2,CF3) :-
	disorder_nc(Disorder,Patient,CF1,true),
	unless_absent([CF1],exclude_substance_and_medical(Patient,CF2,CF3),[CF2,CF3]).

%	selected(CF,Ask): asks the selective specifier Ask only when the disorder is
%	not already ruled out (CF > 0); when it is, every variant gets CF 0.
selected(CF,_) :-
	CF =:= 0,
	!.
selected(_,Ask) :-
	call(Ask).


%===============================ANXIETY DISORDERS===============================

%	Separation Anxiety Disorder (criteria A-D; no substance/medical criterion)
disorder(separation_anxiety_disorder,Patient,CF) :-
	disorder_nc(separation_anxiety_disorder,Patient,CF1,true),
	certainty(separation_anxiety_disorder,1,[CF1],0.97,CF,true).

%	Selective Mutism (criteria A-E; no substance/medical criterion)
disorder(selective_mutism,Patient,CF) :-
	disorder_nc(selective_mutism,Patient,CF1,true),
	certainty(selective_mutism,1,[CF1],0.97,CF,true).

%	Specific Phobia, coded by phobic stimulus (all applicable types are coded)
disorder(specific_phobia_animal_type,Patient,CF) :-
	disorder_nc(specific_phobia,Patient,CF1,true),
	specific_phobia_type(animal_type,Patient,CF2,true),
	certainty(specific_phobia_animal_type,1,[CF1,CF2],0.98,CF,true).
disorder(specific_phobia_natural_environment_type,Patient,CF) :-
	disorder_nc(specific_phobia,Patient,CF1,true),
	specific_phobia_type(natural_environment_type,Patient,CF2,true),
	certainty(specific_phobia_natural_environment_type,1,[CF1,CF2],0.98,CF,true).
disorder(specific_phobia_blood_injection_injury_type,Patient,CF) :-
	disorder_nc(specific_phobia,Patient,CF1,true),
	specific_phobia_type(blood_injection_injury_type,Patient,CF2,true),
	certainty(specific_phobia_blood_injection_injury_type,1,[CF1,CF2],0.98,CF,true).
disorder(specific_phobia_situational_type,Patient,CF) :-
	disorder_nc(specific_phobia,Patient,CF1,true),
	specific_phobia_type(situational_type,Patient,CF2,true),
	certainty(specific_phobia_situational_type,1,[CF1,CF2],0.98,CF,true).
disorder(specific_phobia_other_type,Patient,CF) :-
	disorder_nc(specific_phobia,Patient,CF1,true),
	specific_phobia_type(other_type,Patient,CF2,true),
	certainty(specific_phobia_other_type,1,[CF1,CF2],0.98,CF,true).

%	Social Anxiety Disorder, and its "performance only" specifier
disorder(social_anxiety_disorder,Patient,CF) :-
	primary(social_anxiety_disorder,Patient,CF1,CF2,CF3),
	certainty(social_anxiety_disorder,1,[CF1,CF2,CF3],0.98,CF,true).
disorder(social_anxiety_disorder_performance_only,Patient,CF) :-
	primary(social_anxiety_disorder,Patient,CF1,CF2,CF3),
	unless_absent([CF1],symptomatic_feature(fear_restricted_to_public_performance,Patient,CF4,true),[CF4]),
	certainty(social_anxiety_disorder_performance_only,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Panic Disorder
disorder(panic_disorder,Patient,CF) :-
	primary(panic_disorder,Patient,CF1,CF2,CF3),
	certainty(panic_disorder,1,[CF1,CF2,CF3],0.97,CF,true).

%	Agoraphobia (criterion H on medical conditions is part of disorder_nc)
disorder(agoraphobia,Patient,CF) :-
	disorder_nc(agoraphobia,Patient,CF1,true),
	certainty(agoraphobia,1,[CF1],0.98,CF,true).

%	Generalized Anxiety Disorder
disorder(generalized_anxiety_disorder,Patient,CF) :-
	primary(generalized_anxiety_disorder,Patient,CF1,CF2,CF3),
	certainty(generalized_anxiety_disorder,1,[CF1,CF2,CF3],0.97,CF,true).

%	Substance/Medication-Induced Anxiety Disorder, by onset specifier
disorder(substance_induced_anxiety_disorder_with_onset_during_intoxication,Patient,CF) :-
	disorder_nc(substance_induced_anxiety_disorder,Patient,CF1,true),
	selected(CF1,onset_specifier(onset_during_intoxication)),
	certainty(substance_induced_anxiety_disorder_with_onset_during_intoxication,1,[CF1],0.97,CF,true).
disorder(substance_induced_anxiety_disorder_with_onset_during_withdrawal,Patient,CF) :-
	disorder_nc(substance_induced_anxiety_disorder,Patient,CF1,true),
	selected(CF1,onset_specifier(onset_during_withdrawal)),
	certainty(substance_induced_anxiety_disorder_with_onset_during_withdrawal,1,[CF1],0.97,CF,true).
disorder(substance_induced_anxiety_disorder_with_onset_after_medication_use,Patient,CF) :-
	disorder_nc(substance_induced_anxiety_disorder,Patient,CF1,true),
	selected(CF1,onset_specifier(onset_after_medication_use)),
	certainty(substance_induced_anxiety_disorder_with_onset_after_medication_use,1,[CF1],0.97,CF,true).

%	Anxiety Disorder Due to Another Medical Condition
disorder(anxiety_disorder_due_to_another_medical_condition,Patient,CF) :-
	disorder_nc(anxiety_disorder_due_to_another_medical_condition,Patient,CF1,true),
	certainty(anxiety_disorder_due_to_another_medical_condition,1,[CF1],0.97,CF,true).


%==================OBSESSIVE-COMPULSIVE AND RELATED DISORDERS===================

%	Obsessive-Compulsive Disorder, by insight specifier, and "tic-related"
disorder(obsessive_compulsive_disorder_with_good_or_fair_insight,Patient,CF) :-
	primary(obsessive_compulsive_disorder,Patient,CF1,CF2,CF3),
	selected(CF1,insight_specifier(insight_good_or_fair)),
	certainty(obsessive_compulsive_disorder_with_good_or_fair_insight,1,[CF1,CF2,CF3],0.97,CF,true).
disorder(obsessive_compulsive_disorder_with_poor_insight,Patient,CF) :-
	primary(obsessive_compulsive_disorder,Patient,CF1,CF2,CF3),
	selected(CF1,insight_specifier(insight_poor)),
	certainty(obsessive_compulsive_disorder_with_poor_insight,1,[CF1,CF2,CF3],0.97,CF,true).
disorder(obsessive_compulsive_disorder_with_absent_insight,Patient,CF) :-
	primary(obsessive_compulsive_disorder,Patient,CF1,CF2,CF3),
	selected(CF1,insight_specifier(insight_absent_or_delusional)),
	certainty(obsessive_compulsive_disorder_with_absent_insight,1,[CF1,CF2,CF3],0.97,CF,true).
disorder(obsessive_compulsive_disorder_tic_related,Patient,CF) :-
	primary(obsessive_compulsive_disorder,Patient,CF1,CF2,CF3),
	unless_absent([CF1],symptomatic_feature(history_of_tic_disorder,Patient,CF4,true),[CF4]),
	certainty(obsessive_compulsive_disorder_tic_related,1,[CF1,CF2,CF3,CF4],0.97,CF,true).

%	Body Dysmorphic Disorder, by insight specifier, and "with muscle dysmorphia"
%	(no substance/medical criterion)
disorder(body_dysmorphic_disorder_with_good_or_fair_insight,Patient,CF) :-
	disorder_nc(body_dysmorphic_disorder,Patient,CF1,true),
	selected(CF1,insight_specifier(insight_good_or_fair)),
	certainty(body_dysmorphic_disorder_with_good_or_fair_insight,1,[CF1],0.97,CF,true).
disorder(body_dysmorphic_disorder_with_poor_insight,Patient,CF) :-
	disorder_nc(body_dysmorphic_disorder,Patient,CF1,true),
	selected(CF1,insight_specifier(insight_poor)),
	certainty(body_dysmorphic_disorder_with_poor_insight,1,[CF1],0.97,CF,true).
disorder(body_dysmorphic_disorder_with_absent_insight,Patient,CF) :-
	disorder_nc(body_dysmorphic_disorder,Patient,CF1,true),
	selected(CF1,insight_specifier(insight_absent_or_delusional)),
	certainty(body_dysmorphic_disorder_with_absent_insight,1,[CF1],0.97,CF,true).
disorder(body_dysmorphic_disorder_with_muscle_dysmorphia,Patient,CF) :-
	disorder_nc(body_dysmorphic_disorder,Patient,CF1,true),
	unless_absent([CF1],symptomatic_feature(preoccupied_with_insufficient_muscularity,Patient,CF2,true),[CF2]),
	certainty(body_dysmorphic_disorder_with_muscle_dysmorphia,1,[CF1,CF2],0.97,CF,true).

%	Hoarding Disorder, by insight specifier, and "with excessive acquisition"
%	(medical exclusion only)
disorder(hoarding_disorder_with_good_or_fair_insight,Patient,CF) :-
	disorder_nc(hoarding_disorder,Patient,CF1,true),
	unless_absent([CF1],exclude_medical(Patient,CF2),[CF2]),
	selected(CF1,insight_specifier(insight_good_or_fair)),
	certainty(hoarding_disorder_with_good_or_fair_insight,1,[CF1,CF2],0.97,CF,true).
disorder(hoarding_disorder_with_poor_insight,Patient,CF) :-
	disorder_nc(hoarding_disorder,Patient,CF1,true),
	unless_absent([CF1],exclude_medical(Patient,CF2),[CF2]),
	selected(CF1,insight_specifier(insight_poor)),
	certainty(hoarding_disorder_with_poor_insight,1,[CF1,CF2],0.97,CF,true).
disorder(hoarding_disorder_with_absent_insight,Patient,CF) :-
	disorder_nc(hoarding_disorder,Patient,CF1,true),
	unless_absent([CF1],exclude_medical(Patient,CF2),[CF2]),
	selected(CF1,insight_specifier(insight_absent_or_delusional)),
	certainty(hoarding_disorder_with_absent_insight,1,[CF1,CF2],0.97,CF,true).
disorder(hoarding_disorder_with_excessive_acquisition,Patient,CF) :-
	disorder_nc(hoarding_disorder,Patient,CF1,true),
	unless_absent([CF1],
		( exclude_medical(Patient,CF2),
		  symptomatic_feature(excessive_acquisition_of_unneeded_items,Patient,CF3,true) ),[CF2,CF3]),
	certainty(hoarding_disorder_with_excessive_acquisition,1,[CF1,CF2,CF3],0.97,CF,true).

%	Trichotillomania (Hair-Pulling Disorder) (medical exclusion only)
disorder(trichotillomania,Patient,CF) :-
	disorder_nc(trichotillomania,Patient,CF1,true),
	unless_absent([CF1],exclude_medical(Patient,CF2),[CF2]),
	certainty(trichotillomania,1,[CF1,CF2],0.98,CF,true).

%	Excoriation (Skin-Picking) Disorder
disorder(excoriation_disorder,Patient,CF) :-
	primary(excoriation_disorder,Patient,CF1,CF2,CF3),
	certainty(excoriation_disorder,1,[CF1,CF2,CF3],0.98,CF,true).

%	Substance/Medication-Induced Obsessive-Compulsive and Related Disorder, by onset specifier
disorder(substance_induced_ocrd_with_onset_during_intoxication,Patient,CF) :-
	disorder_nc(substance_induced_ocrd,Patient,CF1,true),
	selected(CF1,onset_specifier(onset_during_intoxication)),
	certainty(substance_induced_ocrd_with_onset_during_intoxication,1,[CF1],0.97,CF,true).
disorder(substance_induced_ocrd_with_onset_during_withdrawal,Patient,CF) :-
	disorder_nc(substance_induced_ocrd,Patient,CF1,true),
	selected(CF1,onset_specifier(onset_during_withdrawal)),
	certainty(substance_induced_ocrd_with_onset_during_withdrawal,1,[CF1],0.97,CF,true).
disorder(substance_induced_ocrd_with_onset_after_medication_use,Patient,CF) :-
	disorder_nc(substance_induced_ocrd,Patient,CF1,true),
	selected(CF1,onset_specifier(onset_after_medication_use)),
	certainty(substance_induced_ocrd_with_onset_after_medication_use,1,[CF1],0.97,CF,true).

%	Obsessive-Compulsive and Related Disorder Due to Another Medical Condition, by presentation specifier
disorder(ocrd_due_to_another_medical_condition_with_ocd_like_symptoms,Patient,CF) :-
	disorder_nc(ocrd_due_to_another_medical_condition,Patient,CF1,true),
	selected(CF1,presentation_specifier(with_ocd_like_symptoms)),
	certainty(ocrd_due_to_another_medical_condition_with_ocd_like_symptoms,1,[CF1],0.97,CF,true).
disorder(ocrd_due_to_another_medical_condition_with_appearance_preoccupations,Patient,CF) :-
	disorder_nc(ocrd_due_to_another_medical_condition,Patient,CF1,true),
	selected(CF1,presentation_specifier(with_appearance_preoccupations)),
	certainty(ocrd_due_to_another_medical_condition_with_appearance_preoccupations,1,[CF1],0.97,CF,true).
disorder(ocrd_due_to_another_medical_condition_with_hoarding_symptoms,Patient,CF) :-
	disorder_nc(ocrd_due_to_another_medical_condition,Patient,CF1,true),
	selected(CF1,presentation_specifier(with_hoarding_symptoms)),
	certainty(ocrd_due_to_another_medical_condition_with_hoarding_symptoms,1,[CF1],0.97,CF,true).
disorder(ocrd_due_to_another_medical_condition_with_hair_pulling_symptoms,Patient,CF) :-
	disorder_nc(ocrd_due_to_another_medical_condition,Patient,CF1,true),
	selected(CF1,presentation_specifier(with_hair_pulling_symptoms)),
	certainty(ocrd_due_to_another_medical_condition_with_hair_pulling_symptoms,1,[CF1],0.97,CF,true).
disorder(ocrd_due_to_another_medical_condition_with_skin_picking_symptoms,Patient,CF) :-
	disorder_nc(ocrd_due_to_another_medical_condition,Patient,CF1,true),
	selected(CF1,presentation_specifier(with_skin_picking_symptoms)),
	certainty(ocrd_due_to_another_medical_condition_with_skin_picking_symptoms,1,[CF1],0.97,CF,true).


%====================TRAUMA- AND STRESSOR-RELATED DISORDERS=====================

%	Reactive Attachment Disorder, and its "persistent" and "severe" specifiers
disorder(reactive_attachment_disorder,Patient,CF) :-
	disorder_nc(reactive_attachment_disorder,Patient,CF1,true),
	certainty(reactive_attachment_disorder,1,[CF1],0.96,CF,true).
disorder(reactive_attachment_disorder_persistent,Patient,CF) :-
	disorder_nc(reactive_attachment_disorder,Patient,CF1,true),
	unless_absent([CF1],symptomatic_feature(disorder_present_more_than_twelve_months,Patient,CF2,true),[CF2]),
	certainty(reactive_attachment_disorder_persistent,1,[CF1,CF2],0.96,CF,true).
disorder(reactive_attachment_disorder_severe,Patient,CF) :-
	disorder_nc(reactive_attachment_disorder,Patient,CF1,true),
	unless_absent([CF1],symptomatic_feature(all_symptoms_at_relatively_high_levels,Patient,CF2,true),[CF2]),
	certainty(reactive_attachment_disorder_severe,1,[CF1,CF2],0.96,CF,true).

%	Disinhibited Social Engagement Disorder, and its "persistent" and "severe" specifiers
disorder(disinhibited_social_engagement_disorder,Patient,CF) :-
	disorder_nc(disinhibited_social_engagement_disorder,Patient,CF1,true),
	certainty(disinhibited_social_engagement_disorder,1,[CF1],0.96,CF,true).
disorder(disinhibited_social_engagement_disorder_persistent,Patient,CF) :-
	disorder_nc(disinhibited_social_engagement_disorder,Patient,CF1,true),
	unless_absent([CF1],symptomatic_feature(disorder_present_more_than_twelve_months,Patient,CF2,true),[CF2]),
	certainty(disinhibited_social_engagement_disorder_persistent,1,[CF1,CF2],0.96,CF,true).
disorder(disinhibited_social_engagement_disorder_severe,Patient,CF) :-
	disorder_nc(disinhibited_social_engagement_disorder,Patient,CF1,true),
	unless_absent([CF1],symptomatic_feature(all_symptoms_at_relatively_high_levels,Patient,CF2,true),[CF2]),
	certainty(disinhibited_social_engagement_disorder_severe,1,[CF1,CF2],0.96,CF,true).

%	Posttraumatic Stress Disorder, and its "with dissociative symptoms" and
%	"with delayed expression" specifiers
disorder(posttraumatic_stress_disorder,Patient,CF) :-
	primary(posttraumatic_stress_disorder,Patient,CF1,CF2,CF3),
	certainty(posttraumatic_stress_disorder,1,[CF1,CF2,CF3],0.98,CF,true).
disorder(posttraumatic_stress_disorder_with_dissociative_symptoms,Patient,CF) :-
	primary(posttraumatic_stress_disorder,Patient,CF1,CF2,CF3),
	unless_absent([CF1],symptomatic_feature(dissociative_symptoms,Patient,CF4,true),[CF4]),
	certainty(posttraumatic_stress_disorder_with_dissociative_symptoms,1,[CF1,CF2,CF3,CF4],0.98,CF,true).
disorder(posttraumatic_stress_disorder_with_delayed_expression,Patient,CF) :-
	primary(posttraumatic_stress_disorder,Patient,CF1,CF2,CF3),
	unless_absent([CF1],symptomatic_feature(full_criteria_not_met_until_six_months_after_event,Patient,CF4,true),[CF4]),
	certainty(posttraumatic_stress_disorder_with_delayed_expression,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Acute Stress Disorder
disorder(acute_stress_disorder,Patient,CF) :-
	primary(acute_stress_disorder,Patient,CF1,CF2,CF3),
	certainty(acute_stress_disorder,1,[CF1,CF2,CF3],0.97,CF,true).

%	Adjustment Disorders, by subtype (separately coded), and the acute /
%	persistent (chronic) course specifiers (criterion C excludes any other
%	mental disorder, so no separate substance/medical exclusion)
disorder(adjustment_disorder_with_depressed_mood,Patient,CF) :-
	disorder_nc(adjustment_disorder,Patient,CF1,true),
	selected(CF1,adjustment_subtype(with_depressed_mood)),
	certainty(adjustment_disorder_with_depressed_mood,1,[CF1],0.95,CF,true).
disorder(adjustment_disorder_with_anxiety,Patient,CF) :-
	disorder_nc(adjustment_disorder,Patient,CF1,true),
	selected(CF1,adjustment_subtype(with_anxiety)),
	certainty(adjustment_disorder_with_anxiety,1,[CF1],0.95,CF,true).
disorder(adjustment_disorder_with_mixed_anxiety_and_depressed_mood,Patient,CF) :-
	disorder_nc(adjustment_disorder,Patient,CF1,true),
	selected(CF1,adjustment_subtype(with_mixed_anxiety_and_depressed_mood)),
	certainty(adjustment_disorder_with_mixed_anxiety_and_depressed_mood,1,[CF1],0.95,CF,true).
disorder(adjustment_disorder_with_disturbance_of_conduct,Patient,CF) :-
	disorder_nc(adjustment_disorder,Patient,CF1,true),
	selected(CF1,adjustment_subtype(with_disturbance_of_conduct)),
	certainty(adjustment_disorder_with_disturbance_of_conduct,1,[CF1],0.95,CF,true).
disorder(adjustment_disorder_with_mixed_disturbance_of_emotions_and_conduct,Patient,CF) :-
	disorder_nc(adjustment_disorder,Patient,CF1,true),
	selected(CF1,adjustment_subtype(with_mixed_disturbance_emotions_conduct)),
	certainty(adjustment_disorder_with_mixed_disturbance_of_emotions_and_conduct,1,[CF1],0.95,CF,true).
disorder(adjustment_disorder_unspecified,Patient,CF) :-
	disorder_nc(adjustment_disorder,Patient,CF1,true),
	selected(CF1,adjustment_subtype(unspecified_adjustment)),
	certainty(adjustment_disorder_unspecified,1,[CF1],0.95,CF,true).
disorder(adjustment_disorder_acute,Patient,CF) :-
	disorder_nc(adjustment_disorder,Patient,CF1,true),
	unless_absent([CF1],symptomatic_feature(adjustment_acute_course,Patient,CF2,true),[CF2]),
	certainty(adjustment_disorder_acute,1,[CF1,CF2],0.95,CF,true).
disorder(adjustment_disorder_persistent,Patient,CF) :-
	disorder_nc(adjustment_disorder,Patient,CF1,true),
	unless_absent([CF1],symptomatic_feature(adjustment_persistent_course,Patient,CF2,true),[CF2]),
	certainty(adjustment_disorder_persistent,1,[CF1,CF2],0.95,CF,true).

%	Prolonged Grief Disorder
disorder(prolonged_grief_disorder,Patient,CF) :-
	primary(prolonged_grief_disorder,Patient,CF1,CF2,CF3),
	certainty(prolonged_grief_disorder,1,[CF1,CF2,CF3],0.97,CF,true).


%---------------------------LIST OF CODED DISORDERS-----------------------------
goals_list(L) :-
	findall(G,disorder_codes(G,_,_),L).

%	disorder_codes(Goal,ICD10CM,ICD11): metadata only. ICD10CM is the code
%	printed in DSM-5-TR; ICD11 is the ICD-11 MMS code of the corresponding
%	category (WHO, ICD-11 for Mortality and Morbidity Statistics, release
%	2026-01, https://icd.who.int/browse/2026-01/mms/en). The induced
%	disorders are coded by substance in both systems; acute stress disorder
%	corresponds to QE84 acute stress reaction, which ICD-11 does not classify
%	as a mental disorder.
disorder_codes(separation_anxiety_disorder,'F93.0','6B05').
disorder_codes(selective_mutism,'F94.0','6B06').
disorder_codes(specific_phobia_animal_type,'F40.218','6B03').
disorder_codes(specific_phobia_natural_environment_type,'F40.228','6B03').
disorder_codes(specific_phobia_blood_injection_injury_type,'F40.23x','6B03').
disorder_codes(specific_phobia_situational_type,'F40.248','6B03').
disorder_codes(specific_phobia_other_type,'F40.298','6B03').
disorder_codes(social_anxiety_disorder,'F40.10','6B04').
disorder_codes(social_anxiety_disorder_performance_only,'F40.10','6B04').
disorder_codes(panic_disorder,'F41.0','6B01').
disorder_codes(agoraphobia,'F40.00','6B02').
disorder_codes(generalized_anxiety_disorder,'F41.1','6B00').
disorder_codes(substance_induced_anxiety_disorder_with_onset_during_intoxication,'F1x.x80 (by substance)','6C4x.71 (by substance)').
disorder_codes(substance_induced_anxiety_disorder_with_onset_during_withdrawal,'F1x.x80 (by substance)','6C4x.71 (by substance)').
disorder_codes(substance_induced_anxiety_disorder_with_onset_after_medication_use,'F1x.x80 (by substance)','6C4x.71 (by substance)').
disorder_codes(anxiety_disorder_due_to_another_medical_condition,'F06.4','6E63').
disorder_codes(obsessive_compulsive_disorder_with_good_or_fair_insight,'F42.2','6B20.0').
disorder_codes(obsessive_compulsive_disorder_with_poor_insight,'F42.2','6B20.1').
disorder_codes(obsessive_compulsive_disorder_with_absent_insight,'F42.2','6B20.1').
disorder_codes(obsessive_compulsive_disorder_tic_related,'F42.2','6B20').
disorder_codes(body_dysmorphic_disorder_with_good_or_fair_insight,'F45.22','6B21.0').
disorder_codes(body_dysmorphic_disorder_with_poor_insight,'F45.22','6B21.1').
disorder_codes(body_dysmorphic_disorder_with_absent_insight,'F45.22','6B21.1').
disorder_codes(body_dysmorphic_disorder_with_muscle_dysmorphia,'F45.22','6B21').
disorder_codes(hoarding_disorder_with_good_or_fair_insight,'F42.3','6B24.0').
disorder_codes(hoarding_disorder_with_poor_insight,'F42.3','6B24.1').
disorder_codes(hoarding_disorder_with_absent_insight,'F42.3','6B24.1').
disorder_codes(hoarding_disorder_with_excessive_acquisition,'F42.3','6B24').
disorder_codes(trichotillomania,'F63.3','6B25.0').
disorder_codes(excoriation_disorder,'F42.4','6B25.1').
disorder_codes(substance_induced_ocrd_with_onset_during_intoxication,'F1x.x88 (by substance)','6C4x.72 (by substance)').
disorder_codes(substance_induced_ocrd_with_onset_during_withdrawal,'F1x.x88 (by substance)','6C4x.72 (by substance)').
disorder_codes(substance_induced_ocrd_with_onset_after_medication_use,'F1x.x88 (by substance)','6C4x.72 (by substance)').
disorder_codes(ocrd_due_to_another_medical_condition_with_ocd_like_symptoms,'F06.8','6E64').
disorder_codes(ocrd_due_to_another_medical_condition_with_appearance_preoccupations,'F06.8','6E64').
disorder_codes(ocrd_due_to_another_medical_condition_with_hoarding_symptoms,'F06.8','6E64').
disorder_codes(ocrd_due_to_another_medical_condition_with_hair_pulling_symptoms,'F06.8','6E64').
disorder_codes(ocrd_due_to_another_medical_condition_with_skin_picking_symptoms,'F06.8','6E64').
disorder_codes(reactive_attachment_disorder,'F94.1','6B44').
disorder_codes(reactive_attachment_disorder_persistent,'F94.1','6B44').
disorder_codes(reactive_attachment_disorder_severe,'F94.1','6B44').
disorder_codes(disinhibited_social_engagement_disorder,'F94.2','6B45').
disorder_codes(disinhibited_social_engagement_disorder_persistent,'F94.2','6B45').
disorder_codes(disinhibited_social_engagement_disorder_severe,'F94.2','6B45').
disorder_codes(posttraumatic_stress_disorder,'F43.10','6B40').
disorder_codes(posttraumatic_stress_disorder_with_dissociative_symptoms,'F43.10','6B40').
disorder_codes(posttraumatic_stress_disorder_with_delayed_expression,'F43.10','6B40').
disorder_codes(acute_stress_disorder,'F43.0','QE84').
disorder_codes(adjustment_disorder_with_depressed_mood,'F43.21','6B43').
disorder_codes(adjustment_disorder_with_anxiety,'F43.22','6B43').
disorder_codes(adjustment_disorder_with_mixed_anxiety_and_depressed_mood,'F43.23','6B43').
disorder_codes(adjustment_disorder_with_disturbance_of_conduct,'F43.24','6B43').
disorder_codes(adjustment_disorder_with_mixed_disturbance_of_emotions_and_conduct,'F43.25','6B43').
disorder_codes(adjustment_disorder_unspecified,'F43.20','6B43').
disorder_codes(adjustment_disorder_acute,'F43.2x','6B43').
disorder_codes(adjustment_disorder_persistent,'F43.2x','6B43').
disorder_codes(prolonged_grief_disorder,'F43.8','6B42').
