# Chapter 2 --- Roles & Permissions

## Purpose

This chapter defines the authorization model of Yelena Inventory.

It explains how responsibilities are represented, how permissions are
granted, and how access to business data is determined.

The objective of this design is to provide a permission model that is
simple, deterministic, scalable, and easy to maintain throughout the
lifetime of the project.

This chapter defines the permanent business rules governing
authorization.

------------------------------------------------------------------------

# Design Philosophy

The permission model is intentionally simple.

The application does not attempt to become a generic permission
management platform.

Instead, it implements a fixed organizational model based on common
business structures found in retail environments.

Permissions are granted through predefined roles rather than
individually assigned capabilities.

This approach minimizes configuration errors, simplifies administration,
and ensures consistent behavior across all installations.

------------------------------------------------------------------------

# Core Principles

### Identity and Responsibility are Separate

Employees represent people.

Roles represent responsibilities.

Permissions are never stored on employees directly.

### One Source of Truth

Every permission originates from active Role Assignments.

No other structure grants permissions.

### Fixed Roles

The set of available roles is fixed.

Roles cannot be created, deleted, or modified from within the
application.

Adding or changing roles requires development.

### Permissions Live in Code

The database stores assignments.

The application determines what each role is allowed to do.

### One Operational Context

Although a user may have access to multiple branches, every action is
always performed inside one selected Current Branch.

------------------------------------------------------------------------

# System Roles

  Role                    Purpose
  ----------------------- ---------------------------------------------
  Developer               System development and maintenance
  System Manager          Full administrative access
  Area Manager            Administrative access within assigned areas
  Branch Manager          Full management of assigned branches
  Deputy Branch Manager   Temporary branch management
  Store Employee          Operational inventory work
  Viewer                  Read-only access within assigned branches

Roles are fixed and cannot be managed from within the application.

------------------------------------------------------------------------

# Role Assignments

Permissions are granted through Role Assignments.

Each assignment connects:

-   One Employee
-   One Role
-   One Business Scope

Role Assignments are the single source of truth for authorization.

Employees may hold multiple active assignments simultaneously.

------------------------------------------------------------------------

# Business Scope

Depending on the assigned role, the operational scope may be:

-   Global
-   Area
-   Branch

The required scope is implied by the assigned role.

The application interprets the assignment and calculates the effective
permissions.

------------------------------------------------------------------------

# Current Branch

Users with access to multiple branches select one Current Branch before
beginning operational work.

The selected branch becomes the active business context.

Changing the Current Branch changes operational context, not
permissions.

------------------------------------------------------------------------

# Permission Evaluation

Permissions are calculated rather than stored.

``` text
Employee
    ↓
Active Role Assignments
    ↓
Current Branch
    ↓
Application evaluates permissions
    ↓
Available Actions
```

------------------------------------------------------------------------

# Temporary Responsibilities

Temporary responsibilities are implemented through Role Assignments with
validity periods.

This mechanism is primarily used for Deputy Branch Managers.

Expired assignments automatically lose effect.

------------------------------------------------------------------------

# Developer

Developer is represented by the protected technical employee:

``` text
EMP0000
```

This account exists outside normal business administration.

It cannot be assigned, modified, or removed from within the application.

------------------------------------------------------------------------

# Business Rules

-   Employees may hold multiple active roles.
-   Roles are permanent.
-   Permissions are never assigned individually.
-   Permissions are always calculated.
-   Exactly one Current Branch is active.
-   Inactive employees cannot have active permissions.
-   Branch membership is derived from Role Assignments.
-   Only one Deputy Branch Manager may be active per branch at any given
    time.

------------------------------------------------------------------------

# Design Decisions

This architecture intentionally chooses:

-   Fixed organizational roles.
-   Code-based permission evaluation.
-   Multiple simultaneous responsibilities.
-   One permission source.
-   One operational context.

------------------------------------------------------------------------

# Rejected Alternatives

### Dynamic Permission Editor

Rejected because it adds complexity without measurable business value.

### Employee Branch Membership

Rejected because branch membership is already implied by active Role
Assignments.

### Individual Permission Assignment

Rejected because maintaining individual permissions significantly
increases complexity.

### Database Permission Logic

Rejected because authorization belongs to the application layer.

------------------------------------------------------------------------

# Future Considerations

Future responsibilities should extend the existing Role Assignment model
rather than introducing parallel authorization systems.

------------------------------------------------------------------------

# Summary

Employees represent people.

Roles represent responsibilities.

Role Assignments connect the two.

Permissions are calculated from active assignments within the Current
Branch context.

This model provides a simple, deterministic and maintainable
authorization architecture.
