# DSM-5-TR Criteria Sheet — Obsessive-Compulsive and Related Disorders

Source: DSM-5-TR (2022), chapter "Obsessive-Compulsive and Related Disorders" (plain-text PDF extraction `/tmp/dsm_ocd.txt`).
Purpose: structured criteria to drive a Prolog expert system. Thresholds, counts, durations and specifiers are quoted exactly.

> EXTRACTION NOTE: The source text ends at the heading "Substance/Medication-Induced Obsessive-Compulsive and Related Disorder" (line 1608) and contains NO criteria text for the final three entries (Substance/Medication-Induced OCRD; OCRD Due to Another Medical Condition; Other Specified / Unspecified OCRD). Those sections below are reconstructed from the chapter introduction and from the structurally identical Anxiety-Disorders templates that DO appear at the start of the source file (lines 1–302). Reconstructed criteria text is marked "(verify — not present in source)".

---

## Obsessive-Compulsive Disorder
ICD-10-CM: F42.2

### Criteria
- **A. Presence of obsessions, compulsions, or both:**
  - **Obsessions** are defined by (1) AND (2):
    1. Recurrent and persistent thoughts, urges, or images that are experienced, at some time during the disturbance, as intrusive and unwanted, and that in most individuals cause marked anxiety or distress.
    2. The individual attempts to ignore or suppress such thoughts, urges, or images, or to neutralize them with some other thought or action (i.e., by performing a compulsion).
  - **Compulsions** are defined by (1) AND (2):
    1. Repetitive behaviors (e.g., hand washing, ordering, checking) or mental acts (e.g., praying, counting, repeating words silently) that the individual feels driven to perform in response to an obsession or according to rules that must be applied rigidly.
    2. The behaviors or mental acts are aimed at preventing or reducing anxiety or distress, or preventing some dreaded event or situation; however, these behaviors or mental acts are not connected in a realistic way with what they are designed to neutralize or prevent, or are clearly excessive.
  - Note: Young children may not be able to articulate the aims of these behaviors or mental acts.
- **B. Time/distress threshold:** the obsessions or compulsions are time-consuming (**e.g., take more than 1 hour per day**) OR cause clinically significant distress or impairment in social, occupational, or other important areas of functioning.
- **C. Substance/medical exclusion:** symptoms not attributable to the physiological effects of a substance (e.g., a drug of abuse, a medication) or another medical condition.
- **D. Other-disorder exclusion:** not better explained by the symptoms of another mental disorder (see exclusion list below).

### Duration / onset
- No minimum duration stated. (Reference figures, not criteria: mean age at onset 19.5 years; 25% of cases by age 14; onset after 35 unusual.)

### Specifiers
- **Insight specifier (THREE levels):**
  - **With good or fair insight:** the individual recognizes that OCD beliefs are definitely or probably not true or that they may or may not be true.
  - **With poor insight:** the individual thinks OCD beliefs are probably true.
  - **With absent insight/delusional beliefs:** the individual is completely convinced that OCD beliefs are true.
- **Tic-related:** the individual has a current or past history of a tic disorder.

### Exclusion criteria (summary)
- Not attributable to a substance or another medical condition (Criterion C).
- Not better explained by another mental disorder (Criterion D), e.g.: excessive worries (GAD); preoccupation with appearance (body dysmorphic disorder); difficulty discarding (hoarding disorder); hair pulling (trichotillomania); skin picking (excoriation disorder); stereotypies (stereotypic movement disorder); ritualized eating (eating disorders); preoccupation with substances or gambling (substance-related/addictive disorders); preoccupation with having an illness (illness anxiety disorder); sexual urges/fantasies (paraphilic disorders); impulses (disruptive, impulse-control, conduct disorders); guilty ruminations (MDD); thought insertion/delusional preoccupations (schizophrenia spectrum/psychotic disorders); repetitive patterns of behavior (autism spectrum disorder).

### DSM-IV-TR -> DSM-5-TR change notes
- Entire chapter is NEW in DSM-5: OCD moved OUT of Anxiety Disorders into its own "Obsessive-Compulsive and Related Disorders" chapter.
- Insight specifier EXPANDED to three levels (good/fair, poor, absent/delusional); DSM-IV had only a single "with poor insight" specifier.
- NEW "tic-related" specifier added.

---

## Body Dysmorphic Disorder
ICD-10-CM: F45.22

