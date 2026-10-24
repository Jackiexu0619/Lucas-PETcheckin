-- Module 1: correct P9 E2's media requirement.
-- E2 is a pre-listening prediction task; E3 is the actual Track 02 listening task.
-- No learner attempts or answer keys are changed.
UPDATE public.pet_textbook_exercises
SET title = 'Predict speakers and situations before listening',
    directions = 'Before listening, look at questions 1–6 with a partner. Predict who you will hear and the situation in each conversation. This prediction task does not require audio playback; Exercise 3 is the listening task.',
    needs_audio = false,
    audio_ref = NULL,
    audio_asset_ref = NULL,
    audio_mime_type = NULL,
    source_note = coalesce(source_note, '') || ' | Module 1 source check: Student’s Book ISBN 9781108539050, printed p.9, Exercise 2 is pre-listening prediction; Exercise 3 instructs learners to listen to Track 02 again. E2 therefore does not require an audio asset.'
WHERE id = 'CPS-U1-P9-LISTENINGPART2-E2';
