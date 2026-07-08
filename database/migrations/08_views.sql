-- Yelena Inventory
-- 08: Derived current inventory

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
    order by
        ic.product_id,
        ic.branch_id,
        ic.counted_at desc,
        ic.created_at desc,
        ic.id desc
) as latest;
