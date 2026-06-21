%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	name:
%		interface_it.pl
%
%	description:
%		Italian localization (DSM-5-TR): label/3 and explanation/3 facts keyed on
%		language-neutral English atoms, plus the Italian command vocabulary.
%		Selected at runtime via language(it).
%
%	author:
%		Donato Meoli
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ---- system / interface labels ----
label(it, system_presentation, '-------------------------------------------------------------------\n-- PESAD - Prolog Expert System for Anxiety,\n--         Obsessive-Compulsive and Trauma-Related Disorders\n--\n--	base di conoscenza: DSM-5-TR\n--	autore:             Donato Meoli\n-------------------------------------------------------------------\n') :- !.
label(it, available_commands, 'Comandi disponibili:') :- !.
label(it, method_request, 'Seleziona il metodo di gestione dell''incertezza:') :- !.
label(it, method_cf, 'Fattori di certezza (t-norma minimo)') :- !.
label(it, method_fuzzy, 'Logica fuzzy (t-norma prodotto)') :- !.
label(it, method_fuzzy_membership, 'Logica fuzzy con funzioni di appartenenza (durata/frequenza graduali)') :- !.
label(it, duration_months, 'Da quanti mesi sono presenti i sintomi (inserire un numero)') :- !.
label(it, panic_attacks_count, 'Quanti attacchi di panico si sono verificati (inserire un numero)') :- !.
label(it, command_investigation, '	investigation.	- Avvia l''investigazione completa dei disturbi;') :- !.
label(it, command_control, '	control.	- Avvia il controllo di un singolo disturbo;') :- !.
label(it, command_facts, '	facts.		- Visualizza i fatti asseriti;') :- !.
label(it, command_help, '	help.		- Visualizza l''elenco dei comandi disponibili;') :- !.
label(it, command_clean, '	clean.		- Pulisce la memoria;') :- !.
label(it, command_quit, '	quit.		- Chiude l''interfaccia grafica.') :- !.
label(it, command_error, 'Comando digitato errato, riprovare nuovamente ') :- !.
label(it, answer_error, 'Risposta errata, rispondere nuovamente') :- !.
label(it, certainty_error, 'Valore di certezza errato, inserire un valore ') :- !.
label(it, diagnosis, '========================== DIAGNOSI ===========================') :- !.
label(it, certainty, ' con grado di certezza ') :- !.
label(it, certainty_request, 'Indicare il grado di certezza ') :- !.
label(it, certainty_hint, '(da 0.0 a 1.0)') :- !.
label(it, yes_no_hint, '(si, no)') :- !.
label(it, option_request, 'Digitare il codice corrispondente all''opzione scelta') :- !.
label(it, goal_request, 'Quale dei seguenti disturbi si vuole controllare') :- !.
label(it, diagnosis_result, 'Il paziente soffre di ') :- !.
label(it, patient, 'Qual è la fascia d''età del paziente') :- !.
label(it, how_request_control, 'Vuoi sapere come e'' stato dedotto') :- !.
label(it, how_request_investigation, 'Vuoi sapere come sono stati dedotti') :- !.
label(it, true_label, ' e'' vero con CF ') :- !.
label(it, false_label, ' e'' falso con CF ') :- !.
label(it, deduced, ' e'' stato dedotto da') :- !.
label(it, stated, ' e'' stato detto') :- !.
label(it, code, ' Codice: ') :- !.
label(it, facts, '============================ FATTI ============================') :- !.

