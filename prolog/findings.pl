%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		findings.pl
%
%	description:
%		Knowledge base - the results of tests and records that an evaluation
%		from facts (evaluate.pl) accepts, and the criterion items each one
%		supports. A finding gives evidence for an item with a degree in
%		[0,1], the membership of its score to the cutoff of the criterion,
%		scaled by the weight of the source; evidence is confirmatory (a
%		structured interview, a standardized test, a document) or provisional
%		(a screening scale, which suggests a criterion but cannot establish
%		it). The cutoffs are those of the instruments' manuals and of the
%		DSM-5-TR text; the scores themselves are entered by the clinician.
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%	finding(Id,Type,Description): Type is integer(Min,Max), number(Min,Max)
%	or boolean; Description is the documentation of the finding.
finding(diva5_inattention_count,integer(0,9),'DIVA-5: inattention symptoms present in adulthood (A1)').
finding(diva5_hyperactivity_count,integer(0,9),'DIVA-5: hyperactivity-impulsivity symptoms present in adulthood (A2)').
finding(diva5_childhood_inattention_count,integer(0,9),'DIVA-5: inattention symptoms present in childhood (B)').
finding(diva5_childhood_hyperactivity_count,integer(0,9),'DIVA-5: hyperactivity-impulsivity symptoms present in childhood (B)').
finding(informant_confirms_childhood_symptoms,boolean,'A parent, partner or record confirms (true) or contradicts (false) the childhood symptoms (B)').
finding(school_report_symptoms_before_twelve,boolean,'School reports document inattentive or hyperactive-impulsive symptoms before age 12 (B)').
finding(settings_with_symptoms,integer(0,10),'Number of settings (home, school, work, friends, other) with several symptoms (C)').
finding(asrs_inattention_count,integer(0,9),'ASRS v1.1 (screening): inattention items in the shaded range (A1, provisional)').
finding(asrs_hyperactivity_count,integer(0,9),'ASRS v1.1 (screening): hyperactivity-impulsivity items in the shaded range (A2, provisional)').
finding(aq_total,integer(0,50),'Autism-Spectrum Quotient total, cutoff 32 (ASD A, provisional)').
finding(raads_r_total,integer(0,240),'RAADS-R total, cutoff 65 (ASD A, provisional)').
finding(raads_r_social_relatedness,integer(0,117),'RAADS-R social relatedness, cutoff 31 (ASD A1, A3, provisional)').
finding(raads_r_language,integer(0,21),'RAADS-R language, cutoff 4 (ASD A2, provisional)').
finding(raads_r_circumscribed_interests,integer(0,42),'RAADS-R circumscribed interests, cutoff 15 (ASD B2, B3, provisional)').
finding(raads_r_sensory_motor,integer(0,60),'RAADS-R sensory-motor, cutoff 16 (ASD B1, B4, provisional)').
finding(adir_social,integer(0,30),'ADI-R algorithm A, reciprocal social interaction, cutoff 10 (ASD A, confirmatory)').
finding(adir_communication,integer(0,26),'ADI-R algorithm B, communication, cutoff 8 (ASD A2, confirmatory)').
finding(adir_restricted,integer(0,12),'ADI-R algorithm C, restricted, repetitive behaviours, cutoff 3 (ASD B, confirmatory)').
finding(adir_onset,integer(0,5),'ADI-R algorithm D, abnormality evident by 36 months, cutoff 1 (ASD C, confirmatory)').
finding(developmental_history_early_onset,boolean,'The developmental history places the first signs in the early developmental period').
finding(asd_support_level_social_communication,integer(1,3),'Level of support needed for social communication (ASD severity)').
finding(asd_support_level_restricted_behaviour,integer(1,3),'Level of support needed for restricted, repetitive behaviours (ASD severity)').
finding(iq_full_scale,number(20,160),'Full-scale IQ from an individually administered standardized test (IDD A; ASD, SLD, language disorder)').
finding(adaptive_behaviour_composite,number(20,160),'Adaptive behaviour composite standard score, e.g., Vineland-3 or ABAS-3 (IDD B)').
finding(reading_standard_score,number(20,160),'Standardized reading achievement score (SLD B, reading)').
finding(written_expression_standard_score,number(20,160),'Standardized written expression achievement score (SLD B, written expression)').
finding(mathematics_standard_score,number(20,160),'Standardized mathematics achievement score (SLD B, mathematics)').
finding(intervention_months,number(0,240),'Months of targeted intervention during which the learning difficulties persisted (SLD A)').
finding(school_report_learning_difficulties,boolean,'School reports document the learning difficulties during the school years (SLD C)').
finding(language_standard_score,number(20,160),'Standardized language composite score (language disorder B; ASD language specifier)').
finding(mabc2_total_percentile,number(0,100),'Movement ABC-2 total score percentile (DCD A)').
finding(tic_onset_age,number(0,99),'Age in years at the first tic (tic disorders C)').
finding(tic_duration_months,number(0,1200),'Months since the first tic (tic disorders B)').
finding(symptom_duration_months,number(0,1200),'Months the current symptoms have lasted').

