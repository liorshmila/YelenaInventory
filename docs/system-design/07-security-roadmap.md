# Chapter 7 - Security Roadmap

## Purpose

This chapter describes the security status and planned security evolution of
Yelena Inventory.

Security reinforces the approved architecture. It does not redefine the domain,
permission model, authentication model, or database ownership rules.

## Security Philosophy

Yelena Inventory uses defense in depth:

```text
Authentication
-> Current Session
-> Permission-aware UX
-> Server-side authorization
-> Database security
-> Audit and monitoring
```

Each layer has a distinct responsibility.

UI hiding is not authorization.

## Implemented Security Foundations in v0.4.0

### Supabase Phone Authentication

Phone/SMS authentication is implemented through Supabase Auth.

Flutter calls:

- `signInWithOtp` to request an SMS OTP,
- `verifyOTP` with `OtpType.sms` to verify the OTP.

OTP generation and SMS delivery are handled by Supabase Auth and its configured
SMS provider.

### Compile-Time Supabase Configuration

The app initializes Supabase from compile-time dart-defines:

- `SUPABASE_URL`
- `SUPABASE_PUBLISHABLE_KEY`

Release builds must use the repository release script so these values are
included without committing secrets.

### Employee/Auth Linking

After successful authentication, Flutter calls `link_authenticated_employee`.

The linking operation returns stable result codes and keeps authentication
identity separate from authorization.

### Current Session

The app loads Current Session facts from the authenticated user:

- current Employee,
- active Role Assignments,
- accessible Branches,
- Current Branch.

Inactive employees and employees without accessible branches do not reach the
operational app state.

### Client-Side Permission-Aware UX

Flutter derives visible screens and actions from Current Session facts and fixed
permission vocabulary.

This improves user experience but is not a security boundary.

### Protected Developer Behavior

The Developer role and `EMP0000` employee are protected from normal employee and
role administration flows.

### Android Release Scanner Protection

The release build includes ProGuard keep rules for ML Kit and Firebase
ComponentDiscovery, preserving scanner functionality in Google Play release
AABs.

## Partially Implemented Enforcement

### Server-Side Authorization for Employee and Assignment Mutations

Sensitive employee-management and role-assignment mutations are performed
through Supabase RPCs that return stable business result codes.

Verified RPC-facing operations include:

- `create_employee_with_first_role_assignment`
- `add_employee_role_assignment`
- `replace_employee_role_assignment`
- `end_employee_role_assignment`
- `deactivate_employee`

The frozen `deactivate_employee` function:

- uses `SECURITY DEFINER`,
- uses `SET search_path TO ''`,
- prevents self-deactivation,
- protects Developer,
- applies the approved hierarchy,
- changes only assignments the operator is authorized to manage,
- deactivates the employee only when no active role assignments remain.

This is implemented server-side authorization for verified employee-management
operations. It does not prove complete server-side enforcement for every module.

### Audit

Audit architecture exists and local audit infrastructure is implemented.

Complete centralized server-side audit coverage for all sensitive RPCs is not
verified in the repository and remains partial/planned.

### Storage Policies

Product image upload, replacement, download, and deletion depend on Supabase
Storage bucket policies for `product-images`.

The repository documents and uses the storage flow, but Supabase policy
configuration itself is managed manually outside source control.

## Remaining Mandatory Security Work

### Full RLS Coverage

Full Row Level Security coverage is not verified across all relevant tables.

RLS remains mandatory before a broader production rollout. RLS policies must
enforce the approved authorization model rather than create a parallel one.

### Complete Server-Side Authorization Coverage

Server-side authorization already exists for verified employee-management and
role-assignment operations.

Remaining business modules should receive equivalent server-side enforcement
where sensitive mutations exist.

### Server-Side Audit Generation

Critical server-side operations should generate centralized audit records on
the server.

Audit generation must remain append-only and business-event focused.

### Session Hardening

Planned improvements include:

- inactivity handling,
- session lifetime policy,
- forced logout for sensitive account changes,
- re-authentication before destructive actions where appropriate.

### Secret Management

Required ongoing practices:

- keep `scripts/release.env.ps1` local and uncommitted,
- rotate secrets when needed,
- never expose service-role keys in Flutter,
- never document reviewer phone numbers or fixed OTPs.

### Backup, Monitoring, and Disaster Recovery

Planned infrastructure work includes:

- database backup strategy,
- restore testing,
- monitoring and alerting,
- operational incident response,
- disaster recovery documentation.

## Security Boundaries

| Layer | Responsibility |
| --- | --- |
| Supabase Auth | Identity |
| Employee link RPC | Auth identity to Employee mapping |
| Current Session | Session facts and Current Branch |
| Flutter permissions | UX and navigation decisions |
| Server RPCs | Sensitive mutation authorization |
| RLS | Row-level database enforcement |
| Audit | Historical investigation |

No layer should replace another.

## Rejected Alternatives

### Client-only security

Rejected because sensitive mutations require server validation.

### Independent server permission model

Rejected because the server must enforce the same Role Assignment model, not a
parallel authorization system.

### Security through obscurity

Rejected because robust systems rely on explicit enforcement.

### Publicly documented reviewer credentials

Rejected because reviewer access must remain controlled outside source control.

## Summary

Yelena Inventory v0.4.0 includes real security foundations: Supabase phone
authentication, employee/Auth linking, Current Session, permission-aware UX, and
server-side authorization for verified employee-management operations.

Security is still incomplete. Full RLS coverage, complete server-side
authorization across all business modules, server-side audit generation,
session hardening, secret rotation, backups, monitoring, and disaster recovery
remain mandatory future work.