### Criteria
- **A.** Preoccupation with one or more perceived defects or flaws in physical appearance that are not observable or appear slight to others.
- **B.** At some point during the course of the disorder, the individual has performed repetitive behaviors (e.g., mirror checking, excessive grooming, skin picking, reassurance seeking) or mental acts (e.g., comparing his or her appearance with that of others) in response to the appearance concerns.
- **C.** The preoccupation causes clinically significant distress or impairment in social, occupational, or other important areas of functioning.
- **D.** The appearance preoccupation is not better explained by concerns with body fat or weight in an individual whose symptoms meet diagnostic criteria for an eating disorder.

### Duration / onset
- No minimum duration stated. (Reference, not criteria: mean age at onset 16–17 years; median 15; most common 12–13; onset before 18 in two-thirds. Preoccupations occur on average 3–8 hours per day.)

### Specifiers
- **With muscle dysmorphia:** the individual is preoccupied with the idea that his or her body build is too small or insufficiently muscular. This specifier is used even if the individual is preoccupied with other body areas.
- **Insight specifier (THREE levels):**
  - **With good or fair insight:** the individual recognizes that BDD beliefs are definitely or probably not true or that they may or may not be true.
  - **With poor insight:** the individual thinks that BDD beliefs are probably true.
  - **With absent insight/delusional beliefs:** the individual is completely convinced that BDD beliefs are true.

### Exclusion criteria (summary)
- Not better explained by concerns with body fat/weight in someone meeting eating-disorder criteria (Criterion D).
- (Differential, not formal criteria): distinguish from normal appearance concerns, clearly noticeable defects, illness anxiety disorder, gender dysphoria, olfactory reference disorder, koro.

### DSM-IV-TR -> DSM-5-TR change notes
- Moved into the new OCRD chapter (was in Somatoform Disorders in DSM-IV).
- NEW Criterion B (repetitive behaviors / mental acts) added in DSM-5.
- NEW "with muscle dysmorphia" specifier and the three-level insight specifier added; delusional appearance beliefs are now coded as BDD with absent insight/delusional beliefs rather than as a separate delusional disorder.

---

## Hoarding Disorder
ICD-10-CM: F42.3

### Criteria
- **A.** Persistent difficulty discarding or parting with possessions, regardless of their actual value.
- **B.** This difficulty is due to a perceived need to save the items and to distress associated with discarding them.
- **C.** The difficulty discarding possessions results in the accumulation of possessions that congest and clutter active living areas and substantially compromises their intended use. If living areas are uncluttered, it is only because of the interventions of third parties (e.g., family members, cleaners, authorities).
- **D.** The hoarding causes clinically significant distress or impairment in social, occupational, or other important areas of functioning (including maintaining a safe environment for self and others).
- **E. Medical exclusion:** the hoarding is not attributable to another medical condition (e.g., brain injury, cerebrovascular disease, Prader-Willi syndrome).
- **F. Other-disorder exclusion:** not better explained by the symptoms of another mental disorder (e.g., obsessions in OCD, decreased energy in MDD, delusions in schizophrenia or another psychotic disorder, cognitive deficits in major neurocognitive disorder, restricted interests in autism spectrum disorder).

### Duration / onset
- "Persistent" required (Criterion A) but no specific minimum duration stated. (Reference: symptoms may first emerge ages 15–19.)

### Specifiers
- **With excessive acquisition:** if difficulty discarding possessions is accompanied by excessive acquisition of items that are not needed or for which there is no available space.
- **Insight specifier (THREE levels):**
  - **With good or fair insight:** the individual recognizes that hoarding-related beliefs and behaviors (re: difficulty discarding, clutter, or excessive acquisition) are problematic.
  - **With poor insight:** the individual is mostly convinced that hoarding-related beliefs and behaviors are not problematic despite evidence to the contrary.
  - **With absent insight/delusional beliefs:** the individual is completely convinced that hoarding-related beliefs and behaviors are not problematic despite evidence to the contrary.

### Exclusion criteria (summary)
- Not attributable to another medical condition (Criterion E: brain injury, cerebrovascular disease, Prader-Willi syndrome, etc.).
- Not better explained by another mental disorder (Criterion F: OCD obsessions, MDD low energy, psychotic delusions, major neurocognitive disorder, autism spectrum disorder).

