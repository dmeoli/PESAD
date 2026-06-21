%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		interface_en.pl
%
%	description:
%		English localization (DSM-5-TR): label/3 and explanation/3 facts keyed on
%		language-neutral English atoms, plus the English command vocabulary.
%		Selected at runtime via language(en).
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ---- system / interface labels ----
label(en, system_presentation, '-------------------------------------------------------------------\n-- PESAD - Prolog Expert System for Anxiety,\n--         Obsessive-Compulsive and Trauma-Related Disorders\n--\n--	knowledge base: DSM-5-TR\n--	author:         Donato Meoli\n-------------------------------------------------------------------\n') :- !.
label(en, available_commands, 'Available commands:') :- !.
label(en, method_request, 'Select the uncertainty method:') :- !.
label(en, method_cf, 'Certainty factors (minimum t-norm)') :- !.
label(en, method_fuzzy, 'Fuzzy logic (product t-norm)') :- !.
label(en, method_fuzzy_membership, 'Fuzzy logic with membership functions (graded duration/frequency)') :- !.
label(en, duration_months, 'For how many months have the symptoms been present (enter a number)') :- !.
label(en, panic_attacks_count, 'How many panic attacks have occurred (enter a number)') :- !.
label(en, command_investigation, '	investigation.	- Run the full investigation of all disorders;') :- !.
label(en, command_control, '	control.	- Run the check of a single disorder;') :- !.
label(en, command_facts, '	facts.		- Show the asserted facts;') :- !.
label(en, command_help, '	help.		- Show the list of available commands;') :- !.
label(en, command_clean, '	clean.		- Clear the memory;') :- !.
label(en, command_quit, '	quit.		- Close the interface.') :- !.
label(en, command_error, 'Wrong command, please try again ') :- !.
label(en, answer_error, 'Wrong answer, please answer again') :- !.
label(en, certainty_error, 'Wrong certainty value, please enter a value ') :- !.
label(en, diagnosis, '========================== DIAGNOSIS ==========================') :- !.
label(en, certainty, ' with a certainty degree of ') :- !.
label(en, certainty_request, 'Enter the certainty degree ') :- !.
label(en, certainty_hint, '(from 0.0 to 1.0)') :- !.
label(en, yes_no_hint, '(yes, no)') :- !.
label(en, option_request, 'Enter the code corresponding to the chosen option') :- !.
label(en, goal_request, 'Which of the following disorders do you want to check') :- !.
label(en, diagnosis_result, 'The patient suffers from ') :- !.
label(en, patient, 'What is the patient''s age range') :- !.
label(en, how_request_control, 'Do you want to know how it was deduced') :- !.
label(en, how_request_investigation, 'Do you want to know how they were deduced') :- !.
label(en, true_label, ' is true with CF ') :- !.
label(en, false_label, ' is false with CF ') :- !.
label(en, deduced, ' was deduced from') :- !.
label(en, stated, ' was stated') :- !.
label(en, code, ' Code: ') :- !.
label(en, facts, '============================ FACTS ============================') :- !.

