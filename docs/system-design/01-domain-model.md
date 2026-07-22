# Chapter 1 - Domain Model

## Purpose

This chapter defines the business domain of Yelena Inventory.

It describes what exists in the business independently of Flutter, Supabase,
SQL, RPCs, authentication providers, screens, or other implementation details.

The implementation follows the domain. The domain is not defined by the
implementation.

## Business Philosophy

Yelena Inventory models a real business with a small number of stable concepts.

Every entity exists because it represents something meaningful in the business:

- a person employed by the business,
- a physical branch,
- a management area,
- a product,
- an inventory count event,
- a role assignment,
- an audit event.

The system avoids technical entities that have no independent business meaning.

## Business Entities

```text
Company
|- Areas
|- Branches
|- Employees
|- Products
|- Inventory Counts
|- Role Assignments
`- Audit Logs
```

## Company

A Company represents one business organization.

Yelena Inventory is intentionally single tenant. Each business operates its own
backend, database, and application instance.

## Area

An Area represents an official management region.

Areas group branches for administration. Areas are optional; a small business
may operate without defining them.

## Branch

A Branch represents one physical operating location.

Every operational action happens inside exactly one Current Branch. A user may
have access to multiple branches, but operational work is always performed in
one selected branch at a time.

## Employee

An Employee represents one physical person employed by the company.

Employees do not represent permissions, branch membership, or responsibilities.
Those concepts belong to Role Assignments.

Employee lifecycle states:

- **Active**: the employee may receive effective access when active Role
  Assignments allow it.
- **Inactive**: the employee remains historically identifiable, but must not
  retain effective application access.
- **Reactivated**: a previously inactive employee becomes active again while
  preserving the same employee identity.

Employee identity remains stable across activation state changes.

## Authentication Identity

Authentication identity is separate from the Employee business entity.

An employee may exist before an authentication identity is linked. Once
authentication succeeds and the server links the identity to the employee, the
application can load the Current Session for that employee.

Authentication does not grant permissions. Role Assignments do.

## Role

A Role represents a fixed responsibility type such as System Manager, Area
Manager, Branch Manager, Store Employee, or Viewer.

Roles are fixed by the product design. They are not dynamic business records
that users create inside the application.

## Role Assignment

A Role Assignment grants one role to one employee in one business scope.

The scope may be:

- global,
- area,
- branch.

Role Assignments are the single source of truth for operational permissions and
branch membership.

An employee may hold several active role assignments at the same time.

## Employee Deactivation

Employee deactivation is a soft lifecycle change, not a hard delete.

Operationally, deactivation can be partial at the operation level: an operator
may be authorized to end some assignments but not side-level or higher
assignments. The employee becomes inactive only when no active role assignments
remain.

This preserves history and prevents unauthorized responsibility changes.

## Product

A Product represents a real inventory item.

The approved business rule is one product equals one barcode. Barcodes are
immutable. A product has at most one current product image.

## Inventory Count

An Inventory Count represents one counting event.

Inventory is event-based. The latest relevant count determines the current
inventory view.

Inventory Counts do not represent product ownership or product identity.

## Audit Log

An Audit Log represents a historical business event.

Audit Logs are intended to be append-only and immutable. They explain how the
current state came to exist; they do not become the current source of truth.

## Business Facts vs Derived Information

Stored facts include:

- Employees,
- Branches,
- Areas,
- Products,
- Inventory Counts,
- Roles,
- Role Assignments,
- Audit Logs.

Derived information includes:

- effective permissions,
- accessible branches,
- visible screens,
- effective role for the Current Branch,
- current operational capabilities.

Derived information should not be persisted as a second source of truth.

## Single Source of Truth

| Business concept | Source of truth |
| --- | --- |
| Employee identity | Employee |
| Authentication identity | Auth provider identity linked to Employee |
| Responsibility | Role Assignment |
| Operational permission | Effective Role Assignments |
| Branch definition | Branch |
| Area definition | Area |
| Product identity | Product |
| Inventory activity | Inventory Count |
| Historical event | Audit Log |

## Rejected Alternatives

### Permissions directly on employees

Rejected because responsibilities change more often than employee identity.

### Direct employee-to-branch membership

Rejected because branch membership is derived from effective Role Assignments.

### Technology-driven domain

Rejected because implementation must follow business reality, not define it.

## Summary

The domain model keeps identity, responsibility, operational context, and
history separate.

This separation is the foundation of the entire Yelena Inventory architecture.