### DSM-IV-TR -> DSM-5-TR change notes
- NEW disorder in DSM-5 (did not exist as a standalone diagnosis in DSM-IV; previously considered a symptom/feature, e.g., of obsessive-compulsive personality disorder or OCD).

---

## Trichotillomania (Hair-Pulling Disorder)
ICD-10-CM: F63.3

### Criteria
- **A.** Recurrent pulling out of one's hair, resulting in hair loss.
- **B.** Repeated attempts to decrease or stop hair pulling.
- **C.** The hair pulling causes clinically significant distress or impairment in social, occupational, or other important areas of functioning.
- **D. Medical exclusion:** the hair pulling or hair loss is not attributable to another medical condition (e.g., a dermatological condition).
- **E. Other-disorder exclusion:** not better explained by the symptoms of another mental disorder (e.g., attempts to improve a perceived defect or flaw in appearance in body dysmorphic disorder).

### Duration / onset
- No minimum duration stated. (Reference: onset most commonly coincides with or follows puberty.)

### Specifiers
- None. (No insight or other specifiers are defined for trichotillomania.)

### Exclusion criteria (summary)
- Not attributable to another medical condition (Criterion D: dermatological conditions, other alopecias).
- Not better explained by another mental disorder (Criterion E), e.g., hair removal to improve perceived appearance defect (BDD); symmetry rituals (OCD); stereotypic movement disorder; psychotic-disorder-driven hair removal.

### DSM-IV-TR -> DSM-5-TR change notes
- Reclassified from Impulse-Control Disorders Not Elsewhere Classified into the new OCRD chapter.
- DSM-IV required mounting tension before pulling and gratification/relief during pulling (former criteria B and C); these were REMOVED in DSM-5. NEW Criterion B "repeated attempts to decrease or stop hair pulling" was added.

---

## Excoriation (Skin-Picking) Disorder
ICD-10-CM: F42.4

### Criteria
- **A.** Recurrent skin picking resulting in skin lesions.
- **B.** Repeated attempts to decrease or stop skin picking.
- **C.** The skin picking causes clinically significant distress or impairment in social, occupational, or other important areas of functioning.
- **D. Substance/medical exclusion:** the skin picking is not attributable to the physiological effects of a substance (e.g., cocaine) or another medical condition (e.g., scabies).
- **E. Other-disorder exclusion:** not better explained by symptoms of another mental disorder (e.g., delusions or tactile hallucinations in a psychotic disorder; attempts to improve a perceived defect or flaw in appearance in body dysmorphic disorder; stereotypies in stereotypic movement disorder; or intention to harm oneself in nonsuicidal self-injury).

### Duration / onset
- No minimum duration stated. (Reference: onset most often during adolescence, commonly coinciding with or following puberty.)

### Specifiers
- None.

### Exclusion criteria (summary)
- Not attributable to a substance (e.g., cocaine) or another medical condition (e.g., scabies) (Criterion D).
- Not better explained by another mental disorder (Criterion E): psychotic delusions/tactile hallucinations; BDD appearance-driven picking; stereotypic movement disorder; nonsuicidal self-injury.
- (Differential, not formal criteria): dermatitis artefacta, malingering, factitious disorder.

### DSM-IV-TR -> DSM-5-TR change notes
- NEW disorder in DSM-5 (not present in DSM-IV).

---

## Substance/Medication-Induced Obsessive-Compulsive and Related Disorder
ICD-10-CM: code selected by substance class and presence/absence of comorbid substance use disorder.

> NOTE: The criteria text is NOT present in the source extraction (file ends at this heading). The criteria below are reconstructed by analogy to the parallel "Substance/Medication-Induced Anxiety Disorder" template that appears at the start of the source, adapted to OCRD per the chapter introduction. Treat as "(verify — not present in source)".

### Criteria (verify — not present in source)
- **A.** Obsessions, compulsions, skin picking, hair pulling, other body-focused repetitive behaviors, or other symptoms characteristic of OCRD predominate in the clinical picture.
- **B.** Evidence from history, physical exam, or labs of BOTH (1) symptoms developed during or soon after substance intoxication/withdrawal or after exposure to/withdrawal from a medication, AND (2) the involved substance/medication is capable of producing the symptoms.
- **C.** The disturbance is not better explained by an OCRD that is not substance/medication-induced (e.g., symptoms precede substance/medication use, or persist for a substantial period — usually longer than 1 month — after intoxication/withdrawal). (verify)
- **D.** The disturbance does not occur exclusively during the course of a delirium. (verify)
- **E.** The disturbance causes clinically significant distress or impairment. (verify)

