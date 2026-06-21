# Criteria Sheet — DSM-5-TR Trauma- and Stressor-Related Disorders

Source: `/tmp/dsm_tr.txt` (PDF extraction of the DSM-5-TR "Trauma- and Stressor-Related Disorders" chapter, 2022).
Counts, thresholds, durations, ages, and specifiers are quoted exactly from the source text. Items are abbreviated but faithful, suitable for later modeling as yes/no symptom questions.

Chapter scope (per source): reactive attachment disorder, disinhibited social engagement disorder, posttraumatic stress disorder (PTSD), acute stress disorder, adjustment disorders, and prolonged grief disorder.

> NOTE ON SOURCE COMPLETENESS: the source slice DID contain every disorder of the chapter (the earlier "truncation" worry was unfounded). **Prolonged Grief Disorder has been checked line-by-line against the DSM-5-TR text and is correct** (ICD code F43.8; criteria A–F as below, B = 1 or both of 2, C = at least 3 of 8, adult threshold 12 months / children-adolescents 6 months). The Substance/Medication-Induced, Due-to-Another-Medical-Condition and Other/Unspecified entries follow the standard cross-chapter template and remain tagged **(verify)** as a courtesy double-check before coding.

---

## Reactive Attachment Disorder
ICD-10-CM: F94.1

- **Criteria**
  - **A.** A consistent pattern of inhibited, emotionally withdrawn behavior toward adult caregivers, manifested by **both** of:
    1. Child rarely or minimally seeks comfort when distressed.
    2. Child rarely or minimally responds to comfort when distressed.
  - **B.** A persistent social and emotional disturbance characterized by **at least two** of:
    1. Minimal social and emotional responsiveness to others.
    2. Limited positive affect.
    3. Episodes of unexplained irritability, sadness, or fearfulness evident even during nonthreatening interactions with adult caregivers.
  - **C.** Pattern of extremes of insufficient care, **at least one** of:
    1. Social neglect/deprivation (persistent lack of basic emotional needs for comfort, stimulation, affection met by caregiving adults).
    2. Repeated changes of primary caregivers limiting opportunity to form stable attachments (e.g., frequent foster-care changes).
    3. Rearing in unusual settings severely limiting opportunity to form selective attachments (e.g., institutions with high child-to-caregiver ratios).
  - **D.** Care in Criterion C is presumed responsible for the disturbed behavior in Criterion A.
  - **E.** Criteria are NOT met for autism spectrum disorder.
  - **F.** Disturbance is evident before age 5 years.
  - **G.** Child has a developmental age of at least 9 months.
- **Duration / onset:** No symptom-duration threshold in the core criteria; onset/evidence required **before age 5 years** (Criterion F). "Persistent" specifier = present for **more than 12 months**.
- **Age rules:** Developmental age **≥ 9 months** (Criterion G); disturbance evident **before age 5 years** (Criterion F).
- **Specifiers:**
  - **Persistent:** disorder present for more than 12 months.
  - **Current severity — Severe:** child exhibits all symptoms of the disorder, each at relatively high levels.
- **Exclusion criteria:** Must NOT meet criteria for autism spectrum disorder (Criterion E). Disturbance attributed to insufficient care (Criterion D). Not diagnosed in children developmentally unable to form selective attachments (hence the ≥9-month rule).
- **DSM-IV-TR → DSM-5-TR change notes:** In DSM-IV, reactive attachment disorder had two subtypes — "inhibited/emotionally withdrawn" and "disinhibited/indiscriminately social." DSM-5 split these into two distinct disorders: reactive attachment disorder (this, the inhibited/withdrawn type) and disinhibited social engagement disorder. Placed in the new Trauma- and Stressor-Related Disorders chapter. (verify exact wording of historical subtype labels)

---

## Disinhibited Social Engagement Disorder
ICD-10-CM: F94.2

