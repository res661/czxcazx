-- Профили игроков для HLOR Hub (HLTV-стиль).
-- Выполни в Supabase → SQL Editor.

-- Доп. колонки (если таблица уже создана):
-- alter table public.player_profiles add column if not exists banner_url text;
-- alter table public.player_profiles add column if not exists trophy_image_url text;
-- alter table public.player_profiles add column if not exists games jsonb not null default '[]'::jsonb;
-- alter table public.player_profiles add column if not exists stats jsonb not null default '[]'::jsonb;
-- alter table public.player_profiles add column if not exists profile_type text not null default 'player';
-- alter table public.player_profiles add column if not exists roster jsonb not null default '[]'::jsonb;
-- update public.player_profiles set games = jsonb_build_array(game) where games = '[]'::jsonb and game is not null;

create table if not exists public.player_profiles (
  id uuid primary key default gen_random_uuid(),
  nickname text not null,
  avatar_url text,
  banner_url text,
  trophy_image_url text,
  game text not null default 'cs2',
  games jsonb not null default '[]'::jsonb,
  stats jsonb not null default '[]'::jsonb,
  teams jsonb not null default '[]'::jsonb,
  trophies jsonb not null default '[]'::jsonb,
  profile_type text not null default 'player',
  roster jsonb not null default '[]'::jsonb,
  tagline text,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists player_profiles_game_sort_idx
  on public.player_profiles (game asc, sort_order asc, nickname asc);

alter table public.player_profiles enable row level security;

drop policy if exists "player_profiles_select_public" on public.player_profiles;
create policy "player_profiles_select_public"
  on public.player_profiles for select
  using (true);

drop policy if exists "player_profiles_insert_authenticated" on public.player_profiles;
create policy "player_profiles_insert_authenticated"
  on public.player_profiles for insert
  with check (auth.role() = 'authenticated');

drop policy if exists "player_profiles_update_authenticated" on public.player_profiles;
create policy "player_profiles_update_authenticated"
  on public.player_profiles for update
  using (auth.role() = 'authenticated')
  with check (auth.role() = 'authenticated');

drop policy if exists "player_profiles_delete_authenticated" on public.player_profiles;
create policy "player_profiles_delete_authenticated"
  on public.player_profiles for delete
  using (auth.role() = 'authenticated');

-- Настройки Hub (featured events) хранятся в site_settings с key = 'hltv_hub':
-- { "featuredEventIds": ["uuid", "..."] }
