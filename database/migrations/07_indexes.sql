-- Yelena Inventory
-- 07: Query-supporting indexes

create index if not exists idx_employee_branches_employee
    on public.employee_branches(employee_id);

create index if not exists idx_employee_branches_branch
    on public.employee_branches(branch_id);

create index if not exists idx_products_active
    on public.products(is_active);

create index if not exists idx_inventory_product
    on public.inventory_counts(product_id);

create index if not exists idx_inventory_branch
    on public.inventory_counts(branch_id);

create index if not exists idx_inventory_employee
    on public.inventory_counts(employee_id);

create index if not exists idx_inventory_counted_at
    on public.inventory_counts(counted_at desc);

create index if not exists idx_audit_created_at
    on public.audit_logs(created_at desc);

create index if not exists idx_audit_employee
    on public.audit_logs(employee_id);

create index if not exists idx_audit_branch
    on public.audit_logs(branch_id);

create index if not exists idx_audit_entity
    on public.audit_logs(entity_type, entity_id);
