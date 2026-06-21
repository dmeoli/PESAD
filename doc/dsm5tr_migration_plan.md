# PESAD → DSM-5-TR Migration & Modeling Plan (Phase A)

This document is the **design bridge** between the extracted DSM-5-TR criteria
(`criteria_sheet_anxiety.md`, `criteria_sheet_ocd.md`, `criteria_sheet_trauma.md`)
and the Prolog knowledge base. **Review this before any code is written.**

Reference edition: **DSM-5-TR (2022)**. Scope: full coverage of the three related
chapters. The DSM-IV-TR knowledge base is **replaced** (kept only in git history).
System renamed (subtitle): *Prolog Expert System for Anxiety, Obsessive-Compulsive
and Trauma-Related Disorders* — acronym **PESAD** retained.

---

## 1. New diagnostic-goal taxonomy (`disorder/3`)

Codable disorders that become diagnostic goals, grouped by chapter. Specifiers
are modeled as extra antecedents/types, not as separate top-level goals (except
where DSM keeps separate codes, e.g. specific-phobia stimulus types).

### 1.1 Anxiety Disorders
| Goal | Specifiers / variants |
| --- | --- |
| Separation Anxiety Disorder | — |
| Selective Mutism | — |
| Specific Phobia | type: animal / natural-environment / blood-injection-injury / situational / other (separate codes → keep as variants, as today) |
| Social Anxiety Disorder | *performance only* (yes/no) |
| Panic Disorder | (panic attack = cross-cutting specifier, see §3) |
| Agoraphobia | — |
| Generalized Anxiety Disorder | — |
| Substance/Medication-Induced Anxiety Disorder | with onset during intoxication / withdrawal / after medication use |
| Anxiety Disorder Due to Another Medical Condition | with panic attacks / with generalized anxiety |

### 1.2 Obsessive-Compulsive and Related Disorders
| Goal | Specifiers / variants |
| --- | --- |
| Obsessive-Compulsive Disorder | insight: good-or-fair / poor / absent-or-delusional; tic-related (yes/no) |
| Body Dysmorphic Disorder | insight (3 levels); with muscle dysmorphia |
| Hoarding Disorder | with excessive acquisition; insight (3 levels) |
| Trichotillomania (Hair-Pulling Disorder) | — |
| Excoriation (Skin-Picking) Disorder | — |
| Substance/Medication-Induced OCRD | (template) |
| OCRD Due to Another Medical Condition | with OC symptoms / appearance preoccupations / hoarding / hair-pulling / skin-picking |

### 1.3 Trauma- and Stressor-Related Disorders
| Goal | Specifiers / variants |
| --- | --- |
| Reactive Attachment Disorder | persistent; severe |
| Disinhibited Social Engagement Disorder | persistent; severe |
| Posttraumatic Stress Disorder (>6 yrs) | with dissociative symptoms; with delayed expression |
| PTSD — children ≤6 yrs (preschool subtype) | with dissociative symptoms; with delayed expression |
| Acute Stress Disorder | — |
| Adjustment Disorders | subtype: depressed mood / anxiety / mixed anxiety-depressed / conduct / mixed emotion-conduct / unspecified; acute / persistent |
| Prolonged Grief Disorder | — |

---

## 2. Delta vs the current (DSM-IV-TR) knowledge base

**Removed / restructured**
- *Panic Disorder With Agoraphobia*, *Panic Disorder Without Agoraphobia*,
  *Agoraphobia Without History of Panic Disorder* → **collapsed** into standalone
  **Panic Disorder** + standalone **Agoraphobia** (decoupled; panic attack becomes
  a specifier).
- *Social phobia generalized / circumscribed* → single **Social Anxiety Disorder**
  + *performance-only* specifier.
- **OCD content-type diagnoses collapsed.** Today PESAD has ~20 OCD diagnoses
  (aggressive, contamination, sexual, religious, order/symmetry, somatic,
  superstitious, perfectionism, miscellaneous, hoarding × poor-insight). DSM-5-TR
  has **one** OCD diagnosis: content is *not* a diagnostic axis. → keep the content
  items only as descriptive obsession/compulsion symptoms (optional, non-diagnostic);
  replace the 2-level insight with the **3-level** insight specifier + tic-related.
- *OCD hoarding type* → promoted to the separate **Hoarding Disorder**.
- *PTSD acute / chronic / acute-delayed / chronic-delayed* (4 variants) → DSM-5-TR
  drops acute/chronic; PTSD restructured into **4 symptom clusters** (B intrusion,
  C avoidance, D negative cognitions/mood, E arousal/reactivity); keep *with delayed
  expression*, add *with dissociative symptoms*, add preschool subtype.
