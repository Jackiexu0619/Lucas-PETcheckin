-- Module 1: transcribe P12 E1-E3 from the Student's Book source.
-- Source: Complete Preliminary for Schools Student's Book without Answers with Online Practice,
-- ISBN 9781108539050, Unit 1, printed page 12. Cross-check answers with the Cambridge Teacher's Book excerpt
-- ISBN 9788490362181. Catalog-only changes; no learner attempts or mastery records are touched.

UPDATE public.pet_textbook_exercises
SET directions = 'Match the extracts from the article (1–5) with the uses of the present simple and present continuous (a–e). Uses: (a) something that happens regularly; (b) something in progress, but not at the present moment; (c) verbs not normally used in the continuous; (d) something happening at the present moment; (e) something that is generally true.',
    items = jsonb_build_array(
      jsonb_build_object('no',1,'text','Most teenagers live in flats or houses.','skill_tag','present_simple_continuous','answer_key','e','explanation','一般真理','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',2,'text','Sonia Ruiz is waking up somewhere.','skill_tag','present_simple_continuous','answer_key','d','explanation','眼前正在发生','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',3,'text','She regularly sees whales.','skill_tag','present_simple_continuous','answer_key','a','explanation','习惯动作','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',4,'text','Her studies are going well.','skill_tag','present_simple_continuous','answer_key','b','explanation','阶段性持续变化','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',5,'text','Sonia loves her boat.','skill_tag','present_simple_continuous','answer_key','c','explanation','状态动词通常不用进行时','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true)
    ),
    item_count = 5,
    transcription_status = 'fully_transcribed',
    source_note = coalesce(source_note, '') || ' | Module 1 source transcription: student-book printed p.12, ISBN 9781108539050; answer mapping cross-checked with Cambridge Teacher’s Book excerpt ISBN 9788490362181.'
WHERE id = 'CPS-U1-P12-GRAMMARPRESENTSIMPLEANDCONTINUOUS-E1';

UPDATE public.pet_textbook_exercises
SET directions = 'Complete Molly’s email with the present simple or present continuous form of the verbs in brackets.',
    items = jsonb_build_array(
      jsonb_build_object('no',1,'text','Hi David, I (1) (write) to you from our hotel, right next to the sea!','skill_tag','present_simple_continuous','answer_key','am writing','explanation','正在写这封邮件','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',2,'text','I (2) (sit) in my bedroom right now','skill_tag','present_simple_continuous','answer_key','am sitting','explanation','现在正在坐着','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',3,'text','which (3) (have) a big window','skill_tag','present_simple_continuous','answer_key','has','explanation','have 表示拥有，不使用进行时','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',4,'text','and I (4) (look) out across the waves at a little island.','skill_tag','present_simple_continuous','answer_key','am looking','explanation','当前正在向外看','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',5,'text','I (5) (love) it here','skill_tag','present_simple_continuous','answer_key','love','explanation','love 为状态动词','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',6,'text','and in the evening I sometimes (6) (stay) here and watch the sun go down.','skill_tag','present_simple_continuous','answer_key','stay','explanation','sometimes 表示习惯','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',7,'text','Every day, we (7) (go) for a walk along the cliffs.','skill_tag','present_simple_continuous','answer_key','go','explanation','every day 表示习惯','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',8,'text','The weather (8) (get) hotter every day.','skill_tag','present_simple_continuous','answer_key','is getting','explanation','天气持续变化','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',9,'text','But we always (9) (leave) the house early in the morning','skill_tag','present_simple_continuous','answer_key','leave','explanation','always 表示习惯','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',10,'text','while that cool wind from out at sea (10) (blow).','skill_tag','present_simple_continuous','answer_key','is blowing','explanation','描述每天早晨离家时正在吹的风','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',11,'text','I (11) (have) a really good time here','skill_tag','present_simple_continuous','answer_key','am having','explanation','当前正玩得开心','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',12,'text','and I (12) (not want) to go home! Bye for now, Molly','skill_tag','present_simple_continuous','answer_key','don''t want','explanation','want 是状态动词','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true)
    ),
    item_count = 12,
    transcription_status = 'fully_transcribed',
    source_note = coalesce(source_note, '') || ' | Module 1 source transcription: Molly’s full email gaps transcribed into item-level context from Student’s Book printed p.12, ISBN 9781108539050; answer forms cross-checked with Cambridge Teacher’s Book excerpt ISBN 9788490362181.'
WHERE id = 'CPS-U1-P12-GRAMMARPRESENTSIMPLEANDCONTINUOUS-E2';

UPDATE public.pet_textbook_exercises
SET directions = 'Make questions using the present simple or the present continuous. Add or change words if necessary.',
    items = jsonb_build_array(
      jsonb_build_object('no',1,'text','what / ‘habit’ / mean?','skill_tag','question_forms','answer_key','What does ''habit'' mean?','explanation','does + mean','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',2,'text','the school bus / stop / in your street?','skill_tag','question_forms','answer_key','Does the school bus stop in your street?','explanation','Does + 单数主语 + 动词原形','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',3,'text','who / watches / the most / TV / in your house?','skill_tag','question_forms','answer_key','Who watches the most TV in your house?','explanation','who 为主语时用 watches','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',4,'text','you / prefer / to get up / early or late?','skill_tag','question_forms','answer_key','Do you prefer to get up early or late?','explanation','Do + you + 动词原形','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',5,'text','everyone / talk / to / their partners / at the moment?','skill_tag','question_forms','answer_key','Is everyone talking to their partners at the moment?','explanation','at the moment 表示进行时','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',6,'text','what colour clothes / you / wear / today?','skill_tag','question_forms','answer_key','What colour clothes are you wearing today?','explanation','today 当前衣着，用现在进行时','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',7,'text','who / sit / behind / us / in this lesson?','skill_tag','question_forms','answer_key','Who is sitting behind us in this lesson?','explanation','正在坐在后面，用现在进行时','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true),
      jsonb_build_object('no',8,'text','what / you / sometimes / forget / to do / in the morning?','skill_tag','question_forms','answer_key','What do you sometimes forget to do in the morning?','explanation','sometimes 习惯用一般现在时','source','Complete Preliminary for Schools Student’s Book, p.12','verified_text',true)
    ),
    item_count = 8,
    transcription_status = 'fully_transcribed',
    source_note = coalesce(source_note, '') || ' | Module 1 source transcription: all eight word-order prompts transcribed from Student’s Book printed p.12, ISBN 9781108539050; answer questions cross-checked with Cambridge Teacher’s Book excerpt ISBN 9788490362181.'
WHERE id = 'CPS-U1-P12-GRAMMARPRESENTSIMPLEANDCONTINUOUS-E3';
