# Yelena Inventory Database

This directory contains the approved Supabase/PostgreSQL database definition
for Yelena Inventory. The architecture is server first: the central database is
the source of truth, while local application storage may later serve only as an
offline cache or fallback.

## Contents

- `DATABASE_SPEC.md` documents all database objects and business rules.
- `ERD.md` shows the entities and their relationships.
- `ADR.md` records the approved architecture decisions.
- `migrations/` contains ordered SQL files, each responsible for one stage of
  database creation.
- `create_yelena_inventory_db.sql` is a standalone script that creates and
  verifies the complete database.

## Running the Migrations

Run the files in `migrations/` in numeric order:

1. `01_extensions.sql`
2. `02_core_tables.sql`
3. `03_relationship_tables.sql`
4. `04_system_tables.sql`
5. `05_constraints.sql`
6. `06_metadata_and_triggers.sql`
7. `07_indexes.sql`
8. `08_views.sql`
9. `09_storage.sql`
10. `10_seed_settings.sql`
11. `11_verify.sql`

Use this approach when migration execution and history are managed
individually. The final file contains read-only verification queries and is
intended to confirm the resulting database state.

## Running the Master Script

For a new Supabase project, run `create_yelena_inventory_db.sql` in the
Supabase SQL Editor. It contains the same operations as the ordered migration
files and can be executed as one complete script.

The script creates database structures and system settings only. It does not
create sample branches, employees, products, or inventory counts.

`create table if not exists` is primarily a safeguard for fresh database
creation and repeat execution against the same approved schema. It does not
alter an existing table when a later schema version adds, removes, or changes
columns. Future schema changes must be implemented as explicit, ordered
migrations rather than by relying on the creation script to update existing
tables automatically.

## Intentionally Excluded

The current approved scope does not include:

- Supabase Auth or application login
- Row Level Security (RLS)
- users, roles, or permissions
- administrator-specific database structures
- multi-tenant support, a `companies` table, or `company_id`
- inventory sessions

Authentication, authorization, and RLS will be designed together in a later
phase. They should not be added independently to this schema.