%	finding_evidence(Id,Value,Evidence): the evidence given by a finding, one
%	of item(Item,Degree,Kind), count(Count,N,Weight,Kind), childhood(N),
%	informant(Agrees), choice(Question,Option) and value(Variable,N).

% ADHD: symptom counts of a structured interview (DIVA-5) or a screening scale
finding_evidence(diva5_inattention_count,N,count(inattention_symptom_count,N,0.95,confirmatory)).
finding_evidence(diva5_hyperactivity_count,N,count(hyperactivity_impulsivity_symptom_count,N,0.95,confirmatory)).
finding_evidence(asrs_inattention_count,N,count(inattention_symptom_count,N,0.8,provisional)).
finding_evidence(asrs_hyperactivity_count,N,count(hyperactivity_impulsivity_symptom_count,N,0.8,provisional)).
finding_evidence(diva5_childhood_inattention_count,N,childhood(N)).
finding_evidence(diva5_childhood_hyperactivity_count,N,childhood(N)).
finding_evidence(informant_confirms_childhood_symptoms,B,informant(B)).
finding_evidence(school_report_symptoms_before_twelve,B,item(several_symptoms_before_age_twelve,D,confirmatory)) :-
	boolean_degree(B,0.9,D).
finding_evidence(settings_with_symptoms,N,item(symptoms_in_two_or_more_settings,D,confirmatory)) :-
	ramp_up(N,1,2,Mu),
	D is 0.95*Mu.

% ASD: screening scales (provisional), scored on their published cutoffs
finding_evidence(aq_total,S,item(I,D,provisional)) :-
	member(I,[social_emotional_reciprocity_deficits,nonverbal_communication_deficits,relationship_deficits]),
	screening_degree(S,26,32,D).
finding_evidence(raads_r_total,S,item(I,D,provisional)) :-
	member(I,[social_emotional_reciprocity_deficits,nonverbal_communication_deficits,relationship_deficits]),
	screening_degree(S,55,65,D).
finding_evidence(raads_r_social_relatedness,S,item(I,D,provisional)) :-
	member(I,[social_emotional_reciprocity_deficits,relationship_deficits]),
	screening_degree(S,25,31,D).
finding_evidence(raads_r_language,S,item(nonverbal_communication_deficits,D,provisional)) :-
	screening_degree(S,2,4,D).
finding_evidence(raads_r_circumscribed_interests,S,item(I,D,provisional)) :-
	member(I,[insistence_on_sameness,restricted_fixated_interests]),
	screening_degree(S,12,15,D).
finding_evidence(raads_r_sensory_motor,S,item(I,D,provisional)) :-
	member(I,[stereotyped_or_repetitive_behaviour,sensory_reactivity_or_interest]),
	screening_degree(S,13,16,D).

% ASD: ADI-R, a structured diagnostic interview (confirmatory), on its
% algorithm cutoffs; a ramp that is null well below the cutoff and unit at it.
finding_evidence(adir_social,S,item(I,D,confirmatory)) :-
	member(I,[social_emotional_reciprocity_deficits,relationship_deficits]),
	ramp_up(S,6,10,D).
finding_evidence(adir_communication,S,item(nonverbal_communication_deficits,D,confirmatory)) :-
	ramp_up(S,5,8,D).
finding_evidence(adir_restricted,S,item(I,D,confirmatory)) :-
	member(I,[stereotyped_or_repetitive_behaviour,insistence_on_sameness,restricted_fixated_interests,sensory_reactivity_or_interest]),
	ramp_up(S,1,3,D).
finding_evidence(adir_onset,S,item(onset_in_early_developmental_period,D,confirmatory)) :-
	ramp_up(S,0,1,D).
finding_evidence(developmental_history_early_onset,B,item(onset_in_early_developmental_period,D,confirmatory)) :-
	boolean_degree(B,0.9,D).
finding_evidence(asd_support_level_social_communication,L,choice(asd_social_communication_support,O)) :-
	nth1(L,[requiring_support,requiring_substantial_support,requiring_very_substantial_support],O).
