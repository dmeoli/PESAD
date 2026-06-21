# DSM-5-TR Criteria Sheet — Anxiety Disorders

Source: DSM-5-TR (2022), "Anxiety Disorders" chapter, extracted text `/tmp/dsm_anx.txt`.
Purpose: structured criteria to drive a Prolog expert system. Thresholds, counts, durations and ages quoted verbatim.

---

## Separation Anxiety Disorder
ICD-10-CM: F93.0

- **Criteria**
  - **A. ≥3 of the following 8 symptoms** — developmentally inappropriate and excessive fear/anxiety concerning separation from attachment figures:
    - A1. Recurrent excessive distress when anticipating/experiencing separation from home or major attachment figures.
    - A2. Persistent excessive worry about losing major attachment figures or about possible harm to them (illness, injury, disasters, death).
    - A3. Persistent excessive worry about an untoward event (getting lost, kidnapped, accident, becoming ill) causing separation from a major attachment figure.
    - A4. Persistent reluctance/refusal to go out, away from home, to school, to work, or elsewhere because of fear of separation.
    - A5. Persistent excessive fear of/reluctance about being alone or without major attachment figures at home or other settings.
    - A6. Persistent reluctance/refusal to sleep away from home or to go to sleep without being near a major attachment figure.
    - A7. Repeated nightmares involving the theme of separation.
    - A8. Repeated complaints of physical symptoms (headaches, stomachaches, nausea, vomiting) when separation occurs or is anticipated.
  - **B.** Persistent fear/anxiety/avoidance (duration — see below).
  - **C.** Clinically significant distress or impairment (social, academic, occupational, or other).
  - **D.** Not better explained by another mental disorder (autism spectrum, psychotic disorder, agoraphobia, generalized anxiety disorder, illness anxiety disorder).
- **Duration / onset**: **at least 4 weeks in children and adolescents (younger than 18 years)**; **typically 6 months or more in adults** (adult duration is a general guide, allowing flexibility).
- **Age rules**: Child/adolescent (<18 yr) vs adult duration distinction (4 weeks vs ~6 months). Onset can be as early as preschool; can present in adulthood without childhood history.
- **Specifiers**: None coded. (Panic Attack specifier is usable across disorders.)
- **Exclusion criteria**: Criterion D — not better explained by another mental disorder (see list above). (Note: substance/medical-condition exclusion is the general anxiety-chapter rule, not stated as a separate lettered criterion here.)
- **DSM-IV-TR -> DSM-5-TR change notes**: Moved into Anxiety Disorders chapter (was in "Disorders Usually First Diagnosed in Infancy, Childhood, or Adolescence"). Removed the requirement of onset before age 18, so adults can be diagnosed; adult duration guidance (~6 months) added. (verify)

---

## Selective Mutism
ICD-10-CM: F94.0

- **Criteria**
  - **A.** Consistent failure to speak in specific social situations where there is an expectation to speak (e.g., school), despite speaking in other situations.
  - **B.** The disturbance interferes with educational/occupational achievement or with social communication.
  - **C.** Duration **at least 1 month** (not limited to the first month of school).
  - **D.** Failure to speak is not attributable to lack of knowledge of, or comfort with, the spoken language required.
  - **E.** Not better explained by a communication disorder (e.g., childhood-onset fluency disorder) and does not occur exclusively during autism spectrum disorder, schizophrenia, or another psychotic disorder.
- **Duration / onset**: **≥1 month** (excluding first month of school). Onset usually before age 5; often detected at school entry.
- **Age rules**: Diagnosed only when the child has established capacity to speak in some situations. The "silent period" of immigrant children learning a new language is explicitly excluded.
- **Specifiers**: None.
- **Exclusion criteria**: Criterion D (language knowledge/comfort) and Criterion E (communication disorder; not exclusively during ASD/schizophrenia/psychotic disorder).
- **DSM-IV-TR -> DSM-5-TR change notes**: Reclassified from childhood-disorders section into Anxiety Disorders. Wording essentially retained. (verify)

---

## Specific Phobia
ICD-10-CM: coded by stimulus (see specifiers)