- **Criteria**
  - **A.** A pattern of behavior in which a child actively approaches and interacts with unfamiliar adults, exhibiting **at least two** of:
    1. Reduced or absent reticence in approaching/interacting with unfamiliar adults.
    2. Overly familiar verbal or physical behavior (not consistent with culturally sanctioned and age-appropriate social boundaries).
    3. Diminished or absent checking back with adult caregiver after venturing away, even in unfamiliar settings.
    4. Willingness to go off with an unfamiliar adult with minimal or no hesitation.
  - **B.** Behaviors in Criterion A are not limited to impulsivity (as in ADHD) but include socially disinhibited behavior.
  - **C.** Pattern of extremes of insufficient care, **at least one** of (same list as Reactive Attachment Disorder C):
    1. Social neglect/deprivation.
    2. Repeated changes of primary caregivers limiting stable attachments.
    3. Rearing in unusual settings limiting selective attachments.
  - **D.** Care in Criterion C is presumed responsible for the disturbed behavior in Criterion A.
  - **E.** Child has a developmental age of at least 9 months.
- **Duration / onset:** No core symptom-duration threshold. "Persistent" specifier = present for **more than 12 months**.
- **Age rules:** Developmental age **≥ 9 months** (Criterion E). (Note: per text, disorder has not been identified in children who experience social neglect only after age 2 years — descriptive, not a criterion.)
- **Specifiers:**
  - **Persistent:** disorder present for more than 12 months.
  - **Current severity — Severe:** child exhibits all symptoms of the disorder, each at relatively high levels.
- **Exclusion criteria:** Behavior must extend beyond mere impulsivity / ADHD (Criterion B). Attributed to insufficient care (Criterion D). Requires developmental age ≥ 9 months (Criterion E).
- **DSM-IV-TR → DSM-5-TR change notes:** New as a standalone disorder in DSM-5; previously the "disinhibited type" subtype of DSM-IV reactive attachment disorder. Placed in the Trauma- and Stressor-Related Disorders chapter. (verify)

---

## Posttraumatic Stress Disorder (PTSD) — Individuals Older Than 6 Years
ICD-10-CM: F43.10
Note (source): These criteria apply to adults, adolescents, and children older than 6 years.

- **Criteria** (4 symptom clusters: B, C, D, E)
  - **Criterion A — Stressor/exposure:** Exposure to actual or threatened death, serious injury, or sexual violence in **one (or more)** of the **4 exposure routes**:
    1. Directly experiencing the traumatic event(s).
    2. Witnessing, in person, the event(s) as they occurred to others.
    3. Learning the event(s) occurred to a close family member or close friend (if actual/threatened death of a family member/friend, the event must have been violent or accidental).
    4. Experiencing repeated or extreme exposure to aversive details of the event(s) (e.g., first responders collecting human remains; police repeatedly exposed to child-abuse details). — Note: A4 does NOT apply to exposure through electronic media, TV, movies, or pictures unless work related.
  - **Criterion B — Intrusion (1 or more of 5):** present, associated with the event, beginning after the event:
    1. Recurrent, involuntary, intrusive distressing memories. (Children >6: may be repetitive play.)
    2. Recurrent distressing dreams related to the event(s). (Children: frightening dreams without recognizable content.)
    3. Dissociative reactions (e.g., flashbacks) — feeling/acting as if the event were recurring. (Children: trauma-specific reenactment in play.)
    4. Intense or prolonged psychological distress at exposure to internal/external cues symbolizing/resembling the event.
    5. Marked physiological reactions to internal/external cues symbolizing/resembling the event.
  - **Criterion C — Avoidance (1 or both of 2):** persistent avoidance of stimuli, beginning after the event:
    1. Avoidance of (or efforts to avoid) distressing memories, thoughts, or feelings about the event.
    2. Avoidance of (or efforts to avoid) external reminders (people, places, conversations, activities, objects, situations) that arouse such memories/thoughts/feelings.
  - **Criterion D — Negative alterations in cognitions and mood (2 or more of 7):** beginning or worsening after the event:
    1. Inability to remember an important aspect of the event (typically dissociative amnesia, not head injury/alcohol/drugs).
    2. Persistent, exaggerated negative beliefs/expectations about oneself, others, or the world.
    3. Persistent, distorted cognitions about cause/consequences leading to self-blame or blame of others.
    4. Persistent negative emotional state (fear, horror, anger, guilt, shame).
    5. Markedly diminished interest or participation in significant activities.
    6. Feelings of detachment or estrangement from others.
    7. Persistent inability to experience positive emotions.
  - **Criterion E — Alterations in arousal and reactivity (2 or more of 6):** beginning or worsening after the event:
    1. Irritable behavior and angry outbursts (little/no provocation), typically verbal/physical aggression toward people or objects.
    2. Reckless or self-destructive behavior.
    3. Hypervigilance.
    4. Exaggerated startle response.
    5. Problems with concentration.
    6. Sleep disturbance (difficulty falling/staying asleep, restless sleep).
  - **Criterion F — Duration:** Duration of the disturbance (Criteria B, C, D, and E) is **more than 1 month**.
  - **Criterion G:** Disturbance causes clinically significant distress or impairment (social, occupational, other).
  - **Criterion H:** Not attributable to physiological effects of a substance (medication, alcohol) or another medical condition.
