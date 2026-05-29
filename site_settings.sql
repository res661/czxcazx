-- Настройки сайта (баннер и др.) для HLOR.
-- Выполни в Supabase → SQL Editor.

create table if not exists public.site_settings (
  key text primary key,
  value jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.site_settings enable row level security;

-- Все видят настройки (баннер на главной).
drop policy if exists "site_settings_select_public" on public.site_settings;
create policy "site_settings_select_public"
  on public.site_settings for select
  using (true);

-- Менять могут только авторизованные админы.
drop policy if exists "site_settings_insert_authenticated" on public.site_settings;
create policy "site_settings_insert_authenticated"
  on public.site_settings for insert
  with check (auth.role() = 'authenticated');

drop policy if exists "site_settings_update_authenticated" on public.site_settings;
create policy "site_settings_update_authenticated"
  on public.site_settings for update
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');