- **Criteria**
  - **A.** Marked fear or anxiety about a specific object or situation (e.g., flying, heights, animals, injections, blood). *In children: may be expressed by crying, tantrums, freezing, or clinging.*
  - **B.** The phobic object/situation almost always provokes immediate fear or anxiety.
  - **C.** The phobic object/situation is actively avoided or endured with intense fear/anxiety.
  - **D.** The fear/anxiety is out of proportion to actual danger and to sociocultural context.
  - **E.** Persistent, **typically lasting 6 months or more**.
  - **F.** Clinically significant distress or impairment (social, occupational, or other).
  - **G.** Not better explained by another mental disorder (agoraphobia; OCD obsessions; PTSD trauma reminders; separation anxiety; social anxiety disorder).
- **Duration / onset**: **≥6 months (typically)** — applies at all ages. Median age at onset 7–11 years (mean ~10); most cases before age 10.
- **Age rules**: Children — fear may show as crying/tantrums/freezing/clinging; assess impairment/duration and developmental appropriateness (excessive transient childhood fears are not diagnosed).
- **Specifiers** (code based on phobic stimulus; code all that apply):
  - **F40.218 Animal** (spiders, insects, dogs).
  - **F40.228 Natural environment** (heights, storms, water).
  - **F40.23x Blood-injection-injury** (needles, invasive procedures). Coding note: F40.230 blood; F40.231 injections/transfusions; F40.232 other medical care; F40.233 injury.
  - **F40.248 Situational** (airplanes, elevators, enclosed places).
  - **F40.298 Other** (choking/vomiting situations; in children loud sounds or costumed characters).
- **Exclusion criteria**: Criterion G — not better explained by another mental disorder (agoraphobia, OCD, PTSD, separation anxiety, social anxiety disorder). General substance/medical-condition exclusion applies.
- **DSM-IV-TR -> DSM-5-TR change notes**: Dropped the requirement that the person *recognizes the fear as excessive or unreasonable* (now judged by clinician, Criterion D). Now requires the **6-month duration at all ages** (previously required only for those under 18). "Type" subtypes retained as specifiers; ICD-10-CM stimulus codes added.

---

## Social Anxiety Disorder
ICD-10-CM: F40.10

