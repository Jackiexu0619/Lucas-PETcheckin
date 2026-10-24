-- P9 Exercise 2 is the pre-listening task for the same six conversations used in Exercise 3.
-- Both exercises depend on the same Track 02 recording; this flags the dependency but does not create an audio asset.
UPDATE public.pet_textbook_exercises
SET needs_audio = true,
    audio_ref = 'Track 02',
    source_note = coalesce(source_note, '') || ' | Module 1 correction: E2 and E3 both use the Track 02 recording; playable audio asset remains unavailable.'
WHERE id = 'CPS-U1-P9-LISTENINGPART2-E2';