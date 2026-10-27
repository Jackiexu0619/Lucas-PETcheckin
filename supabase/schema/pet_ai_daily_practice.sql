-- Deployed 2026-10-27 to Supabase project lucas-pet.
-- Kept here for reproducibility; not a destructive migration.
create table if not exists public.pet_ai_daily_practice (
 profile_id uuid not null references public.pet_profiles(id) on delete cascade,
 session_date date not null,
 base_questions jsonb not null,
 extra_questions jsonb not null default '[]'::jsonb,
 submitted_answers jsonb not null default '[]'::jsonb,
 focus_evidence jsonb not null default '{}'::jsonb,
 model text not null,
 generated_at timestamptz not null default now(),
 updated_at timestamptz not null default now(),
 primary key(profile_id,session_date),
 constraint pet_ai_base_three check (jsonb_typeof(base_questions)='array' and jsonb_array_length(base_questions)=3),
 constraint pet_ai_extra_two check (jsonb_typeof(extra_questions)='array' and jsonb_array_length(extra_questions)<=2),
 constraint pet_ai_answers_five check (jsonb_typeof(submitted_answers)='array' and jsonb_array_length(submitted_answers)<=5)
);
alter table public.pet_ai_daily_practice enable row level security;
revoke all on public.pet_ai_daily_practice from anon, authenticated;