% ---- domain labels ----
label(en, abrupt_surge_of_fear_or_discomfort, 'Experiences an abrupt surge of intense fear or discomfort that peaks within minutes') :- !.
label(en, accumulation_clutters_living_areas, 'Has an accumulation of possessions that congests and clutters active living areas') :- !.
label(en, acute_stress_disorder, 'Acute Stress Disorder') :- !.
label(en, acute_stress_symptoms, 'Acute Stress Symptoms') :- !.
label(en, adjustment_disorder, 'Adjustment Disorder') :- !.
label(en, adjustment_onset_within_three_months, 'Onset Within 3 Months of the Stressor') :- !.
label(en, adjustment_subtype, 'What is the predominant symptom presentation') :- !.
label(en, adolescent, '13-17 years') :- !.
label(en, adult, '>= 18 years') :- !.
label(en, agoraphobia, 'Agoraphobia') :- !.
label(en, agoraphobic_anxiety, 'Agoraphobic Anxiety') :- !.
label(en, altered_sense_of_reality, 'Has an altered sense of the reality of their surroundings or themselves (e.g., daze, time slowing)') :- !.
label(en, animal_type, 'Animal Type') :- !.
label(en, another_medical_condition, 'Has another medical condition that could account for the symptoms') :- !.
label(en, anxiety_disorder_due_to_another_medical_condition, 'Anxiety Disorder Due to Another Medical Condition') :- !.
label(en, anxiety_type, 'What is the main reason for the anxiety') :- !.
label(en, appearance_preoccupation, 'Preoccupation with Perceived Appearance Defects') :- !.
label(en, apprehensive_expectation, 'Apprehensive expectation about a number of events or activities') :- !.
label(en, arousal_alterations, 'Alterations in Arousal and Reactivity') :- !.
label(en, associated_general_medical_condition, 'Associated General Medical Condition') :- !.
label(en, associated_substance_induced_alteration, 'Associated Substance/Medication-Induced Alteration') :- !.
label(en, attack_type, 'When does the episode occur') :- !.
label(en, avoidance, 'Actively avoids them') :- !.
label(en, avoidance_of_external_trauma_reminders, 'Avoids external reminders (people, places, conversations, activities, objects) associated with the trauma') :- !.
label(en, avoidance_of_reminders_of_death, 'Avoids reminders that the person is dead') :- !.
label(en, avoidance_of_trauma_thoughts_or_feelings, 'Avoids distressing memories, thoughts, or feelings about the traumatic event') :- !.
label(en, avoidance_or_negative_cognitions, 'Avoidance or Negative Alterations in Cognitions and Mood') :- !.
label(en, being_easily_fatigued, 'Is easily fatigued') :- !.
label(en, bereavement_at_least_twelve_months, 'Bereavement of at Least 12 Months') :- !.
label(en, bereavement_time, 'How long ago did the death occur') :- !.
label(en, blood_injection_injury_type, 'Blood-Injection-Injury Type') :- !.
label(en, body_dysmorphic_disorder, 'Body Dysmorphic Disorder') :- !.
label(en, chest_pain, 'Experiences chest pain or discomfort') :- !.
label(en, child, '7-12 years') :- !.
label(en, chills_or_hot_flushes, 'Experiences chills or heat sensations') :- !.
label(en, choking, 'Experiences a feeling of choking') :- !.
label(en, comparing_appearance_with_others, 'Compares their appearance with that of others') :- !.
label(en, consistent_failure_to_speak, 'Consistent Failure to Speak in Specific Social Situations') :- !.
label(en, cued_attack, 'On exposure to or anticipation of a trigger') :- !.
label(en, derealization_or_depersonalization, 'Experiences derealization or depersonalization') :- !.
label(en, detachment_from_others, 'Feels detached or estranged from others') :- !.
label(en, difficulty_concentrating, 'Has difficulty concentrating or mind going blank') :- !.
label(en, difficulty_controlling_worry, 'Finds it difficult to control the worry') :- !.
label(en, difficulty_discarding_possessions, 'Has persistent difficulty discarding or parting with possessions, regardless of their value') :- !.
label(en, difficulty_escaping_or_help_unavailable, 'Escape might be difficult or help unavailable in case of panic-like symptoms') :- !.
label(en, difficulty_reintegrating, 'Has difficulty reintegrating into relationships and activities after the death') :- !.
label(en, diminished_interest, 'Has markedly diminished interest or participation in significant activities') :- !.
label(en, directly_experiencing_trauma, 'Directly experienced the traumatic event') :- !.
label(en, disbelief_about_the_death, 'Has a marked sense of disbelief about the death') :- !.
label(en, disinhibited_behaviour_with_strangers, 'Disinhibited Behaviour with Unfamiliar Adults') :- !.
label(en, disinhibited_social_engagement_disorder, 'Disinhibited Social Engagement Disorder') :- !.
label(en, dissociative_amnesia_of_trauma, 'Is unable to remember an important aspect of the traumatic event (dissociative amnesia)') :- !.
label(en, dissociative_flashbacks, 'Has dissociative reactions or flashbacks in which the event feels as though it were recurring') :- !.
label(en, distorted_blame, 'Has persistent, distorted cognitions leading to blaming themselves or others for the trauma') :- !.
label(en, distress_associated_with_discarding, 'Experiences distress associated with discarding possessions and a perceived need to save them') :- !.
label(en, distress_at_separation_from_attachment_figures, 'Experiences recurrent excessive distress when anticipating or experiencing separation from attachment figures') :- !.
label(en, distress_at_trauma_cues, 'Experiences intense or prolonged psychological distress at exposure to cues that resemble the trauma') :- !.
label(en, distressing_dreams, 'Has recurrent distressing dreams related to the traumatic event') :- !.
label(en, does_not_check_back_with_caregiver, 'Shows diminished or absent checking back with the caregiver after venturing away') :- !.
label(en, duration_at_least_one_month, 'Duration of at Least 1 Month') :- !.
label(en, duration_at_least_six_months, 'Duration of at Least 6 Months') :- !.
label(en, duration_three_days_to_one_month, 'Duration of 3 Days to 1 Month') :- !.
label(en, dyspnea, 'Experiences shortness of breath or a feeling of smothering') :- !.
label(en, emotional_numbness, 'Experiences emotional numbness (absence of or marked reduction in emotion)') :- !.
label(en, emotional_or_behavioural_symptoms_after_stressor, 'Developed emotional or behavioural symptoms in response to an identifiable stressor') :- !.
label(en, endurance_with_distress, 'Endures them with intense distress') :- !.
label(en, endurance_without_problems, 'Tolerates them without problems') :- !.
label(en, exaggerated_startle_response, 'Has an exaggerated startle response') :- !.
label(en, excessive_grooming, 'Engages in excessive grooming') :- !.
label(en, excessive_separation_fear, 'Excessive Fear or Anxiety Concerning Separation') :- !.
label(en, excessive_uncontrollable_worry, 'Excessive and Uncontrollable Worry') :- !.
label(en, excessive_worry_about_several_events, 'Has excessive anxiety and worry about a number of events or activities') :- !.
label(en, excoriation_disorder, 'Excoriation (Skin-Picking) Disorder') :- !.
label(en, failure_to_speak_in_specific_social_situations, 'Consistently fails to speak in specific social situations where speaking is expected') :- !.
label(en, fear_almost_always_provoked, 'The feared object or situation almost always provokes immediate fear or anxiety') :- !.
label(en, fear_of_animals, 'Has marked fear or anxiety about animals (e.g., spiders, insects, dogs)') :- !.
label(en, fear_of_being_alone, 'Has persistent excessive fear of or reluctance about being alone without attachment figures') :- !.
label(en, fear_of_being_outside_home_alone, 'Has marked fear or anxiety about being outside of the home alone') :- !.
label(en, fear_of_blood_injection_injury, 'Has marked fear or anxiety about blood, injections, or injury (e.g., needles, invasive procedures)') :- !.
label(en, fear_of_dying, 'Experiences a fear of dying') :- !.
label(en, fear_of_enclosed_places, 'Has marked fear or anxiety about being in enclosed places (e.g., shops, theatres, cinemas)') :- !.
label(en, fear_of_losing_control, 'Experiences a fear of losing control or going crazy') :- !.
label(en, fear_of_natural_environment, 'Has marked fear or anxiety about the natural environment (e.g., heights, storms, water)') :- !.
label(en, fear_of_negative_evaluation, 'Fears acting in a way, or showing anxiety symptoms, that will be negatively evaluated') :- !.
label(en, fear_of_open_spaces, 'Has marked fear or anxiety about being in open spaces (e.g., parking lots, bridges)') :- !.
label(en, fear_of_other_stimuli, 'Has marked fear or anxiety about other stimuli (e.g., choking or vomiting situations)') :- !.
label(en, fear_of_public_transport, 'Has marked fear or anxiety about using public transportation') :- !.
label(en, fear_of_queues_or_crowds, 'Has marked fear or anxiety about standing in line or being in a crowd') :- !.
label(en, fear_of_situations, 'Has marked fear or anxiety about specific situations (e.g., flying, elevators, enclosed places)') :- !.
label(en, fear_out_of_proportion_to_actual_danger, 'The fear or anxiety is out of proportion to the actual danger and sociocultural context') :- !.
label(en, feeling_life_is_meaningless, 'Feels that life is meaningless as a result of the death') :- !.
label(en, generalized_anxiety_disorder, 'Generalized Anxiety Disorder') :- !.
label(en, generalized_anxiety_symptoms, 'Generalized Anxiety Symptoms') :- !.
label(en, grief_associated_symptoms, 'Grief-Associated Symptoms') :- !.
label(en, health_danger, 'Concern about a health danger or threat') :- !.
label(en, hoarding_behaviour, 'Hoarding Behaviour') :- !.
label(en, hoarding_disorder, 'Hoarding Disorder') :- !.
label(en, hypervigilance, 'Shows hypervigilance') :- !.
label(en, identity_disruption_since_death, 'Experiences identity disruption since the death (e.g., feeling part of oneself has died)') :- !.
label(en, inability_to_feel_positive_emotions, 'Has a persistent inability to experience positive emotions') :- !.
label(en, inhibited_attachment_behaviour, 'Inhibited, Emotionally Withdrawn Attachment Behaviour') :- !.
label(en, insight_absent_or_delusional, 'Absent insight / delusional beliefs') :- !.
label(en, insight_good_or_fair, 'Good or fair insight') :- !.
label(en, insight_level, 'How much insight does the patient have into the beliefs/behaviours') :- !.
label(en, insight_poor, 'Poor insight') :- !.
label(en, insufficient_care, 'Pattern of Extremes of Insufficient Care') :- !.
label(en, intense_emotional_pain, 'Experiences intense emotional pain (e.g., anger, bitterness, sorrow) related to the death') :- !.
label(en, intense_loneliness, 'Experiences intense loneliness as a result of the death') :- !.
label(en, intense_yearning_for_the_deceased, 'Experiences intense yearning or longing for the deceased person') :- !.
label(en, intrusion_symptoms, 'Intrusion Symptoms') :- !.
label(en, intrusive_memories, 'Has recurrent, involuntary, and intrusive distressing memories of the traumatic event') :- !.
label(en, irritability, 'Experiences irritability') :- !.
label(en, irritability_or_aggression, 'Shows irritable behaviour and angry outbursts with little or no provocation') :- !.
label(en, learning_of_trauma_to_close_person, 'Learned that the traumatic event occurred to a close family member or close friend') :- !.
label(en, less_than_six_months, '< 6 months') :- !.
label(en, less_than_three_days, '< 3 days') :- !.
label(en, lightheadedness, 'Feels dizzy, unsteady, light-headed, or faint') :- !.
label(en, limited_positive_affect, 'Shows limited positive affect') :- !.
label(en, maladaptive_behaviour_change_due_to_panic, 'Has made a significant maladaptive change in behaviour related to the panic attacks') :- !.
label(en, marked_fear_of_social_scrutiny, 'Has marked fear or anxiety about social situations involving possible scrutiny by others') :- !.
label(en, marked_fear_of_specific_object_or_situation, 'Has marked fear or anxiety about a specific object or situation') :- !.
label(en, medical_etiology, 'Aetiology Due to Another Medical Condition') :- !.
label(en, minimal_social_emotional_responsiveness, 'Shows minimal social and emotional responsiveness to others') :- !.
label(en, mirror_checking, 'Engages in mirror checking') :- !.
label(en, more_than_five, '> 5') :- !.
label(en, more_than_one_hour_per_day, 'Spends more than one hour per day on the obsessions or compulsions') :- !.
label(en, more_than_three_months_after_stressor, 'More than 3 months after the stressor') :- !.
label(en, muscle_tension, 'Experiences muscle tension') :- !.
label(en, natural_environment_type, 'Natural Environment Type') :- !.
label(en, nausea, 'Experiences nausea or abdominal distress') :- !.
label(en, negative_cognitions_and_mood, 'Negative Alterations in Cognitions and Mood') :- !.
label(en, nightmares_about_separation, 'Has repeated nightmares involving the theme of separation') :- !.
label(en, no_onset, 'No identifiable onset') :- !.
label(en, obsessions_or_compulsions, 'Obsessions or Compulsions') :- !.
label(en, obsessive_compulsive_disorder, 'Obsessive-Compulsive Disorder') :- !.
label(en, obsessive_compulsive_disorder_with_good_or_fair_insight, 'Obsessive-Compulsive Disorder, With Good or Fair Insight') :- !.
label(en, obsessive_compulsive_disorder_with_poor_insight, 'Obsessive-Compulsive Disorder, With Poor Insight') :- !.
label(en, obsessive_compulsive_disorder_with_absent_insight, 'Obsessive-Compulsive Disorder, With Absent Insight / Delusional Beliefs') :- !.
label(en, body_dysmorphic_disorder_with_good_or_fair_insight, 'Body Dysmorphic Disorder, With Good or Fair Insight') :- !.
label(en, body_dysmorphic_disorder_with_poor_insight, 'Body Dysmorphic Disorder, With Poor Insight') :- !.
label(en, body_dysmorphic_disorder_with_absent_insight, 'Body Dysmorphic Disorder, With Absent Insight / Delusional Beliefs') :- !.
label(en, hoarding_disorder_with_good_or_fair_insight, 'Hoarding Disorder, With Good or Fair Insight') :- !.
label(en, hoarding_disorder_with_poor_insight, 'Hoarding Disorder, With Poor Insight') :- !.
label(en, hoarding_disorder_with_absent_insight, 'Hoarding Disorder, With Absent Insight / Delusional Beliefs') :- !.
label(en, occupational_distress, 'Experiences distress or impairment in occupational functioning') :- !.
label(en, ocrd_due_to_another_medical_condition, 'Obsessive-Compulsive and Related Disorder Due to Another Medical Condition') :- !.
label(en, one_or_fewer, '<= 1') :- !.
label(en, one_to_three_months, '>= 1 month & < 3 months') :- !.
label(en, other_anxiety_type, 'Another reason for the anxiety') :- !.
label(en, other_functional_distress, 'Experiences distress or impairment in other important areas of functioning') :- !.
label(en, other_type, 'Other Type') :- !.
label(en, overly_familiar_behaviour, 'Shows overly familiar verbal or physical behaviour with unfamiliar adults') :- !.
label(en, palpitations, 'Experiences heart palpitations, a pounding heart, or accelerated heart rate') :- !.
label(en, panic_attack, 'Panic Attack') :- !.
label(en, panic_attacks_frequency, 'How many panic attacks have occurred') :- !.
label(en, panic_consequences_concern, 'Persistent Concern About Panic Attacks and Their Consequences') :- !.
label(en, panic_disorder, 'Panic Disorder') :- !.
label(en, paresthesias, 'Experiences paresthesias (numbness or tingling sensations)') :- !.
label(en, persistent_avoidance, 'Persistent Avoidance of Stimuli') :- !.
label(en, persistent_grief_response, 'Persistent Grief Response') :- !.
label(en, persistent_negative_beliefs, 'Has persistent, exaggerated negative beliefs or expectations about oneself, others, or the world') :- !.
label(en, persistent_negative_emotional_state, 'Has a persistent negative emotional state (e.g., fear, horror, anger, guilt, shame)') :- !.
label(en, phobic_avoidance, 'Phobic Avoidance') :- !.
label(en, phobic_reaction_type, 'How does the patient react to the feared situations') :- !.
label(en, physical_symptoms_on_separation, 'Has repeated complaints of physical symptoms when separation occurs or is anticipated') :- !.
label(en, physiological_reactions_to_cues, 'Has marked physiological reactions to cues that resemble the traumatic event') :- !.
label(en, posttraumatic_stress_disorder, 'Posttraumatic Stress Disorder') :- !.
label(en, preoccupation_with_perceived_appearance_defects, 'Is preoccupied with one or more perceived defects or flaws in physical appearance') :- !.
label(en, preoccupation_with_the_deceased, 'Is preoccupied with thoughts or memories of the deceased person') :- !.
label(en, preschool, '<= 6 years') :- !.
label(en, prolonged_grief_disorder, 'Prolonged Grief Disorder') :- !.
label(en, rarely_responds_to_comfort_when_distressed, 'Rarely or minimally responds to comfort when distressed') :- !.
label(en, rarely_seeks_comfort_when_distressed, 'Rarely or minimally seeks comfort when distressed') :- !.
label(en, reaction_to_stressor, 'Emotional or Behavioural Reaction to a Stressor') :- !.
label(en, reactive_attachment_disorder, 'Reactive Attachment Disorder') :- !.
label(en, rearing_limiting_attachment, 'Was reared in unusual settings that severely limited opportunities to form selective attachments') :- !.
label(en, reassurance_seeking, 'Engages in reassurance seeking about their appearance') :- !.
label(en, reckless_or_self_destructive_behaviour, 'Engages in reckless or self-destructive behaviour') :- !.
label(en, recurrent_hair_pulling, 'Recurrent Hair Pulling') :- !.
label(en, recurrent_intrusive_unwanted_thoughts, 'Has recurrent and persistent thoughts, urges, or images experienced as intrusive and unwanted') :- !.
label(en, recurrent_pulling_out_of_hair, 'Recurrently pulls out their hair, resulting in hair loss') :- !.
label(en, recurrent_skin_picking, 'Recurrent Skin Picking') :- !.
label(en, recurrent_skin_picking_causing_lesions, 'Recurrently picks at their skin, resulting in skin lesions') :- !.
label(en, recurrent_unexpected_panic_attacks, 'Recurrent Unexpected Panic Attacks') :- !.
label(en, reduced_positive_emotions, 'Shows a persistent reduction in the expression of positive emotions') :- !.
label(en, reduced_reticence_with_unfamiliar_adults, 'Shows reduced or absent reticence in approaching and interacting with unfamiliar adults') :- !.
label(en, reluctance_to_go_out_due_to_separation, 'Is persistently reluctant or refuses to go out away from home because of fear of separation') :- !.
label(en, reluctance_to_sleep_away_from_attachment_figures, 'Is persistently reluctant or refuses to sleep away from home or without being near an attachment figure') :- !.
label(en, repeated_attempts_to_stop_hair_pulling, 'Has made repeated attempts to decrease or stop hair pulling') :- !.
label(en, repeated_attempts_to_stop_skin_picking, 'Has made repeated attempts to decrease or stop skin picking') :- !.
label(en, repeated_changes_of_caregivers, 'Experienced repeated changes of primary caregivers that limited stable attachments') :- !.
label(en, repeated_exposure_to_trauma_details, 'Experienced repeated or extreme exposure to aversive details of the traumatic event') :- !.
label(en, repetitive_appearance_behaviours, 'Repetitive Appearance-Related Behaviours') :- !.
label(en, repetitive_behaviours_or_mental_acts, 'Performs repetitive behaviours or mental acts that they feel driven to perform') :- !.
label(en, restlessness, 'Experiences restlessness or feeling keyed up or on edge') :- !.
label(en, selective_mutism, 'Selective Mutism') :- !.
label(en, separation_anxiety_disorder, 'Separation Anxiety Disorder') :- !.
label(en, separation_anxiety_duration, 'Separation Anxiety Duration') :- !.
label(en, significant_distress, 'Clinically Significant Distress or Impairment') :- !.
label(en, situational_type, 'Situational Type') :- !.
label(en, six_months_or_more, '>= 6 months') :- !.
label(en, six_to_twelve_months, '>= 6 months & < 12 months') :- !.
label(en, skin_picking_for_appearance, 'Picks at their skin in an attempt to improve a perceived appearance defect') :- !.
label(en, sleep_disturbance, 'Has sleep disturbance (difficulty falling or staying asleep, or restless sleep)') :- !.
label(en, social_anxiety_disorder, 'Social Anxiety Disorder') :- !.
label(en, social_distress, 'Experiences distress or impairment in social functioning') :- !.
label(en, social_emotional_disturbance, 'Persistent Social and Emotional Disturbance') :- !.
label(en, social_neglect_or_deprivation, 'Experienced social neglect or deprivation (persistent lack of basic emotional needs being met)') :- !.
label(en, social_phobic_anxiety, 'Social Anxiety') :- !.
label(en, speaks_in_other_situations, 'Speaks normally in other situations despite failing to speak in specific social settings') :- !.
label(en, specific_phobia, 'Specific Phobia') :- !.
label(en, specific_phobia_animal_type, 'Specific Phobia, Animal Type') :- !.
label(en, specific_phobia_blood_injection_injury_type, 'Specific Phobia, Blood-Injection-Injury Type') :- !.
label(en, specific_phobia_natural_environment_type, 'Specific Phobia, Natural Environment Type') :- !.
label(en, specific_phobia_other_type, 'Specific Phobia, Other Type') :- !.
label(en, specific_phobia_situational_type, 'Specific Phobia, Situational Type') :- !.
label(en, specific_phobic_anxiety, 'Specific Phobic Anxiety') :- !.
label(en, substance_etiology, 'Substance/Medication Aetiology') :- !.
label(en, substance_induced_anxiety_disorder, 'Substance/Medication-Induced Anxiety Disorder') :- !.
label(en, substance_induced_ocrd, 'Substance/Medication-Induced Obsessive-Compulsive and Related Disorder') :- !.
label(en, sweating, 'Experiences sweating') :- !.
label(en, symptoms_after_medical_condition_onset, 'Symptoms developed after the onset of another medical condition') :- !.
label(en, symptoms_after_substance_or_medication_use, 'Symptoms developed during or soon after substance intoxication, withdrawal, or medication use') :- !.
label(en, symptoms_correlated_with_medical_condition, 'Symptoms are correlated with the course of another medical condition') :- !.
label(en, symptoms_correlated_with_substance_or_medication, 'Symptoms are correlated with the use of a substance or medication capable of producing them') :- !.
label(en, symptoms_duration, 'How long have the symptoms persisted') :- !.
label(en, symptoms_onset, 'When did the symptoms begin relative to the stressor') :- !.
label(en, three_days_to_one_month, '>= 3 days & < 1 month') :- !.
label(en, three_to_six_months, '>= 3 months & < 6 months') :- !.
label(en, time_consuming_more_than_one_hour, 'Time-Consuming, More Than 1 Hour per Day') :- !.
label(en, traumatic_exposure, 'Exposure to a Traumatic Event') :- !.
label(en, trembling, 'Experiences trembling or shaking') :- !.
label(en, trichotillomania, 'Trichotillomania (Hair-Pulling Disorder)') :- !.
label(en, twelve_months_or_more, '>= 12 months') :- !.
label(en, two_to_five, '>= 2 & <= 5') :- !.
label(en, unexpected_attack, 'Out of the blue, unexpectedly') :- !.
label(en, unexplained_irritability_or_fearfulness, 'Has episodes of unexplained irritability, sadness, or fearfulness during nonthreatening interactions') :- !.
label(en, unspecified_adjustment, 'Unspecified') :- !.
label(en, willing_to_go_off_with_strangers, 'Is willing to go off with an unfamiliar adult with minimal or no hesitation') :- !.
label(en, with_anxiety, 'With anxiety') :- !.
label(en, with_depressed_mood, 'With depressed mood') :- !.
label(en, with_disturbance_of_conduct, 'With disturbance of conduct') :- !.
label(en, with_mixed_anxiety_and_depressed_mood, 'With mixed anxiety and depressed mood') :- !.
label(en, with_mixed_disturbance_emotions_conduct, 'With mixed disturbance of emotions and conduct') :- !.
label(en, within_three_months_of_stressor, 'Within 3 months of the stressor') :- !.
label(en, witnessing_trauma, 'Witnessed, in person, the traumatic event as it occurred to others') :- !.
label(en, worry_about_losing_attachment_figures, 'Has persistent excessive worry about losing attachment figures or about harm coming to them') :- !.
label(en, worry_about_new_panic_attacks, 'Has persistent concern or worry about having more panic attacks') :- !.
label(en, worry_about_panic_consequences, 'Has persistent worry about the consequences of the panic attacks (e.g., losing control, a heart attack)') :- !.
label(en, worry_an_event_causes_separation, 'Has persistent excessive worry that an untoward event will cause separation from an attachment figure') :- !.

