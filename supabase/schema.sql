-- Schema v0 for MVP (Supabase/PostgreSQL)
-- Run in Supabase SQL editor

create extension if not exists "uuid-ossp";

-- Profiles mirror auth.users, keep minimal for MVP
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text,
  created_at timestamp with time zone default now()
);

-- Learning plans
create table if not exists public.learning_plans (
  id uuid primary key default uuid_generate_v4(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  description text,
  goal text,
  status text not null default 'active', -- active|paused|completed
  progress numeric default 0,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

create index if not exists idx_learning_plans_owner on public.learning_plans(owner_id);

-- Nodes of a plan (mind map)
create table if not exists public.learning_nodes (
  id uuid primary key default uuid_generate_v4(),
  plan_id uuid not null references public.learning_plans(id) on delete cascade,
  title text not null,
  description text,
  type text not null default 'knowledge', -- knowledge|skill|project
  difficulty text default 'beginner', -- beginner|intermediate|advanced
  estimated_time integer default 60, -- minutes
  status text not null default 'not_started', -- not_started|in_progress|completed
  prerequisites uuid[] default '{}', -- array of node ids (same plan)
  resources jsonb default '[]',
  outputs jsonb default '[]',
  position jsonb default '{"x":0,"y":0}',
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

create index if not exists idx_learning_nodes_plan on public.learning_nodes(plan_id);

-- Share tokens for public read-only view
create table if not exists public.plan_shares (
  id uuid primary key default uuid_generate_v4(),
  plan_id uuid not null references public.learning_plans(id) on delete cascade,
  public_read_token text unique not null,
  created_at timestamp with time zone default now()
);

-- Badges & awards
create table if not exists public.badges (
  id uuid primary key default uuid_generate_v4(),
  code text unique not null,
  title text not null,
  description text
);

create table if not exists public.user_badges (
  user_id uuid not null references public.profiles(id) on delete cascade,
  badge_id uuid not null references public.badges(id) on delete cascade,
  awarded_at timestamp with time zone default now(),
  primary key (user_id, badge_id)
);

-- RLS policies
alter table public.profiles enable row level security;
alter table public.learning_plans enable row level security;
alter table public.learning_nodes enable row level security;
alter table public.plan_shares enable row level security;
alter table public.user_badges enable row level security;

-- Profiles policies
drop policy if exists "profiles_self_select" on public.profiles;
create policy "profiles_self_select" on public.profiles
  for select using (auth.uid() = id);
drop policy if exists "profiles_self_update" on public.profiles;
create policy "profiles_self_update" on public.profiles
  for update using (auth.uid() = id);

-- Plans policies
drop policy if exists "plans_owner_select" on public.learning_plans;
create policy "plans_owner_select" on public.learning_plans
  for select using (owner_id = auth.uid());
drop policy if exists "plans_owner_crud" on public.learning_plans;
create policy "plans_owner_crud" on public.learning_plans
  for all using (owner_id = auth.uid()) with check (owner_id = auth.uid());

-- Nodes policies
drop policy if exists "nodes_owner_select" on public.learning_nodes;
create policy "nodes_owner_select" on public.learning_nodes
  for select using (
    exists (
      select 1 from public.learning_plans p
      where p.id = plan_id and p.owner_id = auth.uid()
    )
  );
drop policy if exists "nodes_owner_crud" on public.learning_nodes;
create policy "nodes_owner_crud" on public.learning_nodes
  for all using (
    exists (
      select 1 from public.learning_plans p
      where p.id = plan_id and p.owner_id = auth.uid()
    )
  ) with check (
    exists (
      select 1 from public.learning_plans p
      where p.id = plan_id and p.owner_id = auth.uid()
    )
  );

-- Shares policies (owner full access)
drop policy if exists "shares_owner_crud" on public.plan_shares;
create policy "shares_owner_crud" on public.plan_shares
  for all using (
    exists (
      select 1 from public.learning_plans p
      where p.id = plan_id and p.owner_id = auth.uid()
    )
  ) with check (
    exists (
      select 1 from public.learning_plans p
      where p.id = plan_id and p.owner_id = auth.uid()
    )
  );

-- Badges policies (read-only for all authenticated, awards restricted)
drop policy if exists "badges_read" on public.badges;
create policy "badges_read" on public.badges
  for select using (true);
drop policy if exists "user_badges_self" on public.user_badges;
create policy "user_badges_self" on public.user_badges
  for select using (user_id = auth.uid());

-- Timestamps
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end; $$ language plpgsql;

drop trigger if exists trg_plans_updated on public.learning_plans;
create trigger trg_plans_updated before update on public.learning_plans
for each row execute function public.set_updated_at();

drop trigger if exists trg_nodes_updated on public.learning_nodes;
create trigger trg_nodes_updated before update on public.learning_nodes
for each row execute function public.set_updated_at();