% ---- domain labels ----
label(it, abrupt_surge_of_fear_or_discomfort, 'Avverte un improvviso aumento di paura o disagio intensi che raggiunge il picco in pochi minuti') :- !.
label(it, accumulation_clutters_living_areas, 'Presenta un accumulo di oggetti che congestiona e ingombra gli spazi vitali attivi') :- !.
label(it, acute_stress_disorder, 'Disturbo da Stress Acuto') :- !.
label(it, acute_stress_symptoms, 'Sintomi da Stress Acuto') :- !.
label(it, adjustment_disorder, 'Disturbo dell''Adattamento') :- !.
label(it, adjustment_onset_within_three_months, 'Esordio Entro 3 Mesi dal Fattore Stressante') :- !.
label(it, adjustment_subtype, 'Qual è la presentazione sintomatologica predominante') :- !.
label(it, adolescent, '13-17 anni') :- !.
label(it, adult, '>= 18 anni') :- !.
label(it, agoraphobia, 'Agorafobia') :- !.
label(it, agoraphobic_anxiety, 'Ansia Agorafobica') :- !.
label(it, altered_sense_of_reality, 'Ha un''alterata percezione della realtà dell''ambiente circostante o di sé (es. stordimento, rallentamento del tempo)') :- !.
label(it, animal_type, 'Tipo Animali') :- !.
label(it, another_medical_condition, 'Presenta un''altra condizione medica che potrebbe spiegare i sintomi') :- !.
label(it, anxiety_disorder_due_to_another_medical_condition, 'Disturbo d''Ansia Dovuto a un''Altra Condizione Medica') :- !.
label(it, anxiety_type, 'Qual è il motivo principale dell''ansia') :- !.
label(it, appearance_preoccupation, 'Preoccupazione per Difetti Percepiti dell''Aspetto') :- !.
label(it, apprehensive_expectation, 'Attesa apprensiva riguardo a numerosi eventi o attività') :- !.
label(it, arousal_alterations, 'Alterazioni dell''Arousal e della Reattività') :- !.
label(it, associated_general_medical_condition, 'Condizione Medica Generale Associata') :- !.
label(it, associated_substance_induced_alteration, 'Alterazione Associata Indotta da Sostanze/Farmaci') :- !.
label(it, attack_type, 'Quando si verifica l''episodio') :- !.
label(it, avoidance, 'Le evita attivamente') :- !.
label(it, avoidance_of_external_trauma_reminders, 'Evita stimoli esterni (persone, luoghi, conversazioni, attività, oggetti) associati al trauma') :- !.
label(it, avoidance_of_reminders_of_death, 'Evita stimoli che ricordano che la persona è morta') :- !.
label(it, avoidance_of_trauma_thoughts_or_feelings, 'Evita ricordi, pensieri o emozioni angoscianti relativi all''evento traumatico') :- !.
label(it, avoidance_or_negative_cognitions, 'Evitamento o Alterazioni Negative di Pensieri ed Emozioni') :- !.
label(it, being_easily_fatigued, 'Si affatica facilmente') :- !.
label(it, bereavement_at_least_twelve_months, 'Lutto da Almeno 12 Mesi') :- !.
label(it, bereavement_time, 'Quanto tempo fa è avvenuta la morte') :- !.
label(it, blood_injection_injury_type, 'Tipo Sangue-Iniezioni-Ferite') :- !.
label(it, body_dysmorphic_disorder, 'Disturbo da Dismorfismo Corporeo') :- !.
label(it, chest_pain, 'Avverte dolore o fastidio al petto') :- !.
label(it, child, '7-12 anni') :- !.
label(it, chills_or_hot_flushes, 'Avverte brividi o vampate di calore') :- !.
label(it, choking, 'Avverte una sensazione di soffocamento') :- !.
label(it, comparing_appearance_with_others, 'Confronta il proprio aspetto con quello degli altri') :- !.
label(it, consistent_failure_to_speak, 'Costante Incapacità di Parlare in Specifiche Situazioni Sociali') :- !.
label(it, cued_attack, 'In seguito all''esposizione o all''anticipazione di un fattore scatenante') :- !.
label(it, derealization_or_depersonalization, 'Sperimenta derealizzazione o depersonalizzazione') :- !.
label(it, detachment_from_others, 'Si sente distaccato o estraneo dagli altri') :- !.
label(it, difficulty_concentrating, 'Ha difficoltà a concentrarsi o sensazioni di vuoto mentale') :- !.
label(it, difficulty_controlling_worry, 'Trova difficile controllare la preoccupazione') :- !.
label(it, difficulty_discarding_possessions, 'Ha persistente difficoltà a gettare o separarsi dai propri averi, indipendentemente dal loro valore') :- !.
label(it, difficulty_escaping_or_help_unavailable, 'La fuga potrebbe essere difficile o l''aiuto non disponibile in caso di sintomi simili al panico') :- !.
label(it, difficulty_reintegrating, 'Ha difficoltà a reinserirsi nelle relazioni e nelle attività dopo la morte') :- !.
label(it, diminished_interest, 'Ha un interesse o una partecipazione marcatamente ridotti ad attività significative') :- !.
label(it, directly_experiencing_trauma, 'Ha vissuto direttamente l''evento traumatico') :- !.
label(it, disbelief_about_the_death, 'Ha un marcato senso di incredulità riguardo alla morte') :- !.
label(it, disinhibited_behaviour_with_strangers, 'Comportamento Disinibito con Adulti Non Familiari') :- !.
label(it, disinhibited_social_engagement_disorder, 'Disturbo da Impegno Sociale Disinibito') :- !.
label(it, dissociative_amnesia_of_trauma, 'È incapace di ricordare un aspetto importante dell''evento traumatico (amnesia dissociativa)') :- !.
label(it, dissociative_flashbacks, 'Ha reazioni dissociative o flashback in cui l''evento sembra ripresentarsi') :- !.
label(it, distorted_blame, 'Ha pensieri persistenti e distorti che lo portano a incolpare se stesso o gli altri per il trauma') :- !.
label(it, distress_associated_with_discarding, 'Prova disagio associato al gettare via gli oggetti e una percepita necessità di conservarli') :- !.
label(it, distress_at_separation_from_attachment_figures, 'Prova un disagio eccessivo e ricorrente quando anticipa o vive la separazione dalle figure di attaccamento') :- !.
label(it, distress_at_trauma_cues, 'Prova un disagio psicologico intenso o prolungato all''esposizione a stimoli che ricordano il trauma') :- !.
label(it, distressing_dreams, 'Ha sogni angoscianti ricorrenti correlati all''evento traumatico') :- !.
label(it, does_not_check_back_with_caregiver, 'Mostra una ridotta o assente verifica del ritorno alla figura di accudimento dopo essersi allontanato') :- !.
label(it, duration_at_least_one_month, 'Durata di Almeno 1 Mese') :- !.
label(it, duration_at_least_six_months, 'Durata di Almeno 6 Mesi') :- !.
label(it, duration_three_days_to_one_month, 'Durata da 3 Giorni a 1 Mese') :- !.
label(it, dyspnea, 'Avverte mancanza di respiro o sensazione di asfissia') :- !.
label(it, emotional_numbness, 'Prova un intorpidimento emotivo (assenza o marcata riduzione delle emozioni)') :- !.
label(it, emotional_or_behavioural_symptoms_after_stressor, 'Ha sviluppato sintomi emotivi o comportamentali in risposta a un fattore stressante identificabile') :- !.
label(it, endurance_with_distress, 'Le sopporta con intenso disagio') :- !.
label(it, endurance_without_problems, 'Le tollera senza problemi') :- !.
label(it, exaggerated_startle_response, 'Ha una risposta di allarme esagerata') :- !.
label(it, excessive_grooming, 'Mette in atto eccessiva cura della propria persona') :- !.
label(it, excessive_separation_fear, 'Paura o Ansia Eccessiva Riguardo alla Separazione') :- !.
label(it, excessive_uncontrollable_worry, 'Preoccupazione Eccessiva e Incontrollabile') :- !.
label(it, excessive_worry_about_several_events, 'Ha ansia e preoccupazione eccessive riguardo a numerosi eventi o attività') :- !.
label(it, excoriation_disorder, 'Disturbo da Escoriazione') :- !.
label(it, failure_to_speak_in_specific_social_situations, 'Non riesce costantemente a parlare in specifiche situazioni sociali in cui ci si aspetta che parli') :- !.
label(it, fear_almost_always_provoked, 'L''oggetto o la situazione temuti provocano quasi sempre paura o ansia immediate') :- !.
label(it, fear_of_animals, 'Ha paura o ansia marcate riguardo agli animali (es. ragni, insetti, cani)') :- !.
label(it, fear_of_being_alone, 'Ha una paura o riluttanza eccessiva e persistente nello stare da solo senza le figure di attaccamento') :- !.
label(it, fear_of_being_outside_home_alone, 'Ha paura o ansia marcate nello stare fuori casa da solo') :- !.
label(it, fear_of_blood_injection_injury, 'Ha paura o ansia marcate riguardo a sangue, iniezioni o ferite (es. aghi, procedure invasive)') :- !.
label(it, fear_of_dying, 'Avverte paura di morire') :- !.
label(it, fear_of_enclosed_places, 'Ha paura o ansia marcate nello stare in luoghi chiusi (es. negozi, teatri, cinema)') :- !.
label(it, fear_of_losing_control, 'Avverte paura di perdere il controllo o di impazzire') :- !.
label(it, fear_of_natural_environment, 'Ha paura o ansia marcate riguardo all''ambiente naturale (es. altezze, temporali, acqua)') :- !.
label(it, fear_of_negative_evaluation, 'Teme di agire in un modo, o di mostrare sintomi d''ansia, che verranno valutati negativamente') :- !.
label(it, fear_of_open_spaces, 'Ha paura o ansia marcate nello stare in spazi aperti (es. parcheggi, ponti)') :- !.
label(it, fear_of_other_stimuli, 'Ha paura o ansia marcate riguardo ad altri stimoli (es. situazioni di soffocamento o vomito)') :- !.
label(it, fear_of_public_transport, 'Ha paura o ansia marcate nell''utilizzare i mezzi di trasporto pubblico') :- !.
label(it, fear_of_queues_or_crowds, 'Ha paura o ansia marcate nello stare in fila o tra la folla') :- !.
label(it, fear_of_situations, 'Ha paura o ansia marcate riguardo a situazioni specifiche (es. volare, ascensori, luoghi chiusi)') :- !.
label(it, fear_out_of_proportion_to_actual_danger, 'La paura o l''ansia sono sproporzionate rispetto al pericolo reale e al contesto socioculturale') :- !.
label(it, feeling_life_is_meaningless, 'Sente che la vita è priva di significato a seguito della morte') :- !.
label(it, generalized_anxiety_disorder, 'Disturbo d''Ansia Generalizzata') :- !.
label(it, generalized_anxiety_symptoms, 'Sintomi d''Ansia Generalizzata') :- !.
label(it, grief_associated_symptoms, 'Sintomi Associati al Lutto') :- !.
label(it, health_danger, 'Preoccupazione per un pericolo o una minaccia per la salute') :- !.
label(it, hoarding_behaviour, 'Comportamento di Accumulo') :- !.
label(it, hoarding_disorder, 'Disturbo da Accumulo') :- !.
label(it, hypervigilance, 'Mostra ipervigilanza') :- !.
label(it, identity_disruption_since_death, 'Sperimenta un''alterazione dell''identità a seguito della morte (es. sentire che una parte di sé è morta)') :- !.
label(it, inability_to_feel_positive_emotions, 'Ha una persistente incapacità di provare emozioni positive') :- !.
label(it, inhibited_attachment_behaviour, 'Comportamento di Attaccamento Inibito ed Emotivamente Ritirato') :- !.
label(it, insight_absent_or_delusional, 'Insight assente / convinzioni deliranti') :- !.
label(it, insight_good_or_fair, 'Insight buono o discreto') :- !.
label(it, insight_level, 'Quanto insight ha il paziente riguardo alle convinzioni/ai comportamenti') :- !.
label(it, insight_poor, 'Insight scarso') :- !.
label(it, insufficient_care, 'Pattern di Forme Estreme di Accudimento Insufficiente') :- !.
label(it, intense_emotional_pain, 'Prova un intenso dolore emotivo (es. rabbia, amarezza, sofferenza) legato alla morte') :- !.
label(it, intense_loneliness, 'Prova un''intensa solitudine a seguito della morte') :- !.
label(it, intense_yearning_for_the_deceased, 'Prova un intenso desiderio o nostalgia per la persona deceduta') :- !.
label(it, intrusion_symptoms, 'Sintomi Intrusivi') :- !.
label(it, intrusive_memories, 'Ha ricordi angoscianti ricorrenti, involontari e intrusivi dell''evento traumatico') :- !.
label(it, irritability, 'Avverte irritabilità') :- !.
label(it, irritability_or_aggression, 'Mostra comportamento irritabile e scoppi di rabbia con scarsa o nessuna provocazione') :- !.
label(it, learning_of_trauma_to_close_person, 'Ha appreso che l''evento traumatico è accaduto a un familiare stretto o a un amico intimo') :- !.
label(it, less_than_six_months, '< 6 mesi') :- !.
label(it, less_than_three_days, '< 3 giorni') :- !.
label(it, lightheadedness, 'Si sente vertiginoso, instabile, stordito o sul punto di svenire') :- !.
label(it, limited_positive_affect, 'Mostra un affetto positivo limitato') :- !.
label(it, maladaptive_behaviour_change_due_to_panic, 'Ha apportato un significativo cambiamento disadattivo del comportamento legato agli attacchi di panico') :- !.
label(it, marked_fear_of_social_scrutiny, 'Ha paura o ansia marcate riguardo a situazioni sociali che comportano un possibile giudizio da parte degli altri') :- !.
label(it, marked_fear_of_specific_object_or_situation, 'Ha paura o ansia marcate riguardo a un oggetto o a una situazione specifici') :- !.
label(it, medical_etiology, 'Eziologia Dovuta a un''Altra Condizione Medica') :- !.
label(it, minimal_social_emotional_responsiveness, 'Mostra una minima reattività sociale ed emotiva verso gli altri') :- !.
label(it, mirror_checking, 'Si controlla allo specchio') :- !.
label(it, more_than_five, '> 5') :- !.
label(it, more_than_one_hour_per_day, 'Trascorre più di un''ora al giorno con le ossessioni o le compulsioni') :- !.
label(it, more_than_three_months_after_stressor, 'Più di 3 mesi dopo il fattore stressante') :- !.
label(it, muscle_tension, 'Avverte tensione muscolare') :- !.
label(it, natural_environment_type, 'Tipo Ambiente Naturale') :- !.
label(it, nausea, 'Avverte nausea o disturbi addominali') :- !.
label(it, negative_cognitions_and_mood, 'Alterazioni Negative di Pensieri ed Emozioni') :- !.
label(it, nightmares_about_separation, 'Ha incubi ripetuti che riguardano il tema della separazione') :- !.
label(it, no_onset, 'Nessun esordio identificabile') :- !.
label(it, obsessions_or_compulsions, 'Ossessioni o Compulsioni') :- !.
label(it, obsessive_compulsive_disorder, 'Disturbo Ossessivo-Compulsivo') :- !.
label(it, obsessive_compulsive_disorder_with_good_or_fair_insight, 'Disturbo Ossessivo-Compulsivo, Con Insight Buono o Sufficiente') :- !.
label(it, obsessive_compulsive_disorder_with_poor_insight, 'Disturbo Ossessivo-Compulsivo, Con Scarso Insight') :- !.
label(it, obsessive_compulsive_disorder_with_absent_insight, 'Disturbo Ossessivo-Compulsivo, Con Insight Assente / Convinzioni Deliranti') :- !.
label(it, body_dysmorphic_disorder_with_good_or_fair_insight, 'Disturbo da Dismorfismo Corporeo, Con Insight Buono o Sufficiente') :- !.
label(it, body_dysmorphic_disorder_with_poor_insight, 'Disturbo da Dismorfismo Corporeo, Con Scarso Insight') :- !.
label(it, body_dysmorphic_disorder_with_absent_insight, 'Disturbo da Dismorfismo Corporeo, Con Insight Assente / Convinzioni Deliranti') :- !.
label(it, hoarding_disorder_with_good_or_fair_insight, 'Disturbo da Accumulo, Con Insight Buono o Sufficiente') :- !.
label(it, hoarding_disorder_with_poor_insight, 'Disturbo da Accumulo, Con Scarso Insight') :- !.
label(it, hoarding_disorder_with_absent_insight, 'Disturbo da Accumulo, Con Insight Assente / Convinzioni Deliranti') :- !.
label(it, occupational_distress, 'Sperimenta disagio o compromissione del funzionamento lavorativo') :- !.
label(it, ocrd_due_to_another_medical_condition, 'Disturbo Ossessivo-Compulsivo e Disturbi Correlati Dovuto a un''Altra Condizione Medica') :- !.
label(it, one_or_fewer, '<= 1') :- !.
label(it, one_to_three_months, '>= 1 mese & < 3 mesi') :- !.
label(it, other_anxiety_type, 'Un altro motivo dell''ansia') :- !.
label(it, other_functional_distress, 'Sperimenta disagio o compromissione in altre aree importanti del funzionamento') :- !.
label(it, other_type, 'Altro Tipo') :- !.
label(it, overly_familiar_behaviour, 'Mostra un comportamento verbale o fisico eccessivamente confidenziale con adulti non familiari') :- !.
label(it, palpitations, 'Avverte palpitazioni cardiache, battito accelerato o tachicardia') :- !.
label(it, panic_attack, 'Attacco di Panico') :- !.
label(it, panic_attacks_frequency, 'Quanti attacchi di panico si sono verificati') :- !.
label(it, panic_consequences_concern, 'Preoccupazione Persistente per gli Attacchi di Panico e le Loro Conseguenze') :- !.
label(it, panic_disorder, 'Disturbo di Panico') :- !.
label(it, paresthesias, 'Avverte parestesie (sensazioni di intorpidimento o formicolio)') :- !.
label(it, persistent_avoidance, 'Evitamento Persistente degli Stimoli') :- !.
label(it, persistent_grief_response, 'Risposta di Lutto Persistente') :- !.
label(it, persistent_negative_beliefs, 'Ha convinzioni o aspettative negative persistenti ed esagerate su se stesso, sugli altri o sul mondo') :- !.
label(it, persistent_negative_emotional_state, 'Ha uno stato emotivo negativo persistente (es. paura, orrore, rabbia, colpa, vergogna)') :- !.
label(it, phobic_avoidance, 'Evitamento Fobico') :- !.
label(it, phobic_reaction_type, 'Come reagisce il paziente alle situazioni temute') :- !.
label(it, physical_symptoms_on_separation, 'Ha ripetute lamentele di sintomi fisici quando la separazione si verifica o viene anticipata') :- !.
label(it, physiological_reactions_to_cues, 'Ha marcate reazioni fisiologiche a stimoli che ricordano l''evento traumatico') :- !.
label(it, posttraumatic_stress_disorder, 'Disturbo da Stress Post-Traumatico') :- !.
label(it, preoccupation_with_perceived_appearance_defects, 'È preoccupato per uno o più difetti o imperfezioni percepiti nell''aspetto fisico') :- !.
label(it, preoccupation_with_the_deceased, 'È preoccupato da pensieri o ricordi della persona deceduta') :- !.
label(it, preschool, '<= 6 anni') :- !.
label(it, prolonged_grief_disorder, 'Disturbo da Lutto Prolungato') :- !.
label(it, rarely_responds_to_comfort_when_distressed, 'Risponde raramente o minimamente al conforto quando è in difficoltà') :- !.
label(it, rarely_seeks_comfort_when_distressed, 'Cerca raramente o minimamente conforto quando è in difficoltà') :- !.
label(it, reaction_to_stressor, 'Reazione Emotiva o Comportamentale a un Fattore Stressante') :- !.
label(it, reactive_attachment_disorder, 'Disturbo Reattivo dell''Attaccamento') :- !.
label(it, rearing_limiting_attachment, 'È stato allevato in contesti insoliti che limitavano gravemente le opportunità di formare attaccamenti selettivi') :- !.
label(it, reassurance_seeking, 'Cerca rassicurazioni riguardo al proprio aspetto') :- !.
label(it, reckless_or_self_destructive_behaviour, 'Mette in atto comportamenti spericolati o autodistruttivi') :- !.
label(it, recurrent_hair_pulling, 'Strappamento Ricorrente dei Capelli') :- !.
label(it, recurrent_intrusive_unwanted_thoughts, 'Ha pensieri, impulsi o immagini ricorrenti e persistenti vissuti come intrusivi e indesiderati') :- !.
label(it, recurrent_pulling_out_of_hair, 'Si strappa ricorrentemente i capelli, con conseguente perdita di capelli') :- !.
label(it, recurrent_skin_picking, 'Stuzzicamento Ricorrente della Pelle') :- !.
label(it, recurrent_skin_picking_causing_lesions, 'Si stuzzica ricorrentemente la pelle, con conseguenti lesioni cutanee') :- !.
label(it, recurrent_unexpected_panic_attacks, 'Attacchi di Panico Inaspettati Ricorrenti') :- !.
label(it, reduced_positive_emotions, 'Mostra una persistente riduzione dell''espressione di emozioni positive') :- !.
label(it, reduced_reticence_with_unfamiliar_adults, 'Mostra una ridotta o assente reticenza nell''avvicinarsi e interagire con adulti non familiari') :- !.
label(it, reluctance_to_go_out_due_to_separation, 'È persistentemente riluttante o si rifiuta di uscire lontano da casa per paura della separazione') :- !.
label(it, reluctance_to_sleep_away_from_attachment_figures, 'È persistentemente riluttante o si rifiuta di dormire lontano da casa o senza essere vicino a una figura di attaccamento') :- !.
label(it, repeated_attempts_to_stop_hair_pulling, 'Ha fatto ripetuti tentativi di ridurre o interrompere lo strappamento dei capelli') :- !.
label(it, repeated_attempts_to_stop_skin_picking, 'Ha fatto ripetuti tentativi di ridurre o interrompere lo stuzzicamento della pelle') :- !.
label(it, repeated_changes_of_caregivers, 'Ha vissuto ripetuti cambiamenti delle figure di accudimento primarie che hanno limitato attaccamenti stabili') :- !.
label(it, repeated_exposure_to_trauma_details, 'Ha vissuto un''esposizione ripetuta o estrema a dettagli ripugnanti dell''evento traumatico') :- !.
label(it, repetitive_appearance_behaviours, 'Comportamenti Ripetitivi Legati all''Aspetto') :- !.
label(it, repetitive_behaviours_or_mental_acts, 'Mette in atto comportamenti o azioni mentali ripetitivi che si sente obbligato a eseguire') :- !.
label(it, restlessness, 'Avverte irrequietezza o la sensazione di essere teso o con i nervi a fior di pelle') :- !.
label(it, selective_mutism, 'Mutismo Selettivo') :- !.
label(it, separation_anxiety_disorder, 'Disturbo d''Ansia di Separazione') :- !.
label(it, separation_anxiety_duration, 'Durata dell''Ansia di Separazione') :- !.
label(it, significant_distress, 'Disagio o Compromissione Clinicamente Significativi') :- !.
label(it, situational_type, 'Tipo Situazionale') :- !.
label(it, six_months_or_more, '>= 6 mesi') :- !.
label(it, six_to_twelve_months, '>= 6 mesi & < 12 mesi') :- !.
label(it, skin_picking_for_appearance, 'Si stuzzica la pelle nel tentativo di migliorare un difetto percepito dell''aspetto') :- !.
label(it, sleep_disturbance, 'Ha disturbi del sonno (difficoltà ad addormentarsi o a mantenere il sonno, oppure sonno agitato)') :- !.
label(it, social_anxiety_disorder, 'Disturbo d''Ansia Sociale') :- !.
label(it, social_distress, 'Sperimenta disagio o compromissione del funzionamento sociale') :- !.
label(it, social_emotional_disturbance, 'Disturbo Sociale ed Emotivo Persistente') :- !.
label(it, social_neglect_or_deprivation, 'Ha vissuto trascuratezza o deprivazione sociale (persistente mancato soddisfacimento dei bisogni emotivi di base)') :- !.
label(it, social_phobic_anxiety, 'Ansia Sociale') :- !.
label(it, speaks_in_other_situations, 'Parla normalmente in altre situazioni nonostante non riesca a parlare in specifici contesti sociali') :- !.
label(it, specific_phobia, 'Fobia Specifica') :- !.
label(it, specific_phobia_animal_type, 'Fobia Specifica, Tipo Animali') :- !.
label(it, specific_phobia_blood_injection_injury_type, 'Fobia Specifica, Tipo Sangue-Iniezioni-Ferite') :- !.
label(it, specific_phobia_natural_environment_type, 'Fobia Specifica, Tipo Ambiente Naturale') :- !.
label(it, specific_phobia_other_type, 'Fobia Specifica, Altro Tipo') :- !.
label(it, specific_phobia_situational_type, 'Fobia Specifica, Tipo Situazionale') :- !.
label(it, specific_phobic_anxiety, 'Ansia Fobica Specifica') :- !.
label(it, substance_etiology, 'Eziologia da Sostanze/Farmaci') :- !.
label(it, substance_induced_anxiety_disorder, 'Disturbo d''Ansia Indotto da Sostanze/Farmaci') :- !.
label(it, substance_induced_ocrd, 'Disturbo Ossessivo-Compulsivo e Disturbi Correlati Indotto da Sostanze/Farmaci') :- !.
label(it, sweating, 'Avverte sudorazione') :- !.
label(it, symptoms_after_medical_condition_onset, 'I sintomi si sono sviluppati dopo l''esordio di un''altra condizione medica') :- !.
label(it, symptoms_after_substance_or_medication_use, 'I sintomi si sono sviluppati durante o subito dopo l''intossicazione da sostanze, l''astinenza o l''uso di farmaci') :- !.
label(it, symptoms_correlated_with_medical_condition, 'I sintomi sono correlati al decorso di un''altra condizione medica') :- !.
label(it, symptoms_correlated_with_substance_or_medication, 'I sintomi sono correlati all''uso di una sostanza o di un farmaco in grado di produrli') :- !.
label(it, symptoms_duration, 'Da quanto tempo persistono i sintomi') :- !.
label(it, symptoms_onset, 'Quando sono iniziati i sintomi rispetto al fattore stressante') :- !.
label(it, three_days_to_one_month, '>= 3 giorni & < 1 mese') :- !.
label(it, three_to_six_months, '>= 3 mesi & < 6 mesi') :- !.
label(it, time_consuming_more_than_one_hour, 'Dispendio di Tempo, Più di 1 Ora al Giorno') :- !.
label(it, traumatic_exposure, 'Esposizione a un Evento Traumatico') :- !.
label(it, trembling, 'Avverte tremori o scosse') :- !.
label(it, trichotillomania, 'Tricotillomania') :- !.
label(it, twelve_months_or_more, '>= 12 mesi') :- !.
label(it, two_to_five, '>= 2 & <= 5') :- !.
label(it, unexpected_attack, 'All''improvviso, in modo inaspettato') :- !.
label(it, unexplained_irritability_or_fearfulness, 'Ha episodi di irritabilità, tristezza o timore inspiegabili durante interazioni non minacciose') :- !.
label(it, unspecified_adjustment, 'Non specificato') :- !.
label(it, willing_to_go_off_with_strangers, 'È disposto ad allontanarsi con un adulto non familiare con minima o nessuna esitazione') :- !.
label(it, with_anxiety, 'Con ansia') :- !.
label(it, with_depressed_mood, 'Con umore depresso') :- !.
label(it, with_disturbance_of_conduct, 'Con alterazione della condotta') :- !.
label(it, with_mixed_anxiety_and_depressed_mood, 'Con ansia e umore depresso misti') :- !.
label(it, with_mixed_disturbance_emotions_conduct, 'Con alterazione mista delle emozioni e della condotta') :- !.
label(it, within_three_months_of_stressor, 'Entro 3 mesi dal fattore stressante') :- !.
label(it, witnessing_trauma, 'Ha assistito di persona all''evento traumatico mentre accadeva ad altri') :- !.
label(it, worry_about_losing_attachment_figures, 'Ha una preoccupazione eccessiva e persistente di perdere le figure di attaccamento o che possa accadere loro del male') :- !.
label(it, worry_about_new_panic_attacks, 'Ha una preoccupazione persistente di avere altri attacchi di panico') :- !.
label(it, worry_about_panic_consequences, 'Ha una preoccupazione persistente per le conseguenze degli attacchi di panico (es. perdere il controllo, un infarto)') :- !.
label(it, worry_an_event_causes_separation, 'Ha una preoccupazione eccessiva e persistente che un evento spiacevole possa causare la separazione da una figura di attaccamento') :- !.

