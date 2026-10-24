-- Module 1: distinguish an audio track label from a real playable asset reference.
CREATE OR REPLACE VIEW public.pet_textbook_catalog_quality_audit
WITH (security_invoker = true)
AS
WITH item_stats AS (
  SELECT e.id,
    count(i.item) AS actual_item_count,
    count(*) FILTER (WHERE nullif(btrim(coalesce(i.item->>'text', '')), '') IS NOT NULL AND coalesce((i.item->>'verified_text')::boolean, false)) AS verified_text_count,
    count(*) FILTER (WHERE nullif(btrim(coalesce(i.item->>'text', '')), '') IS NULL) AS missing_text_count,
    count(*) FILTER (WHERE nullif(btrim(coalesce(i.item->>'text', '')), '') IS NOT NULL AND NOT coalesce((i.item->>'verified_text')::boolean, false)) AS unverified_text_count,
    count(*) FILTER (WHERE e.task_type IN ('grammar_choice','reading_mcq','listening_mcq','vocabulary_choice','grammar_gap','vocabulary_gap','reading_gap','listening_gap','grammar_rewrite','grammar_order_matching','grammar_dialogue_gap','grammar_matching','reading_photo_matching','grammar_correction','grammar_table','listening_note','vocabulary_grammar','past_form_pronunciation_sort') AND nullif(btrim(coalesce(i.item->>'answer_key', '')), '') IS NULL) AS missing_answer_count
  FROM public.pet_textbook_exercises e
  LEFT JOIN LATERAL jsonb_array_elements(e.items) AS i(item) ON true
  GROUP BY e.id
)
SELECT e.id,e.book_code,e.unit_no,e.printed_page,e.pdf_page,e.section,e.exercise_no,e.title,e.task_type,e.item_count,
 s.actual_item_count,s.verified_text_count,s.missing_text_count,s.unverified_text_count,s.missing_answer_count,
 e.needs_image,e.image_ref,e.image_alt,e.needs_audio,e.audio_ref,e.audio_asset_ref,e.audio_mime_type,
 e.transcription_status,e.answer_status,e.answer_source,e.answer_officially_verified,e.grading_mode,
 array_remove(ARRAY[
 CASE WHEN e.item_count <> s.actual_item_count THEN 'item_count_mismatch' END,
 CASE WHEN s.missing_text_count > 0 AND e.task_type IN ('grammar_choice','reading_mcq','listening_mcq','vocabulary_choice','grammar_gap','vocabulary_gap','reading_gap','listening_gap','grammar_rewrite','grammar_order_matching','grammar_dialogue_gap','grammar_matching','vocabulary_matching','reading_photo_matching','grammar_correction','grammar_table','listening_note','vocabulary_grammar','past_form_pronunciation_sort','speaking_gap','speaking_matching','speaking_order') THEN 'missing_item_text' END,
 CASE WHEN s.missing_text_count > 0 AND e.task_type NOT IN ('grammar_choice','reading_mcq','listening_mcq','vocabulary_choice','grammar_gap','vocabulary_gap','reading_gap','listening_gap','grammar_rewrite','grammar_order_matching','grammar_dialogue_gap','grammar_matching','vocabulary_matching','reading_photo_matching','grammar_correction','grammar_table','listening_note','vocabulary_grammar','past_form_pronunciation_sort','speaking_gap','speaking_matching','speaking_order') AND nullif(btrim(coalesce(e.directions,'')), '') IS NULL THEN 'missing_exercise_directions' END,
 CASE WHEN s.unverified_text_count > 0 THEN 'item_text_not_source_verified' END,
 CASE WHEN s.missing_answer_count > 0 THEN 'missing_answer_key_for_objective_item' END,
 CASE WHEN e.needs_image AND nullif(btrim(coalesce(e.image_ref, '')), '') IS NULL THEN 'missing_image_reference' END,
 CASE WHEN e.needs_audio AND nullif(btrim(coalesce(e.audio_ref, '')), '') IS NULL THEN 'missing_audio_reference' END,
 CASE WHEN e.needs_audio AND nullif(btrim(coalesce(e.audio_asset_ref, '')), '') IS NULL THEN 'missing_audio_asset_reference' END,
 CASE WHEN e.answer_source = 'teacher_book_third_party_text' AND NOT e.answer_officially_verified THEN 'third_party_answer_source_not_officially_verified' END,
 CASE WHEN (e.task_type ILIKE '%speaking%' AND coalesce(e.section, '') ILIKE '%Listening%') OR (e.task_type ILIKE '%listening%' AND coalesce(e.section, '') ILIKE '%Speaking%') THEN 'review_task_type_section_mapping' END
 ]::text[],NULL) AS issue_codes,
 (e.answer_officially_verified AND e.grading_mode IN ('exact_option','acceptable_variants')
  AND e.task_type NOT ILIKE '%speaking%' AND e.task_type NOT ILIKE '%writing%' AND e.task_type NOT ILIKE '%listening%'
  AND e.item_count > 0 AND e.item_count = s.actual_item_count AND s.verified_text_count = e.item_count
  AND s.missing_text_count = 0 AND s.unverified_text_count = 0 AND s.missing_answer_count = 0
  AND (NOT e.needs_image OR nullif(btrim(coalesce(e.image_ref, '')), '') IS NOT NULL)
  AND (NOT e.needs_audio OR (nullif(btrim(coalesce(e.audio_ref, '')), '') IS NOT NULL AND nullif(btrim(coalesce(e.audio_asset_ref, '')), '') IS NOT NULL))
 ) AS auto_grading_candidate
FROM public.pet_textbook_exercises e JOIN item_stats s ON s.id=e.id;

COMMENT ON VIEW public.pet_textbook_catalog_quality_audit IS
 'Read-only Module 1 quality gate. Distinguishes track labels from actual audio asset references. Missing audio assets are flagged separately. auto_grading_candidate is metadata eligibility only, not proof of browser playback or pedagogical validation.';
REVOKE ALL ON public.pet_textbook_catalog_quality_audit FROM PUBLIC, anon, authenticated;
GRANT SELECT ON public.pet_textbook_catalog_quality_audit TO service_role;
