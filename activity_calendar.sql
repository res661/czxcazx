-- Таблица «Календарь активностей» для HLOR.
-- Выполни в Supabase → SQL Editor.

create table if not exists public.activity_calendar (
  id uuid primary key default gen_random_uuid(),
  event_date date not null,
  title text not null,
  time_label text,
  category text,
  event_id uuid,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

-- Миграция для уже существующей таблицы (Supabase → SQL Editor):
-- alter table public.activity_calendar add column if not exists category text;
-- alter table public.activity_calendar add column if not exists event_id uuid;

create index if not exists activity_calendar_date_sort_idx
  on public.activity_calendar (event_date asc, sort_order asc);

alter table public.activity_calendar enable row level security;

-- Публичное чтение (страница календаря у всех).
drop policy if exists "activity_calendar_select_public" on public.activity_calendar;
create policy "activity_calendar_select_public"
  on public.activity_calendar for select
  using (true);

-- Изменения только для авторизованных (админы входят через Supabase Auth).
drop policy if exists "activity_calendar_write_authenticated" on public.activity_calendar;
create policy "activity_calendar_write_authenticated"
  on public.activity_calendar for insert
  with check (auth.role() = 'authenticated');

drop policy if exists "activity_calendar_update_authenticated" on public.activity_calendar;
create policy "activity_calendar_update_authenticated"
  on public.activity_calendar for update
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

drop policy if exists "activity_calendar_delete_authenticated" on public.activity_calendar;
create policy "activity_calendar_delete_authenticated"
  on public.activity_calendar for delete
  using (auth.role() = 'authenticated');
