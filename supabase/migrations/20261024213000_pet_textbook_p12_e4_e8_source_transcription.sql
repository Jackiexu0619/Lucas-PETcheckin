-- Module 1: reconcile P12 E4-E8 against the Student's Book printed page.
-- Source: Complete Preliminary for Schools Student's Book without Answers with Online Practice,
-- ISBN 9781108539050, Unit 1, printed p.12. Open-ended speaking stays manual-review.
-- No learner records, mastery state, or review scheduling are changed.

UPDATE public.pet_textbook_exercises
SET directions = 'Work in pairs. Ask and answer the questions from Exercise 3.',
    items = jsonb_build_array(
      jsonb_build_object('no',1,'text','What does ''habit'' mean?','source','Student’s Book p.12, Exercise 3 answer used in Exercise 4','skill_tag','question_forms','verified_text',true),
      jsonb_build_object('no',2,'text','Does the school bus stop in your street?','source','Student’s Book p.12, Exercise 3 answer used in Exercise 4','skill_tag','question_forms','verified_text',true),
      jsonb_build_object('no',3,'text','Who watches the most TV in your house?','source','Student’s Book p.12, Exercise 3 answer used in Exercise 4','skill_tag','question_forms','verified_text',true),
      jsonb_build_object('no',4,'text','Do you prefer to get up early or late?','source','Student’s Book p.12, Exercise 3 answer used in Exercise 4','skill_tag','question_forms','verified_text',true),
      jsonb_build_object('no',5,'text','Is everyone talking to their partners at the moment?','source','Student’s Book p.12, Exercise 3 answer used in Exercise 4','skill_tag','question_forms','verified_text',true),
      jsonb_build_object('no',6,'text','What colour clothes are you wearing today?','source','Student’s Book p.12, Exercise 3 answer used in Exercise 4','skill_tag','question_forms','verified_text',true),
      jsonb_build_object('no',7,'text','Who is sitting behind us in this lesson?','source','Student’s Book p.12, Exercise 3 answer used in Exercise 4','skill_tag','question_forms','verified_text',true),
      jsonb_build_object('no',8,'text','What do you sometimes forget to do in the morning?','source','Student’s Book p.12, Exercise 3 answer used in Exercise 4','skill_tag','question_forms','verified_text',true)
    ),
    item_count = 8,
    transcription_status = 'fully_transcribed',
    answer_status = 'open_ended',
    source_note = coalesce(source_note, '') || ' | Module 1 source reconciliation: task instruction checked against Student’s Book ISBN 9781108539050, p.12; prompts reuse the verified Exercise 3 answer questions. Speaking responses remain manual review.'
WHERE id = 'CPS-U1-P12-GRAMMARPRESENTSIMPLEANDCONTINUOUS-E4';

UPDATE public.pet_textbook_exercises
SET directions = 'Do the task below. Use the present continuous to write three questions about what your partner is doing, thinking or feeling now, e.g. Are you feeling good? Use the present simple to write three questions about what your partner likes, wants or prefers, e.g. Do you prefer weekdays or weekends? Ask and answer the questions.',
    items = jsonb_build_array(
      jsonb_build_object('no',1,'source','Response slot structured from printed task directions; not a verbatim question','skill_tag','present_continuous_question','verified_text',false),
      jsonb_build_object('no',2,'source','Response slot structured from printed task directions; not a verbatim question','skill_tag','present_continuous_question','verified_text',false),
      jsonb_build_object('no',3,'source','Response slot structured from printed task directions; not a verbatim question','skill_tag','present_continuous_question','verified_text',false),
      jsonb_build_object('no',4,'source','Response slot structured from printed task directions; not a verbatim question','skill_tag','present_simple_question','verified_text',false),
      jsonb_build_object('no',5,'source','Response slot structured from printed task directions; not a verbatim question','skill_tag','present_simple_question','verified_text',false),
      jsonb_build_object('no',6,'source','Response slot structured from printed task directions; not a verbatim question','skill_tag','present_simple_question','verified_text',false)
    ),
    item_count = 6,
    transcription_status = 'fully_transcribed',
    answer_status = 'open_ended',
    source_note = coalesce(source_note, '') || ' | Module 1 source transcription: task directions and examples checked against Student’s Book ISBN 9781108539050, p.12. Six slots are learner-generated questions, not fixed printed questions; do not auto-score.'
WHERE id = 'CPS-U1-P12-GRAMMARPRESENTSIMPLEANDCONTINUOUS-E5';

UPDATE public.pet_textbook_exercises
SET transcription_status = 'fully_transcribed',
    source_note = coalesce(source_note, '') || ' | Module 1 source check: 26-word list checked against Student’s Book ISBN 9781108539050, p.12.'
WHERE id = 'CPS-U1-P12-PRONUNCIATIONSZZ-E6';

UPDATE public.pet_textbook_exercises
SET directions = 'Work in pairs. Think of a friend or family member. Tell your partner these things about them.',
    items = jsonb_build_array(
      jsonb_build_object('no',1,'text','Facts, e.g. She lives in …, she belongs to …','source','Student’s Book p.12, Exercise 7','skill_tag','personal_facts','verified_text',true),
      jsonb_build_object('no',2,'text','Things he or she often does, e.g. He often plays … every day.','source','Student’s Book p.12, Exercise 7','skill_tag','habits','verified_text',true),
      jsonb_build_object('no',3,'text','Something your friend is doing around now, e.g. She’s learning Spanish.','source','Student’s Book p.12, Exercise 7','skill_tag','present_continuous_around_now','verified_text',true),
      jsonb_build_object('no',4,'text','What you think your friend is doing right now, e.g. He’s walking home.','source','Student’s Book p.12, Exercise 7','skill_tag','present_continuous_inference','verified_text',true)
    ),
    item_count = 4,
    transcription_status = 'fully_transcribed',
    answer_status = 'open_ended',
    source_note = coalesce(source_note, '') || ' | Module 1 source transcription: four speaking prompts and examples checked against Student’s Book ISBN 9781108539050, p.12; responses require a speaking rubric, not a unique answer key.'
WHERE id = 'CPS-U1-P12-SPEAKINGPRACTICE-E7';

UPDATE public.pet_textbook_exercises
SET directions = 'Now ask your partner more questions about the friend or family member.',
    items = jsonb_build_array(
      jsonb_build_object('no',1,'text','Where does she go to school?','source','Student’s Book p.12, Exercise 8 example','skill_tag','follow_up_question','verified_text',true),
      jsonb_build_object('no',2,'text','Is he doing English lessons this year?','source','Student’s Book p.12, Exercise 8 example','skill_tag','follow_up_question','verified_text',true)
    ),
    item_count = 2,
    transcription_status = 'fully_transcribed',
    answer_status = 'open_ended',
    source_note = coalesce(source_note, '') || ' | Module 1 source transcription: two printed follow-up question examples checked against Student’s Book ISBN 9781108539050, p.12; learners should also ask additional relevant questions.'
WHERE id = 'CPS-U1-P12-SPEAKINGPRACTICE-E8';
