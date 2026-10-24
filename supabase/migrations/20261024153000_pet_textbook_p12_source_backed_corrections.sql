-- Module 1: source-backed P12 catalog corrections only.
-- Does not alter parent_entries, learner attempts, vocabulary state, or snapshots.

-- E3: clarify that answer_key values are reference answers to missing printed prompts.
UPDATE public.pet_textbook_exercises
SET directions = 'Form the questions from the prompts in the printed book. The stored answer_key values are reference answers; the original jumbled prompts still need source transcription.',
    source_note = coalesce(source_note, '') || ' | Module 1 clarification: answer_key contains the reference questions, not the original jumbled prompts; do not treat it as a transcription of the prompt text.'
WHERE id = 'CPS-U1-P12-GRAMMARPRESENTSIMPLEANDCONTINUOUS-E3';

-- E4: the eight question prompts are already present in the parent-provided P12/E3 source notes.
UPDATE public.pet_textbook_exercises
SET directions = 'Ask a partner the eight questions from Exercise 3. These prompts are reconstructed from the existing parent-provided P12 material; check the printed page for layout.',
    items = jsonb_build_array(
      jsonb_build_object('no',1,'source','parent-provided P12 source notes','text','What does ''habit'' mean?','skill_tag','question_forms','verified_text',true),
      jsonb_build_object('no',2,'source','parent-provided P12 source notes','text','Does the school bus stop in your street?','skill_tag','question_forms','verified_text',true),
      jsonb_build_object('no',3,'source','parent-provided P12 source notes','text','Who watches the most TV in your house?','skill_tag','question_forms','verified_text',true),
      jsonb_build_object('no',4,'source','parent-provided P12 source notes','text','Do you prefer to get up early or late?','skill_tag','question_forms','verified_text',true),
      jsonb_build_object('no',5,'source','parent-provided P12 source notes','text','Is everyone talking to their partners at the moment?','skill_tag','question_forms','verified_text',true),
      jsonb_build_object('no',6,'source','parent-provided P12 source notes','text','What colour clothes are you wearing today?','skill_tag','question_forms','verified_text',true),
      jsonb_build_object('no',7,'source','parent-provided P12 source notes','text','Who is sitting behind us in this lesson?','skill_tag','question_forms','verified_text',true),
      jsonb_build_object('no',8,'source','parent-provided P12 source notes','text','What do you sometimes forget to do in the morning?','skill_tag','question_forms','verified_text',true)
    ),
    item_count = 8,
    answer_status = 'open_ended',
    source_note = coalesce(source_note, '') || ' | Module 1: eight prompts restored from existing parent-provided P12/E3 question list; retain manual review for speaking responses.'
WHERE id = 'CPS-U1-P12-GRAMMARPRESENTSIMPLEANDCONTINUOUS-E4';

-- E5: correct the known task size (six learner-generated questions) without inventing verbatim textbook prompts.
UPDATE public.pet_textbook_exercises
SET directions = 'Create six interview questions: three using the present continuous (current activities/feelings) and three using the present simple (habits/preferences). This is a parent-provided task summary, not a verbatim transcription.',
    items = jsonb_build_array(
      jsonb_build_object('no',1,'source','parent-provided task structure; not verbatim','skill_tag','present_continuous_question','verified_text',false),
      jsonb_build_object('no',2,'source','parent-provided task structure; not verbatim','skill_tag','present_continuous_question','verified_text',false),
      jsonb_build_object('no',3,'source','parent-provided task structure; not verbatim','skill_tag','present_continuous_question','verified_text',false),
      jsonb_build_object('no',4,'source','parent-provided task structure; not verbatim','skill_tag','present_simple_question','verified_text',false),
      jsonb_build_object('no',5,'source','parent-provided task structure; not verbatim','skill_tag','present_simple_question','verified_text',false),
      jsonb_build_object('no',6,'source','parent-provided task structure; not verbatim','skill_tag','present_simple_question','verified_text',false)
    ),
    item_count = 6,
    answer_status = 'open_ended',
    source_note = coalesce(source_note, '') || ' | Module 1: six response slots reflect parent-provided task structure; prompt wording is not claimed to be verbatim.'
WHERE id = 'CPS-U1-P12-GRAMMARPRESENTSIMPLEANDCONTINUOUS-E5';

-- E7: preserve the four-part description structure without inventing original wording.
UPDATE public.pet_textbook_exercises
SET directions = 'Describe a family member or friend in four parts: where they live; what they usually do; what they are doing now; and a reasonable guess about what they may be doing now. Parent-provided task summary, not verbatim textbook wording.',
    answer_status = 'open_ended',
    source_note = coalesce(source_note, '') || ' | Module 1: four-part task scope recovered from prior parent-provided notes; exact printed wording remains to be visually checked.'
WHERE id = 'CPS-U1-P12-SPEAKINGPRACTICE-E7';

-- E8: retain an open-ended follow-up task; do not invent an exact question count.
UPDATE public.pet_textbook_exercises
SET directions = 'Ask follow-up questions about the family member or friend introduced in Exercise 7. The exact original follow-up list and question count have not been recovered; use the printed book as authority.',
    answer_status = 'open_ended',
    source_note = coalesce(source_note, '') || ' | Module 1: follow-up task scope recovered from prior parent-provided notes; exact prompt list remains unverified.'
WHERE id = 'CPS-U1-P12-SPEAKINGPRACTICE-E8';
