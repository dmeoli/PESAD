# DSM-5-TR criteria sheet: Anxiety Disorders

Reference: DSM-5-TR (APA, 2022), chapter "Anxiety Disorders" (pp. 215-262 of
the print edition). The criteria are paraphrased in my own words; letters,
counts, durations and codes are those of the manual. ICD-10-CM codes are the
ones printed in DSM-5-TR; ICD-11 codes are from the WHO ICD-11 MMS, release
2026-01 (https://icd.who.int/browse/2026-01/mms/en), and are metadata only.
Status: every entry was checked against the DSM-5-TR text on 2026-11-16; the
column "KB" names the clause that implements each criterion in
`prolog/criteria.pl` (`disorder_nc/4` and its manifestations/features) or
`prolog/disorders.pl` (`disorder/3`).

---

## Separation Anxiety Disorder (p. 217)
ICD-10-CM F93.0 · ICD-11 6B05

| | Criterion (paraphrase) | KB |
| --- | --- | --- |
| A | Developmentally inappropriate, excessive fear of separation from attachment figures, with at least 3 of 8: distress at separation; worry about losing or harm to attachment figures; worry that an untoward event will separate them; reluctance to go out (school, work) for fear of separation; fear of being alone; reluctance to sleep away or alone; nightmares about separation; physical complaints when separation occurs or is expected | `excessive_separation_fear` (3 of 8) |
| B | Persistent: at least 4 weeks in children and adolescents, typically 6 months or more in adults | `separation_anxiety_duration` (by age group) |
| C | Clinically significant distress or impairment | `significant_distress` |
| D | Not better explained by another mental disorder (autism, psychosis, agoraphobia, GAD, illness anxiety) | `separation_fear_better_explained_by_other_disorder` (false) |

No substance/medical criterion and no specifier. The adult duration is "typically", i.e., a guide.

## Selective Mutism (p. 222)
ICD-10-CM F94.0 · ICD-11 6B06

| | Criterion | KB |
| --- | --- | --- |
| A | Consistent failure to speak in specific social situations where speech is expected, while speaking in others | `consistent_failure_to_speak` |
| B | Interferes with school, work or social communication | `significant_distress` |
| C | At least 1 month, not limited to the first month of school | `duration_at_least_one_month` |
| D | Not due to lack of knowledge of, or comfort with, the language | `failure_to_speak_due_to_language_knowledge` (false) |
| E | Not better explained by a communication disorder, nor only during autism, schizophrenia or another psychotic disorder | `mutism_better_explained_by_other_disorder` (false) |

## Specific Phobia (p. 224)
ICD-10-CM by stimulus (below) · ICD-11 6B03

| | Criterion | KB |
| --- | --- | --- |
| A | Marked fear or anxiety about a specific object or situation (in children also crying, tantrums, freezing, clinging) | `specific_phobic_anxiety` |
| B | Almost always provokes immediate fear | `specific_phobic_anxiety` |
| C | Actively avoided or endured with intense fear | `phobic_avoidance` |
| D | Out of proportion to the actual danger and to the sociocultural context | `specific_phobic_anxiety` |
| E | Persistent, typically 6 months or more | `duration_at_least_six_months` |
| F | Clinically significant distress or impairment | `significant_distress` |
| G | Not better explained by another mental disorder (agoraphobia, OCD, PTSD, separation anxiety, social anxiety) | `phobia_better_explained_by_other_disorder` (false) |

Specifier, coded by stimulus, all that apply: F40.218 animal; F40.228 natural
environment; F40.23x blood-injection-injury (F40.230 blood, F40.231 injections
and transfusions, F40.232 other medical care, F40.233 injury); F40.248
situational; F40.298 other. One goal per type; two types give two goals.

## Social Anxiety Disorder (p. 229)
ICD-10-CM F40.10 · ICD-11 6B04

| | Criterion | KB |
| --- | --- | --- |
| A | Marked fear of social situations with possible scrutiny; in children also with peers, not only with adults | `social_phobic_anxiety` (+ `anxiety_occurs_in_peer_settings` for preschool/child) |
| B | Fear of acting in a way, or showing anxiety, that will be negatively evaluated | `social_phobic_anxiety` |
| C | Almost always provoke fear | `social_phobic_anxiety` |
| D | Avoided or endured with intense fear | `phobic_avoidance` |
| E | Out of proportion to the actual threat and context | `social_phobic_anxiety` |
| F | Persistent, typically 6 months or more | `duration_at_least_six_months` |
| G | Distress or impairment | `significant_distress` |
| H | Not attributable to a substance or another medical condition | `exclude_substance_and_medical` |
| I | Not better explained by another mental disorder (panic, BDD, autism) | `social_fear_better_explained_by_other_disorder` (false) |
| J | With a medical condition present, the fear is unrelated or excessive | `fear_accounted_for_by_medical_condition` (false) |

Specifier: performance only (fear restricted to speaking or performing in
public), goal `social_anxiety_disorder_performance_only`.

## Panic Disorder (p. 235)
ICD-10-CM F41.0 · ICD-11 6B01

| | Criterion | KB |
| --- | --- | --- |
| A | Recurrent unexpected panic attacks: an abrupt surge of fear peaking within minutes with at least 4 of 13 symptoms (palpitations; sweating; trembling; shortness of breath; choking; chest pain; nausea; dizziness; chills or heat; paresthesias; derealization or depersonalization; fear of losing control; fear of dying). Culture-specific symptoms do not count | `recurrent_unexpected_panic_attacks`, `panic_attack` (4 of 13), at least 2 attacks |
| B | At least one attack followed by 1 month or more of worry about further attacks or their consequences, or of maladaptive behaviour change | `panic_consequences_concern`, `duration_at_least_one_month` |
| C | Not attributable to a substance or another medical condition | `exclude_substance_and_medical` |
| D | Not better explained by another mental disorder (attacks only to social fears, phobic objects, obsessions, trauma reminders, separation) | `panic_better_explained_by_other_disorder` (false) |

The panic attack specifier (p. 242) is not a mental disorder and cannot be
coded; it is not used for panic disorder itself. The KB evaluates panic attacks
inside the criteria and does not attach the "with panic attacks" specifier to
other goals.

## Agoraphobia (p. 246)
ICD-10-CM F40.00 · ICD-11 6B02

| | Criterion | KB |
| --- | --- | --- |
| A | Marked fear of at least 2 of 5 situations: public transport; open spaces; enclosed places; lines or crowds; being outside home alone | `agoraphobic_anxiety` (2 of 5) |
| B | Feared because escape might be difficult or help unavailable if panic-like or embarrassing symptoms occur | `agoraphobic_anxiety` (`anxiety_type`) |
| C | Almost always provoke fear | `agoraphobic_anxiety` |
| D | Avoided, faced only with a companion, or endured with intense fear | `agoraphobic_avoidance` |
| E | Out of proportion to the actual danger and context | `agoraphobic_anxiety` |
| F | Persistent, typically 6 months or more | `duration_at_least_six_months` |
| G | Distress or impairment | `significant_distress` |
| H | With a medical condition present, the fear is clearly excessive | `fear_accounted_for_by_medical_condition` (false) |
| I | Not better explained by another mental disorder (situational phobia, social anxiety, OCD, BDD, PTSD, separation anxiety) | `agoraphobia_better_explained_by_other_disorder` (false) |

Diagnosed irrespective of panic disorder; when both are met, both are assigned.

## Generalized Anxiety Disorder (p. 250)
ICD-10-CM F41.1 · ICD-11 6B00

| | Criterion | KB |
| --- | --- | --- |
| A | Excessive worry about a number of events, more days than not, for at least 6 months | `excessive_uncontrollable_worry` (+ `worry_more_days_than_not`), `duration_at_least_six_months` |
| B | The worry is difficult to control | `excessive_uncontrollable_worry` |
| C | At least 3 of 6 (restlessness; fatigue; poor concentration; irritability; muscle tension; sleep disturbance); only 1 in children | `generalized_anxiety_symptoms` (1 for preschool/child, else 3) |
| D | Distress or impairment | `significant_distress` |
| E | Not attributable to a substance or another medical condition | `exclude_substance_and_medical` |
| F | Not better explained by another mental disorder | `worry_better_explained_by_other_disorder` (false) |

## Substance/Medication-Induced Anxiety Disorder (p. 255)
ICD-10-CM F1x.180 / F1x.280 / F1x.980 by substance (opioids F11.188/F11.288/F11.988, caffeine F15.980 only, other or unknown F19.x80) · ICD-11 by substance, 6C4x.71 (e.g., 6C40.71 alcohol, 6C45.71 cocaine; caffeine 6C48.40, hallucinogens 6C49.61, dissociative drugs 6C4D.61)

| | Criterion | KB |
| --- | --- | --- |
| A | Panic attacks or anxiety predominate | `predominant_anxiety` |
| B | Evidence that (1) symptoms arose during or soon after intoxication, withdrawal or medication exposure and (2) the substance can produce them | `substance_etiology` |
| C | Not better explained by an independent anxiety disorder (symptoms preceding use, or persisting about 1 month after acute withdrawal or intoxication) | `independent_disorder_evidence` (false) |
| D | Not only during a delirium | `not_delirium_bound` |
| E | Distress or impairment | `significant_distress` |

Specifiers: with onset during intoxication, during withdrawal, after
medication use (one goal each). The 4th character of the code records a
comorbid use disorder (1 mild, 2 moderate or severe, 9 none); the KB does not
assess use disorders.

## Anxiety Disorder Due to Another Medical Condition (p. 258)
ICD-10-CM F06.4 · ICD-11 6E63 (secondary anxiety syndrome)

A panic attacks or anxiety predominate; B evidence of a direct
pathophysiological consequence of another medical condition; C not better
explained by another mental disorder; D not only during a delirium; E distress
or impairment. No specifier; the medical condition is coded separately and
named in the diagnosis. KB: `predominant_anxiety`, `medical_etiology`,
`disturbance_better_explained_by_other_mental_disorder` (false),
`not_delirium_bound`, `significant_distress`.

## Other Specified / Unspecified Anxiety Disorder (p. 261)
ICD-10-CM F41.8 / F41.9 · ICD-11 6B0Y / 6B0Z

Residual categories (characteristic symptoms with distress, full criteria not
met, not adjustment disorder with anxiety). DSM-5-TR examples for "other
specified": limited-symptom attacks; generalized anxiety less often than more
days than not; khyâl cap; ataque de nervios. Not modelled as goals: the KB
reports only full-criteria disorders, and a subthreshold picture gives no
diagnosis.

---

## Resolution of the earlier "(verify)" marks

- F06.4, F41.8, F41.9, F14.980, the anxiety-due-to-AMC criteria A-E and the
  onset specifiers of the induced disorder: confirmed in the DSM-5-TR text
  (pp. 255-261). The table also lists "other (or unknown) substance" F19.x80,
  which the earlier sheet missed.
- "Anxiety disorder due to AMC with panic attacks / with generalized anxiety":
  wrong, DSM-5-TR has no specifier for this disorder; removed.
- Social anxiety "performance only": the specifier wording is confirmed (p. 229).
- The notes comparing DSM-IV-TR with DSM-5-TR cannot be confirmed from the
  reference text, which does not compare editions; they were removed from
  this sheet. The one comparison the manual does state for these chapters is
  kept where it applies (agoraphobia is diagnosed irrespective of panic
  disorder).