% ---- explanations ----
explanation(en, abrupt_surge_of_fear_or_discomfort, 'An abrupt surge of intense fear or discomfort peaking within minutes is the defining feature of a panic attack.') :- !.
explanation(en, accumulation_clutters_living_areas, 'Clutter that congests and compromises active living areas is a core feature of hoarding disorder.') :- !.
explanation(en, adjustment_subtype, 'The predominant symptom presentation is recorded as the subtype specifier for adjustment disorder.') :- !.
explanation(en, altered_sense_of_reality, 'An altered sense of reality of one''s surroundings or oneself is a dissociative symptom counting toward acute stress disorder.') :- !.
explanation(en, another_medical_condition, 'The presence of another medical condition may point to an anxiety or OCRD disorder due to another medical condition and helps rule out a primary disorder.') :- !.
explanation(en, anxiety_type, 'The main reason for the anxiety helps distinguish agoraphobia, illness-related fear, and generalized apprehensive expectation.') :- !.
explanation(en, attack_type, 'Whether panic attacks are unexpected or cued distinguishes panic disorder (unexpected) from cued anxiety presentations.') :- !.
explanation(en, avoidance_of_external_trauma_reminders, 'Avoidance of external trauma reminders is part of the avoidance cluster of PTSD and acute stress disorder.') :- !.
explanation(en, avoidance_of_reminders_of_death, 'Avoidance of reminders that the person is dead is one of the symptoms supporting prolonged grief disorder.') :- !.
explanation(en, avoidance_of_trauma_thoughts_or_feelings, 'Avoidance of internal trauma reminders is part of the avoidance cluster of PTSD and acute stress disorder.') :- !.
explanation(en, being_easily_fatigued, 'Being easily fatigued is one of the associated symptoms of generalized anxiety disorder.') :- !.
explanation(en, bereavement_time, 'The time since the death is compared against the 12-month (or 6-month in youth) threshold for prolonged grief disorder.') :- !.
explanation(en, chest_pain, 'Chest pain or discomfort is one of the physical symptoms of a panic attack.') :- !.
explanation(en, chills_or_hot_flushes, 'Chills or heat sensations are among the physical symptoms of a panic attack.') :- !.
explanation(en, choking, 'A feeling of choking is one of the physical symptoms of a panic attack.') :- !.
explanation(en, comparing_appearance_with_others, 'Comparing one''s appearance with that of others is a repetitive mental act seen in body dysmorphic disorder.') :- !.
explanation(en, derealization_or_depersonalization, 'Derealization or depersonalization is one of the symptoms of a panic attack and may also indicate the dissociative subtype of PTSD.') :- !.
explanation(en, detachment_from_others, 'Feelings of detachment or estrangement from others belong to the negative cognitions and mood cluster of PTSD.') :- !.
explanation(en, difficulty_concentrating, 'Difficulty concentrating is an associated symptom of generalized anxiety disorder and an arousal symptom of PTSD.') :- !.
explanation(en, difficulty_controlling_worry, 'Difficulty controlling the worry is a core feature distinguishing generalized anxiety disorder from ordinary worry.') :- !.
explanation(en, difficulty_discarding_possessions, 'Persistent difficulty discarding possessions points toward hoarding disorder.') :- !.
explanation(en, difficulty_reintegrating, 'Difficulty reintegrating into relationships and activities is one of the symptoms supporting prolonged grief disorder.') :- !.
explanation(en, diminished_interest, 'Markedly diminished interest in significant activities belongs to the negative cognitions and mood cluster of PTSD.') :- !.
explanation(en, directly_experiencing_trauma, 'Directly experiencing a traumatic event is one of the qualifying exposure routes for PTSD and acute stress disorder.') :- !.
explanation(en, disbelief_about_the_death, 'A marked sense of disbelief about the death is one of the symptoms supporting prolonged grief disorder.') :- !.
explanation(en, dissociative_amnesia_of_trauma, 'Inability to remember an important aspect of the trauma is a negative cognition symptom of PTSD and a dissociative symptom of acute stress disorder.') :- !.
explanation(en, dissociative_flashbacks, 'Dissociative reactions such as flashbacks are part of the intrusion cluster of PTSD and acute stress disorder.') :- !.
explanation(en, distorted_blame, 'Distorted cognitions leading to self-blame or blame of others belong to the negative cognitions and mood cluster of PTSD.') :- !.
explanation(en, distress_associated_with_discarding, 'Distress associated with discarding and a perceived need to save items underlies the difficulty discarding in hoarding disorder.') :- !.
explanation(en, distress_at_separation_from_attachment_figures, 'Recurrent excessive distress at separation from attachment figures is a core symptom of separation anxiety disorder.') :- !.
explanation(en, distress_at_trauma_cues, 'Intense psychological distress at exposure to trauma cues is part of the intrusion cluster of PTSD and acute stress disorder.') :- !.
explanation(en, distressing_dreams, 'Recurrent distressing dreams related to the event are part of the intrusion cluster of PTSD and acute stress disorder.') :- !.
explanation(en, does_not_check_back_with_caregiver, 'Diminished checking back with the caregiver after venturing away is a symptom of disinhibited social engagement disorder.') :- !.
explanation(en, dyspnea, 'Shortness of breath or smothering is one of the physical symptoms of a panic attack.') :- !.
explanation(en, emotional_numbness, 'Emotional numbness is one of the symptoms supporting prolonged grief disorder.') :- !.
explanation(en, emotional_or_behavioural_symptoms_after_stressor, 'Emotional or behavioural symptoms developing in response to an identifiable stressor are the core of adjustment disorder.') :- !.
explanation(en, exaggerated_startle_response, 'An exaggerated startle response is part of the arousal and reactivity cluster of PTSD and acute stress disorder.') :- !.
explanation(en, excessive_grooming, 'Excessive grooming is a repetitive behaviour seen in body dysmorphic disorder.') :- !.
explanation(en, excessive_worry_about_several_events, 'Excessive anxiety and worry about a number of events or activities is a core feature of generalized anxiety disorder.') :- !.
explanation(en, failure_to_speak_in_specific_social_situations, 'Consistent failure to speak in specific social situations where speaking is expected is the core feature of selective mutism.') :- !.
explanation(en, fear_almost_always_provoked, 'When the feared stimulus almost always provokes immediate fear or anxiety, this supports specific phobia, social anxiety disorder, or agoraphobia.') :- !.
explanation(en, fear_of_animals, 'Fear of animals supports a diagnosis of specific phobia, animal type.') :- !.
explanation(en, fear_of_being_alone, 'Fear of or reluctance about being alone without attachment figures is a symptom of separation anxiety disorder.') :- !.
explanation(en, fear_of_being_outside_home_alone, 'Fear of being outside the home alone is one of the agoraphobic situations.') :- !.
explanation(en, fear_of_blood_injection_injury, 'Fear of blood, injections, or injury supports a diagnosis of specific phobia, blood-injection-injury type.') :- !.
explanation(en, fear_of_dying, 'Fear of dying is one of the cognitive symptoms of a panic attack.') :- !.
explanation(en, fear_of_enclosed_places, 'Fear of enclosed places is one of the agoraphobic situations.') :- !.
explanation(en, fear_of_losing_control, 'Fear of losing control or going crazy is one of the cognitive symptoms of a panic attack.') :- !.
explanation(en, fear_of_natural_environment, 'Fear of the natural environment supports a diagnosis of specific phobia, natural environment type.') :- !.
explanation(en, fear_of_negative_evaluation, 'Fear of being negatively evaluated by others is the core cognition of social anxiety disorder.') :- !.
explanation(en, fear_of_open_spaces, 'Fear of open spaces is one of the agoraphobic situations.') :- !.
explanation(en, fear_of_other_stimuli, 'Fear of other stimuli (e.g., choking or vomiting) supports a diagnosis of specific phobia, other type.') :- !.
explanation(en, fear_of_public_transport, 'Fear of using public transportation is one of the agoraphobic situations.') :- !.
explanation(en, fear_of_queues_or_crowds, 'Fear of standing in line or being in a crowd is one of the agoraphobic situations.') :- !.
explanation(en, fear_of_situations, 'Fear of specific situations such as flying or enclosed places supports specific phobia, situational type.') :- !.
explanation(en, fear_out_of_proportion_to_actual_danger, 'Fear that is out of proportion to the actual danger is a required feature of the phobic and agoraphobic disorders.') :- !.
explanation(en, feeling_life_is_meaningless, 'Feeling that life is meaningless as a result of the death is one of the symptoms supporting prolonged grief disorder.') :- !.
explanation(en, hypervigilance, 'Hypervigilance is part of the arousal and reactivity cluster of PTSD and acute stress disorder.') :- !.
explanation(en, identity_disruption_since_death, 'Identity disruption since the death is one of the symptoms supporting prolonged grief disorder.') :- !.
explanation(en, inability_to_feel_positive_emotions, 'Persistent inability to experience positive emotions is a negative cognition symptom of PTSD and acute stress disorder.') :- !.
explanation(en, insight_level, 'The level of insight is recorded as a specifier for OCD, body dysmorphic disorder, and hoarding disorder.') :- !.
explanation(en, intense_emotional_pain, 'Intense emotional pain related to the death is one of the symptoms supporting prolonged grief disorder.') :- !.
explanation(en, intense_loneliness, 'Intense loneliness as a result of the death is one of the symptoms supporting prolonged grief disorder.') :- !.
explanation(en, intense_yearning_for_the_deceased, 'Intense yearning or longing for the deceased is a core feature of the persistent grief response in prolonged grief disorder.') :- !.
explanation(en, intrusive_memories, 'Recurrent, involuntary, intrusive distressing memories are part of the intrusion cluster of PTSD and acute stress disorder.') :- !.
explanation(en, irritability, 'Irritability is one of the associated symptoms of generalized anxiety disorder.') :- !.
explanation(en, irritability_or_aggression, 'Irritable behaviour and angry outbursts are part of the arousal and reactivity cluster of PTSD and acute stress disorder.') :- !.
explanation(en, learning_of_trauma_to_close_person, 'Learning that the event occurred to a close person is one of the qualifying exposure routes for PTSD and acute stress disorder.') :- !.
explanation(en, lightheadedness, 'Feeling dizzy, unsteady, or light-headed is one of the physical symptoms of a panic attack.') :- !.
explanation(en, limited_positive_affect, 'Limited positive affect is part of the social and emotional disturbance of reactive attachment disorder.') :- !.
explanation(en, maladaptive_behaviour_change_due_to_panic, 'A significant maladaptive change in behaviour related to the attacks is one of the consequences required for panic disorder.') :- !.
explanation(en, marked_fear_of_social_scrutiny, 'Marked fear of social situations involving possible scrutiny is the core feature of social anxiety disorder.') :- !.
explanation(en, marked_fear_of_specific_object_or_situation, 'Marked fear of a specific object or situation is the core feature of specific phobia.') :- !.
explanation(en, minimal_social_emotional_responsiveness, 'Minimal social and emotional responsiveness is part of the social and emotional disturbance of reactive attachment disorder.') :- !.
explanation(en, mirror_checking, 'Mirror checking is a repetitive behaviour seen in body dysmorphic disorder.') :- !.
explanation(en, more_than_one_hour_per_day, 'Spending more than one hour per day on obsessions or compulsions meets the time-consuming threshold for OCD.') :- !.
explanation(en, muscle_tension, 'Muscle tension is one of the associated symptoms of generalized anxiety disorder.') :- !.
explanation(en, nausea, 'Nausea or abdominal distress is one of the physical symptoms of a panic attack.') :- !.
explanation(en, nightmares_about_separation, 'Repeated nightmares with a separation theme are a symptom of separation anxiety disorder.') :- !.
explanation(en, occupational_distress, 'Distress or impairment in occupational functioning helps establish the clinical significance required by most disorders.') :- !.
explanation(en, other_functional_distress, 'Distress or impairment in other important areas of functioning helps establish the clinical significance required by most disorders.') :- !.
explanation(en, overly_familiar_behaviour, 'Overly familiar verbal or physical behaviour is a symptom of disinhibited social engagement disorder.') :- !.
explanation(en, palpitations, 'The presence of palpitations may be indicative of a panic attack.') :- !.
explanation(en, panic_attacks_frequency, 'The number of panic attacks helps establish whether the attacks are recurrent, as required for panic disorder.') :- !.
explanation(en, paresthesias, 'Paresthesias (numbness or tingling) are among the physical symptoms of a panic attack.') :- !.
explanation(en, patient, 'The patient''s age group is used to apply age-specific criteria, durations, and the preschool PTSD subtype.') :- !.
explanation(en, persistent_negative_beliefs, 'Persistent exaggerated negative beliefs about oneself, others, or the world belong to the negative cognitions and mood cluster of PTSD.') :- !.
explanation(en, persistent_negative_emotional_state, 'A persistent negative emotional state belongs to the negative cognitions and mood cluster of PTSD.') :- !.
explanation(en, phobic_reaction_type, 'How the patient reacts to feared situations (avoidance or endurance with distress) is required for the phobic and agoraphobic disorders.') :- !.
explanation(en, physical_symptoms_on_separation, 'Repeated complaints of physical symptoms when separation occurs or is anticipated are a symptom of separation anxiety disorder.') :- !.
explanation(en, physiological_reactions_to_cues, 'Marked physiological reactions to trauma cues are part of the intrusion cluster of PTSD and acute stress disorder.') :- !.
explanation(en, preoccupation_with_perceived_appearance_defects, 'Preoccupation with perceived defects or flaws in appearance is the core feature of body dysmorphic disorder.') :- !.
explanation(en, preoccupation_with_the_deceased, 'Preoccupation with thoughts or memories of the deceased is a core feature of the persistent grief response in prolonged grief disorder.') :- !.
explanation(en, rarely_responds_to_comfort_when_distressed, 'Rarely responding to comfort when distressed is part of the inhibited attachment behaviour of reactive attachment disorder.') :- !.
explanation(en, rarely_seeks_comfort_when_distressed, 'Rarely seeking comfort when distressed is part of the inhibited attachment behaviour of reactive attachment disorder.') :- !.
explanation(en, rearing_limiting_attachment, 'Rearing in settings that limit selective attachments is one form of insufficient care underlying attachment disorders.') :- !.
explanation(en, reassurance_seeking, 'Reassurance seeking about appearance is a repetitive behaviour seen in body dysmorphic disorder.') :- !.
explanation(en, reckless_or_self_destructive_behaviour, 'Reckless or self-destructive behaviour is part of the arousal and reactivity cluster of PTSD.') :- !.
explanation(en, recurrent_intrusive_unwanted_thoughts, 'Recurrent intrusive and unwanted thoughts, urges, or images define obsessions in OCD.') :- !.
explanation(en, recurrent_pulling_out_of_hair, 'Recurrent pulling out of hair resulting in hair loss is the core feature of trichotillomania.') :- !.
explanation(en, recurrent_skin_picking_causing_lesions, 'Recurrent skin picking resulting in lesions is the core feature of excoriation disorder.') :- !.
explanation(en, reduced_positive_emotions, 'A persistent reduction in the expression of positive emotions is part of the combined cluster of the preschool PTSD subtype.') :- !.
explanation(en, reduced_reticence_with_unfamiliar_adults, 'Reduced reticence in approaching unfamiliar adults is a symptom of disinhibited social engagement disorder.') :- !.
explanation(en, reluctance_to_go_out_due_to_separation, 'Reluctance or refusal to go out because of fear of separation is a symptom of separation anxiety disorder.') :- !.
explanation(en, reluctance_to_sleep_away_from_attachment_figures, 'Reluctance or refusal to sleep away from attachment figures is a symptom of separation anxiety disorder.') :- !.
explanation(en, repeated_attempts_to_stop_hair_pulling, 'Repeated attempts to decrease or stop hair pulling are a required criterion for trichotillomania.') :- !.
explanation(en, repeated_attempts_to_stop_skin_picking, 'Repeated attempts to decrease or stop skin picking are a required criterion for excoriation disorder.') :- !.
explanation(en, repeated_changes_of_caregivers, 'Repeated changes of primary caregivers are one form of insufficient care underlying attachment disorders.') :- !.
explanation(en, repeated_exposure_to_trauma_details, 'Repeated or extreme exposure to aversive details is one of the qualifying exposure routes for PTSD in those older than 6.') :- !.
explanation(en, repetitive_behaviours_or_mental_acts, 'Repetitive behaviours or mental acts performed in response to obsessions define compulsions in OCD.') :- !.
explanation(en, restlessness, 'Restlessness or feeling keyed up is one of the associated symptoms of generalized anxiety disorder.') :- !.
explanation(en, skin_picking_for_appearance, 'Skin picking to improve a perceived appearance defect points to body dysmorphic disorder rather than excoriation disorder.') :- !.
explanation(en, sleep_disturbance, 'Sleep disturbance is an associated symptom of generalized anxiety disorder and an arousal symptom of PTSD and acute stress disorder.') :- !.
explanation(en, social_distress, 'Distress or impairment in social functioning helps establish the clinical significance required by most disorders.') :- !.
explanation(en, social_neglect_or_deprivation, 'Social neglect or deprivation is one form of insufficient care underlying the attachment disorders.') :- !.
explanation(en, speaks_in_other_situations, 'Speaking normally in other situations confirms that the failure to speak is situation-specific, as required for selective mutism.') :- !.
explanation(en, sweating, 'Sweating is one of the physical symptoms of a panic attack.') :- !.
explanation(en, symptoms_after_medical_condition_onset, 'Symptoms developing after the onset of another medical condition support a disorder due to another medical condition.') :- !.
explanation(en, symptoms_after_substance_or_medication_use, 'Symptoms developing during or soon after substance or medication use support a substance/medication-induced disorder.') :- !.
explanation(en, symptoms_correlated_with_medical_condition, 'Symptoms correlated with the course of a medical condition support a disorder due to another medical condition.') :- !.
explanation(en, symptoms_correlated_with_substance_or_medication, 'Symptoms correlated with a substance or medication capable of producing them support a substance/medication-induced disorder.') :- !.
explanation(en, symptoms_duration, 'The duration of symptoms is used to apply the minimum-duration thresholds that distinguish acute stress disorder, PTSD, and the anxiety disorders.') :- !.
explanation(en, symptoms_onset, 'The timing of symptom onset relative to the stressor is used to distinguish adjustment disorder and to apply onset specifiers.') :- !.
explanation(en, trembling, 'Trembling or shaking is one of the physical symptoms of a panic attack.') :- !.
explanation(en, unexplained_irritability_or_fearfulness, 'Episodes of unexplained irritability, sadness, or fearfulness are part of the social and emotional disturbance of reactive attachment disorder.') :- !.
explanation(en, willing_to_go_off_with_strangers, 'Willingness to go off with an unfamiliar adult is a symptom of disinhibited social engagement disorder.') :- !.
explanation(en, witnessing_trauma, 'Witnessing the event in person as it occurred to others is one of the qualifying exposure routes for PTSD and acute stress disorder.') :- !.
explanation(en, worry_about_losing_attachment_figures, 'Persistent worry about losing attachment figures or about harm coming to them is a symptom of separation anxiety disorder.') :- !.
explanation(en, worry_about_new_panic_attacks, 'Persistent worry about having more panic attacks is one of the consequences required for panic disorder.') :- !.
explanation(en, worry_about_panic_consequences, 'Persistent worry about the consequences of the attacks is one of the consequences required for panic disorder.') :- !.
explanation(en, worry_an_event_causes_separation, 'Persistent worry that an untoward event will cause separation is a symptom of separation anxiety disorder.') :- !.

