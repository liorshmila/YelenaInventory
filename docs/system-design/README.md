# Yelena Inventory System Design Handbook

## Purpose

This handbook is the architectural source of truth for Yelena Inventory.
It defines the permanent business and technical principles that guide the
Flutter application, Supabase backend, database design, security model, and
future implementation work.

The handbook is a living specification. When a completed feature changes the
implemented architecture or current implementation status, the handbook must be
updated to remain accurate.

## Document Status Convention

The handbook distinguishes between three kinds of statements:

- **Implemented**: verified in the repository or in the approved backend
  contract used by the current release.
- **Partial**: implemented in one layer or module, but not complete across the
  whole system.
- **Planned**: approved architecture or future work that is not yet complete.

Permanent architectural principles are not release notes. They describe how the
system must continue to behave even as implementation details evolve.

## Current Implementation Baseline - v0.4.0

The current approved Google Play closed-testing release is:

- Semantic version: `0.4.0`
- Flutter/Android build number: `16`
- Git tag: `v0.4.0`
- Distribution status: Google Play closed-testing track

This does not imply a public production rollout.

Verified implementation facts for this baseline include:

- Supabase is initialized from compile-time dart-defines.
- Phone authentication is performed through Supabase Auth.
- Flutter requests SMS OTPs with `signInWithOtp`.
- Flutter verifies SMS OTPs with `verifyOTP` and `OtpType.sms`.
- OTP generation and SMS delivery are handled by Supabase Auth and its
  configured SMS provider, not by Flutter.
- Authenticated users are linked to employees through the
  `link_authenticated_employee` RPC.
- Existing authenticated sessions are restored through the Auth/session gate.
- Branch CRUD, Employee Management, Role Assignment Management, operational
  inventory, product images, and Current Session flows are Supabase-backed in
  the current application architecture.
- Local Drift storage still exists for legacy/local modules and controlled
  fallback behavior, but it is not authoritative for the final server-first
  architecture.
- Release AABs must be built through the repository release script so required
  Supabase dart-defines are included.

## Core Principles

### One Source of Truth

Every business fact must have exactly one authoritative source.

Examples:

- Employee records represent people.
- Role Assignments determine responsibilities, branch access, and operational
  permissions.
- Branch records represent physical locations.
- Product records represent inventory items.
- Inventory Counts represent count events.
- Audit records preserve history.

Business information must not be duplicated unless the architecture explicitly
requires a cache or derived read model.

### Server First

Supabase and the central database are the authoritative source of business
facts.

Local storage may be used for:

- caching,
- device performance,
- controlled offline fallback,
- legacy compatibility during migration.

Offline or cached data must never become the source of truth. If offline support
is introduced, it must reconcile with the server.

### Fixed Business Model

Yelena Inventory intentionally implements a fixed business model:

- fixed system roles,
- fixed permission vocabulary,
- one Current Branch during operational work,
- one product per barcode,
- one image per product,
- event-based inventory counts,
- append-only audit intent,
- soft deletion through `is_active`.

The application is not intended to become a generic ERP platform.

### Authentication, Authorization, and Context Are Separate

- Authentication answers who the user is.
- Authorization answers what the user may do.
- Current Branch answers where the user is currently working.

These responsibilities must not be merged.

### UI Permissions Are Not Security Boundaries

Flutter evaluates permissions for presentation, navigation, and user
experience. Sensitive business mutations must also be validated server-side.

### Simplicity Over Flexibility

When two solutions provide equivalent business value, the simpler solution is
preferred.

Complexity must justify itself.

## Handbook Contents

| Document | Purpose |
| --- | --- |
| `README.md` | Architecture overview and current baseline |
| `01-domain-model.md` | Technology-independent business domain |
| `02-roles-and-permissions.md` | Authorization model |
| `03-authentication.md` | Supabase Auth and identity model |
| `04-audit-system.md` | Audit principles and implementation status |
| `05-database-design.md` | Database and server-operation design |
| `06-development-guidelines.md` | Development and release standards |
| `07-security-roadmap.md` | Implemented, partial, and planned security work |

## ADR Relationship

System Design documents describe how the system works.

ADR documents describe why architectural decisions were made.

Both are official project documentation.

## Guiding Statement

Keep the architecture simple.

Keep the business model deterministic.

Keep the server authoritative.

Add complexity only when the business truly requires it.
