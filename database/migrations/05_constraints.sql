-- Yelena Inventory
-- 05: Named business constraints

do $$
begin
    if not exists (
        select 1 from pg_constraint
        where conname = 'chk_branches_name_not_empty'
          and conrelid = 'public.branches'::regclass
    ) then
        alter table public.branches
            add constraint chk_branches_name_not_empty
            check (btrim(name) <> '');
    end if;

    if not exists (
        select 1 from pg_constraint
        where conname = 'chk_branches_branch_code_not_empty'
          and conrelid = 'public.branches'::regclass
    ) then
        alter table public.branches
            add constraint chk_branches_branch_code_not_empty
            check (btrim(branch_code) <> '');
    end if;

    if not exists (
        select 1 from pg_constraint
        where conname = 'chk_branches_branch_code_no_spaces'
          and conrelid = 'public.branches'::regclass
    ) then
        alter table public.branches
            add constraint chk_branches_branch_code_no_spaces
            check (branch_code !~ '\s');
    end if;

    if not exists (
        select 1 from pg_constraint
        where conname = 'uq_branches_name'
          and conrelid = 'public.branches'::regclass
    ) then
        alter table public.branches
            add constraint uq_branches_name unique (name);
    end if;

    if not exists (
        select 1 from pg_constraint
        where conname = 'uq_branches_branch_code'
          and conrelid = 'public.branches'::regclass
    ) then
        alter table public.branches
            add constraint uq_branches_branch_code unique (branch_code);
    end if;

    if not exists (
        select 1 from pg_constraint
        where conname = 'chk_employees_name_not_empty'
          and conrelid = 'public.employees'::regclass
    ) then
        alter table public.employees
            add constraint chk_employees_name_not_empty
            check (btrim(name) <> '');
    end if;

    if not exists (
        select 1 from pg_constraint
        where conname = 'chk_employees_phone_not_empty'
          and conrelid = 'public.employees'::regclass
    ) then
        alter table public.employees
            add constraint chk_employees_phone_not_empty
            check (btrim(phone) <> '');
    end if;

    if not exists (
        select 1 from pg_constraint
        where conname = 'chk_employees_phone_no_spaces'
          and conrelid = 'public.employees'::regclass
    ) then
        alter table public.employees
            add constraint chk_employees_phone_no_spaces
            check (phone !~ '\s');
    end if;

    if not exists (
        select 1 from pg_constraint
        where conname = 'chk_employees_employee_code_not_empty'
          and conrelid = 'public.employees'::regclass
    ) then
        alter table public.employees
            add constraint chk_employees_employee_code_not_empty
            check (btrim(employee_code) <> '');
    end if;

    if not exists (
        select 1 from pg_constraint
        where conname = 'chk_employees_employee_code_no_spaces'
          and conrelid = 'public.employees'::regclass
    ) then
        alter table public.employees
            add constraint chk_employees_employee_code_no_spaces
            check (employee_code !~ '\s');
    end if;

    if not exists (
        select 1 from pg_constraint
        where conname = 'uq_employees_phone'
          and conrelid = 'public.employees'::regclass
    ) then
        alter table public.employees
            add constraint uq_employees_phone unique (phone);
    end if;

    if not exists (
        select 1 from pg_constraint
        where conname = 'uq_employees_employee_code'
          and conrelid = 'public.employees'::regclass
    ) then
        alter table public.employees
            add constraint uq_employees_employee_code unique (employee_code);
    end if;

    if not exists (
        select 1 from pg_constraint
        where conname = 'uq_employee_branch'
          and conrelid = 'public.employee_branches'::regclass
    ) then
        alter table public.employee_branches
            add constraint uq_employee_branch unique (employee_id, branch_id);
    end if;

    if not exists (
        select 1 from pg_constraint
        where conname = 'chk_products_barcode_not_empty'
          and conrelid = 'public.products'::regclass
    ) then
        alter table public.products
            add constraint chk_products_barcode_not_empty
            check (btrim(barcode) <> '');
    end if;

    if not exists (
        select 1 from pg_constraint
        where conname = 'chk_products_barcode_no_spaces'
          and conrelid = 'public.products'::regclass
    ) then
        alter table public.products
            add constraint chk_products_barcode_no_spaces
            check (barcode !~ '\s');
    end if;

    if not exists (
        select 1 from pg_constraint
        where conname = 'chk_inventory_counts_quantity_non_negative'
          and conrelid = 'public.inventory_counts'::regclass
    ) then
        alter table public.inventory_counts
            add constraint chk_inventory_counts_quantity_non_negative
            check (quantity >= 0);
    end if;
end
$$;
