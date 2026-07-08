-- Yelena Inventory
-- 02: Core business tables

create table if not exists public.branches (
    id uuid primary key default gen_random_uuid(),
    name text not null,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    branch_code text not null
);

create table if not exists public.employees (
    id uuid primary key default gen_random_uuid(),
    name text not null,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    phone text not null,
    updated_at timestamptz not null default now(),
    employee_code text not null
);

create table if not exists public.products (
    id uuid primary key default gen_random_uuid(),
    barcode text not null unique,
    name text,
    notes text,
    image_path text,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists public.inventory_counts (
    id uuid primary key default gen_random_uuid(),
    product_id uuid not null references public.products(id),
    branch_id uuid not null references public.branches(id),
    employee_id uuid references public.employees(id),
    quantity integer not null,
    counted_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    created_at timestamptz not null default now()
);
