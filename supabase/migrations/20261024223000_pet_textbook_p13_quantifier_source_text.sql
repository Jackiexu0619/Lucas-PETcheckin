-- Module 1: transcribe P13 Grammar Quantifiers Exercise 2 from the Student's Book.
-- Source: Complete Preliminary for Schools Student's Book without Answers with Online Practice,
-- ISBN 9781108539050, printed p.13; answers cross-checked against Cambridge Teacher's Book excerpt ISBN 9788490362181.
-- Catalog-only correction. No learner records or scoring modes are changed.
UPDATE public.pet_textbook_exercises
SET directions = 'Choose the correct option in italics.',
    items = jsonb_build_array(
      jsonb_build_object('no',1,'text','I put a bit of / a few make-up on, but not many / much.','skill_tag','quantifiers','answer_key','a bit of; much','explanation','make-up is uncountable.','source','Student’s Book ISBN 9781108539050, p.13','verified_text',true),
      jsonb_build_object('no',2,'text','It doesn''t take many / much time to wash those clothes and it only takes a lot of / a few hours to dry them.','skill_tag','quantifiers','answer_key','much; a few','explanation','time is uncountable; hours are countable.','source','Student’s Book ISBN 9781108539050, p.13','verified_text',true),
      jsonb_build_object('no',3,'text','I''ve got a bit of / a few video games but I can''t buy any more because they cost much / a lot of money.','skill_tag','quantifiers','answer_key','a few; a lot of','explanation','video games are countable; money is uncountable.','source','Student’s Book ISBN 9781108539050, p.13','verified_text',true),
      jsonb_build_object('no',4,'text','Those new light bulbs don''t use many / a lot of electricity, so lots of / much people are buying them.','skill_tag','quantifiers','answer_key','a lot of; lots of','explanation','electricity is uncountable; people is plural countable.','source','Student’s Book ISBN 9781108539050, p.13','verified_text',true),
      jsonb_build_object('no',5,'text','I don''t use much / many shampoo, just a bit of / a few drops. My hair always goes dry if I use a lot / a lot of.','skill_tag','quantifiers','answer_key','much; a few; a lot','explanation','shampoo is uncountable; drops are countable; without a following noun use a lot.','source','Student’s Book ISBN 9781108539050, p.13','verified_text',true),
      jsonb_build_object('no',6,'text','There isn''t much / a lot space in my bedroom so I don''t keep a bit of / many things there.','skill_tag','quantifiers','answer_key','much; many','explanation','space is uncountable; things is plural countable.','source','Student’s Book ISBN 9781108539050, p.13','verified_text',true)
    ),
    item_count = 6,
    transcription_status = 'fully_transcribed',
    source_note = coalesce(source_note, '') || ' | Module 1 source transcription: all six quantifier-choice sentences transcribed from Student’s Book ISBN 9781108539050, p.13; answer keys cross-checked against Cambridge Teacher’s Book excerpt ISBN 9788490362181.'
WHERE id = 'CPS-U1-P13-GRAMMARQUANTIFIERS-E2';