- **Duration / onset:** Criterion F = **more than 1 month**. "With delayed expression" if full criteria not met until **at least 6 months** after the event.
- **Age rules:** These criteria apply to adults, adolescents, and **children older than 6 years**. Separate criteria set exists for **children 6 years and younger** (see next section).
- **Specifiers:**
  - **With dissociative symptoms** — meets PTSD criteria plus persistent/recurrent **either**: (1) **Depersonalization** (detachment, feeling like an outside observer of one's mental processes/body) or (2) **Derealization** (experiences of unreality of surroundings). Note: dissociative symptoms must not be attributable to a substance (e.g., alcohol intoxication blackouts) or another medical condition (e.g., complex partial seizures).
  - **With delayed expression** — full diagnostic criteria not met until at least 6 months after the event (some symptoms may be immediate).
- **Exclusion criteria:** Criterion H (not due to substance/medication or another medical condition). Symptoms must begin or worsen after the traumatic event.
- **DSM-IV-TR → DSM-5-TR change notes:** PTSD moved OUT of Anxiety Disorders into this new Trauma- and Stressor-Related Disorders chapter. Restructured from **3 symptom clusters (DSM-IV)** to **4 clusters (B intrusion, C avoidance, D negative cognitions/mood, E arousal)** — DSM-IV's combined avoidance/numbing cluster was split into separate C (avoidance) and D (negative alterations in cognitions and mood). The DSM-IV A2 subjective-response requirement (fear, helplessness, horror) was removed. Acute/chronic specifiers removed; **"with delayed expression"** kept (renamed from DSM-IV "delayed onset"); **"with dissociative symptoms"** subtype added. A separate developmental subtype for children ≤6 years added.

---

## Posttraumatic Stress Disorder in Children 6 Years and Younger (PTSD preschool subtype)
(Subsumed under F43.10; source presents it as a distinct criteria set.)

- **Criteria** (note: clusters differ from the older-than-6 set — avoidance and negative cognitions are MERGED into Criterion C)
  - **Criterion A — Exposure** (one or more of **3 routes** — only 3, not 4):
    1. Directly experiencing the event(s).
    2. Witnessing, in person, the event(s) as it occurred to others, especially primary caregivers.
    3. Learning the event(s) occurred to a parent or caregiving figure.
  - **Criterion B — Intrusion (1 or more of 5):** beginning after the event:
    1. Recurrent, involuntary, intrusive distressing memories (may be expressed as play reenactment; may not appear distressing).
    2. Recurrent distressing dreams related to the event(s) (may not be possible to confirm frightening content relates to the trauma).
    3. Dissociative reactions/flashbacks — feeling/acting as if the event were recurring; trauma-specific reenactment may occur in play.
    4. Intense or prolonged psychological distress at exposure to internal/external cues symbolizing/resembling the event.
    5. Marked physiological reactions to reminders of the event(s).
  - **Criterion C — (1 or more) of the following, representing EITHER persistent avoidance OR negative alterations in cognitions/mood** (combined cluster, 6 items total; beginning or worsening after the event):
    - *Persistent Avoidance of Stimuli:*
      1. Avoidance of (or efforts to avoid) activities, places, or physical reminders arousing recollections of the event.
      2. Avoidance of (or efforts to avoid) people, conversations, or interpersonal situations arousing recollections of the event.
    - *Negative Alterations in Cognitions:*
      3. Substantially increased frequency of negative emotional states (fear, guilt, sadness, shame, confusion).
      4. Markedly diminished interest/participation in significant activities, including constriction of play.
      5. Socially withdrawn behavior.
      6. Persistent reduction in expression of positive emotions.
  - **Criterion D — Alterations in arousal and reactivity (2 or more of 5):** beginning or worsening after the event:
    1. Irritable behavior and angry outbursts (little/no provocation), verbal/physical aggression toward people or objects (including extreme temper tantrums).
    2. Hypervigilance.
    3. Exaggerated startle response.
    4. Problems with concentration.
    5. Sleep disturbance.
  - **Criterion E — Duration:** more than 1 month.
  - **Criterion F:** Disturbance causes clinically significant distress or impairment in relationships with parents, siblings, peers, or other caregivers, or with school behavior.
  - **Criterion G:** Not attributable to physiological effects of a substance (medication or alcohol) or another medical condition.
- **Duration / onset:** Criterion E = **more than 1 month**. "With delayed expression" = full criteria not met until at least 6 months after the event.
- **Age rules:** Applies to **children 6 years and younger**. MODIFIED COUNTS vs. the older set:
  - Exposure routes: **3** (no "repeated/extreme exposure to aversive details" route).
  - Intrusion (B): 1 or more of 5 (same count).
  - Combined avoidance + negative cognitions (C): **only 1 (or more)** required from the merged 6-item cluster (vs. older set's 1-of-2 avoidance AND 2-of-7 cognitions/mood separately).
  - Arousal (D): **2 or more of 5** (older set is 2 of 6; "reckless/self-destructive behavior" item absent here).
- **Specifiers:**
  - **With dissociative symptoms** — meets PTSD criteria plus persistent/recurrent **Depersonalization** or **Derealization** (not attributable to a substance, e.g., blackouts, or another medical condition, e.g., complex partial seizures).
  - **With delayed expression** — full criteria not met until at least 6 months after the event.
- **Exclusion criteria:** Criterion G (not due to substance/medication or another medical condition).
- **DSM-IV-TR → DSM-5-TR change notes:** This developmentally-modified preschool subtype is new in DSM-5 (no DSM-IV equivalent); thresholds lowered/restructured for young children as above.

---

## Acute Stress Disorder
ICD-10-CM: F43.0

- **Criteria**
  - **A — Exposure** to actual or threatened death, serious injury, or sexual violence in **one (or more)** of **4 ways** (same as PTSD adult Criterion A):
    1. Directly experiencing the event(s).
    2. Witnessing, in person, the event(s) as it occurred to others.
    3. Learning the event(s) occurred to a close family member or close friend (death of family/friend must have been violent or accidental).
    4. Experiencing repeated or extreme exposure to aversive details of the event(s) (e.g., first responders). — Does NOT apply to electronic media/TV/movies/pictures unless work related.
  - **B — Symptoms:** Presence of **nine (or more) of the following 14 symptoms** from any of the **five categories** (intrusion, negative mood, dissociation, avoidance, arousal), beginning or worsening after the event:
    - *Intrusion:*
      1. Recurrent, involuntary, intrusive distressing memories (children: repetitive play).
      2. Recurrent distressing dreams related to the event(s) (children: frightening dreams without recognizable content).
      3. Dissociative reactions/flashbacks (children: trauma-specific reenactment in play).
      4. Intense/prolonged psychological distress OR marked physiological reactions to internal/external cues symbolizing/resembling the event. (= PTSD B4 + B5 combined.)
    - *Negative Mood:*
      5. Persistent inability to experience positive emotions.
    - *Dissociative Symptoms:*
      6. Altered sense of reality of one's surroundings or oneself (e.g., seeing oneself from another's perspective, daze, time slowing).
      7. Inability to remember an important aspect of the event (typically dissociative amnesia, not head injury/alcohol/drugs).
    - *Avoidance Symptoms:*
      8. Efforts to avoid distressing memories, thoughts, or feelings about the event.
      9. Efforts to avoid external reminders (people, places, conversations, activities, objects, situations).
    - *Arousal Symptoms:*
      10. Sleep disturbance.
      11. Irritable behavior and angry outbursts (little/no provocation), verbal/physical aggression.
      12. Hypervigilance.
      13. Problems with concentration.
      14. Exaggerated startle response.
  - **C — Duration:** Duration of the disturbance (symptoms in Criterion B) is **3 days to 1 month after trauma exposure**. (Note: symptoms typically begin immediately, but persistence for at least 3 days and up to a month is required.)
  - **D:** Disturbance causes clinically significant distress or impairment (social, occupational, other).
  - **E:** Not attributable to physiological effects of a substance (medication or alcohol) or another medical condition (e.g., mild traumatic brain injury), and **not better explained by brief psychotic disorder**.
- **Duration / onset:** **3 days to 1 month** after trauma exposure (Criterion C). Symptoms resolving in <3 days do not qualify; if symptoms persist >1 month and meet PTSD criteria, diagnosis changes to PTSD.
- **Age rules:** None specific (children noted descriptively for play/dreams presentation; no separate child criteria set).
- **Specifiers:** **None** (no formal specifiers in the criteria set).
- **Exclusion criteria:** Criterion E — not due to substance/medication or another medical condition (e.g., mild TBI); not better explained by brief psychotic disorder.
- **DSM-IV-TR → DSM-5-TR change notes:** Stressor criterion (A) revised to mirror PTSD (explicit exposure routes; subjective fear/helplessness/horror reaction removed). DSM-IV required a set of dissociative symptoms; DSM-5 instead requires **≥ 9 of 14 symptoms** across 5 categories (intrusion, negative mood, dissociation, avoidance, arousal), dissociation no longer mandatory. Duration window stated as 3 days to 1 month (DSM-IV: 2 days to 4 weeks). (verify DSM-IV duration figures)

---

## Adjustment Disorders
ICD-10-CM: F43.2x (subtype-dependent, see specifiers)

- **Criteria**
  - **A.** Development of emotional or behavioral symptoms in response to an identifiable stressor(s), occurring **within 3 months of the onset of the stressor(s)**.
  - **B.** Symptoms/behaviors are clinically significant, evidenced by **one or both** of:
    1. Marked distress out of proportion to the severity/intensity of the stressor (accounting for external context and cultural factors).
    2. Significant impairment in social, occupational, or other important areas of functioning.
  - **C.** The stress-related disturbance does not meet criteria for another mental disorder and is not merely an exacerbation of a preexisting mental disorder.
  - **D.** The symptoms do not represent normal bereavement and are not better explained by prolonged grief disorder.
  - **E.** Once the stressor or its consequences have terminated, the symptoms do not persist for more than an **additional 6 months**.
- **Duration / onset:** Onset **within 3 months** of the stressor (Criterion A); symptoms do not persist **more than 6 months** after the stressor/its consequences end (Criterion E).
- **Age rules:** None specific.
- **Specifiers — subtype (Specify whether):**
  - **F43.21 With depressed mood** — low mood, tearfulness, hopelessness predominate.
  - **F43.22 With anxiety** — nervousness, worry, jitteriness, or separation anxiety predominate.
  - **F43.23 With mixed anxiety and depressed mood** — combination of depression and anxiety predominates.
  - **F43.24 With disturbance of conduct** — disturbance of conduct predominates.
  - **F43.25 With mixed disturbance of emotions and conduct** — both emotional symptoms and conduct disturbance predominate.
  - **F43.20 Unspecified** — maladaptive reactions not classifiable as a specific subtype.
- **Course specifiers (Specify if):**
  - **Acute** — persistence of symptoms for less than 6 months.
  - **Persistent (chronic)** — persistence of symptoms for 6 months or longer (applies to chronic stressors or stressors with enduring consequences; symptoms cannot persist >6 months after termination of the stressor/its consequences).
- **Exclusion criteria:** Criterion C (does not meet criteria for another mental disorder; not merely an exacerbation of a preexisting disorder). Criterion D (not normal bereavement; not better explained by prolonged grief disorder).
- **DSM-IV-TR → DSM-5-TR change notes:** Moved into the Trauma- and Stressor-Related Disorders chapter (DSM-IV had adjustment disorders as their own class). Subtypes essentially retained. DSM-5-TR added the explicit exclusion that symptoms "are not better explained by prolonged grief disorder" (Criterion D), reflecting the new prolonged grief diagnosis. (verify whether the "with disturbance of conduct"/"mixed" labels are unchanged from DSM-IV)

---

## Prolonged Grief Disorder
ICD-10-CM: F43.8
> VERIFIED against the DSM-5-TR source text (new disorder, added in DSM-5-TR 2022).

- **Criteria** (verified)
  - **A.** The death, at least 12 months ago (in children/adolescents, at least 6 months ago), of a person who was close to the bereaved individual. **(verify)**
  - **B.** Since the death, a persistent grief response characterized by **one or both** of, to a clinically significant degree, nearly every day for at least the last month: (1) intense yearning/longing for the deceased; (2) preoccupation with thoughts/memories of the deceased (in children/adolescents, may focus on circumstances of the death). **(verify)**
  - **C.** Since the death, **at least three** of the following symptoms present to a clinically significant degree nearly every day for at least the last month: **(verify)**
    1. Identity disruption (e.g., feeling as though part of oneself has died).
    2. Marked sense of disbelief about the death.
    3. Avoidance of reminders that the person is dead.
    4. Intense emotional pain (e.g., anger, bitterness, sorrow) related to the death.
    5. Difficulty reintegrating into relationships and activities after the death.
    6. Emotional numbness (absence of or marked reduction in emotion).
    7. Feeling that life is meaningless as a result of the death.
    8. Intense loneliness as a result of the death.
  - **D.** The disturbance causes clinically significant distress or impairment in social, occupational, or other important areas of functioning. **(verify)**
  - **E.** The duration and severity of the bereavement reaction clearly exceed expected social, cultural, or religious norms for the individual's culture and context. **(verify)**
  - **F.** Not better explained by another mental disorder (e.g., major depressive disorder, PTSD) and not attributable to a substance or another medical condition. **(verify)**
- **Duration / onset:** Time-since-death threshold = **at least 12 months for adults** (Criterion A); grief response and symptoms present **nearly every day for at least the last month** (Criteria B/C). **(verify)**
- **Age rules:** Adult time threshold **12 months**; children and adolescents time threshold **6 months** (Criterion A). **(verify)**
- **Specifiers:** No formal symptom-cluster specifiers; clinical-significance/cultural-norm exceedance is built into Criteria D/E. **(verify whether any specifier exists)**
- **Exclusion criteria:** Not better explained by another mental disorder; not due to a substance or another medical condition (Criterion F). Reaction must exceed cultural/religious norms (Criterion E). **(verify)**
- **DSM-IV-TR → DSM-5-TR change notes:** **Prolonged grief disorder is NEW, added in DSM-5-TR (2022).** It did not exist in DSM-IV-TR or in the original DSM-5 (2013), which had "persistent complex bereavement disorder" only as a Section III condition for further study. **(verify exact relationship to the Section III condition)**

---

## Other Specified Trauma- and Stressor-Related Disorder
ICD-10-CM: F43.89
> NOT present in the supplied source file. Documented from general DSM-5-TR knowledge — **(verify)**.

- **Description:** Presentations with characteristic trauma-/stressor-related symptoms causing clinically significant distress or impairment that do not meet full criteria for any disorder in this class; the clinician records the specific reason (e.g., "adjustment-like disorders with delayed onset of symptoms that occur more than 3 months after the stressor," "persistent complex bereavement disorder," "ataque de nervios" and other cultural concepts of distress). **(verify the listed examples)**
- **Duration / onset:** N/A — subthreshold category.
- **Specifiers:** None; free-text reason recorded.
- **Exclusion criteria:** Used only when full criteria for a specific disorder are not met.

## Unspecified Trauma- and Stressor-Related Disorder
ICD-10-CM: F43.9
> NOT present in the supplied source file. Documented from general DSM-5-TR knowledge — **(verify)**.

- **Description:** Presentations with characteristic trauma-/stressor-related symptoms causing clinically significant distress or impairment that do not meet full criteria for any disorder in this class, used when the clinician chooses not to specify the reason, or there is insufficient information (e.g., emergency room settings). **(verify)**
- **Duration / onset:** N/A.
- **Specifiers:** None.
- **Exclusion criteria:** Used only when full criteria for a specific disorder are not met.