finding_evidence(asd_support_level_restricted_behaviour,L,choice(asd_restricted_behaviour_support,O)) :-
	nth1(L,[requiring_support,requiring_substantial_support,requiring_very_substantial_support],O).

% IQ and adaptive functioning: about 2 standard deviations below the mean
% (70, with 5 points of measurement error) on a scale of mean 100, SD 15
finding_evidence(iq_full_scale,IQ,item(I,D,confirmatory)) :-
	member(I,[intellectual_deficits_on_standardized_testing,accompanying_intellectual_impairment]),
	ramp_down(IQ,70,76,D).
%	an IQ in the normal range rules out that intellectual disability explains
%	another disorder; a low IQ only suggests it, the clinician decides
finding_evidence(iq_full_scale,IQ,item(I,D,Kind)) :-
	member(I,[autistic_features_better_explained_by_intellectual_disability,learning_difficulties_explained_by_intellectual_disability,language_difficulties_better_explained_by_intellectual_disability]),
	ramp_down(IQ,70,76,D),
	( D =:= 0 -> Kind = confirmatory ; Kind = provisional ).
finding_evidence(adaptive_behaviour_composite,S,item(adaptive_functioning_deficits,D,confirmatory)) :-
	ramp_down(S,70,76,D).

% Academic achievement: 1.5 SD below the mean (78) for the greatest certainty,
% down to 1 SD (85) with converging evidence (DSM-5-TR, p. 79)
finding_evidence(reading_standard_score,S,item(reading_skills_below_age,D,confirmatory)) :-
	ramp_down(S,78,85,D).
finding_evidence(written_expression_standard_score,S,item(written_expression_skills_below_age,D,confirmatory)) :-
	ramp_down(S,78,85,D).
finding_evidence(mathematics_standard_score,S,item(mathematics_skills_below_age,D,confirmatory)) :-
	ramp_down(S,78,85,D).
finding_evidence(intervention_months,M,item(difficulties_persist_despite_interventions,D,confirmatory)) :-
	ramp_up(M,3,6,D).
finding_evidence(school_report_learning_difficulties,B,item(learning_difficulties_began_in_school_years,D,confirmatory)) :-
	boolean_degree(B,0.9,D).

% Language and motor tests
finding_evidence(language_standard_score,S,item(I,D,confirmatory)) :-
	member(I,[language_abilities_substantially_below_age,accompanying_language_impairment]),
	ramp_down(S,78,85,D).
finding_evidence(mabc2_total_percentile,P,item(motor_skills_substantially_below_age,D,confirmatory)) :-
	ramp_down(P,5,16,D).

% Tics and durations
finding_evidence(tic_onset_age,A,item(tic_onset_before_age_eighteen,D,confirmatory)) :-
	( A < 18 -> D = 1.0 ; D = 0.0 ).
finding_evidence(tic_duration_months,M,item(tics_persisted_more_than_one_year,D,confirmatory)) :-
	ramp_up(M,12,13,D).
finding_evidence(symptom_duration_months,M,value(duration_months,M)).
finding_evidence(symptom_duration_months,M,choice(symptoms_duration,O)) :-
	duration_option(M,O).

%	childhood_evidence(Total,Informant,Degree): criterion B from the childhood
%	counts of the interview: "several" symptoms (3 or more, soft from 1),
%	weighted by the corroboration of an informant, since the recall of
%	childhood symptoms alone is unreliable (DSM-5-TR, p. 70).
childhood_evidence(Total,Informant,Degree) :-
	ramp_up(Total,1,3,Mu),
	informant_weight(Informant,W),
	Degree is W*Mu.

informant_weight(true,0.95).
informant_weight(none,0.8).
informant_weight(false,0.45).

%	screening_degree(Score,Low,Cutoff,Degree): a screening score up to Cutoff,
%	weighted 0.8 (screening scales are provisional evidence anyway).
screening_degree(S,Low,Cutoff,D) :-
	ramp_up(S,Low,Cutoff,Mu),
	D is 0.8*Mu.

%	boolean_degree(Value,Weight,Degree): a yes/no record as evidence.
boolean_degree(true,W,W).
boolean_degree(false,W,D) :-
	D is 1-W.

%	duration_option(Months,Option): the option of the duration question.
duration_option(M,less_than_three_days) :- M < 0.1, !.
duration_option(M,three_days_to_one_month) :- M < 1, !.
duration_option(M,one_to_three_months) :- M < 3, !.
duration_option(M,three_to_six_months) :- M < 6, !.
duration_option(_,six_months_or_more).
