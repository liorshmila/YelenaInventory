-- Yelena Inventory
-- 10: Required system settings

insert into public.app_settings (key, value)
values
    ('schema_version', '"0.4.0"'::jsonb),
    ('minimum_app_version', '"0.4.0"'::jsonb)
on conflict (key) do update
set value = excluded.value;
