# Chapter 6 - Development Guidelines

## Purpose

This chapter defines the development standards for Yelena Inventory.

The goal is to keep future implementation aligned with the approved
architecture while allowing the project to evolve safely.

## Architectural Authority

The Yelena Inventory System Design Handbook is a living specification.

Code must follow the Handbook. When a completed feature changes the documented
architecture or implementation status, update the Handbook as part of the work.

Do not modify the Handbook merely to justify accidental code behavior. If the
architecture genuinely changes, document the decision intentionally.

## General Principles

- Implement business requirements, not technical shortcuts.
- Prefer existing architecture over new abstractions.
- Avoid duplicate representations of the same business fact.
- Keep responsibilities small.
- Make business rules easy to discover.
- Preserve Server First architecture.
- Keep local storage non-authoritative.

## Supabase and Database Change Rules

Supabase database changes are currently performed manually by the project owner.

Codex or other agents must not create, edit, or run database changes unless the
project owner explicitly approves that exact task.

Do not modify without explicit approval:

- SQL,
- migrations,
- schema definitions,
- constraints,
- triggers,
- grants,
- RLS policies,
- publications,
- database functions,
- Supabase configuration.

Database inspection and reporting are allowed. Database mutation is not.

When documenting backend behavior, distinguish between:

- local SQL artifacts,
- verified Flutter usage,
- approved manual Supabase backend contracts,
- planned architecture.

## Permission and Security Guidelines

Role Assignments remain the single source of authorization facts.

Flutter permission checks improve UX, but they never replace server-side
authorization.

Do not introduce:

- dynamic roles,
- runtime permission editors,
- alternative authorization paths,
- duplicate permission tables,
- client-only security for sensitive mutations.

Sensitive operations should be validated server-side where implemented and
expanded server-side where still planned.

## Authentication Guidelines

Authentication identifies the user.

Authorization follows from the linked Employee and effective Role Assignments.

Current Branch defines operational context.

Do not merge these concepts.

Do not create fake users, bypass authentication, or hardcode reviewer
credentials.

## Secrets and Reviewer Data

Never hardcode or document:

- reviewer phone numbers,
- fixed OTP codes,
- Supabase URLs or keys that are not public documentation placeholders,
- service-role keys,
- Google Play reviewer credentials,
- personal phone numbers,
- real customer data.

Reviewer credentials must remain outside source control.

## Release Build Guidelines

Google Play release builds must use:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
& .\scripts\build_android_release.ps1
```

Run the command from the repository root.

Do not create Google Play AABs with a plain:

```powershell
flutter build appbundle --release
```

The release script:

- loads local Supabase configuration from `scripts/release.env.ps1`,
- keeps `release.env.ps1` uncommitted,
- passes the required dart-defines,
- increments only the Flutter build number,
- leaves the semantic version under deliberate manual control,
- produces the release AAB at
  `yelena_inventory/build/app/outputs/bundle/release/app-release.aab`.

## Command and Validation Guidelines

Human-facing command instructions should be kept on one line whenever practical.

Significant changes should run relevant validation and report results honestly.
Typical checks include:

- `dart format .`
- `flutter analyze`
- focused tests where applicable
- release build script for release tasks

If a validation command cannot run, report why.

## Commit Guidelines

Use Conventional Commits with a scope.

Examples:

- `feat(employee-management): complete employee lifecycle workflow`
- `fix(auth): handle expired OTP errors`
- `docs(system-design): update v0.4.0 implementation baseline`

Do not commit or push unless explicitly asked.

## Audit Guidelines

Every significant business action should be auditable.

Ask:

```text
Would an administrator reasonably want to know that this happened?
```

If the answer is yes, the operation probably belongs in the Audit System.

Do not confuse audit intent with verified audit implementation coverage.

## Code Review Checklist

Before approving significant changes, verify:

- Does it follow the Domain Model?
- Does it preserve one source of truth?
- Does it avoid duplicate concepts?
- Does it preserve Server First data ownership?
- Does it keep local storage non-authoritative?
- Does it follow the Role Assignment permission architecture?
- Does it avoid client-only security for sensitive operations?
- Does it preserve audit intent?
- Does it update documentation when implementation status changes?
- Does it avoid secrets and reviewer credentials?

## Rejected Alternatives

### Code defines the architecture

Rejected because architecture should remain intentional rather than accidental.

### Parallel implementations

Rejected because multiple implementations of the same business concept
inevitably diverge.

### UI hiding as authorization

Rejected because hidden controls do not protect backend data.

## Summary

Development should implement the approved architecture faithfully.

The Handbook, database contracts, Flutter code, release process, and security
model must evolve together and remain honest about what is implemented, partial,
and planned.