% ---- explanations ----
explanation(it, abrupt_surge_of_fear_or_discomfort, 'Un improvviso aumento di paura o disagio intensi che raggiunge il picco in pochi minuti è la caratteristica distintiva di un attacco di panico.') :- !.
explanation(it, accumulation_clutters_living_areas, 'L''ingombro che congestiona e compromette gli spazi vitali attivi è una caratteristica centrale del disturbo da accumulo.') :- !.
explanation(it, adjustment_subtype, 'La presentazione sintomatologica predominante viene registrata come specificatore di sottotipo per il disturbo dell''adattamento.') :- !.
explanation(it, altered_sense_of_reality, 'Un''alterata percezione della realtà dell''ambiente circostante o di sé è un sintomo dissociativo che concorre alla diagnosi di disturbo da stress acuto.') :- !.
explanation(it, another_medical_condition, 'La presenza di un''altra condizione medica può indicare un disturbo d''ansia o ossessivo-compulsivo dovuto a un''altra condizione medica e aiuta a escludere un disturbo primario.') :- !.
explanation(it, anxiety_type, 'Il motivo principale dell''ansia aiuta a distinguere l''agorafobia, la paura legata alla salute e l''attesa apprensiva generalizzata.') :- !.
explanation(it, attack_type, 'Se gli attacchi di panico siano inaspettati o scatenati distingue il disturbo di panico (inaspettati) dalle presentazioni d''ansia scatenata.') :- !.
explanation(it, avoidance_of_external_trauma_reminders, 'L''evitamento di stimoli esterni che ricordano il trauma fa parte del cluster di evitamento del PTSD e del disturbo da stress acuto.') :- !.
explanation(it, avoidance_of_reminders_of_death, 'L''evitamento degli stimoli che ricordano che la persona è morta è uno dei sintomi a sostegno del disturbo da lutto prolungato.') :- !.
explanation(it, avoidance_of_trauma_thoughts_or_feelings, 'L''evitamento di stimoli interni che ricordano il trauma fa parte del cluster di evitamento del PTSD e del disturbo da stress acuto.') :- !.
explanation(it, being_easily_fatigued, 'L''affaticarsi facilmente è uno dei sintomi associati del disturbo d''ansia generalizzata.') :- !.
explanation(it, bereavement_time, 'Il tempo trascorso dalla morte viene confrontato con la soglia di 12 mesi (o 6 mesi nei giovani) per il disturbo da lutto prolungato.') :- !.
explanation(it, chest_pain, 'Il dolore o fastidio al petto è uno dei sintomi fisici di un attacco di panico.') :- !.
explanation(it, chills_or_hot_flushes, 'I brividi o le vampate di calore sono tra i sintomi fisici di un attacco di panico.') :- !.
explanation(it, choking, 'Una sensazione di soffocamento è uno dei sintomi fisici di un attacco di panico.') :- !.
explanation(it, comparing_appearance_with_others, 'Confrontare il proprio aspetto con quello degli altri è un''azione mentale ripetitiva osservata nel disturbo da dismorfismo corporeo.') :- !.
explanation(it, derealization_or_depersonalization, 'La derealizzazione o depersonalizzazione è uno dei sintomi di un attacco di panico e può anche indicare il sottotipo dissociativo del PTSD.') :- !.
explanation(it, detachment_from_others, 'I sentimenti di distacco o estraneità dagli altri appartengono al cluster delle alterazioni negative di pensieri ed emozioni del PTSD.') :- !.
explanation(it, difficulty_concentrating, 'La difficoltà di concentrazione è un sintomo associato del disturbo d''ansia generalizzata e un sintomo di arousal del PTSD.') :- !.
explanation(it, difficulty_controlling_worry, 'La difficoltà di controllare la preoccupazione è una caratteristica centrale che distingue il disturbo d''ansia generalizzata dalla preoccupazione ordinaria.') :- !.
explanation(it, difficulty_discarding_possessions, 'La persistente difficoltà a gettare i propri averi indirizza verso il disturbo da accumulo.') :- !.
explanation(it, difficulty_reintegrating, 'La difficoltà a reinserirsi nelle relazioni e nelle attività è uno dei sintomi a sostegno del disturbo da lutto prolungato.') :- !.
explanation(it, diminished_interest, 'L''interesse marcatamente ridotto verso attività significative appartiene al cluster delle alterazioni negative di pensieri ed emozioni del PTSD.') :- !.
explanation(it, directly_experiencing_trauma, 'Vivere direttamente un evento traumatico è una delle vie di esposizione che qualificano per il PTSD e il disturbo da stress acuto.') :- !.
explanation(it, disbelief_about_the_death, 'Un marcato senso di incredulità riguardo alla morte è uno dei sintomi a sostegno del disturbo da lutto prolungato.') :- !.
explanation(it, dissociative_amnesia_of_trauma, 'L''incapacità di ricordare un aspetto importante del trauma è un sintomo cognitivo negativo del PTSD e un sintomo dissociativo del disturbo da stress acuto.') :- !.
explanation(it, dissociative_flashbacks, 'Le reazioni dissociative come i flashback fanno parte del cluster intrusivo del PTSD e del disturbo da stress acuto.') :- !.
explanation(it, distorted_blame, 'I pensieri distorti che portano ad incolpare se stessi o gli altri appartengono al cluster delle alterazioni negative di pensieri ed emozioni del PTSD.') :- !.
explanation(it, distress_associated_with_discarding, 'Il disagio associato al gettare via gli oggetti e la percepita necessità di conservarli sono alla base della difficoltà a disfarsene nel disturbo da accumulo.') :- !.
explanation(it, distress_at_separation_from_attachment_figures, 'Il disagio eccessivo e ricorrente alla separazione dalle figure di attaccamento è un sintomo centrale del disturbo d''ansia di separazione.') :- !.
explanation(it, distress_at_trauma_cues, 'Il disagio psicologico intenso all''esposizione a stimoli del trauma fa parte del cluster intrusivo del PTSD e del disturbo da stress acuto.') :- !.
explanation(it, distressing_dreams, 'I sogni angoscianti ricorrenti correlati all''evento fanno parte del cluster intrusivo del PTSD e del disturbo da stress acuto.') :- !.
explanation(it, does_not_check_back_with_caregiver, 'La ridotta verifica del ritorno alla figura di accudimento dopo essersi allontanato è un sintomo del disturbo da impegno sociale disinibito.') :- !.
explanation(it, dyspnea, 'La mancanza di respiro o la sensazione di asfissia è uno dei sintomi fisici di un attacco di panico.') :- !.
explanation(it, emotional_numbness, 'L''intorpidimento emotivo è uno dei sintomi a sostegno del disturbo da lutto prolungato.') :- !.
explanation(it, emotional_or_behavioural_symptoms_after_stressor, 'I sintomi emotivi o comportamentali che si sviluppano in risposta a un fattore stressante identificabile sono il nucleo del disturbo dell''adattamento.') :- !.
explanation(it, exaggerated_startle_response, 'Una risposta di allarme esagerata fa parte del cluster dell''arousal e della reattività del PTSD e del disturbo da stress acuto.') :- !.
explanation(it, excessive_grooming, 'L''eccessiva cura della propria persona è un comportamento ripetitivo osservato nel disturbo da dismorfismo corporeo.') :- !.
explanation(it, excessive_worry_about_several_events, 'L''ansia e la preoccupazione eccessive riguardo a numerosi eventi o attività sono una caratteristica centrale del disturbo d''ansia generalizzata.') :- !.
explanation(it, failure_to_speak_in_specific_social_situations, 'La costante incapacità di parlare in specifiche situazioni sociali in cui ci si aspetta che si parli è la caratteristica centrale del mutismo selettivo.') :- !.
explanation(it, fear_almost_always_provoked, 'Quando lo stimolo temuto provoca quasi sempre paura o ansia immediate, questo supporta la fobia specifica, il disturbo d''ansia sociale o l''agorafobia.') :- !.
explanation(it, fear_of_animals, 'La paura degli animali supporta una diagnosi di fobia specifica, tipo animali.') :- !.
explanation(it, fear_of_being_alone, 'La paura o riluttanza nello stare da solo senza le figure di attaccamento è un sintomo del disturbo d''ansia di separazione.') :- !.
explanation(it, fear_of_being_outside_home_alone, 'La paura di stare fuori casa da solo è una delle situazioni agorafobiche.') :- !.
explanation(it, fear_of_blood_injection_injury, 'La paura di sangue, iniezioni o ferite supporta una diagnosi di fobia specifica, tipo sangue-iniezioni-ferite.') :- !.
explanation(it, fear_of_dying, 'La paura di morire è uno dei sintomi cognitivi di un attacco di panico.') :- !.
explanation(it, fear_of_enclosed_places, 'La paura dei luoghi chiusi è una delle situazioni agorafobiche.') :- !.
explanation(it, fear_of_losing_control, 'La paura di perdere il controllo o di impazzire è uno dei sintomi cognitivi di un attacco di panico.') :- !.
explanation(it, fear_of_natural_environment, 'La paura dell''ambiente naturale supporta una diagnosi di fobia specifica, tipo ambiente naturale.') :- !.
explanation(it, fear_of_negative_evaluation, 'La paura di essere valutato negativamente dagli altri è la cognizione centrale del disturbo d''ansia sociale.') :- !.
explanation(it, fear_of_open_spaces, 'La paura degli spazi aperti è una delle situazioni agorafobiche.') :- !.
explanation(it, fear_of_other_stimuli, 'La paura di altri stimoli (es. soffocamento o vomito) supporta una diagnosi di fobia specifica, altro tipo.') :- !.
explanation(it, fear_of_public_transport, 'La paura di utilizzare i mezzi di trasporto pubblico è una delle situazioni agorafobiche.') :- !.
explanation(it, fear_of_queues_or_crowds, 'La paura di stare in fila o tra la folla è una delle situazioni agorafobiche.') :- !.
explanation(it, fear_of_situations, 'La paura di situazioni specifiche come volare o i luoghi chiusi supporta la fobia specifica, tipo situazionale.') :- !.
explanation(it, fear_out_of_proportion_to_actual_danger, 'La paura sproporzionata rispetto al pericolo reale è una caratteristica richiesta dei disturbi fobici e agorafobici.') :- !.
explanation(it, feeling_life_is_meaningless, 'Il sentire che la vita è priva di significato a seguito della morte è uno dei sintomi a sostegno del disturbo da lutto prolungato.') :- !.
explanation(it, hypervigilance, 'L''ipervigilanza fa parte del cluster dell''arousal e della reattività del PTSD e del disturbo da stress acuto.') :- !.
explanation(it, identity_disruption_since_death, 'L''alterazione dell''identità a seguito della morte è uno dei sintomi a sostegno del disturbo da lutto prolungato.') :- !.
explanation(it, inability_to_feel_positive_emotions, 'La persistente incapacità di provare emozioni positive è un sintomo cognitivo negativo del PTSD e del disturbo da stress acuto.') :- !.
explanation(it, insight_level, 'Il livello di insight viene registrato come specificatore per il disturbo ossessivo-compulsivo, il disturbo da dismorfismo corporeo e il disturbo da accumulo.') :- !.
explanation(it, intense_emotional_pain, 'L''intenso dolore emotivo legato alla morte è uno dei sintomi a sostegno del disturbo da lutto prolungato.') :- !.
explanation(it, intense_loneliness, 'L''intensa solitudine a seguito della morte è uno dei sintomi a sostegno del disturbo da lutto prolungato.') :- !.
explanation(it, intense_yearning_for_the_deceased, 'L''intenso desiderio o nostalgia per la persona deceduta è una caratteristica centrale della risposta di lutto persistente nel disturbo da lutto prolungato.') :- !.
explanation(it, intrusive_memories, 'I ricordi angoscianti ricorrenti, involontari e intrusivi fanno parte del cluster intrusivo del PTSD e del disturbo da stress acuto.') :- !.
explanation(it, irritability, 'L''irritabilità è uno dei sintomi associati del disturbo d''ansia generalizzata.') :- !.
explanation(it, irritability_or_aggression, 'Il comportamento irritabile e gli scoppi di rabbia fanno parte del cluster dell''arousal e della reattività del PTSD e del disturbo da stress acuto.') :- !.
explanation(it, learning_of_trauma_to_close_person, 'Apprendere che l''evento è accaduto a una persona vicina è una delle vie di esposizione che qualificano per il PTSD e il disturbo da stress acuto.') :- !.
explanation(it, lightheadedness, 'Il sentirsi vertiginoso, instabile o stordito è uno dei sintomi fisici di un attacco di panico.') :- !.
explanation(it, limited_positive_affect, 'L''affetto positivo limitato fa parte del disturbo sociale ed emotivo del disturbo reattivo dell''attaccamento.') :- !.
explanation(it, maladaptive_behaviour_change_due_to_panic, 'Un significativo cambiamento disadattivo del comportamento legato agli attacchi è una delle conseguenze richieste per il disturbo di panico.') :- !.
explanation(it, marked_fear_of_social_scrutiny, 'La paura marcata delle situazioni sociali che comportano un possibile giudizio è la caratteristica centrale del disturbo d''ansia sociale.') :- !.
explanation(it, marked_fear_of_specific_object_or_situation, 'La paura marcata di un oggetto o di una situazione specifici è la caratteristica centrale della fobia specifica.') :- !.
explanation(it, minimal_social_emotional_responsiveness, 'La minima reattività sociale ed emotiva fa parte del disturbo sociale ed emotivo del disturbo reattivo dell''attaccamento.') :- !.
explanation(it, mirror_checking, 'Il controllarsi allo specchio è un comportamento ripetitivo osservato nel disturbo da dismorfismo corporeo.') :- !.
explanation(it, more_than_one_hour_per_day, 'Trascorrere più di un''ora al giorno con ossessioni o compulsioni soddisfa la soglia di dispendio di tempo per il disturbo ossessivo-compulsivo.') :- !.
explanation(it, muscle_tension, 'La tensione muscolare è uno dei sintomi associati del disturbo d''ansia generalizzata.') :- !.
explanation(it, nausea, 'La nausea o i disturbi addominali sono uno dei sintomi fisici di un attacco di panico.') :- !.
explanation(it, nightmares_about_separation, 'Gli incubi ripetuti con un tema di separazione sono un sintomo del disturbo d''ansia di separazione.') :- !.
explanation(it, occupational_distress, 'Il disagio o la compromissione del funzionamento lavorativo aiuta a stabilire la significatività clinica richiesta dalla maggior parte dei disturbi.') :- !.
explanation(it, other_functional_distress, 'Il disagio o la compromissione in altre aree importanti del funzionamento aiuta a stabilire la significatività clinica richiesta dalla maggior parte dei disturbi.') :- !.
explanation(it, overly_familiar_behaviour, 'Il comportamento verbale o fisico eccessivamente confidenziale è un sintomo del disturbo da impegno sociale disinibito.') :- !.
explanation(it, palpitations, 'La presenza di palpitazioni può essere indicativa di un attacco di panico.') :- !.
explanation(it, panic_attacks_frequency, 'Il numero di attacchi di panico aiuta a stabilire se gli attacchi siano ricorrenti, come richiesto per il disturbo di panico.') :- !.
explanation(it, paresthesias, 'Le parestesie (intorpidimento o formicolio) sono tra i sintomi fisici di un attacco di panico.') :- !.
explanation(it, patient, 'La fascia d''età del paziente viene utilizzata per applicare i criteri, le durate specifici per l''età e il sottotipo prescolare del PTSD.') :- !.
explanation(it, persistent_negative_beliefs, 'Le convinzioni negative persistenti ed esagerate su se stessi, sugli altri o sul mondo appartengono al cluster delle alterazioni negative di pensieri ed emozioni del PTSD.') :- !.
explanation(it, persistent_negative_emotional_state, 'Uno stato emotivo negativo persistente appartiene al cluster delle alterazioni negative di pensieri ed emozioni del PTSD.') :- !.
explanation(it, phobic_reaction_type, 'Il modo in cui il paziente reagisce alle situazioni temute (evitamento o sopportazione con disagio) è richiesto per i disturbi fobici e agorafobici.') :- !.
explanation(it, physical_symptoms_on_separation, 'Le ripetute lamentele di sintomi fisici quando la separazione si verifica o viene anticipata sono un sintomo del disturbo d''ansia di separazione.') :- !.
explanation(it, physiological_reactions_to_cues, 'Le marcate reazioni fisiologiche agli stimoli del trauma fanno parte del cluster intrusivo del PTSD e del disturbo da stress acuto.') :- !.
explanation(it, preoccupation_with_perceived_appearance_defects, 'La preoccupazione per difetti o imperfezioni percepiti nell''aspetto è la caratteristica centrale del disturbo da dismorfismo corporeo.') :- !.
explanation(it, preoccupation_with_the_deceased, 'La preoccupazione per pensieri o ricordi della persona deceduta è una caratteristica centrale della risposta di lutto persistente nel disturbo da lutto prolungato.') :- !.
explanation(it, rarely_responds_to_comfort_when_distressed, 'Il rispondere raramente al conforto quando si è in difficoltà fa parte del comportamento di attaccamento inibito del disturbo reattivo dell''attaccamento.') :- !.
explanation(it, rarely_seeks_comfort_when_distressed, 'Il cercare raramente conforto quando si è in difficoltà fa parte del comportamento di attaccamento inibito del disturbo reattivo dell''attaccamento.') :- !.
explanation(it, rearing_limiting_attachment, 'L''essere allevati in contesti che limitano gli attaccamenti selettivi è una forma di accudimento insufficiente alla base dei disturbi dell''attaccamento.') :- !.
explanation(it, reassurance_seeking, 'La ricerca di rassicurazioni riguardo all''aspetto è un comportamento ripetitivo osservato nel disturbo da dismorfismo corporeo.') :- !.
explanation(it, reckless_or_self_destructive_behaviour, 'Il comportamento spericolato o autodistruttivo fa parte del cluster dell''arousal e della reattività del PTSD.') :- !.
explanation(it, recurrent_intrusive_unwanted_thoughts, 'I pensieri, impulsi o immagini ricorrenti, intrusivi e indesiderati definiscono le ossessioni nel disturbo ossessivo-compulsivo.') :- !.
explanation(it, recurrent_pulling_out_of_hair, 'Lo strappamento ricorrente dei capelli con conseguente perdita di capelli è la caratteristica centrale della tricotillomania.') :- !.
explanation(it, recurrent_skin_picking_causing_lesions, 'Lo stuzzicamento ricorrente della pelle con conseguenti lesioni è la caratteristica centrale del disturbo da escoriazione.') :- !.
explanation(it, reduced_positive_emotions, 'Una persistente riduzione dell''espressione di emozioni positive fa parte del cluster combinato del sottotipo prescolare del PTSD.') :- !.
explanation(it, reduced_reticence_with_unfamiliar_adults, 'La ridotta reticenza nell''avvicinarsi ad adulti non familiari è un sintomo del disturbo da impegno sociale disinibito.') :- !.
explanation(it, reluctance_to_go_out_due_to_separation, 'La riluttanza o il rifiuto di uscire per paura della separazione è un sintomo del disturbo d''ansia di separazione.') :- !.
explanation(it, reluctance_to_sleep_away_from_attachment_figures, 'La riluttanza o il rifiuto di dormire lontano dalle figure di attaccamento è un sintomo del disturbo d''ansia di separazione.') :- !.
explanation(it, repeated_attempts_to_stop_hair_pulling, 'I ripetuti tentativi di ridurre o interrompere lo strappamento dei capelli sono un criterio richiesto per la tricotillomania.') :- !.
explanation(it, repeated_attempts_to_stop_skin_picking, 'I ripetuti tentativi di ridurre o interrompere lo stuzzicamento della pelle sono un criterio richiesto per il disturbo da escoriazione.') :- !.
explanation(it, repeated_changes_of_caregivers, 'I ripetuti cambiamenti delle figure di accudimento primarie sono una forma di accudimento insufficiente alla base dei disturbi dell''attaccamento.') :- !.
explanation(it, repeated_exposure_to_trauma_details, 'L''esposizione ripetuta o estrema a dettagli ripugnanti è una delle vie di esposizione che qualificano per il PTSD nelle persone di età superiore ai 6 anni.') :- !.
explanation(it, repetitive_behaviours_or_mental_acts, 'I comportamenti o le azioni mentali ripetitivi messi in atto in risposta alle ossessioni definiscono le compulsioni nel disturbo ossessivo-compulsivo.') :- !.
explanation(it, restlessness, 'L''irrequietezza o la sensazione di essere teso è uno dei sintomi associati del disturbo d''ansia generalizzata.') :- !.
explanation(it, skin_picking_for_appearance, 'Lo stuzzicamento della pelle per migliorare un difetto percepito dell''aspetto indirizza verso il disturbo da dismorfismo corporeo piuttosto che verso il disturbo da escoriazione.') :- !.
explanation(it, sleep_disturbance, 'Il disturbo del sonno è un sintomo associato del disturbo d''ansia generalizzata e un sintomo di arousal del PTSD e del disturbo da stress acuto.') :- !.
explanation(it, social_distress, 'Il disagio o la compromissione del funzionamento sociale aiuta a stabilire la significatività clinica richiesta dalla maggior parte dei disturbi.') :- !.
explanation(it, social_neglect_or_deprivation, 'La trascuratezza o deprivazione sociale è una forma di accudimento insufficiente alla base dei disturbi dell''attaccamento.') :- !.
explanation(it, speaks_in_other_situations, 'Il parlare normalmente in altre situazioni conferma che l''incapacità di parlare è specifica della situazione, come richiesto per il mutismo selettivo.') :- !.
explanation(it, sweating, 'La sudorazione è uno dei sintomi fisici di un attacco di panico.') :- !.
explanation(it, symptoms_after_medical_condition_onset, 'I sintomi che si sviluppano dopo l''esordio di un''altra condizione medica supportano un disturbo dovuto a un''altra condizione medica.') :- !.
explanation(it, symptoms_after_substance_or_medication_use, 'I sintomi che si sviluppano durante o subito dopo l''uso di sostanze o farmaci supportano un disturbo indotto da sostanze/farmaci.') :- !.
explanation(it, symptoms_correlated_with_medical_condition, 'I sintomi correlati al decorso di una condizione medica supportano un disturbo dovuto a un''altra condizione medica.') :- !.
explanation(it, symptoms_correlated_with_substance_or_medication, 'I sintomi correlati a una sostanza o a un farmaco in grado di produrli supportano un disturbo indotto da sostanze/farmaci.') :- !.
explanation(it, symptoms_duration, 'La durata dei sintomi viene utilizzata per applicare le soglie di durata minima che distinguono il disturbo da stress acuto, il PTSD e i disturbi d''ansia.') :- !.
explanation(it, symptoms_onset, 'La tempistica dell''esordio dei sintomi rispetto al fattore stressante viene utilizzata per distinguere il disturbo dell''adattamento e per applicare i specificatori di esordio.') :- !.
explanation(it, trembling, 'I tremori o le scosse sono uno dei sintomi fisici di un attacco di panico.') :- !.
explanation(it, unexplained_irritability_or_fearfulness, 'Gli episodi di irritabilità, tristezza o timore inspiegabili fanno parte del disturbo sociale ed emotivo del disturbo reattivo dell''attaccamento.') :- !.
explanation(it, willing_to_go_off_with_strangers, 'La disponibilità ad allontanarsi con un adulto non familiare è un sintomo del disturbo da impegno sociale disinibito.') :- !.
explanation(it, witnessing_trauma, 'Assistere di persona all''evento mentre accade ad altri è una delle vie di esposizione che qualificano per il PTSD e il disturbo da stress acuto.') :- !.
explanation(it, worry_about_losing_attachment_figures, 'La preoccupazione persistente di perdere le figure di attaccamento o che possa accadere loro del male è un sintomo del disturbo d''ansia di separazione.') :- !.
explanation(it, worry_about_new_panic_attacks, 'La preoccupazione persistente di avere altri attacchi di panico è una delle conseguenze richieste per il disturbo di panico.') :- !.
explanation(it, worry_about_panic_consequences, 'La preoccupazione persistente per le conseguenze degli attacchi è una delle conseguenze richieste per il disturbo di panico.') :- !.
explanation(it, worry_an_event_causes_separation, 'La preoccupazione persistente che un evento spiacevole possa causare la separazione è un sintomo del disturbo d''ansia di separazione.') :- !.

