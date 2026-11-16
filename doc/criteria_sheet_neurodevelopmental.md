# DSM-5-TR criteria sheet: Neurodevelopmental Disorders

Reference: DSM-5-TR (APA, 2022), chapter "Neurodevelopmental Disorders" (pp.
35-99 of the print edition). The criteria are paraphrased in my own words;
letters, counts, durations and codes are those of the manual. ICD-11 codes are
from the WHO ICD-11 MMS, release 2026-01
(https://icd.who.int/browse/2026-01/mms/en), as metadata only; the tic
disorders sit in chapter 8 (diseases of the nervous system) of ICD-11. Status:
every entry was checked against the DSM-5-TR text on 2026-11-16; "KB" names the
implementing clause in `prolog/criteria.pl` or `prolog/disorders.pl`. Global
developmental delay, speech sound disorder, childhood-onset fluency disorder,
stereotypic movement disorder and the other specified / unspecified categories
are not modelled.

---

## Intellectual Developmental Disorder (Intellectual Disability) (p. 37)
ICD-10-CM F70 mild, F71 moderate, F72 severe, F73 profound · ICD-11 6A00.0-6A00.3

| | Criterion (paraphrase) | KB |
| --- | --- | --- |
| A | Deficits in intellectual functions (reasoning, problem solving, planning, abstract thinking, judgement, learning), confirmed both by clinical assessment and by an individually administered standardized intelligence test | `intellectual_function_deficits` (2 of 2) |
| B | Deficits in adaptive functioning that, without ongoing support, limit one or more activities of daily life across several environments | `adaptive_functioning_deficits` |
| C | Onset of both deficits during the developmental period | `onset_in_early_developmental_period` |

Severity (one goal each) is rated on adaptive functioning, not on the IQ score
(p. 41), and is asked as a choice (`idd_severity`). The IQ is entered by the
clinician from a standardized test: the finding `iq_full_scale` supports A with
full membership up to 70 and none from 76 (about 2 SD below the mean, 70 ± 5,
p. 41).

## Language Disorder (p. 47)
ICD-10-CM F80.2 · ICD-11 6A01.2

| | Criterion | KB |
| --- | --- | --- |
| A | Persistent difficulties acquiring and using language from deficits of comprehension or production, among them reduced vocabulary, limited sentence structure, impaired discourse | `language_acquisition_deficits` (1 of 3) |
| B | Abilities substantially and quantifiably below age, with functional limitations | `language_abilities_substantially_below_age`, `significant_distress` |
| C | Onset in the early developmental period | `onset_in_early_developmental_period` |
| D | Not attributable to a sensory, motor, medical or neurological condition, not better explained by intellectual disability or global developmental delay | `language_difficulties_attributable_to_sensory_or_medical_condition`, `language_difficulties_better_explained_by_intellectual_disability` (false) |

## Social (Pragmatic) Communication Disorder (p. 54)
ICD-10-CM F80.82 · ICD-11 6A01.22 (developmental language disorder with impairment of mainly pragmatic language)

| | Criterion | KB |
| --- | --- | --- |
| A | Persistent difficulties in the social use of verbal and nonverbal communication, all 4: using communication for social purposes; adapting it to the context or listener; following the rules of conversation and storytelling; understanding what is not explicit and nonliteral language | `social_communication_deficits` (4 of 4) |
| B | Functional limitations in communication, participation, relationships, school or work | `significant_distress` |
| C | Onset in the early developmental period | `onset_in_early_developmental_period` |
| D | Not attributable to a medical or neurological condition or to low structural language, not better explained by autism spectrum disorder, intellectual disability, global developmental delay or another mental disorder | `restricted_repetitive_behaviours` (false), `pragmatic_deficits_better_explained_by_other_condition` (false) |

The autism part of D is the absence of autism criterion B (restricted,
repetitive behaviour, currently or by history), which is how the manual
separates the two disorders (p. 55): the same pragmatic deficits with 2
restricted patterns give autism, not this disorder.

## Autism Spectrum Disorder (p. 56)
ICD-10-CM F84.0 · ICD-11 6A02 (6A02.0-6A02.3, 6A02.5 by intellectual and functional-language impairment)

| | Criterion | KB |
| --- | --- | --- |
| A | Persistent deficits in social communication and interaction across contexts, all 3, currently or by history: social-emotional reciprocity; nonverbal communication; developing, maintaining and understanding relationships | `social_interaction_deficits` (3 of 3) |
| B | Restricted, repetitive patterns, at least 2 of 4, currently or by history: stereotyped or repetitive movements, use of objects or speech; insistence on sameness, routines, rituals; highly restricted, fixated interests; hyper- or hyporeactivity to sensory input | `restricted_repetitive_behaviours` (2 of 4) |
| C | Present in the early developmental period (possibly masked or not fully manifest until later) | `onset_in_early_developmental_period` |
| D | Clinically significant impairment | `significant_distress` |
| E | Not better explained by intellectual disability or global developmental delay; with intellectual disability, social communication must be below the general developmental level | `autistic_features_better_explained_by_intellectual_disability` (false) |

Specifiers: with or without accompanying intellectual impairment
(`accompanying_intellectual_impairment`) and language impairment
(`accompanying_language_impairment`), modelled as the four combinations, one
goal each, since each one has its own ICD-11 code; level of support for social
communication and for restricted, repetitive behaviours (levels 1-3, table 2),
one goal per level and domain. The specifiers on associated conditions and
catatonia are not modelled.

## Attention-Deficit/Hyperactivity Disorder (p. 68)
ICD-10-CM F90.2 combined, F90.0 predominantly inattentive, F90.1 predominantly hyperactive/impulsive · ICD-11 6A05.2, 6A05.0, 6A05.1

| | Criterion | KB |
| --- | --- | --- |
| A1 | At least 6 of 9 inattention symptoms for at least 6 months, inconsistent with the developmental level; at least 5 from age 17 | `inattention_symptoms` (6 or 5 of 9), `duration_at_least_six_months` |
| A2 | At least 6 of 9 hyperactivity-impulsivity symptoms, same terms | `hyperactivity_impulsivity_symptoms` (6 or 5 of 9) |
| A | A1 and/or A2 | `inattention_or_hyperactivity` (maximum of the two) |
| B | Several symptoms present before age 12 | `several_symptoms_before_age_twelve` |
| C | Several symptoms in two or more settings | `symptoms_in_two_or_more_settings` |
| D | Clear interference with social, academic or occupational functioning | `significant_distress` |
| E | Not only during a psychotic disorder, not better explained by another mental disorder or by substance intoxication or withdrawal | `adhd_symptoms_better_explained_by_other_disorder` (false) |

Presentations (one goal each): combined (A1 and A2), predominantly inattentive
(A1, not A2), predominantly hyperactive/impulsive (A2, not A1). In partial
remission: full criteria met in the past, neither A1 nor A2 now, still
impairing (`full_adhd_criteria_previously_met`). Severity mild / moderate /
severe is asked as a choice (`adhd_severity`). The threshold of 5 symptoms
applies from age 17: with the exact age (`/evaluate`) it is exact; with the
age bands of the consultation it applies to adults, and a 17-year-old in the
13-17 band is held to 6.

## Specific Learning Disorder (p. 76)
ICD-10-CM F81.0 reading, F81.81 written expression, F81.2 mathematics · ICD-11 6A03.0, 6A03.1, 6A03.2

| | Criterion | KB |
| --- | --- | --- |
| A | At least 1 of 6 learning difficulties persisting at least 6 months despite targeted interventions: word reading; reading comprehension; spelling; written expression; number sense and calculation; mathematical reasoning | the symptoms of each domain, `duration_at_least_six_months`, `difficulties_persist_despite_interventions` |
| B | Skills substantially and quantifiably below age, interfering with school, work or daily life, confirmed by standardized achievement measures; from age 17 a documented history may replace the standardized assessment | `reading_skills_below_age`, `written_expression_skills_below_age`, `mathematics_skills_below_age` or `documented_history_of_impairing_learning_difficulties`, `significant_distress` |
| C | Onset during the school years | `learning_difficulties_began_in_school_years` |
| D | Not better accounted for by intellectual disability, uncorrected vision or hearing, other mental or neurological disorders, psychosocial adversity, lack of proficiency in the language of instruction or inadequate instruction | `learning_difficulties_explained_by_intellectual_disability`, `learning_difficulties_better_accounted_for_by_other_factors` (false) |

Every impaired domain is coded (one goal each: `reading_impairment`,
`written_expression_impairment`, `mathematics_impairment`); severity is asked as
a choice (`learning_disorder_severity`). The manual places low achievement at
1.5 SD below the mean (standard score 78 or less) for the greatest certainty
and allows 1 SD (85) with converging evidence (p. 79): the achievement
findings have full membership up to 78 and none from 85.

## Developmental Coordination Disorder (p. 85)
ICD-10-CM F82 · ICD-11 6A04

| | Criterion | KB |
| --- | --- | --- |
| A | Coordinated motor skills substantially below age and opportunity: clumsiness, slow or inaccurate performance | `motor_coordination_deficits` (2 of 2) |
| B | Significant, persistent interference with daily activities, school, leisure and play | `motor_deficits_interfere_with_daily_activities` |
| C | Onset in the early developmental period | `onset_in_early_developmental_period` |
| D | Not better explained by intellectual disability or visual impairment, not attributable to a neurological condition affecting movement | `motor_deficits_explained_by_intellectual_disability_or_visual_impairment`, `motor_deficits_due_to_neurological_condition` (false) |

## Tic Disorders (p. 93)
A tic is a sudden, rapid, recurrent, nonrhythmic movement or vocalization.

**Tourette's disorder**, ICD-10-CM F95.2 · ICD-11 8A05.00: A multiple motor
and at least one vocal tic, not necessarily together
(`multiple_motor_and_vocal_tics`); B more than 1 year since the first tic
(`tics_persisted_more_than_one_year`); C onset before 18
(`tic_onset_before_age_eighteen`); D not attributable to a substance or a
medical condition (the shared exclusion, `primary/5`).

**Persistent (chronic) motor or vocal tic disorder**, ICD-10-CM F95.1 · ICD-11
8A05.01 motor, 8A05.02 phonic: A motor or vocal tics, not both; B, C, D as
above; E never met the criteria for Tourette's disorder
(`criteria_ever_met_for_tourettes_disorder`, false). The specifier "with motor
tics only" / "with vocal tics only" is the kind of tic of A, so the two goals
cover the disorder (`motor_tics`, `vocal_tics`).

**Provisional tic disorder**, ICD-10-CM F95.0 · ICD-11 8A05.03 (transient
motor tics; ICD-11 has no code for transient vocal tics): A motor and/or vocal
tics (`motor_or_vocal_tics`); B less than 1 year since the first tic
(`tics_persisted_more_than_one_year`, false); C, D as above; E never met the
criteria for Tourette's or persistent tic disorder.

---

## Findings from test results (`prolog/findings.pl`)

`POST /evaluate` accepts the results of tests and records as findings. Each
one gives evidence for criterion items, with a degree in [0,1]: the membership
of the score to the cutoff, scaled by the weight of the source. Evidence is
confirmatory (structured interview, standardized test, record) or provisional
(screening scale): a provisional item lowers the uncertainty of the lower bound
but leaves the criterion unknown until the clinician confirms it. A direct
answer to an item overrides any finding.

| Finding | Items | Degree |
| --- | --- | --- |
| `diva5_inattention_count`, `diva5_hyperactivity_count` (0-9) | A1, A2 counts | 0.95 × [count ≥ threshold], soft from threshold - 1 |
| `asrs_inattention_count`, `asrs_hyperactivity_count` (0-9) | A1, A2 counts, provisional | 0.8 × the same |
| `diva5_childhood_*_count`, `informant_confirms_childhood_symptoms` | ADHD B | total from 1 to 3 symptoms, × 0.95 confirmed, 0.8 no informant, 0.45 contradicted |
| `school_report_symptoms_before_twelve` | ADHD B | 0.9 |
| `settings_with_symptoms` | ADHD C | 0.95 × [settings ≥ 2] |
| `aq_total` (cutoff 32), `raads_r_total` (65) and the RAADS-R subscales | ASD A1-A3, B1-B4, provisional | 0.8 × membership from below the cutoff to the cutoff |
| `iq_full_scale` | IDD A test, ASD intellectual impairment; the intellectual-disability exclusions of ASD, SLD and language disorder (confirmed false above 76, provisional below) | 1 up to 70, 0 from 76 |
| `adaptive_behaviour_composite` | IDD B | 1 up to 70, 0 from 76 |
| `reading_`, `written_expression_`, `mathematics_standard_score` | SLD B by domain | 1 up to 78, 0 from 85 |
| `intervention_months`, `school_report_learning_difficulties` | SLD A, C | 3 to 6 months; 0.9 |
| `language_standard_score` | language disorder B, ASD language impairment | 1 up to 78, 0 from 85 |
| `mabc2_total_percentile` | DCD A | 1 up to the 5th percentile, 0 from the 16th |
| `tic_onset_age`, `tic_duration_months` | tics C, B | crisp at 18 years and 12 months |
| `developmental_history_early_onset` | onset in the early developmental period | 0.9 |
| `symptom_duration_months`, `asd_support_level_*` | the duration and support-level questions | crisp |
