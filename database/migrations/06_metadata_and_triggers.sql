-- Yelena Inventory
-- 06: Updated-at metadata function and triggers

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
create trigger trg_branches_updated_at
before update on public.branches
for each row execute function public.update_updated_at_column();

drop trigger if exists trg_employees_updated_at on public.employees;
create trigger trg_employees_updated_at
before update on public.employees
for each row execute function public.update_updated_at_column();

drop trigger if exists trg_employee_branches_updated_at on public.employee_branches;
create trigger trg_employee_branches_updated_at
before update on public.employee_branches
for each row execute function public.update_updated_at_column();

drop trigger if exists trg_products_updated_at on public.products;
create trigger trg_products_updated_at
before update on public.products
for each row execute function public.update_updated_at_column();

drop trigger if exists trg_inventory_counts_updated_at on public.inventory_counts;
create trigger trg_inventory_counts_updated_at
before update on public.inventory_counts
for each row execute function public.update_updated_at_column();

drop trigger if exists trg_app_settings_updated_at on public.app_settings;
create trigger trg_app_settings_updated_at
before update on public.app_settings
for each row execute function public.update_updated_at_column();