- Specific phobia: drop the *recognizes excessive/unreasonable* symptom; duration
  **≥6 months for all ages** (today it differs by age).

**Added (new disorders)**
Separation Anxiety Disorder, Selective Mutism, Body Dysmorphic Disorder, Hoarding
Disorder, Trichotillomania, Excoriation, Reactive Attachment Disorder, Disinhibited
Social Engagement Disorder, Adjustment Disorders, Prolonged Grief Disorder,
preschool-PTSD subtype.

**Largely unchanged**
Generalized Anxiety Disorder; the substance-induced / due-to-AMC templates;
the certainty-factor engine, the ask protocols and the explanation module (no
engine logic change expected — see §5).

---

## 3. New / changed shared atoms

- **Insight (3 levels):** replace `insight_high / insight_low` with
  `insight_good_or_fair / insight_poor / insight_absent_or_delusional`. Used by OCD,
  BDD, Hoarding (via `multiple_ask`).
- **Panic attack as a specifier:** the panic-attack manifestation (≥4 of 13
  symptoms) stays, but it is referenced as an optional specifier "(with panic
  attacks)" rather than gating a separate diagnosis.
- **Durations / onset:** unify specific/social phobia to ≥6 months all ages; add
  Acute Stress 3 days–1 month; PTSD >1 month; Adjustment within 3 months / ≤6
  months after stressor ends; Prolonged Grief ≥12 months (≥6 months children).
  → revise the `symptoms_duration` / `symptoms_onset` option atoms accordingly.
- **Age groups:** keep child / adolescent / adult; add an explicit **≤6 years
  (preschool)** branch for the PTSD preschool subtype, and ≥18 handling for
  Separation Anxiety (duration 4 weeks <18 vs ~6 months adults).
- **New polythetic criteria (M-of-N) to encode:** PGD C (≥3 of 8), PTSD D (≥2 of
  7) / E (≥2 of 6) / B (≥1 of 5) / C (≥1 of 2), Acute Stress (≥9 of 14),
  Separation Anxiety (≥3 of 8), GAD (≥3 of 6, 1 in children). The existing
  `criterion_ask(Attribute, Items, M, CF)` already supports exactly this — only
  the data changes.

---

## 4. Modeling approach (four inference levels, unchanged shape)

The current 4-level structure maps cleanly onto DSM-5-TR:
1. `disorder/3` — codable diagnosis (goal), combining sub-disorders + specifiers.
2. `disorder_nc/4` + `*_type/4` — the criterion sets / specifiers.
3. `symptomatic_manifestation/4`, `symptomatic_feature/4` — clusters and
   duration/onset/etiology features.
4. `symptom/3` (via `criterion_ask`) and the `multiple_ask` choices — leaf facts.

Each DSM lettered criterion becomes a manifestation or feature; each polythetic
"≥M of N" criterion becomes one `criterion_ask`; each "choose one" criterion
(insight, type, onset) becomes a `multiple_ask`/`selective_ask`. Specifiers either
add antecedents (e.g. dissociative symptoms) or select a type atom.

---

## 5. Engine impact

Minimal. The system is KB-driven: `criterion_ask` (M-of-N), `multiple_ask`,
`selective_ask`, the CF calculus and the proof-tree explanation are generic and
need **no logic change**. The only engine-adjacent edits: the 3-level insight
option list and possibly an extra age branch — both are data, not control flow.

---

## 6. Open design questions for review

1. **OCD content items** — keep the ~10 content families (aggressive, contamination,
   …) as *non-diagnostic descriptive* symptoms in the OCD section, or drop them
   entirely (DSM-5-TR doesn't use them diagnostically)? *Recommendation: keep as
   optional descriptive symptoms so the explanation is richer, but they don't
   change the diagnosis.*
2. **Other Specified / Unspecified** categories (per chapter) — model as low-CF
   fallback goals or omit? *Recommendation: omit as positive goals (they are
   residual categories), mention in docs.*
3. **Preschool PTSD** — separate goal or a branch of PTSD keyed on age ≤6?
   *Recommendation: a `patient = preschool` branch of the PTSD rules (mirrors the
   current child/adolescent/adult branching).*
4. **Adjustment Disorders subtypes** — six separate goals or one goal + subtype
   specifier? *Recommendation: one goal + `multiple_ask` subtype, matching how the
   current code handles phobia/OCD types.*
5. **Rule certainty constants** (the per-rule CF like 0.97/0.98) for the new
   disorders — reuse the existing convention (≈0.95–0.99 by specificity)?

Once these are confirmed, Phase B (KB redesign) can start: rewrite `disorders.pl`
and `criteria.pl`, update `goals_list`, then localization (Phase C), verification
(Phase E) and the LaTeX/README rewrite (Phase F).
