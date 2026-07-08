-- ============================================================================
-- Yelena Inventory - Complete Supabase/PostgreSQL database creation script
-- Schema version: 0.4.0
-- ============================================================================

-- 1. Extensions
create extension if not exists pgcrypto;

-- 2. Core tables
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

-- 3. Relationship tables
create table if not exists public.employee_branches (
    id uuid primary key default gen_random_uuid(),
    employee_id uuid not null references public.employees(id),
    branch_id uuid not null references public.branches(id),
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

-- 4. System tables
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

-- 5. Constraints
do $$
begin
    if not exists (select 1 from pg_constraint where conname = 'chk_branches_name_not_empty' and conrelid = 'public.branches'::regclass) then
        alter table public.branches add constraint chk_branches_name_not_empty check (btrim(name) <> '');
    end if;
    if not exists (select 1 from pg_constraint where conname = 'chk_branches_branch_code_not_empty' and conrelid = 'public.branches'::regclass) then
        alter table public.branches add constraint chk_branches_branch_code_not_empty check (btrim(branch_code) <> '');
    end if;
    if not exists (select 1 from pg_constraint where conname = 'chk_branches_branch_code_no_spaces' and conrelid = 'public.branches'::regclass) then
        alter table public.branches add constraint chk_branches_branch_code_no_spaces check (branch_code !~ '\s');
    end if;
    if not exists (select 1 from pg_constraint where conname = 'uq_branches_name' and conrelid = 'public.branches'::regclass) then
        alter table public.branches add constraint uq_branches_name unique (name);
    end if;
    if not exists (select 1 from pg_constraint where conname = 'uq_branches_branch_code' and conrelid = 'public.branches'::regclass) then
        alter table public.branches add constraint uq_branches_branch_code unique (branch_code);
    end if;
    if not exists (select 1 from pg_constraint where conname = 'chk_employees_name_not_empty' and conrelid = 'public.employees'::regclass) then
        alter table public.employees add constraint chk_employees_name_not_empty check (btrim(name) <> '');
    end if;
    if not exists (select 1 from pg_constraint where conname = 'chk_employees_phone_not_empty' and conrelid = 'public.employees'::regclass) then
        alter table public.employees add constraint chk_employees_phone_not_empty check (btrim(phone) <> '');
    end if;
    if not exists (select 1 from pg_constraint where conname = 'chk_employees_phone_no_spaces' and conrelid = 'public.employees'::regclass) then
        alter table public.employees add constraint chk_employees_phone_no_spaces check (phone !~ '\s');
    end if;
    if not exists (select 1 from pg_constraint where conname = 'chk_employees_employee_code_not_empty' and conrelid = 'public.employees'::regclass) then
        alter table public.employees add constraint chk_employees_employee_code_not_empty check (btrim(employee_code) <> '');
    end if;
    if not exists (select 1 from pg_constraint where conname = 'chk_employees_employee_code_no_spaces' and conrelid = 'public.employees'::regclass) then
        alter table public.employees add constraint chk_employees_employee_code_no_spaces check (employee_code !~ '\s');
    end if;
    if not exists (select 1 from pg_constraint where conname = 'uq_employees_phone' and conrelid = 'public.employees'::regclass) then
        alter table public.employees add constraint uq_employees_phone unique (phone);
    end if;
    if not exists (select 1 from pg_constraint where conname = 'uq_employees_employee_code' and conrelid = 'public.employees'::regclass) then
        alter table public.employees add constraint uq_employees_employee_code unique (employee_code);
    end if;
    if not exists (select 1 from pg_constraint where conname = 'uq_employee_branch' and conrelid = 'public.employee_branches'::regclass) then
        alter table public.employee_branches add constraint uq_employee_branch unique (employee_id, branch_id);
    end if;
    if not exists (select 1 from pg_constraint where conname = 'chk_products_barcode_not_empty' and conrelid = 'public.products'::regclass) then
        alter table public.products add constraint chk_products_barcode_not_empty check (btrim(barcode) <> '');
    end if;
    if not exists (select 1 from pg_constraint where conname = 'chk_products_barcode_no_spaces' and conrelid = 'public.products'::regclass) then
        alter table public.products add constraint chk_products_barcode_no_spaces check (barcode !~ '\s');
    end if;
    if not exists (select 1 from pg_constraint where conname = 'chk_inventory_counts_quantity_non_negative' and conrelid = 'public.inventory_counts'::regclass) then
        alter table public.inventory_counts add constraint chk_inventory_counts_quantity_non_negative check (quantity >= 0);
    end if;
end
$$;

-- 6. Metadata and triggers
create or replace function public.update_updated_at_column()
returns trigger
language plpgsql
as $$
begin
    new.updated_at = now();
    return new;
end;
$$;

drop trigger if exists trg_branches_updated_at on public.branches;
create trigger trg_branches_updated_at before update on public.branches
for each row execute function public.update_updated_at_column();

drop trigger if exists trg_employees_updated_at on public.employees;
create trigger trg_employees_updated_at before update on public.employees
for each row execute function public.update_updated_at_column();

drop trigger if exists trg_employee_branches_updated_at on public.employee_branches;
create trigger trg_employee_branches_updated_at before update on public.employee_branches
for each row execute function public.update_updated_at_column();

drop trigger if exists trg_products_updated_at on public.products;
create trigger trg_products_updated_at before update on public.products
for each row execute function public.update_updated_at_column();

drop trigger if exists trg_inventory_counts_updated_at on public.inventory_counts;
create trigger trg_inventory_counts_updated_at before update on public.inventory_counts
for each row execute function public.update_updated_at_column();

drop trigger if exists trg_app_settings_updated_at on public.app_settings;
create trigger trg_app_settings_updated_at before update on public.app_settings
for each row execute function public.update_updated_at_column();

-- 7. Indexes
create index if not exists idx_employee_branches_employee on public.employee_branches(employee_id);
create index if not exists idx_employee_branches_branch on public.employee_branches(branch_id);
create index if not exists idx_products_active on public.products(is_active);
create index if not exists idx_inventory_product on public.inventory_counts(product_id);
create index if not exists idx_inventory_branch on public.inventory_counts(branch_id);
create index if not exists idx_inventory_employee on public.inventory_counts(employee_id);
create index if not exists idx_inventory_counted_at on public.inventory_counts(counted_at desc);
create index if not exists idx_audit_created_at on public.audit_logs(created_at desc);
create index if not exists idx_audit_employee on public.audit_logs(employee_id);
create index if not exists idx_audit_branch on public.audit_logs(branch_id);
create index if not exists idx_audit_entity on public.audit_logs(entity_type, entity_id);

-- 8. Views
create or replace view public.current_inventory as
select
    latest.inventory_count_id,
    latest.product_id,
    latest.barcode,
    latest.product_name,
    latest.image_path,
    latest.branch_id,
    latest.branch_name,
    latest.employee_id,
    latest.employee_name,
    latest.quantity,
    latest.counted_at
from (
    select distinct on (ic.product_id, ic.branch_id)
        ic.id as inventory_count_id,
        ic.product_id,
        p.barcode,
        p.name as product_name,
        p.image_path,
        ic.branch_id,
        b.name as branch_name,
        ic.employee_id,
        e.name as employee_name,
        ic.quantity,
        ic.counted_at,
        ic.created_at
    from public.inventory_counts ic
    join public.products p on p.id = ic.product_id
    join public.branches b on b.id = ic.branch_id
    left join public.employees e on e.id = ic.employee_id
    where p.is_active = true
      and b.is_active = true
    order by ic.product_id, ic.branch_id, ic.counted_at desc, ic.created_at desc, ic.id desc
) as latest;

-- 9. Storage
insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do update
set name = excluded.name,
    public = excluded.public;

-- 10. Seed settings
insert into public.app_settings (key, value)
values
    ('schema_version', '"0.4.0"'::jsonb),
    ('minimum_app_version', '"0.4.0"'::jsonb)
on conflict (key) do update
set value = excluded.value;

-- 11. Verification queries
with required_tables(table_name) as (
    values ('branches'), ('employees'), ('employee_branches'), ('products'),
           ('inventory_counts'), ('audit_logs'), ('app_settings')
)
select table_name, to_regclass('public.' || table_name) is not null as exists
from required_tables
order by table_name;

select exists (
    select 1 from information_schema.views
    where table_schema = 'public' and table_name = 'current_inventory'
) as current_inventory_view_exists;

select event_object_table as table_name, trigger_name
from information_schema.triggers
where trigger_schema = 'public'
  and trigger_name in (
      'trg_branches_updated_at', 'trg_employees_updated_at',
      'trg_employee_branches_updated_at', 'trg_products_updated_at',
      'trg_inventory_counts_updated_at', 'trg_app_settings_updated_at'
  )
order by event_object_table;

select count(*) as audit_logs_trigger_count
from information_schema.triggers
where trigger_schema = 'public' and event_object_table = 'audit_logs';

select id, name, public
from storage.buckets
where id = 'product-images';

select key, value
from public.app_settings
where key in ('schema_version', 'minimum_app_version')
order by key;

select
    count(*) as barcode_index_count,
    array_agg(index_name order by index_name) as barcode_indexes
from (
    select distinct index_class.relname as index_name
    from pg_index index_info
    join pg_class table_class on table_class.oid = index_info.indrelid
    join pg_namespace table_namespace on table_namespace.oid = table_class.relnamespace
    join pg_class index_class on index_class.oid = index_info.indexrelid
    join unnest(index_info.indkey) with ordinality as indexed_column(attnum, position) on true
    join pg_attribute attribute_info
      on attribute_info.attrelid = table_class.oid
     and attribute_info.attnum = indexed_column.attnum
    where table_namespace.nspname = 'public'
      and table_class.relname = 'products'
      and attribute_info.attname = 'barcode'
      and index_info.indnatts = 1
) as product_barcode_indexes;