% ---- refined induced/medical-condition tail (DSM-5-TR) ----
label(en, predominant_anxiety, 'Predominant Anxiety (Panic Attacks or Anxiety)') :- !.
label(en, predominant_oc_presentation, 'Predominant Obsessive-Compulsive Presentation') :- !.
label(en, not_delirium_bound, 'Not Occurring Exclusively During Delirium') :- !.
label(en, substance_intoxication_or_withdrawal_or_medication_use, 'Was intoxicated by or in withdrawal from a substance, or had taken a medication, around the time the symptoms appeared') :- !.
label(en, symptoms_developed_during_or_after_substance_use, 'The symptoms developed during or soon after substance intoxication or withdrawal, or after exposure to a medication') :- !.
label(en, substance_capable_of_producing_symptoms, 'The involved substance or medication is capable of producing the reported symptoms') :- !.
label(en, disturbance_is_direct_consequence_of_medical_condition, 'There is evidence that the disturbance is the direct physiological consequence of another medical condition') :- !.
label(en, not_exclusively_during_delirium, 'The disturbance does not occur only during episodes of delirium') :- !.
explanation(en, substance_intoxication_or_withdrawal_or_medication_use, 'Establishing the involvement of a substance or medication is needed to consider a substance/medication-induced disorder') :- !.
explanation(en, symptoms_developed_during_or_after_substance_use, 'A temporal link between the symptoms and the substance or medication supports a substance/medication-induced disorder (Criterion B1)') :- !.
explanation(en, substance_capable_of_producing_symptoms, 'The substance or medication must be pharmacologically capable of causing the symptoms (Criterion B2)') :- !.
explanation(en, disturbance_is_direct_consequence_of_medical_condition, 'A direct pathophysiological link to a medical condition supports a disorder due to another medical condition (Criterion B)') :- !.
explanation(en, not_exclusively_during_delirium, 'Symptoms occurring exclusively during a delirium would exclude this diagnosis (Criterion D)') :- !.
