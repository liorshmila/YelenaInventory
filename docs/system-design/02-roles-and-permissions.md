# Chapter 2 - Roles & Permissions

## Purpose

This chapter defines the authorization model of Yelena Inventory.

It explains how responsibilities are represented, how branch access is derived,
and how the application decides which screens and actions are available.

Authentication identifies the user. Authorization determines what that user may
do.

## Permanent Principles

### Identity and Responsibility Are Separate

Employees represent people.

Roles represent responsibility types.

Role Assignments connect employees to responsibilities.

### Role Assignments Are the Permission Source

Every operational permission originates from effective Role Assignments.

No second permission source exists.

### Fixed Roles

The role set is fixed by the application design:

- `developer`
- `system_manager`
- `area_manager`
- `branch_manager`
- `deputy_branch_manager`
- `store_employee`
- `viewer`

Roles cannot be created, deleted, or renamed through the application.

### Permissions Are Fixed Capabilities

The permission vocabulary and role capability definitions are fixed in
application code.

The database stores role assignment facts. It does not store a dynamic
permission editor.

### UI Visibility Is Not Authorization

Flutter evaluates permissions to improve presentation, navigation, and user
experience.

Hiding a button is not a security boundary. Sensitive business mutations must
also be validated server-side.

## System Roles

| Role | Purpose |
| --- | --- |
| Developer | Protected development and maintenance role |
| System Manager | Broad company-level administration |
| Area Manager | Administration within assigned areas |
| Branch Manager | Management of assigned branches |
| Deputy Branch Manager | Time-limited branch management |
| Store Employee | Operational inventory work |
| Viewer | Read-only branch-scoped access |

`developer` is protected and outside normal role administration.

## Role Assignment Scope

Each assignment has exactly one scope model implied by the role:

| Role | Scope |
| --- | --- |
| `developer` | global |
| `system_manager` | global |
| `area_manager` | area |
| `branch_manager` | branch |
| `deputy_branch_manager` | branch, time-limited |
| `store_employee` | branch |
| `viewer` | branch, or no effective access fallback where explicitly designed |

Current Branch is operational context. It is not itself a permission source.

## Effective Assignments

An assignment is effective only when:

- the employee is active,
- the assignment is active,
- `valid_from` is absent or has started,
- `valid_until` is absent or has not passed,
- the assignment scope applies to the Current Branch when branch context is
  required.

Employees may hold multiple effective assignments at the same time. Effective
permissions are the union of applicable assignments.

## Implemented State in v0.4.0

Verified Flutter implementation includes:

- `RoleCode` and `RoleModel` with stable role codes.
- `RoleAssignmentModel` with `validFrom`, `validUntil`, `isActive`, and
  effectiveness evaluation.
- `EffectivePermissions` as the fixed application permission vocabulary.
- Current Session facts: authenticated user, current employee, active role
  assignments, accessible branches, and current branch.
- Current Branch selection and persistence by branch code.
- Employee Management and Role Assignment Management driven by
  Role Assignments.
- Role assignment create, replace, and end operations through Supabase RPCs.
- Employee deactivation through a Supabase RPC.

## Server-Side Authorization

For sensitive employee-management and role-assignment operations, Flutter calls
server-side RPCs that return stable result codes.

The server-side checks are part of defense in depth and must remain aligned with
the same role hierarchy used by the application.

The current verified RPC-facing operations include:

- `add_employee_role_assignment`
- `replace_employee_role_assignment`
- `end_employee_role_assignment`
- `deactivate_employee`
- `create_employee_with_first_role_assignment`

## Assignment Management

Assignment management is intentionally history-preserving.

Adding an assignment creates a new active responsibility.

Replacing an assignment is experienced by the user as editing, but the server
preserves history internally.

Ending an assignment cancels the active responsibility without deleting the
employee or historical records.

## Frozen `deactivate_employee` Contract

The current `deactivate_employee` operation is frozen as implemented.

It:

- accepts `p_target_employee_id uuid`,
- returns `text`,
- uses `SECURITY DEFINER`,
- uses `SET search_path TO ''`,
- prevents self-deactivation,
- protects the Developer role,
- evaluates active role assignments in this fixed order:
  1. `system_manager`
  2. `area_manager`
  3. `branch_manager`
  4. `deputy_branch_manager`
  5. `store_employee`
  6. `viewer`,
- applies the same authorization hierarchy used by
  `end_employee_role_assignment`,
- deactivates only assignments the operator is authorized to manage,
- leaves side-level or higher assignments intact when the operator cannot manage
  them,
- deactivates the employee only when no active role assignments remain.

Primary success results:

- `deactivated`
- `partiallyDeactivated`
- `nothingToDeactivate`

Known error results:

- `unauthorized`
- `employeeNotFound`
- `employeeInactive`
- `selfManagementNotAllowed`
- `protectedRole`
- `operationFailed`

This contract must not be expanded or redesigned without explicit approval.

## Rejected Alternatives

### Dynamic permission editor

Rejected because it adds complexity without measurable business value.

### Employee branch membership as a permission source

Rejected because branch membership is derived from Role Assignments.

### Client-only authorization

Rejected because sensitive operations require independent server validation.

### Independent server permission model

Rejected because maintaining two authorization models would create
contradictions.

## Summary

Role Assignments are the single authorization source.

Flutter derives user experience from those assignments.

Server-side RPCs independently validate sensitive mutations.

Both layers must enforce the same approved authorization model.
