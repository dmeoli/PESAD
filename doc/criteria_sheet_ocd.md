# DSM-5-TR criteria sheet: Obsessive-Compulsive and Related Disorders

Reference: DSM-5-TR (APA, 2022), chapter "Obsessive-Compulsive and Related
Disorders" (pp. 263-294 of the print edition). The criteria are paraphrased in
my own words; letters, counts and codes are those of the manual. ICD-11 codes
are from the WHO ICD-11 MMS, release 2026-01
(https://icd.who.int/browse/2026-01/mms/en), as metadata only. Status: every
entry was checked against the DSM-5-TR text on 2026-11-16; "KB" names the
implementing clause in `prolog/criteria.pl` or `prolog/disorders.pl`.

The insight specifier (with good or fair insight / with poor insight / with
absent insight or delusional beliefs) applies to OCD, body dysmorphic disorder
and hoarding disorder; the KB has one goal per level. ICD-11 has two levels
only (fair to good, `.0`; poor to absent, `.1`), so both "poor" and "absent"
map to `.1`.

---

## Obsessive-Compulsive Disorder (p. 265)
ICD-10-CM F42.2 · ICD-11 6B20 (6B20.0 / 6B20.1)

| | Criterion (paraphrase) | KB |
| --- | --- | --- |
| A | Obsessions, compulsions or both. Obsession: (1) recurrent intrusive, unwanted thoughts, urges or images and (2) attempts to ignore, suppress or neutralize them. Compulsion: (1) repetitive behaviours or mental acts the person feels driven to perform and (2) aimed at reducing distress or preventing a dreaded event, unrealistically or excessively | `obsessions_or_compulsions` = max(`obsessions`, `compulsions`), each 2 of 2 |
| B | Time-consuming (e.g., more than 1 hour a day) or causing distress or impairment | `time_consuming_or_distressing` (1 of 4) |
| C | Not attributable to a substance or another medical condition | `exclude_substance_and_medical` |
| D | Not better explained by another mental disorder (GAD, BDD, hoarding, trichotillomania, excoriation, stereotypies, eating disorders, addictions, illness anxiety, paraphilias, impulse-control disorders, depression, psychosis, autism) | `oc_symptoms_better_explained_by_other_disorder` (false) |

Specifiers: insight (3 levels); tic-related (current or past tic disorder),
goal `obsessive_compulsive_disorder_tic_related`.

## Body Dysmorphic Disorder (p. 271)
ICD-10-CM F45.22 · ICD-11 6B21 (6B21.0 / 6B21.1)

| | Criterion | KB |
| --- | --- | --- |
| A | Preoccupation with perceived flaws in appearance that others do not see or find slight | `appearance_preoccupation` |
| B | At some point, repetitive behaviours (mirror checking, grooming, skin picking, reassurance seeking) or mental acts (comparing) in response | `repetitive_appearance_behaviours` (1 of 5) |
| C | Distress or impairment | `significant_distress` |
| D | Not better explained by concerns with body fat or weight in someone meeting criteria for an eating disorder | `appearance_concern_better_explained_by_eating_disorder` (false) |

No substance/medical criterion. Specifiers: with muscle dysmorphia (goal
`body_dysmorphic_disorder_with_muscle_dysmorphia`); insight.

## Hoarding Disorder (p. 277)
ICD-10-CM F42.3 · ICD-11 6B24 (6B24.0 / 6B24.1)

| | Criterion | KB |
| --- | --- | --- |
| A | Persistent difficulty discarding possessions, whatever their value | `hoarding_behaviour` (3 of 3) |
| B | Due to a perceived need to save them and distress at discarding | `hoarding_behaviour` |
| C | Accumulation that clutters active living areas (or is uncluttered only through third parties) | `hoarding_behaviour` |
| D | Distress or impairment, including a safe environment | `significant_distress` |
| E | Not attributable to another medical condition (brain injury, cerebrovascular disease, Prader-Willi) | `exclude_medical` |
| F | Not better explained by another mental disorder | `hoarding_better_explained_by_other_disorder` (false) |

E names no substance, so the KB applies the medical exclusion only.
Specifiers: with excessive acquisition (goal
`hoarding_disorder_with_excessive_acquisition`); insight.

## Trichotillomania (Hair-Pulling Disorder) (p. 281)
ICD-10-CM F63.3 · ICD-11 6B25.0

A recurrent hair pulling with hair loss; B repeated attempts to decrease or
stop; C distress or impairment; D not attributable to another medical condition
(e.g., dermatological); E not better explained by another mental disorder
(e.g., BDD). KB: `recurrent_hair_pulling`, `significant_distress`,
`exclude_medical`, `hair_pulling_better_explained_by_other_disorder` (false). No
specifier; D names no substance.

## Excoriation (Skin-Picking) Disorder (p. 284)
ICD-10-CM F42.4 · ICD-11 6B25.1

A recurrent skin picking with lesions; B repeated attempts to stop; C distress
or impairment; D not attributable to a substance (e.g., cocaine) or another
medical condition (e.g., scabies); E not better explained by another mental
disorder (psychosis, BDD, stereotypies, nonsuicidal self-injury). KB:
`recurrent_skin_picking`, `significant_distress`, `exclude_substance_and_medical`,
`skin_picking_better_explained_by_other_disorder` (false). No specifier.

## Substance/Medication-Induced Obsessive-Compulsive and Related Disorder (p. 287)
ICD-10-CM F15.188/F15.288/F15.988 (amphetamine-type or other stimulant), F14.188/F14.288/F14.988 (cocaine), F19.188/F19.288/F19.988 (other or unknown) · ICD-11 6C45.72 (cocaine), 6C46.72 (stimulants), 6C47.72 (synthetic cathinones)

Same template as the induced anxiety disorder: A obsessions, compulsions, skin
picking, hair pulling or other characteristic symptoms predominate; B
substance etiology (1) and (2); C no evidence of an independent disorder
(symptoms preceding use, or persisting about 1 month); D not only during a
delirium; E distress or impairment. KB: `predominant_oc_presentation`,
`substance_etiology`, `independent_disorder_evidence` (false),
`not_delirium_bound`, `significant_distress`. Specifiers: with onset during
intoxication / during withdrawal / after medication use (one goal each).
DSM-5-TR says this diagnosis is made "in addition to" intoxication or
withdrawal, while the anxiety one is made "instead of"; the KB does not model
intoxication or withdrawal as disorders, so the difference has no effect.

## OCRD Due to Another Medical Condition (p. 291)
ICD-10-CM F06.8 · ICD-11 6E64 (secondary obsessive-compulsive or related syndrome)

A obsessions, compulsions, appearance preoccupations, hoarding, hair pulling,
skin picking or other characteristic symptoms predominate; B direct
pathophysiological consequence of another medical condition; C not better
explained by another mental disorder; D not only during a delirium; E distress
or impairment. Specifiers: with obsessive-compulsive disorder-like symptoms,
with appearance preoccupations, with hoarding symptoms, with hair-pulling
symptoms, with skin-picking symptoms (one goal each, chosen by the predominant
presentation).

## Other Specified / Unspecified OCRD (pp. 293-294)
ICD-10-CM F42.8 / F42.9 · ICD-11 6B2Y / 6B2Z

Residual categories. DSM-5-TR examples for "other specified": body
dysmorphic-like disorder with actual flaws; body dysmorphic-like disorder
without repetitive behaviours; other body-focused repetitive behaviour disorder
(nail biting, lip biting, cheek chewing); obsessional jealousy; olfactory
reference disorder (jikoshu-kyofu); shubo-kyofu; koro. Not modelled as goals.

---

## Resolution of the earlier "(verify)" marks

- The earlier sheet was written from an extraction that stopped at the induced
  disorder; the criteria of the induced disorder, of the disorder due to AMC
  (with its five specifiers), F06.8, F42.8, F42.9 and the "other specified"
  examples are now confirmed in the DSM-5-TR text (pp. 287-294). The ICD-10-CM
  table of the induced disorder lists only stimulants, cocaine and other or
  unknown substances.
- "Usually remits within days to weeks" (induced disorder) is not a criterion
  and was removed; criterion C gives "about 1 month" as an example.
- The notes comparing DSM-IV-TR with DSM-5 cannot be confirmed from the
  reference text, which does not compare editions; they were removed.
