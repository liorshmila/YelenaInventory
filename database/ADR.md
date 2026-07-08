# Yelena Inventory Architecture Decision Records

## ADR-001: Single-Tenant Architecture

**Status:** Accepted

Yelena Inventory serves one business organization. The schema does not contain
`companies`, `tenants`, or `company_id`. Multi-tenant isolation would add
complexity that is not required by the approved business model.

## ADR-002: Server-First Architecture

**Status:** Accepted

The central PostgreSQL database is the source of truth. Flutter local storage
may later act as an offline cache or temporary fallback, but it must not become
an independent authoritative database.

## ADR-003: Supabase/PostgreSQL Backend Foundation

**Status:** Accepted

Supabase Free provides the shared PostgreSQL backend and product-image storage.
The schema uses standard PostgreSQL structures so its business model remains
clear and maintainable.

## ADR-004: One Product Equals One Barcode

**Status:** Accepted

Each product has exactly one unique barcode. A different barcode represents a
different product rather than an alias of the original product. No barcode
mapping table is required.

## ADR-005: Barcodes Are Immutable

**Status:** Accepted

A product barcode does not change during the product's lifetime in this
application. When a different barcode is required, a new product is created.
This keeps inventory event identity stable.

## ADR-006: One Image Per Product

**Status:** Accepted

Each product has zero or one image. Its storage object path is held directly in
`products.image_path`. A separate `product_images` table and image history are
outside the approved scope.

## ADR-007: Current Inventory Is Derived

**Status:** Accepted

Every count is stored as an event in `inventory_counts`. The latest event for a
product and branch determines current inventory. The `current_inventory` view
derives that state with deterministic ordering; no mutable current-stock table
is maintained.

## ADR-008: No Inventory Sessions

**Status:** Accepted

Inventory events stand independently and do not require a session container.
The schema therefore has no `inventory_sessions` table.

## ADR-009: No Inventory Source Column

**Status:** Accepted

`inventory_counts` has no `source` column. No current business behavior
requires categorizing events by source, and speculative flexibility is
intentionally avoided.

## ADR-010: Audit Log Is Append-Only

**Status:** Accepted

`audit_logs` records immutable historical events. It has `created_at` but no
`updated_at`, and the common updated-at trigger is not attached to it. Existing
audit records must not be rewritten as normal business data.

## ADR-011: Employees May Belong to Multiple Branches

**Status:** Accepted

Employee membership is many-to-many and is represented by
`employee_branches`. A direct `branch_id` on `employees` would incorrectly
restrict an employee to one branch.

## ADR-012: Future Roles Belong to Employee-Branch Membership

**Status:** Accepted

If roles are introduced, they should describe an employee's responsibility in
a specific branch and therefore belong to the employee-branch relationship.
No role columns or role tables are added before the authentication and
authorization design is approved.

## ADR-013: RLS Is Deferred Until Auth and Roles

**Status:** Accepted

There is currently no login, Supabase Auth integration, user model, role model,
or permission model. RLS is intentionally disabled until these concerns can be
designed together. Adding partial policies now could create false security or
conflict with the future authorization model.

## ADR-014: Soft Delete Uses `is_active`

**Status:** Accepted

Business entities are deactivated with `is_active = false` instead of being
physically deleted. This preserves references and history. Active-state
filtering is explicit where required, including the `current_inventory` view.

## ADR-015: No Branch Manager Column Yet

**Status:** Accepted

Branches do not contain `manager_id`. Manager behavior depends on future user,
role, and permission decisions and must be introduced with that design rather
than embedded prematurely in the branch table.
