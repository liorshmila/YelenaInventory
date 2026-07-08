-- Yelena Inventory
-- 03: Relationship tables

create table if not exists public.employee_branches (
    id uuid primary key default gen_random_uuid(),
    employee_id uuid not null references public.employees(id),
    branch_id uuid not null references public.branches(id),
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);
