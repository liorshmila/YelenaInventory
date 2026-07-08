-- Yelena Inventory
-- 04: System and audit tables

create table if not exists public.audit_logs (
    id uuid primary key default gen_random_uuid(),
    action text not null,
    entity_type text not null,
    entity_id uuid,
    branch_id uuid references public.branches(id),
    employee_id uuid references public.employees(id),
    details jsonb,
    created_at timestamptz not null default now(),
    device_info jsonb,
    app_version text
);

create table if not exists public.app_settings (
    key text primary key,
    value jsonb not null,
    updated_at timestamptz not null default now()
);
