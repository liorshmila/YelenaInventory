# Chapter 1 --- Domain Model

## Purpose

This chapter defines the business domain of Yelena Inventory.

It describes **what exists in the business**, independently of
implementation details, programming language, database technology, or
user interface.

The purpose of the Domain Model is to establish a stable representation
of business reality upon which every future technical decision will be
based.

This chapter is intentionally technology-agnostic.

Flutter, Supabase, SQL tables, APIs, authentication mechanisms, and UI
implementation are consequences of the domain---not the domain itself.

Whenever implementation becomes inconsistent with the Domain Model, the
implementation should be reconsidered.

------------------------------------------------------------------------

# Business Philosophy

Yelena Inventory models a real business.

Every entity in the system exists because it represents something that
exists in reality.

For example:

-   A person employed by the business is represented as an Employee.
-   A physical store is represented as a Branch.
-   A management region is represented as an Area.
-   A product sold or counted by the business is represented as a
    Product.
-   A completed counting operation is represented as an Inventory Count.
-   A historical business event is represented as an Audit Log.

The system intentionally avoids introducing technical entities that have
no independent business meaning.

The goal is to keep the model intuitive, predictable, and easy to
understand even for someone unfamiliar with the implementation.

------------------------------------------------------------------------

# Business Entities

At its highest level, the business consists of a small number of
permanent concepts.

``` text
Company
│
├── Areas
├── Branches
├── Employees
├── Products
├── Inventory Counts
├── Role Assignments
└── Audit Logs
```

Each entity has one clearly defined responsibility.

No entity exists merely to support another.

No entity duplicates information owned by another.

------------------------------------------------------------------------

# Entity Definitions

## Company

A Company represents one business organization.

Yelena Inventory is intentionally designed as a **Single Tenant**
system.

Each business operates its own backend, its own database, and its own
application instance.

The system never mixes information belonging to different businesses.

------------------------------------------------------------------------

## Area

An Area represents a management region.

Areas group one or more branches for administrative purposes.

Areas are optional.

Small businesses may operate successfully without defining any areas.

Removing areas never changes the underlying business model.

------------------------------------------------------------------------

## Branch

A Branch represents one physical operating location.

Every operational activity performed inside the application takes place
within the context of exactly one branch.

Although users may have access to multiple branches, every action is
always executed inside one selected **Current Branch**.

This design keeps workflows predictable and prevents accidental
cross-branch operations.

------------------------------------------------------------------------

## Employee

An Employee represents one physical person employed by the company.

Employees do **not** represent permissions.

Employees do **not** represent responsibilities.

Employees do **not** represent branch membership.

Those concepts are intentionally modeled elsewhere.

Separating identity from responsibility keeps the Employee entity stable
throughout the employee's lifecycle.

------------------------------------------------------------------------

## Role Assignment

A Role Assignment represents a business responsibility granted to an
employee.

It connects:

-   one Employee,
-   one Role,
-   one Business Scope.

Role Assignments are the single source of truth for operational
permissions.

Every permission in the application is derived from active Role
Assignments.

No alternative permission structure exists.

------------------------------------------------------------------------

## Product

A Product represents a real inventory item managed by the business.

Products exist independently of employees, branches, or inventory
operations.

------------------------------------------------------------------------

## Inventory Count

An Inventory Count represents an inventory counting event.

It records operational work performed by employees.

It does **not** represent inventory ownership or the product itself.

------------------------------------------------------------------------

## Audit Log

An Audit Log represents a historical event.

It documents **what happened**, **when it happened**, and **who
performed the action**.

Audit Logs are immutable.

They are never edited and never deleted.

Their purpose is investigation, accountability, and historical
reconstruction.

------------------------------------------------------------------------

# Relationships

Conceptually:

``` text
Employee
        │
        ▼
Role Assignment
        │
        ▼
Role
        │
        ▼
Business Scope
        │
        ├── Area
        └── Branch
```

Responsibilities may change without changing employee identity.

------------------------------------------------------------------------

# Business Facts vs Derived Information

The system stores facts, not derived information.

Stored facts include Employees, Branches, Areas, Products and Role
Assignments.

Derived information includes permissions, accessible branches and
operational capabilities.

------------------------------------------------------------------------

# Single Source of Truth

  Business Concept          Source of Truth
  ------------------------- -----------------
  Employee identity         Employee
  Business role             Role
  Operational permissions   Role Assignment
  Branch definition         Branch
  Area definition           Area
  Historical events         Audit Log

------------------------------------------------------------------------

# Domain Principles

-   Every entity represents a real business concept.
-   Every business fact has exactly one owner.
-   Identity and responsibility are modeled separately.
-   Derived information should not be stored.
-   Simplicity is preferred over configurability.

------------------------------------------------------------------------

# Design Decisions

-   Business-first architecture.
-   Normalized domain model.
-   Separation between identity and permissions.
-   One source of truth for every business concept.
-   Technology-independent business definitions.

------------------------------------------------------------------------

# Rejected Alternatives

### Permissions directly on employees

Rejected because responsibilities change more frequently than employee
identity.

### Direct employee-to-branch membership

Rejected because branch membership is derived from active Role
Assignments.

### Technology-driven domain

Rejected because implementation must follow the business, not define it.

------------------------------------------------------------------------

# Future Considerations

Future modules should integrate into this domain model rather than
introduce parallel concepts.

------------------------------------------------------------------------

# Summary

The Domain Model is the foundation of Yelena Inventory.

It describes the business as it exists in reality.

Everything else is an implementation of this model.

> **The domain defines the system. The implementation follows the
> domain.**
