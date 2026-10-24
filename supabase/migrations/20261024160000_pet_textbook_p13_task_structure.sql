-- Module 1: restore task-level instructions from existing parent-provided P13 notes.
-- These are explicitly summaries, not claimed verbatim textbook transcription.
UPDATE public.pet_textbook_exercises
SET directions = 'Ask and answer about home activities, television/computer games and time spent. Practise a few, a bit of, many, much, a lot of and lots of where appropriate. Parent-provided P13 task summary; not verbatim textbook wording.',
    answer_status = 'open_ended',
    source_note = coalesce(source_note, '') || ' | Module 1: task scope recovered from prior parent-provided P13 notes; direction is a summary, not verbatim book text.'
WHERE id = 'CPS-U1-P13-GRAMMARQUANTIFIERS-E3';

UPDATE public.pet_textbook_exercises
SET directions = 'Write three countable and three uncountable kitchen items. Label each and explain why it is countable or uncountable. Parent-provided P13 task summary; not verbatim textbook wording.',
    answer_status = 'open_ended',
    source_note = coalesce(source_note, '') || ' | Module 1: task scope recovered from prior parent-provided P13 notes; direction is a summary, not verbatim book text.'
WHERE id = 'CPS-U1-P13-COUNTABLEANDUNCOUNTABLENOUNS-E5';
