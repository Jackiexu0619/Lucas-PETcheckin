# Module 1 — Textbook Catalog Quality Baseline

Date: 2026-10-24  
Scope: `Complete Preliminary for Schools`, catalog pages P8–P23, 100 exercise groups / 498 item slots.  
Source: read-only query of `public.pet_textbook_catalog_quality_audit`. No learner data changed.

## What this report means

This is a catalog-data quality baseline, not a claim that every issue is an error in the textbook itself. "Missing item text" means an item has no `text` value; some open-ended tasks may legitimately be recorded as a task instruction rather than a list of prompts, but the current catalog does not distinguish those cases clearly. "Review section/task_type mapping" is a heuristic flag that requires checking against the book. "Auto-grading candidate" is metadata eligibility only, not approval to ship automatic scoring.

## Page-by-page baseline

| Page | Exercise groups | Item text missing (item slots) | Groups with missing text | Missing image refs | Missing audio refs | Third-party answer groups not officially verified | Section/type review flags | Metadata grading candidates |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| P8 | 2 | 8 | 2 | 1 | 0 | 0 | 1 | 0 |
| P9 | 6 | 11 | 2 | 1 | 1 | 0 | 1 | 1 |
| P10 | 7 | 19 | 5 | 2 | 0 | 0 | 0 | 0 |
| P11 | 3 | 6 | 2 | 2 | 0 | 0 | 0 | 0 |
| P12 | 8 | 40 | 7 | 0 | 0 | 0 | 0 | 0 |
| P13 | 8 | 14 | 3 | 1 | 0 | 0 | 0 | 0 |
| P14 | 8 | 1 | 1 | 2 | 0 | 0 | 1 | 1 |
| P15 | 5 | 8 | 3 | 1 | 0 | 0 | 0 | 0 |
| P16 | 5 | 0 | 0 | 2 | 0 | 3 | 0 | 0 |
| P17 | 4 | 7 | 3 | 2 | 0 | 1 | 0 | 0 |
| P18 | 5 | 13 | 3 | 1 | 0 | 2 | 0 | 0 |
| P19 | 10 | 12 | 3 | 0 | 0 | 6 | 0 | 0 |
| P20 | 9 | 9 | 7 | 1 | 0 | 2 | 0 | 0 |
| P21 | 6 | 16 | 4 | 3 | 0 | 2 | 1 | 0 |
| P22 | 7 | 15 | 4 | 1 | 0 | 2 | 1 | 0 |
| P23 | 7 | 7 | 5 | 1 | 0 | 0 | 0 | 0 |
| **Total** | **100** | **186** | **54** | **21** | **1** | **18** | **5** | **2** |

Totals for missing-text groups, asset references and answer sources count exercise groups; the 186 figure counts individual item slots.

## Priority findings

### P0 — Confirmed catalog defects or blockers

1. **P12 is the largest content gap:** 40 of 66 item slots have no item text; 7 of 8 exercise groups contain at least one missing-text item. Previously supplied material identifies concrete gaps in Exercises 3, 4, 5, 7 and 8. Do not fill the missing text from guesses; recover the existing source and map each field correctly.
2. **P9 Exercise 2** (`CPS-U1-P9-LISTENINGPART2-E2`) needs audio but has no `audio_ref`. It must not be treated as a complete Listening exercise until the genuine track is mapped.
3. **21 exercise groups need images but have no `image_ref`.** The new columns are intentionally blank until an actual source asset is verified.
4. **18 groups use third-party teacher-book text without official-answer verification.** These answers must not silently become official keys or unlock automatic scoring.

### P1 — Existing source-backed content should be reconciled first

- **P12 E3:** eight reference questions are stored in `answer_key`, while the original jumbled-word prompts are missing from `text`. The answer field is appropriate for reference answers; the defect is missing source prompt text, not a confirmed field swap.
- **P12 E4:** eight partner-question slots exist but lack prompt text. Existing context confirms this exercise follows E3; populate only after confirming the correct source representation.
- **P12 E5:** catalog says two slots; existing context says the task requires six questions (three present-continuous and three present-simple). Record the task structure without pretending newly written scaffolding is verbatim book text.
- **P12 E7/E8:** four and one slots respectively exist, but prompt coverage is incomplete. Existing context describes the four-part family/friend description and follow-up questions; verify exact scope before editing.
- **P14 E2:** preserve the home/room description, furniture and spatial-layout requirements, not just a one-line summary.
- **P14 E7:** the catalog references Track 03 as a `.lis` file with browser compatibility unverified. A track label is not proof that audio playback works.
- **P13 E3/E5:** prior context identifies concrete free-time/quantifier practice and a task listing three countable plus three uncountable kitchen items. Reconcile those with the existing two-slot and six-slot records.

### P2 — Mapping and scoring discipline

- Five section/task-type pairs are flagged by a heuristic for manual review; do not batch-change labels until the printed book confirms the intended skill.
- Only two groups meet the current conservative metadata criteria for automatic-scoring candidates. Both still require real source and browser validation. This is not a release authorization.
- Open-ended Speaking/Writing should use task instructions and a suitable rubric, not a fabricated single answer.
- A complete item record must separate prompt text, answer key, source verification, required media and scoring mode.

## Change policy

1. Use source-backed corrections only.
2. Preserve existing parent results and historical records.
3. Prefer additive, reversible catalog-only changes; no bulk rewrite of `items` JSON.
4. Re-run the audit view after each correction and compare counts.
5. Update `docs/DEVELOPMENT_PROGRESS.md` after each completed subtask, with evidence and one next action.

## Next implementation slice

Start with P12, because it has the highest confirmed gap and previously supplied source context. Build a field-by-field correction plan for E3/E4/E5/E7/E8, distinguishing exact source text from parent-provided task summaries. Correct only fields supported by those sources; leave remaining unknowns explicitly unresolved. Then re-run the view and regression-check existing learner records.
