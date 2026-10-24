# Module 1 — Textbook Catalog Quality Baseline

Date: 2026-10-24  
Scope: `Complete Preliminary for Schools`, catalog pages P8–P23, 100 exercise groups / 498 item slots.  
Source: read-only query of `public.pet_textbook_catalog_quality_audit`. No learner data changed.

## What this report means

This is a catalog-data quality baseline, not a claim that every issue is an error in the textbook itself. "Item text missing" is a raw field count, not automatically a defect: the quality view now distinguishes structured tasks that require item prompts from open-ended tasks that can be represented by exercise-level directions. "Review section/task_type mapping" is a heuristic flag that requires checking against the book. "Auto-grading candidate" is metadata eligibility only, not approval to ship automatic scoring.

## Page-by-page baseline

| Page | Exercise groups | Item text missing (item slots) | Groups with missing text | Missing image refs | Missing track labels | Missing playable audio assets | Third-party answer groups not officially verified | Section/type review flags | Metadata grading candidates |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| P8 | 2 | 8 | 2 | 1 | 0 | 0 | 0 | 1 | 0 |
| P9 | 6 | 11 | 2 | 1 | 1 | 2 | 0 | 1 | 1 |
| P10 | 7 | 19 | 5 | 2 | 0 | 0 | 0 | 0 | 0 |
| P11 | 3 | 6 | 2 | 2 | 0 | 0 | 0 | 0 | 0 |
| P12 | 8 | 11 | 3 | 0 | 0 | 0 | 0 | 0 | 2 |
| P13 | 8 | 14 | 3 | 1 | 0 | 0 | 0 | 0 | 0 |
| P14 | 8 | 1 | 1 | 2 | 0 | 1 | 0 | 1 | 1 |
| P15 | 5 | 8 | 3 | 1 | 0 | 0 | 0 | 0 | 0 |
| P16 | 5 | 0 | 0 | 2 | 0 | 0 | 3 | 0 | 0 |
| P17 | 4 | 7 | 3 | 2 | 0 | 0 | 1 | 0 | 0 |
| P18 | 5 | 13 | 3 | 1 | 0 | 0 | 2 | 0 | 0 |
| P19 | 10 | 12 | 3 | 0 | 0 | 4 | 6 | 0 | 0 |
| P20 | 9 | 9 | 7 | 1 | 0 | 3 | 2 | 0 | 0 |
| P21 | 6 | 16 | 4 | 3 | 0 | 1 | 2 | 1 | 0 |
| P22 | 7 | 15 | 4 | 1 | 0 | 2 | 2 | 1 | 0 |
| P23 | 7 | 7 | 5 | 1 | 0 | 0 | 0 | 0 | 0 |
| **Total** | **100** | **157** | **50** | **21** | **1** | **13** | **18** | **5** | **4** |

Totals for missing-text groups, asset references and answer sources count exercise groups; the 157 figure counts individual item slots.

## Priority findings

### P0 — Confirmed catalog defects or blockers

1. **P12 E1–E3 are now transcribed from the Student’s Book source:** 25 structured item prompts were restored and verified (5 + 12 + 8). The remaining 11 empty item slots are intentional response slots for open-ended E5/E7/E8, not missing fixed questions. E4/E5/E7/E8 still need exact source reconciliation; the current directions for those tasks are summaries pending that pass.
2. **All 13 exercises marked `needs_audio` lack a playable `audio_asset_ref`.** P9 Exercise 2 (`CPS-U1-P9-LISTENINGPART2-E2`) also lacks a track label (`audio_ref`). The Supabase project currently has no storage buckets or audio objects. Track names such as Track 02/03 are labels, not playable files; P14 Track 03 is explicitly noted as `.lis` with browser compatibility unverified.
3. **21 exercise groups need images but have no `image_ref`.** The new columns are intentionally blank until an actual source asset is verified.
4. **18 groups use third-party teacher-book text without official-answer verification.** These answers must not silently become official keys or unlock automatic scoring.

### P1 — Existing source-backed content should be reconciled first

- **P12 E3:** eight reference questions are stored in `answer_key`, while the original jumbled-word prompts are missing from `text`. The answer field is appropriate for reference answers; the defect is missing source prompt text, not a confirmed field swap.
- **P12 E4:** the eight partner questions have now been restored from existing parent-provided P12/E3 notes and are retained as open-ended speaking prompts.
- **P12 E5:** corrected from two to six response slots (three present-continuous and three present-simple). The directions explicitly state that this is a task summary, not verbatim book text.
- **P12 E7/E8:** task directions have been restored from prior notes; E8's exact original follow-up list/count remains unverified.
- **P14 E2:** preserve the home/room description, furniture and spatial-layout requirements, not just a one-line summary.
- **P14 E7:** the catalog references Track 03 as a `.lis` file with browser compatibility unverified. A track label is not proof that audio playback works.
- **P13 E3/E5:** task directions have been restored from prior notes. E3 targets home/free-time/TV-games/time expressions and quantifiers; E5 requires three countable and three uncountable kitchen items with explanations. Both remain open-ended/manual review.

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


## Audio asset distinction (2026-10-24)

The catalog previously used `audio_ref` for labels such as `Track 02`; that is not proof a playable file exists. New nullable fields `audio_asset_ref` and `audio_mime_type` separate the real file reference and verified MIME type from the printed track label. The audit now flags both missing track labels and missing playable assets. Current evidence: 13 exercises require audio, all 13 lack a playable asset reference, and the Supabase project has zero storage buckets/objects for the queried audio patterns. No audio file has been fabricated or linked by guesswork.

The current audit issue-code counts are: 6 structured exercise groups missing item prompts; 27 non-structured groups missing exercise directions; 21 groups missing image references; 1 group missing a track label; 13 groups missing playable audio assets; 18 third-party answer-source groups not officially verified; 5 section/task-type mapping flags; 1 structured task missing an answer key; and 2 groups with text that has not passed source verification.
