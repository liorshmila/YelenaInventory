# Chapter 4 - Audit System

## Purpose

This chapter defines the audit architecture of Yelena Inventory.

Audit records significant business events so administrators and developers can
understand what happened, when it happened, and who performed the action.

Audit is for history and investigation. It is not the current source of truth.

## Permanent Principles

### History Never Changes

Audit records are intended to be append-only and immutable.

Once written, an audit record should not be edited or deleted.

### Business Tables Store Current State

Operational tables describe the current business reality.

Audit describes how that reality came to exist.

### Audit Records Business Events

Audit should capture meaningful business activity, not UI noise.

Examples that should not be audited:

- opening a screen,
- typing into a field,
- local validation failures,
- navigation events,
- temporary UI state.

### Audit Is Not Authorization

Audit does not grant permissions, determine current inventory, or decide current
employee state. It preserves historical evidence.

## Business Events That Should Be Audited

The approved audit intent includes:

- employee created,
- employee updated,
- employee deactivated,
- employee reactivated,
- role assignment created,
- role assignment replaced,
- role assignment ended,
- branch created,
- branch updated,
- branch deactivated,
- product image changed,
- inventory count created,
- inventory count updated,
- inventory count deleted,
- critical administrative maintenance actions.

This list describes audit intent. It does not mean every item is already
verified as producing a centralized audit record.

## Current Implementation Status in v0.4.0

### Implemented

The Flutter project contains:

- a Drift `audit_logs` table,
- `AuditRepository`,
- `auditLogsProvider`,
- `AuditLogScreen`,
- local filtering by all/today/week/branches/employees/inventory.

Repository-level calls to `auditRepository.logAction` are verified for legacy
and operational flows including:

- branch create/update/deactivate paths,
- some local employee create/update/delete paths,
- inventory save paths.

### Partial

The Supabase database scripts include a `public.audit_logs` table and indexes,
but the current repository evidence does not prove that all v0.4.0 server-side
RPC mutations write centralized Supabase audit entries.

Employee lifecycle and role-assignment RPCs should be auditable, but this
handbook does not claim complete audit coverage unless the server function body
or verified backend behavior is available.

### Planned

Future audit work should:

- move important audit generation to the server for sensitive operations,
- ensure employee and role-assignment lifecycle events are captured,
- avoid duplicate audit systems,
- keep audit append-only,
- keep audit readable and useful for investigation.

## Audit Lifecycle

```text
Business action
-> Business rule executed
-> Business state changed
-> Audit record written
-> Immutable history preserved
```

## Audit Data Shape

The local and database designs both support audit records with business-focused
fields such as:

- action,
- entity type,
- entity id,
- employee context,
- branch context,
- description or structured details,
- timestamp.

The exact storage shape may differ while the audit module is still migrating.

## Rejected Alternatives

### Storing history inside operational tables

Rejected because it mixes current state with historical investigation.

### Auditing every database update

Rejected because excessive low-value records hide important business events.

### Editable audit records

Rejected because audit must remain trustworthy.

### Multiple independent audit systems

Rejected because the business needs one coherent historical timeline.

## Summary

Audit is the historical memory of Yelena Inventory.

The permanent architecture requires immutable, business-event audit records.

The current implementation is partial: local audit infrastructure exists and
server audit storage is represented in SQL artifacts, but complete centralized
audit coverage for all sensitive Supabase operations remains planned until
verified.
