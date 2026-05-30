-- Флаг «турнир для HLOR Hub» на событии.
-- Выполни в Supabase → SQL Editor.

alter table public.events
  add column if not exists hub_tournament boolean not null default false;

create index if not exists events_hub_tournament_idx
  on public.events (hub_tournament asc, sort_order asc);
