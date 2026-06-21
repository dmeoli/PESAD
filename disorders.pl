%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		disorders.pl
%
%	description:
%		Knowledge base - codable disorders (DSM-5-TR) across the Anxiety,
%		Obsessive-Compulsive and Related, and Trauma- and Stressor-Related
%		chapters. Each disorder/3 rule is a diagnostic goal combining
%		sub-disorders, types and exclusions; also holds the entry points
%		solve_goal/2, investigate_goals/1 and the goals list.
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
%		shared exclusion - the disturbance is not better attributable to a substance
%		or to another medical condition (both required to be false).
exclude_substance_and_medical(Patient,CF_Substance,CF_Medical) :-
	disorder_nc(associated_substance_induced_alteration,Patient,CF_Substance,false),
	disorder_nc(associated_general_medical_condition,Patient,CF_Medical,false).


%===============================ANXIETY DISORDERS===============================

%	Separation Anxiety Disorder
disorder(separation_anxiety_disorder,Patient,CF) :-
	disorder_nc(separation_anxiety_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(separation_anxiety_disorder,1,[CF1,CF2,CF3],0.97,CF,true).

%	Selective Mutism
disorder(selective_mutism,Patient,CF) :-
	disorder_nc(selective_mutism,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(selective_mutism,1,[CF1,CF2,CF3],0.97,CF,true).

%	Specific Phobia, Animal Type
disorder(specific_phobia_animal_type,Patient,CF) :-
	disorder_nc(specific_phobia,Patient,CF1,true),
	specific_phobia_type(animal_type,Patient,CF2,true),
	exclude_substance_and_medical(Patient,CF3,CF4),
	certainty(specific_phobia_animal_type,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Specific Phobia, Natural Environment Type
disorder(specific_phobia_natural_environment_type,Patient,CF) :-
	disorder_nc(specific_phobia,Patient,CF1,true),
	specific_phobia_type(natural_environment_type,Patient,CF2,true),
	exclude_substance_and_medical(Patient,CF3,CF4),
	certainty(specific_phobia_natural_environment_type,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Specific Phobia, Blood-Injection-Injury Type
disorder(specific_phobia_blood_injection_injury_type,Patient,CF) :-
	disorder_nc(specific_phobia,Patient,CF1,true),
	specific_phobia_type(blood_injection_injury_type,Patient,CF2,true),
	exclude_substance_and_medical(Patient,CF3,CF4),
	certainty(specific_phobia_blood_injection_injury_type,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Specific Phobia, Situational Type
disorder(specific_phobia_situational_type,Patient,CF) :-
	disorder_nc(specific_phobia,Patient,CF1,true),
	specific_phobia_type(situational_type,Patient,CF2,true),
	exclude_substance_and_medical(Patient,CF3,CF4),
	certainty(specific_phobia_situational_type,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Specific Phobia, Other Type
disorder(specific_phobia_other_type,Patient,CF) :-
	disorder_nc(specific_phobia,Patient,CF1,true),
	specific_phobia_type(other_type,Patient,CF2,true),
	exclude_substance_and_medical(Patient,CF3,CF4),
	certainty(specific_phobia_other_type,1,[CF1,CF2,CF3,CF4],0.98,CF,true).

%	Social Anxiety Disorder
disorder(social_anxiety_disorder,Patient,CF) :-
	disorder_nc(social_anxiety_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(social_anxiety_disorder,1,[CF1,CF2,CF3],0.98,CF,true).

%	Panic Disorder
disorder(panic_disorder,Patient,CF) :-
	disorder_nc(panic_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(panic_disorder,1,[CF1,CF2,CF3],0.97,CF,true).

%	Agoraphobia
disorder(agoraphobia,Patient,CF) :-
	disorder_nc(agoraphobia,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(agoraphobia,1,[CF1,CF2,CF3],0.98,CF,true).

%	Generalized Anxiety Disorder
disorder(generalized_anxiety_disorder,Patient,CF) :-
	disorder_nc(generalized_anxiety_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(generalized_anxiety_disorder,1,[CF1,CF2,CF3],0.97,CF,true).

%	Substance/Medication-Induced Anxiety Disorder
disorder(substance_induced_anxiety_disorder,Patient,CF) :-
	symptomatic_manifestation(predominant_anxiety,Patient,CF1,true),
	symptomatic_feature(substance_etiology,Patient,CF2,true),
	symptomatic_feature(not_delirium_bound,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	certainty(substance_induced_anxiety_disorder,1,[CF1,CF2,CF3,CF4],0.90,CF,true).

%	Anxiety Disorder Due to Another Medical Condition
disorder(anxiety_disorder_due_to_another_medical_condition,Patient,CF) :-
	symptomatic_manifestation(predominant_anxiety,Patient,CF1,true),
	symptomatic_feature(medical_etiology,Patient,CF2,true),
	symptomatic_feature(not_delirium_bound,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	certainty(anxiety_disorder_due_to_another_medical_condition,1,[CF1,CF2,CF3,CF4],0.90,CF,true).


%==================OBSESSIVE-COMPULSIVE AND RELATED DISORDERS===================

%	Obsessive-Compulsive Disorder (with the DSM-5-TR insight specifier)
disorder(obsessive_compulsive_disorder_with_good_or_fair_insight,Patient,CF) :-
	insight_specifier(insight_good_or_fair),
	disorder_nc(obsessive_compulsive_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(obsessive_compulsive_disorder_with_good_or_fair_insight,1,[CF1,CF2,CF3],0.97,CF,true).
disorder(obsessive_compulsive_disorder_with_poor_insight,Patient,CF) :-
	insight_specifier(insight_poor),
	disorder_nc(obsessive_compulsive_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(obsessive_compulsive_disorder_with_poor_insight,1,[CF1,CF2,CF3],0.97,CF,true).
disorder(obsessive_compulsive_disorder_with_absent_insight,Patient,CF) :-
	insight_specifier(insight_absent_or_delusional),
	disorder_nc(obsessive_compulsive_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(obsessive_compulsive_disorder_with_absent_insight,1,[CF1,CF2,CF3],0.97,CF,true).

%	Body Dysmorphic Disorder (with the DSM-5-TR insight specifier)
disorder(body_dysmorphic_disorder_with_good_or_fair_insight,Patient,CF) :-
	insight_specifier(insight_good_or_fair),
	disorder_nc(body_dysmorphic_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(body_dysmorphic_disorder_with_good_or_fair_insight,1,[CF1,CF2,CF3],0.97,CF,true).
disorder(body_dysmorphic_disorder_with_poor_insight,Patient,CF) :-
	insight_specifier(insight_poor),
	disorder_nc(body_dysmorphic_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(body_dysmorphic_disorder_with_poor_insight,1,[CF1,CF2,CF3],0.97,CF,true).
disorder(body_dysmorphic_disorder_with_absent_insight,Patient,CF) :-
	insight_specifier(insight_absent_or_delusional),
	disorder_nc(body_dysmorphic_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(body_dysmorphic_disorder_with_absent_insight,1,[CF1,CF2,CF3],0.97,CF,true).

%	Hoarding Disorder (with the DSM-5-TR insight specifier)
disorder(hoarding_disorder_with_good_or_fair_insight,Patient,CF) :-
	insight_specifier(insight_good_or_fair),
	disorder_nc(hoarding_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(hoarding_disorder_with_good_or_fair_insight,1,[CF1,CF2,CF3],0.97,CF,true).
disorder(hoarding_disorder_with_poor_insight,Patient,CF) :-
	insight_specifier(insight_poor),
	disorder_nc(hoarding_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(hoarding_disorder_with_poor_insight,1,[CF1,CF2,CF3],0.97,CF,true).
disorder(hoarding_disorder_with_absent_insight,Patient,CF) :-
	insight_specifier(insight_absent_or_delusional),
	disorder_nc(hoarding_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(hoarding_disorder_with_absent_insight,1,[CF1,CF2,CF3],0.97,CF,true).

%	Trichotillomania (Hair-Pulling Disorder)
disorder(trichotillomania,Patient,CF) :-
	disorder_nc(trichotillomania,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(trichotillomania,1,[CF1,CF2,CF3],0.98,CF,true).

%	Excoriation (Skin-Picking) Disorder
disorder(excoriation_disorder,Patient,CF) :-
	disorder_nc(excoriation_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(excoriation_disorder,1,[CF1,CF2,CF3],0.98,CF,true).

%	Substance/Medication-Induced Obsessive-Compulsive and Related Disorder
disorder(substance_induced_ocrd,Patient,CF) :-
	symptomatic_manifestation(predominant_oc_presentation,Patient,CF1,true),
	symptomatic_feature(substance_etiology,Patient,CF2,true),
	symptomatic_feature(not_delirium_bound,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	certainty(substance_induced_ocrd,1,[CF1,CF2,CF3,CF4],0.88,CF,true).

%	Obsessive-Compulsive and Related Disorder Due to Another Medical Condition
disorder(ocrd_due_to_another_medical_condition,Patient,CF) :-
	symptomatic_manifestation(predominant_oc_presentation,Patient,CF1,true),
	symptomatic_feature(medical_etiology,Patient,CF2,true),
	symptomatic_feature(not_delirium_bound,Patient,CF3,true),
	symptomatic_manifestation(significant_distress,Patient,CF4,true),
	certainty(ocrd_due_to_another_medical_condition,1,[CF1,CF2,CF3,CF4],0.88,CF,true).


%====================TRAUMA- AND STRESSOR-RELATED DISORDERS=====================

%	Reactive Attachment Disorder
disorder(reactive_attachment_disorder,Patient,CF) :-
	disorder_nc(reactive_attachment_disorder,Patient,CF1,true),
	certainty(reactive_attachment_disorder,1,[CF1],0.96,CF,true).

%	Disinhibited Social Engagement Disorder
disorder(disinhibited_social_engagement_disorder,Patient,CF) :-
	disorder_nc(disinhibited_social_engagement_disorder,Patient,CF1,true),
	certainty(disinhibited_social_engagement_disorder,1,[CF1],0.96,CF,true).

%	Posttraumatic Stress Disorder
disorder(posttraumatic_stress_disorder,Patient,CF) :-
	disorder_nc(posttraumatic_stress_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(posttraumatic_stress_disorder,1,[CF1,CF2,CF3],0.98,CF,true).

%	Acute Stress Disorder
disorder(acute_stress_disorder,Patient,CF) :-
	disorder_nc(acute_stress_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(acute_stress_disorder,1,[CF1,CF2,CF3],0.97,CF,true).

%	Adjustment Disorder
disorder(adjustment_disorder,Patient,CF) :-
	disorder_nc(adjustment_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(adjustment_disorder,1,[CF1,CF2,CF3],0.95,CF,true).

%	Prolonged Grief Disorder
disorder(prolonged_grief_disorder,Patient,CF) :-
	disorder_nc(prolonged_grief_disorder,Patient,CF1,true),
	exclude_substance_and_medical(Patient,CF2,CF3),
	certainty(prolonged_grief_disorder,1,[CF1,CF2,CF3],0.97,CF,true).


%----------------------------LIST OF CODED DISORDERS----------------------------
goals_list([separation_anxiety_disorder,selective_mutism,specific_phobia_animal_type,specific_phobia_natural_environment_type,specific_phobia_blood_injection_injury_type,specific_phobia_situational_type,specific_phobia_other_type,social_anxiety_disorder,panic_disorder,agoraphobia,generalized_anxiety_disorder,substance_induced_anxiety_disorder,anxiety_disorder_due_to_another_medical_condition,obsessive_compulsive_disorder_with_good_or_fair_insight,obsessive_compulsive_disorder_with_poor_insight,obsessive_compulsive_disorder_with_absent_insight,body_dysmorphic_disorder_with_good_or_fair_insight,body_dysmorphic_disorder_with_poor_insight,body_dysmorphic_disorder_with_absent_insight,hoarding_disorder_with_good_or_fair_insight,hoarding_disorder_with_poor_insight,hoarding_disorder_with_absent_insight,trichotillomania,excoriation_disorder,substance_induced_ocrd,ocrd_due_to_another_medical_condition,reactive_attachment_disorder,disinhibited_social_engagement_disorder,posttraumatic_stress_disorder,acute_stress_disorder,adjustment_disorder,prolonged_grief_disorder]).