### Duration / onset
- Symptoms must develop during/soon after intoxication, withdrawal, or medication exposure/withdrawal; usually remit within days to weeks/up to ~1 month after discontinuation. (verify)

### Specifiers
- **With onset during intoxication** (verify)
- **With onset during withdrawal** (verify)
- **With onset after medication use** (verify)

### Exclusion criteria (summary)
- Diagnosis NOT given if symptoms precede substance/medication use or persist substantially (usually >1 month) beyond intoxication/withdrawal (then consider an independent OCRD), or if symptoms occur exclusively during delirium. (verify)

### DSM-IV-TR -> DSM-5-TR change notes
- NEW in DSM-5 as part of the new OCRD chapter; no DSM-IV equivalent.

---

## Obsessive-Compulsive and Related Disorder Due to Another Medical Condition
ICD-10-CM: F06.8 (verify — code not present in source).

> NOTE: Criteria text NOT present in the source extraction. Reconstructed by analogy to the parallel "Anxiety Disorder Due to Another Medical Condition" template and the chapter intro. Treat as "(verify — not present in source)".

### Criteria (verify — not present in source)
- **A.** Obsessions, compulsions, preoccupations with appearance, hoarding, hair pulling, skin picking, other body-focused repetitive behaviors, or other OCRD-characteristic symptoms predominate in the clinical picture.
- **B.** Evidence from history, physical exam, or labs that the disturbance is the direct pathophysiological consequence of another medical condition.
- **C.** The disturbance is not better explained by another mental disorder.
- **D.** The disturbance does not occur exclusively during the course of a delirium.
- **E.** The disturbance causes clinically significant distress or impairment in social, occupational, or other important areas of functioning.
- Coding note: include the name of the other medical condition within the name of the disorder; code and list the medical condition separately. (verify)

### Duration / onset
- Generally follows the course of the underlying medical condition. (verify)

### Specifiers
- **With obsessive-compulsive disorder–like symptoms** (verify)
- **With appearance preoccupations** (verify)
- **With hoarding symptoms** (verify)
- **With hair-pulling symptoms** (verify)
- **With skin-picking symptoms** (verify)

### Exclusion criteria (summary)
- Not better explained by another mental disorder (Criterion C); not exclusively during delirium (Criterion D); distinguish from substance/medication-induced OCRD and independent OCRD. (verify)

### DSM-IV-TR -> DSM-5-TR change notes
- NEW in DSM-5 as part of the new OCRD chapter; no DSM-IV equivalent.

---

## Other Specified Obsessive-Compulsive and Related Disorder
ICD-10-CM: F42.8 (verify — code not present in source).

> NOTE: Definitional text not present in source extraction. Reconstructed from the chapter intro and the parallel anxiety template.

### Description
- Applies to presentations with OCRD-characteristic symptoms that cause clinically significant distress or impairment but do not meet full criteria for any specific OCRD; clinician communicates the specific reason the presentation does not meet full criteria.

### Example presentations (from chapter intro)
- Body dysmorphic-like disorder with actual flaws (verify)
- Body dysmorphic-like disorder without repetitive behaviors (verify)
- Other body-focused repetitive behavior disorder (e.g., nail biting, lip biting, cheek chewing)
- Obsessional jealousy
- Olfactory reference disorder (olfactory reference syndrome)
- Shubo-kyofu; koro; jikoshu-kyofu (verify — listed in chapter intro/culture material)

### DSM-IV-TR -> DSM-5-TR change notes
- NEW residual category within the new OCRD chapter; replaces/refines DSM-IV "not otherwise specified."

---

## Unspecified Obsessive-Compulsive and Related Disorder
ICD-10-CM: F42.9 (verify — code not present in source).

### Description
- Applies to presentations with OCRD-characteristic symptoms that cause clinically significant distress or impairment but do not meet full criteria for any specific OCRD, and where the clinician chooses NOT to specify the reason, or there is insufficient information to make a more specific diagnosis (e.g., emergency room settings).

### DSM-IV-TR -> DSM-5-TR change notes
- NEW residual category within the new OCRD chapter.