- **Criteria**
  - **A.** Marked fear/anxiety about one or more social situations involving possible scrutiny (social interactions, being observed, performing). *In children: anxiety must occur in peer settings, not just with adults.*
  - **B.** Fears acting in a way / showing anxiety symptoms that will be negatively evaluated (humiliating, embarrassing, leading to rejection, or offending others).
  - **C.** Social situations almost always provoke fear/anxiety. *In children: may show as crying, tantrums, freezing, clinging, shrinking, or failing to speak.*
  - **D.** Social situations are avoided or endured with intense fear/anxiety.
  - **E.** Fear/anxiety out of proportion to actual threat and sociocultural context.
  - **F.** Persistent, **typically lasting 6 months or more**.
  - **G.** Clinically significant distress or impairment.
  - **H.** Not attributable to physiological effects of a substance or another medical condition.
  - **I.** Not better explained by another mental disorder (panic disorder, body dysmorphic disorder, autism spectrum disorder).
  - **J.** If another medical condition is present (e.g., Parkinson's, obesity, disfigurement), the fear/anxiety/avoidance is clearly unrelated or excessive.
- **Duration / onset**: **≥6 months (typically)**. Median age at onset 13 years; 75% between ages 8 and 15.
- **Age rules**: In children, anxiety must occur in peer settings (not just with adults); child expressions of fear listed in Criterion C.
- **Specifiers**: **Performance only** — fear restricted to speaking or performing in public.
- **Exclusion criteria**: Criterion H (substance/medical condition), Criterion I (other mental disorder), Criterion J (unrelated/excessive vs another medical condition).
- **DSM-IV-TR -> DSM-5-TR change notes**: Renamed from **Social Phobia** to **Social Anxiety Disorder**. The "Generalized" specifier was removed and replaced by the **"Performance only"** specifier. Now requires 6-month duration at all ages; removed the requirement that the person recognizes the fear as excessive/unreasonable (clinician judges, Criterion E). (verify on exact specifier wording)

---

## Panic Disorder
ICD-10-CM: F41.0

- **Criteria**
  - **A.** Recurrent **unexpected** panic attacks. A panic attack = abrupt surge of intense fear/discomfort peaking within minutes, during which **≥4 of the following 13 symptoms** occur (abrupt surge can arise from calm or anxious state):
    1. Palpitations, pounding heart, or accelerated heart rate.
    2. Sweating.
    3. Trembling or shaking.
    4. Shortness of breath or smothering.
    5. Feelings of choking.
    6. Chest pain or discomfort.
    7. Nausea or abdominal distress.
    8. Dizzy, unsteady, light-headed, or faint.
    9. Chills or heat sensations.
    10. Paresthesias (numbness or tingling).
    11. Derealization or depersonalization.
    12. Fear of losing control or "going crazy."
    13. Fear of dying.
    - *Note: culture-specific symptoms (tinnitus, neck soreness, headache, uncontrollable screaming/crying) do not count toward the 4.*
  - **B.** At least one attack followed by **≥1 month** of one or both: (1) persistent concern/worry about more attacks or their consequences; (2) significant maladaptive behavior change related to the attacks.
  - **C.** Not attributable to physiological effects of a substance or another medical condition (e.g., hyperthyroidism, cardiopulmonary disorders).
  - **D.** Not better explained by another mental disorder (social anxiety disorder, specific phobia, OCD, PTSD, separation anxiety disorder).
- **Duration / onset**: Criterion B requires **≥1 month** of concern/behavior change after an attack. Median age at onset (US) 20–24 years.
- **Age rules**: Prevalence low before age 14 (<0.4%). No major presentation differences between adolescents and adults.
- **Specifiers**: For panic disorder, panic attack is contained in the criteria and is **not** used as a specifier. (Severity/remission specifiers are not stated in extracted text.)
- **Exclusion criteria**: Criterion C (substance / medical condition) and Criterion D (other mental disorder). Limited-symptom-only or never-having-full-symptom unexpected attacks -> consider other/unspecified anxiety disorder.
- **DSM-IV-TR -> DSM-5-TR change notes**: Panic disorder and agoraphobia were **decoupled** — no longer "panic disorder with/without agoraphobia"; each is a separate diagnosis and both can be coded together. "Within minutes" peak wording (DSM-5) replaced DSM-IV "within 10 minutes." (verify)

---

## Panic Attack (Specifier)
Not a codable mental disorder; usable as a specifier across many disorders (e.g., "PTSD with panic attacks"). Not used as a specifier for panic disorder itself.

- **Criteria**: Abrupt surge of intense fear/discomfort peaking within minutes, with **≥4 of 13 symptoms** (identical list to Panic Disorder Criterion A above): palpitations; sweating; trembling/shaking; shortness of breath; choking; chest pain; nausea/abdominal distress; dizzy/faint; chills/heat sensations; paresthesias; derealization/depersonalization; fear of losing control or "going crazy"; fear of dying.
  - 11 of the 13 are physical; 2 are cognitive (fear of losing control/going crazy; fear of dying).
  - **Limited-symptom attack** = meets all other criteria but **fewer than 4** symptoms.
  - Types: **expected** (obvious cue/trigger) vs **unexpected** (no obvious cue; includes nocturnal panic attack).
- **Duration / onset**: "Within minutes" = time to peak intensity is literally a few minutes.
- **Age rules**: Rare/uncommon in preadolescent children; unexpected attacks rare before puberty.
- **Specifiers**: It *is* a specifier ("with panic attacks").
- **Exclusion criteria**: Should not be diagnosed if episodes lack the essential abrupt surge of intense fear/discomfort (e.g., anger attacks). Rule out medical condition / substance cause.
- **DSM-IV-TR -> DSM-5-TR change notes**: In DSM-5 panic attack became a cross-cutting **specifier** applicable to any disorder; expected/unexpected typology formalized. (verify)

---

## Agoraphobia
ICD-10-CM: F40.00

- **Criteria**
  - **A. Marked fear/anxiety about ≥2 of the following 5 situations:**
    1. Using public transportation (automobiles, buses, trains, ships, planes).
    2. Being in open spaces (parking lots, marketplaces, bridges).
    3. Being in enclosed places (shops, theaters, cinemas).
    4. Standing in line or being in a crowd.
    5. Being outside of the home alone.
  - **B.** Fears/avoids these because of thoughts that escape might be difficult or help unavailable if panic-like or other incapacitating/embarrassing symptoms develop (e.g., fear of falling in elderly; fear of incontinence).
  - **C.** The agoraphobic situations almost always provoke fear/anxiety.
  - **D.** Situations are actively avoided, require a companion, or are endured with intense fear/anxiety.
  - **E.** Fear/anxiety out of proportion to actual danger and sociocultural context.
  - **F.** Persistent, **typically lasting 6 months or more**.
  - **G.** Clinically significant distress or impairment.
  - **H.** If another medical condition is present (e.g., inflammatory bowel disease, Parkinson's), fear/anxiety/avoidance is clearly excessive.
  - **I.** Not better explained by another mental disorder (specific phobia situational type; social anxiety disorder; OCD; body dysmorphic disorder; PTSD; separation anxiety disorder).
  - *Note: Agoraphobia is diagnosed irrespective of panic disorder; if both criteria are met, assign both diagnoses.*
- **Duration / onset**: **≥6 months (typically)**. Mean age at onset 21 years; two-thirds onset before age 35.
- **Age rules**: Rare first onset in childhood; ~10% of older adults report first onset after age 65. In children, "being outside of home alone" is the most feared situation.
- **Specifiers**: None listed. (Panic Attack specifier may apply.)
- **Exclusion criteria**: Criterion H (excessive vs medical condition) and Criterion I (other mental disorder). Differentiated from situational specific phobia by requiring ≥2 agoraphobic situations.
- **DSM-IV-TR -> DSM-5-TR change notes**: Now a **standalone codable diagnosis**, decoupled from panic disorder (no longer "panic disorder with agoraphobia" / "agoraphobia without history of panic disorder"). Requires fear of **≥2 of 5 situation clusters**; 6-month duration and clinician-judged proportionality added. (verify)

---

## Generalized Anxiety Disorder
ICD-10-CM: F41.1

- **Criteria**
  - **A.** Excessive anxiety and worry (apprehensive expectation), **occurring more days than not for at least 6 months**, about a number of events or activities (e.g., work/school performance).
  - **B.** The individual finds it difficult to control the worry.
  - **C. Anxiety/worry associated with ≥3 of the following 6 symptoms** (with at least some present more days than not for the past 6 months). **Note: only 1 item required in children.**
    1. Restlessness or feeling keyed up / on edge.
    2. Being easily fatigued.
    3. Difficulty concentrating or mind going blank.
    4. Irritability.
    5. Muscle tension.
    6. Sleep disturbance (difficulty falling/staying asleep, or restless/unsatisfying sleep).
  - **D.** Anxiety/worry/physical symptoms cause clinically significant distress or impairment.
  - **E.** Not attributable to physiological effects of a substance or another medical condition (e.g., hyperthyroidism).
  - **F.** Not better explained by another mental disorder (panic disorder, social anxiety disorder, OCD, separation anxiety, PTSD, anorexia nervosa, somatic symptom disorder, body dysmorphic disorder, illness anxiety disorder, schizophrenia/delusional disorder).
- **Duration / onset**: **≥6 months**, worry occurring **more days than not**; symptoms present more days than not over the past 6 months. Mean age at onset (North America) 35 years (later than other anxiety disorders); rarely before adolescence.
- **Age rules**: **Children: only 1 of the 6 Criterion C symptoms required** (adults need ≥3). Children/adolescents typically worry about competence/performance.
- **Specifiers**: None.
- **Exclusion criteria**: Criterion E (substance/medical condition) and Criterion F (other mental disorder).
- **DSM-IV-TR -> DSM-5-TR change notes**: Criteria essentially unchanged from DSM-IV (3 of 6 associated symptoms; 1 in children; ≥6 months, more days than not). (verify)

---

## Substance/Medication-Induced Anxiety Disorder
ICD-10-CM: code by substance class and presence/severity of comorbid use disorder (see table below).

- **Criteria**
  - **A.** Panic attacks or anxiety is predominant in the clinical picture.
  - **B.** Evidence from history/exam/labs of **both**: (1) symptoms in A developed during or soon after substance intoxication or withdrawal, or after exposure to/withdrawal from a medication; **and** (2) the involved substance/medication is capable of producing the Criterion A symptoms.
  - **C.** Not better explained by an independent (non-substance/medication-induced) anxiety disorder. Evidence of independence: symptoms precede the substance/medication use; symptoms persist for a substantial period (**e.g., about 1 month**) after cessation of acute withdrawal/severe intoxication; or other evidence of an independent disorder (e.g., history of recurrent non-substance-related episodes).
  - **D.** Does not occur exclusively during the course of a delirium.
  - **E.** Clinically significant distress or impairment.
  - *Note: Diagnose this (instead of substance intoxication/withdrawal) only when Criterion A symptoms predominate and are severe enough to warrant clinical attention.*
- **Duration / onset**: Tied to intoxication/withdrawal/medication exposure. Persistence ~1 month beyond acute withdrawal/intoxication suggests an independent disorder (Criterion C).
- **Age rules**: None specified.
- **Specifiers** (coding, not stated as "specify if" wording in extracted text): onset specifiers in standard DSM-5-TR are "With onset during intoxication" / "With onset during withdrawal" / "With onset after medication use" (verify — not present in extracted text). ICD-10-CM code depends on comorbid use-disorder severity:
  - 4th-position character "1" = with mild use disorder; "2" = with moderate/severe use disorder; "9" = without use disorder.
- **Substances / ICD-10-CM codes** (mild use / moderate-severe use / no use disorder):
  - Alcohol: F10.180 / F10.280 / F10.980
  - Caffeine: NA / NA / F15.980
  - Cannabis: F12.180 / F12.280 / F12.980
  - Phencyclidine: F16.180 / F16.280 / F16.980
  - Other hallucinogen: F16.180 / F16.280 / F16.980
  - Inhalant: F18.180 / F18.280 / F18.980
  - Opioid: F11.188 / F11.288 / F11.988
  - Sedative, hypnotic, or anxiolytic: F13.180 / F13.280 / F13.980
  - Amphetamine-type substance (or other stimulant): F15.180 / F15.280 / F15.980
  - Cocaine: F14.180 / F14.280 / (without use disorder code cut off in source — standard is F14.980, verify)
- **Exclusion criteria**: Criterion C (independent anxiety disorder) and Criterion D (not exclusively during delirium). No separate substance use disorder diagnosis is given alongside this code.
- **DSM-IV-TR -> DSM-5-TR change notes**: ICD-10-CM coding scheme that embeds comorbid use-disorder severity into the diagnosis code is a DSM-5/DSM-5-TR feature. (verify)

---

## Anxiety Disorder Due to Another Medical Condition
ICD-10-CM: F06.4 (verify — text not present in extracted file)

> NOTE: The diagnostic-criteria text for this disorder is **not present** in the extracted file (the file truncates mid-table in the previous disorder). The following reproduces the standard DSM-5-TR criteria from knowledge and is marked for verification.

- **Criteria** (verify against source):
  - **A.** Panic attacks or anxiety is predominant in the clinical picture.
  - **B.** Evidence from history/exam/labs that the disturbance is the direct pathophysiological consequence of another medical condition.
  - **C.** Not better explained by another mental disorder.
  - **D.** Does not occur exclusively during a delirium.
  - **E.** Clinically significant distress or impairment.
- **Duration / onset**: Tied to the course of the underlying medical condition. (verify)
- **Age rules**: None specified. (verify)
- **Specifiers**: None standard. (verify)
- **Exclusion criteria**: Not better explained by another mental disorder; not exclusively during delirium. Examples of causal medical conditions (drawn from related text in the file): hyperthyroidism, hyperparathyroidism, pheochromocytoma, vestibular dysfunctions, seizure disorders, cardiopulmonary conditions (arrhythmias, supraventricular tachycardia, asthma, COPD).
- **DSM-IV-TR -> DSM-5-TR change notes**: Largely retained from DSM-IV "Anxiety Disorder Due to a General Medical Condition." (verify)

---

## Other Specified Anxiety Disorder / Unspecified Anxiety Disorder
ICD-10-CM: F41.8 (Other Specified) / F41.9 (Unspecified) (verify — text not present in extracted file)

> NOTE: This section is **not present** in the extracted file. Content below is from standard DSM-5-TR knowledge and is marked for verification.

- **Other Specified Anxiety Disorder (F41.8)** (verify): For presentations with characteristic anxiety symptoms causing clinically significant distress/impairment that do not meet full criteria for any specific anxiety disorder, where the clinician chooses to communicate the specific reason. Example presentations include: limited-symptom attacks; generalized anxiety not occurring more days than not; *khyâl cap* (wind attacks); *ataque de nervios* (attack of nerves).
- **Unspecified Anxiety Disorder (F41.9)** (verify): Same threshold, but the clinician chooses **not** to specify the reason, or there is insufficient information (e.g., emergency-room settings).
- **Duration / onset**: N/A.
- **Age rules**: N/A.
- **Specifiers**: N/A (residual categories).
- **Exclusion criteria**: Used only when full criteria for a specific anxiety disorder are not met and symptoms are not better explained by another disorder.
- **DSM-IV-TR -> DSM-5-TR change notes**: Replaced the single DSM-IV "Anxiety Disorder Not Otherwise Specified (NOS)" with the two categories Other Specified / Unspecified. (verify)
