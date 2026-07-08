-- Yelena Inventory
-- 11: Verification queries
-- Each query should return the expected state described in its heading.

-- Required tables: expected 7 rows, all with exists = true.
with required_tables(table_name) as (
    values
        ('branches'),
        ('employees'),
        ('employee_branches'),
        ('products'),
        ('inventory_counts'),
        ('audit_logs'),
        ('app_settings')
)
select
    table_name,
    to_regclass('public.' || table_name) is not null as exists
from required_tables
order by table_name;

-- Current inventory view: expected exists = true.
select exists (
    select 1
    from information_schema.views
    where table_schema = 'public'
      and table_name = 'current_inventory'
) as current_inventory_view_exists;

-- Updated-at triggers: expected exactly the 6 listed rows.
select
    event_object_table as table_name,
    trigger_name
from information_schema.triggers
where trigger_schema = 'public'
  and trigger_name in (
      'trg_branches_updated_at',
      'trg_employees_updated_at',
      'trg_employee_branches_updated_at',
      'trg_products_updated_at',
      'trg_inventory_counts_updated_at',
      'trg_app_settings_updated_at'
  )
order by event_object_table;

-- Audit log triggers: expected trigger_count = 0.
select count(*) as trigger_count
from information_schema.triggers
where trigger_schema = 'public'
  and event_object_table = 'audit_logs';

-- Product images bucket: expected one row with public = true.
select id, name, public
from storage.buckets
where id = 'product-images';

-- Required settings: expected 2 rows.
select key, value
from public.app_settings
where key in ('schema_version', 'minimum_app_version')
order by key;

-- Barcode indexes: expected exactly one index, created by the UNIQUE constraint.
select
    count(*) as barcode_index_count,
    array_agg(index_name order by index_name) as barcode_indexes
from (
    select distinct index_class.relname as index_name
    from pg_index index_info
    join pg_class table_class on table_class.oid = index_info.indrelid
    join pg_namespace table_namespace
      on table_namespace.oid = table_class.relnamespace
    join pg_class index_class on index_class.oid = index_info.indexrelid
    join unnest(index_info.indkey) with ordinality as indexed_column(attnum, position)
      on true
    join pg_attribute attribute_info
      on attribute_info.attrelid = table_class.oid
     and attribute_info.attnum = indexed_column.attnum
    where table_namespace.nspname = 'public'
      and table_class.relname = 'products'
      and attribute_info.attname = 'barcode'
      and index_info.indnatts = 1
) as product_barcode_indexes;
