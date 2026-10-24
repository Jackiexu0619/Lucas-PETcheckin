-- Student's Book ISBN 9781108539050, printed p.9: Exercise 2 asks learners
-- to inspect questions 1-6 and predict the speakers/situations with a partner.
-- The Track 02 listening icon and playback instruction appear at Exercise 3.
-- Keep the printed track label for context, but do not require an audio asset
-- to complete the Exercise 2 prediction task.
UPDATE public.pet_textbook_exercises
SET needs_audio = false,
    source_note = concat_ws(' | ', nullif(source_note, ''),
      '2026-10-25 source correction: Student Book ISBN 9781108539050 p.9 places the Track 02 listening icon at E3; E2 is a partner prediction task based on the printed questions. This supersedes the prior E2 audio-required note.')
WHERE id = 'CPS-U1-P9-LISTENINGPART2-E2'
  AND needs_audio IS DISTINCT FROM false;
