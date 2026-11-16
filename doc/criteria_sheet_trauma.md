# DSM-5-TR criteria sheet: Trauma- and Stressor-Related Disorders

Reference: DSM-5-TR (APA, 2022), chapter "Trauma- and Stressor-Related
Disorders" (pp. 295-328 of the print edition). The criteria are paraphrased in
my own words; letters, counts, durations and codes are those of the manual.
ICD-11 codes are from the WHO ICD-11 MMS, release 2026-01
(https://icd.who.int/browse/2026-01/mms/en), as metadata only. Status: every
entry was checked against the DSM-5-TR text on 2026-11-16; "KB" names the
implementing clause in `prolog/criteria.pl` or `prolog/disorders.pl`.

---

## Reactive Attachment Disorder (p. 295)
ICD-10-CM F94.1 · ICD-11 6B44

| | Criterion (paraphrase) | KB |
| --- | --- | --- |
| A | Inhibited, withdrawn behaviour toward caregivers: rarely seeks and rarely responds to comfort when distressed (both) | `inhibited_attachment_behaviour` (2 of 2) |
| B | At least 2 of 3: minimal social and emotional responsiveness; limited positive affect; unexplained irritability, sadness or fear with caregivers | `social_emotional_disturbance` (2 of 3) |
| C | Extremes of insufficient care, at least 1 of 3: neglect or deprivation; repeated changes of primary caregivers; rearing in unusual settings | `insufficient_care` (1 of 3) |
| D | The care in C is presumed responsible for A | `care_presumed_responsible_for_disturbance` |
| E | Criteria for autism spectrum disorder are not met | `criteria_met_for_autism_spectrum_disorder` (false) |
| F | Evident before age 5 years | `disturbance_evident_before_age_five` |
| G | Developmental age of at least 9 months | `developmental_age_at_least_nine_months` |

The criteria refer to a child: the KB rules the goal out for adults
(`child_patient`). Specifiers: persistent (more than 12 months); severe (all
symptoms at relatively high levels); one goal each.

## Disinhibited Social Engagement Disorder (p. 298)
ICD-10-CM F94.2 · ICD-11 6B45

A a child actively approaches unfamiliar adults with at least 2 of 4: reduced
reticence; overly familiar behaviour; little checking back with the caregiver;
willingness to go off with a stranger; B not limited to impulsivity (as in
ADHD); C insufficient care as in reactive attachment disorder; D the care is
presumed responsible; E developmental age of at least 9 months. KB:
`disinhibited_behaviour_with_strangers` (2 of 4),
`behaviour_not_limited_to_impulsivity`, `insufficient_care`,
`care_presumed_responsible_for_disturbance`,
`developmental_age_at_least_nine_months`, `child_patient`. Specifiers:
persistent; severe.

## Posttraumatic Stress Disorder (p. 301)
ICD-10-CM F43.10 · ICD-11 6B40

Adults, adolescents and children older than 6 years:

| | Criterion | KB |
| --- | --- | --- |
| A | Exposure to actual or threatened death, serious injury or sexual violence, in 1 or more of 4 ways: direct; witnessed in person; learned of it happening to a close person (violent or accidental if a death); repeated or extreme exposure to aversive details (not through media unless work related) | `traumatic_exposure` (1 of 4) |
| B | At least 1 of 5 intrusions: memories; dreams; flashbacks; distress at cues; physiological reactions to cues | `intrusion_symptoms` (1 of 5) |
| C | At least 1 of 2 avoidances: internal (memories, thoughts, feelings); external reminders | `persistent_avoidance` (1 of 2) |
| D | At least 2 of 7 negative alterations: amnesia; negative beliefs; distorted blame; negative emotional state; diminished interest; detachment; inability to feel positive emotions | `negative_cognitions_and_mood` (2 of 7) |
| E | At least 2 of 6 alterations in arousal: irritability or aggression; recklessness; hypervigilance; startle; poor concentration; sleep disturbance | `arousal_alterations` (2 of 6) |
| F | Duration of B-E more than 1 month | `duration_at_least_one_month` |
| G | Distress or impairment | `significant_distress` |
| H | Not attributable to a substance or another medical condition | `exclude_substance_and_medical` |

Children 6 years and younger (separate criteria set, same code): A only 3 ways
(direct; witnessed, especially by caregivers; learned of it happening to a
parent or caregiver); B as above; C at least 1 of 6 from a merged list of
avoidance (activities, places, people, conversations) and negative cognitions
(negative emotional states, diminished interest or constricted play, social
withdrawal, reduced positive emotions); D at least 2 of 5 arousal symptoms (no
recklessness); E more than 1 month; F distress or impairment in relationships
or school behaviour; G not attributable to a substance or medical condition.
KB: the `preschool` clause of `disorder_nc(posttraumatic_stress_disorder, ...)`
with `preschool_traumatic_exposure`, `avoidance_or_negative_cognitions` and
`preschool_arousal_alterations`.

Specifiers: with dissociative symptoms (persistent depersonalization or
derealization, not due to a substance or medical condition), goal
`posttraumatic_stress_disorder_with_dissociative_symptoms`; with delayed
expression (full criteria met only 6 months or more after the event), goal
`posttraumatic_stress_disorder_with_delayed_expression`. The manual confirms
that "delayed expression" replaces the earlier "delayed onset" (p. 308).

## Acute Stress Disorder (p. 313)
ICD-10-CM F43.0 · ICD-11 QE84 (acute stress reaction, outside the mental-disorder chapter)

| | Criterion | KB |
| --- | --- | --- |
| A | Exposure as in PTSD criterion A (4 ways) | `traumatic_exposure` |
| B | At least 9 of 14 symptoms of intrusion (memories; dreams; flashbacks; distress or physiological reaction to cues, one item), negative mood (inability to feel positive emotions), dissociation (altered sense of reality; amnesia), avoidance (internal; external) and arousal (sleep; irritability; hypervigilance; concentration; startle) | `acute_stress_symptoms` (9 of 14) |
| C | Duration 3 days to 1 month after the exposure | `duration_three_days_to_one_month` |
| D | Distress or impairment | `significant_distress` |
| E | Not attributable to a substance or medical condition (e.g., mild brain injury) and not better explained by brief psychotic disorder | `exclude_substance_and_medical`, `better_explained_by_brief_psychotic_disorder` (false) |

No specifier.

## Adjustment Disorders (p. 319)
ICD-10-CM F43.2x by subtype · ICD-11 6B43

| | Criterion | KB |
| --- | --- | --- |
| A | Emotional or behavioural symptoms in response to an identifiable stressor, within 3 months of its onset | `reaction_to_stressor`, `adjustment_onset_within_three_months` |
| B | Marked distress out of proportion to the stressor, or significant impairment | `adjustment_clinical_significance` (1 of 4) |
| C | Does not meet the criteria of another mental disorder and is not just an exacerbation of a preexisting one | `stress_reaction_meets_criteria_for_another_disorder` (false) |
| D | Not normal bereavement and not better explained by prolonged grief disorder | `symptoms_represent_normal_bereavement` (false); prolonged grief falls under C |
| E | Symptoms do not persist more than 6 months after the stressor or its consequences end | `symptoms_persist_beyond_six_months_after_stressor_ends` (false) |

Subtypes, separately coded and one goal each: F43.21 with depressed mood;
F43.22 with anxiety; F43.23 with mixed anxiety and depressed mood; F43.24 with
disturbance of conduct; F43.25 with mixed disturbance of emotions and conduct;
F43.20 unspecified. Course specifiers: acute (less than 6 months), persistent
or chronic (6 months or longer, with a chronic stressor or lasting
consequences); goals `adjustment_disorder_acute` and
`adjustment_disorder_persistent`. Since criterion C excludes any other mental
disorder, the KB applies no separate substance/medical exclusion.

## Prolonged Grief Disorder (p. 322)
ICD-10-CM F43.8 · ICD-11 6B42

| | Criterion | KB |
| --- | --- | --- |
| A | Death of a close person at least 12 months ago (at least 6 months for children and adolescents) | `bereavement_at_least_twelve_months` (by age group) |
| B | Since the death, at least 1 of 2: intense yearning; preoccupation with the deceased (in youth, possibly with the circumstances of the death); most days, and nearly every day for at least the last month | `persistent_grief_response` (1 of 2), `grief_symptoms_nearly_every_day_last_month` |
| C | At least 3 of 8, with the same frequency: identity disruption; disbelief; avoidance of reminders that the person is dead; intense emotional pain; difficulty reintegrating; emotional numbness; life feels meaningless; intense loneliness | `grief_associated_symptoms` (3 of 8) |
| D | Distress or impairment | `significant_distress` |
| E | Duration and severity clearly exceed social, cultural or religious norms | `bereavement_reaction_exceeds_cultural_norms` |
| F | Not better explained by another mental disorder (e.g., major depressive disorder, PTSD) and not attributable to a substance or medical condition | `grief_better_explained_by_other_disorder` (false), `exclude_substance_and_medical` |

No specifier. New in DSM-5-TR: the manual states (Section III introduction)
that persistent complex bereavement disorder, a condition for further study in
DSM-5, was moved to Section II and renamed prolonged grief disorder, with
reformulated criteria.

## Other Specified / Unspecified Trauma- and Stressor-Related Disorder (pp. 327-328)
ICD-10-CM F43.8 / F43.9 · ICD-11 6B4Y / 6B4Z

Residual categories. DSM-5-TR examples for "other specified": adjustment-like
disorders with onset more than 3 months after the stressor; adjustment-like
disorders lasting more than 6 months without a prolonged stressor; persistent
response to trauma with PTSD-like symptoms (subthreshold PTSD); ataque de
nervios; other cultural syndromes. Not modelled as goals. Note that DSM-5-TR
prints F43.8 for both this category and prolonged grief disorder.

---

## Resolution of the earlier "(verify)" marks

- Prolonged grief disorder A-F, its thresholds (12 months, 6 in youth; 1 of 2;
  3 of 8; nearly every day for the last month) and the absence of specifiers:
  confirmed (p. 322). Its relation to persistent complex bereavement disorder
  is confirmed by the Section III introduction (p. 903).
- Other specified trauma- and stressor-related disorder: the code is F43.8,
  not F43.89 as the earlier sheet said; the examples are confirmed (p. 327).
  Unspecified: F43.9, confirmed.
- Adjustment disorder subtype labels and codes F43.20-F43.25 and the
  acute/persistent specifiers: confirmed (p. 319).
- PTSD "delayed expression" replacing DSM-IV "delayed onset": confirmed by
  the DSM-5-TR text (p. 308). The other notes comparing DSM-IV-TR with DSM-5
  (the subtypes of DSM-IV reactive attachment disorder, the DSM-IV acute
  stress duration of 2 days to 4 weeks, the history of the adjustment
  labels) cannot be confirmed from the reference text, which does not compare
  editions; they were removed.
