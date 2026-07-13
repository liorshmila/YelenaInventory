# Chapter 4 --- Audit System

## Purpose

This chapter defines the audit architecture of Yelena Inventory.

The Audit System records the historical activity of the business and
provides a reliable timeline of significant events performed within the
application.

Its purpose is accountability, traceability, operational investigation,
and historical reconstruction.

The Audit System is not designed to participate in business operations.

Its responsibility is to preserve history.

------------------------------------------------------------------------

# Design Philosophy

Business data describes the current state of the system.

Audit describes **how the system reached that state.**

These two responsibilities are intentionally separated.

Operational tables answer questions such as:

-   What is the employee's current role?
-   Which branch is currently active?
-   Which products exist?

Audit answers different questions:

-   Who changed the employee?
-   When was a permission granted?
-   Which manager deactivated the branch?
-   What happened before an inventory discrepancy was discovered?

The Audit System exists to answer historical questions.

------------------------------------------------------------------------

# Core Principles

### History Never Changes

Audit records are immutable.

Once written, an audit record is never modified.

It may only be created.

This guarantees historical consistency.

### Business Tables Store Current State

Operational tables always represent the current business reality.

They are not responsible for preserving history.

Historical information belongs inside the Audit System.

### Audit Does Not Replace Business Data

The Audit System complements the operational database.

It never becomes the source of truth for business entities.

Instead, it records the evolution of those entities.

### Important Events Only

Not every database update deserves an audit record.

The Audit System records meaningful business events.

Its goal is clarity rather than noise.

------------------------------------------------------------------------

# What Should Be Audited

### Employee Management

-   Employee created
-   Employee updated
-   Employee deactivated
-   Employee reactivated

### Roles & Permissions

-   Role assigned
-   Role removed
-   Temporary assignment created
-   Temporary assignment expired
-   Current Branch changed (future decision)

### Branch Administration

-   Branch created
-   Branch updated
-   Branch deactivated
-   Area assignment changed

### Inventory

-   Inventory count started
-   Inventory count completed
-   Inventory count cancelled
-   Product quantity adjusted
-   Inventory finalized

### Administration

-   Critical maintenance actions
-   Future administrative operations

------------------------------------------------------------------------

# What Should Not Be Audited

Examples include:

-   Opening screens
-   Typing into text fields
-   Temporary UI state
-   Validation failures
-   Navigation events

The Audit System records business events---not user interface activity.

------------------------------------------------------------------------

# Audit Lifecycle

``` text
Business Action
        │
        ▼
Business Rule Executed
        │
        ▼
Business Data Updated
        │
        ▼
Audit Record Written
        │
        ▼
Immutable History
```

------------------------------------------------------------------------

# Relationship to Business Entities

Audit references business entities such as Employees, Branches, Areas,
Products and Inventory Counts.

It stores only the information necessary to reconstruct what happened
without duplicating operational data.

------------------------------------------------------------------------

# Investigation Philosophy

The operational database explains the current situation.

The Audit System explains how that situation came to exist.

Together they provide a complete understanding of the business.

------------------------------------------------------------------------

# Business Rules

-   Audit is append-only.
-   Audit records are immutable.
-   Audit exists for historical reconstruction.
-   Operational tables never duplicate historical information.
-   Significant business events should produce audit entries.
-   Audit should remain human-readable.

------------------------------------------------------------------------

# Design Decisions

This architecture intentionally chooses:

-   Immutable audit history.
-   Separation between operational and historical data.
-   Human-readable audit records.
-   Business-event auditing.
-   One centralized audit history.

------------------------------------------------------------------------

# Rejected Alternatives

### Storing History Inside Operational Tables

Rejected because it mixes current state with historical information.

### Auditing Every Database Change

Rejected because it produces excessive noise.

### Editable Audit Records

Rejected because historical records must remain trustworthy.

### Multiple Audit Systems

Rejected because the business should have one chronological history.

------------------------------------------------------------------------

# Future Considerations

Future modules should integrate into the existing Audit System.

Potential future enhancements include filtering, exports, investigation
reports, digital signatures and external audit integrations.

------------------------------------------------------------------------

# Summary

The Audit System is the historical memory of Yelena Inventory.

Operational tables describe **what is true today**.

The Audit System explains **how today's reality came to exist**.

By keeping historical information separate from operational data, the
architecture remains clean, maintainable, and easy to investigate.

Every meaningful business event contributes to a single, immutable
timeline that allows administrators and developers to reconstruct past
actions with confidence.

The Audit System is not part of the business workflow---it is the
permanent historical record of that workflow.