% ---- refined induced/medical-condition tail (DSM-5-TR) ----
label(it, predominant_anxiety, 'Ansia Predominante (Attacchi di Panico o Ansia)') :- !.
label(it, predominant_oc_presentation, 'Presentazione Ossessivo-Compulsiva Predominante') :- !.
label(it, not_delirium_bound, 'Non Esclusivamente Durante un Delirium') :- !.
label(it, substance_intoxication_or_withdrawal_or_medication_use, 'Era intossicato o in astinenza da una sostanza, o aveva assunto un farmaco, nel periodo in cui sono comparsi i sintomi') :- !.
label(it, symptoms_developed_during_or_after_substance_use, 'I sintomi si sono sviluppati durante o poco dopo l''intossicazione o l''astinenza da sostanze, o dopo l''esposizione a un farmaco') :- !.
label(it, substance_capable_of_producing_symptoms, 'La sostanza o il farmaco coinvolti sono in grado di produrre i sintomi riferiti') :- !.
label(it, disturbance_is_direct_consequence_of_medical_condition, 'Vi è evidenza che il disturbo sia la diretta conseguenza fisiologica di un''altra condizione medica') :- !.
label(it, not_exclusively_during_delirium, 'Il disturbo non si manifesta esclusivamente durante episodi di delirium') :- !.
explanation(it, substance_intoxication_or_withdrawal_or_medication_use, 'Stabilire il coinvolgimento di una sostanza o di un farmaco è necessario per considerare un disturbo indotto da sostanze/farmaci') :- !.
explanation(it, symptoms_developed_during_or_after_substance_use, 'Un legame temporale tra i sintomi e la sostanza o il farmaco supporta un disturbo indotto (Criterio B1)') :- !.
explanation(it, substance_capable_of_producing_symptoms, 'La sostanza o il farmaco deve essere farmacologicamente in grado di causare i sintomi (Criterio B2)') :- !.
explanation(it, disturbance_is_direct_consequence_of_medical_condition, 'Un legame fisiopatologico diretto con una condizione medica supporta un disturbo dovuto a un''altra condizione medica (Criterio B)') :- !.
explanation(it, not_exclusively_during_delirium, 'Sintomi che si manifestano esclusivamente durante un delirium escluderebbero questa diagnosi (Criterio D)') :- !.
