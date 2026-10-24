-- Module 1: transcribe the P9 Listening Part 2 task and answer options from source.
-- Student's Book ISBN 9781108539050, printed p.9; answer mapping checked against Cambridge Teacher's Book ISBN 9788490362181.
-- Track label is metadata only; no playable audio asset is fabricated or added.

UPDATE public.pet_textbook_exercises
SET directions = 'Who will you hear? What is the situation in each conversation?',
    items = jsonb_build_array(
      jsonb_build_object('no',1,'text','You will hear two friends talking about the kind of flat they would like to live in.','skill_tag','listening_prediction','answer_key','Two friends discuss a flat they would like to live in.','explanation','Suggested prediction from the Teacher’s Book; other reasonable predictions are acceptable.','source','Student’s Book p.9 / Teacher’s Book Unit 1','verified_text',true),
      jsonb_build_object('no',2,'text','You will hear a boy telling his friend about changing school.','skill_tag','listening_prediction','answer_key','A boy tells his friend about changing school.','explanation','Suggested prediction from the Teacher’s Book; other reasonable predictions are acceptable.','source','Student’s Book p.9 / Teacher’s Book Unit 1','verified_text',true),
      jsonb_build_object('no',3,'text','You will hear a girl talking about a trip to the beach.','skill_tag','listening_prediction','answer_key','A girl talks about a day trip to the beach.','explanation','Suggested prediction from the Teacher’s Book; other reasonable predictions are acceptable.','source','Student’s Book p.9 / Teacher’s Book Unit 1','verified_text',true),
      jsonb_build_object('no',4,'text','You will hear two friends talking about the town where they live.','skill_tag','listening_prediction','answer_key','Two friends talk about the town where they live.','explanation','Suggested prediction from the Teacher’s Book; other reasonable predictions are acceptable.','source','Student’s Book p.9 / Teacher’s Book Unit 1','verified_text',true),
      jsonb_build_object('no',5,'text','You will hear a boy talking to a friend about a shop.','skill_tag','listening_prediction','answer_key','A boy talks to a friend about a shop.','explanation','Suggested prediction from the Teacher’s Book; other reasonable predictions are acceptable.','source','Student’s Book p.9 / Teacher’s Book Unit 1','verified_text',true),
      jsonb_build_object('no',6,'text','You will hear two friends talking about their homes.','skill_tag','listening_prediction','answer_key','Two friends talk about their homes.','explanation','Suggested prediction from the Teacher’s Book; other reasonable predictions are acceptable.','source','Student’s Book p.9 / Teacher’s Book Unit 1','verified_text',true)
    ),
    item_count = 6,
    audio_ref = 'Track 02',
    transcription_status = 'fully_transcribed',
    source_note = coalesce(source_note, '') || ' | Module 1 source transcription: P9 Listening Part 2 pre-listening prompts checked against Student’s Book ISBN 9781108539050 and Teacher’s Book excerpt ISBN 9788490362181. Track 02 is a track label only; playable audio asset is still missing.'
WHERE id = 'CPS-U1-P9-LISTENINGPART2-E2';

UPDATE public.pet_textbook_exercises
SET directions = 'For each question, choose the correct answer. Listen to Track 02 again and check your answers.',
    items = jsonb_build_array(
      jsonb_build_object('no',1,'text','You will hear two friends talking about the kind of flat they would like to live in. They agree that it should: A be on one of the higher floors; B have at least three bedrooms; C be close to public transport.','skill_tag','listening_part2','answer_key','C','explanation','The speakers agree that the flat should be close to public transport.','source','Student’s Book ISBN 9781108539050, p.9','verified_text',true),
      jsonb_build_object('no',2,'text','You will hear a boy telling his friend about changing school. What does he say about it? A He finds the lessons hard. B He still misses his old school friends. C He thinks his new classmates are unfriendly.','skill_tag','listening_part2','answer_key','B','explanation','He still misses his old school friends.','source','Student’s Book ISBN 9781108539050, p.9','verified_text',true),
      jsonb_build_object('no',3,'text','You will hear a girl talking about a trip to the beach. What did she like best about it? A swimming in the sea; B going on a free boat trip; C playing volleyball.','skill_tag','listening_part2','answer_key','C','explanation','She liked playing volleyball best.','source','Student’s Book ISBN 9781108539050, p.9','verified_text',true),
      jsonb_build_object('no',4,'text','You will hear two friends talking about the town where they live. They agree that: A there is too much traffic; B some parts of it are dangerous; C it is smaller than they would like.','skill_tag','listening_part2','answer_key','A','explanation','They agree there is too much traffic.','source','Student’s Book ISBN 9781108539050, p.9','verified_text',true),
      jsonb_build_object('no',5,'text','You will hear a boy talking to a friend about a shop. What does the boy think about the shop? A There are not enough assistants. B The prices there are reasonable. C It sells a wide variety of items.','skill_tag','listening_part2','answer_key','A','explanation','The boy thinks there are not enough assistants.','source','Student’s Book ISBN 9781108539050, p.9','verified_text',true),
      jsonb_build_object('no',6,'text','You will hear two friends talking about their homes. The girl says her room would be better if: A it was quieter; B it was a lot bigger; C it was sometimes warmer.','skill_tag','listening_part2','answer_key','C','explanation','She would like her room to be sometimes warmer.','source','Student’s Book ISBN 9781108539050, p.9','verified_text',true)
    ),
    item_count = 6,
    audio_ref = 'Track 02',
    transcription_status = 'fully_transcribed',
    source_note = coalesce(source_note, '') || ' | Module 1 source transcription: all six Listening Part 2 questions/options checked against Student’s Book ISBN 9781108539050, p.9; answers cross-checked with Cambridge Teacher’s Book excerpt ISBN 9788490362181. Track 02 is not a playable asset reference.'
WHERE id = 'CPS-U1-P9-LISTENINGPART2-E3';
