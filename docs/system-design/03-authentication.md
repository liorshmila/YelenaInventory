# Chapter 3 - Authentication

## Purpose

This chapter defines the identity and authentication model of Yelena Inventory.

Authentication verifies who the user is.

Authorization determines what the user may do.

Current Branch determines where the user is working.

These responsibilities are intentionally separate.

## Permanent Principles

### Authentication Does Not Grant Permissions

Authentication establishes identity only. It does not define roles,
responsibilities, accessible branches, or visible actions.

After authentication, authorization is derived from the linked Employee and
effective Role Assignments.

### One Authenticated Identity Maps to One Employee

Every authenticated application user must map to exactly one Employee through
`employees.auth_user_id`.

An Employee may exist before an Auth identity is linked.

### Employee Identity Is Stable

The Employee record represents the person in the business. Authentication
credentials may change over time, but the Employee business identity should be
preserved.

Changing a phone number changes the authentication attribute. It does not
automatically destroy the Employee identity.

## Implemented Supabase Auth Flow in v0.4.0

Flutter initializes Supabase through `SupabaseService` using compile-time
dart-defines:

- `SUPABASE_URL`
- `SUPABASE_PUBLISHABLE_KEY`

Phone authentication is performed through Supabase Auth:

1. The user enters an Israeli mobile phone number.
2. Flutter normalizes the phone number to E.164 format.
3. Flutter calls `signInWithOtp`.
4. Supabase Auth generates the OTP and sends the SMS through its configured SMS
   provider.
5. The user enters the SMS code.
6. Flutter calls `verifyOTP` with `OtpType.sms`.
7. Supabase Auth returns the authenticated user/session.
8. Flutter calls the `link_authenticated_employee` RPC.
9. If linking succeeds or is idempotently already linked, Flutter bootstraps the
   Current Session by authenticated user id.

OTP generation and SMS delivery are not implemented in Flutter and are not
implemented in repository Edge Functions. They are handled by Supabase Auth and
the SMS provider configured outside source control.

## Employee Linking

After successful SMS verification, the application calls
`link_authenticated_employee`.

The approved linking behavior is:

- use the authenticated user/session rather than trusting a client-provided
  employee id,
- link only to an existing Employee,
- do not create an Employee during authentication,
- do not overwrite an employee already linked to another Auth user,
- treat an already-correct link as idempotent success,
- return stable result codes.

Known Flutter result handling includes:

- `linked`
- `alreadyLinked`
- `employeeNotFound`
- `employeeInactive`
- `linkingConflict`
- `authenticatedPhoneMissing`
- `invalidAuthenticatedPhone`
- `operationFailed`

## Current Session Bootstrap

After successful linking, Flutter loads the Current Session:

```text
auth user id
-> employees.auth_user_id
-> Employee
-> effective Role Assignments
-> accessible Branches
-> Current Branch
```

Session resolution rules:

- inactive employee: no active permission,
- no accessible branches: no active permission,
- saved branch restored only if still accessible,
- one accessible branch selected automatically,
- multiple accessible branches require branch selection.

The selected branch is stored locally by stable branch code. The database does
not persist the user's current branch.

## Existing Session Restoration

On app startup, `AuthSessionGate` calls the Auth controller to restore the
current Supabase Auth session.

If a valid session exists, the app links/bootstrap checks are run again and the
user is routed according to Current Session status.

If no session exists, the app shows the phone login flow.

## Inactive and Reactivated Employees

Inactive employees must not retain effective application access.

The current employee creation RPC can reactivate an inactive employee when the
same phone number is used, according to the approved server contract. This
preserves the employee id, employee code, and existing `auth_user_id`.

## Google Play Reviewer Access

Google Play closed testing uses a dedicated reviewer employee and Supabase
test-phone functionality.

The purpose is to allow app review without exposing real employee credentials.

Reviewer phone numbers, fixed OTPs, Supabase keys, and reviewer credentials must
remain outside source control and must not be documented in the repository.

## Business Rules

- Authentication identifies people.
- Authorization follows authentication.
- Every authenticated user must map to one Employee.
- Employees may exist before authentication.
- Authentication does not create business employees.
- Inactive employees must not retain effective access.
- Supabase Auth sessions may be restored automatically.

## Rejected Alternatives

### Username and password

Rejected because SMS verification is simpler for operational store employees.

### Authentication determines permissions

Rejected because permissions belong to Role Assignments.

### Direct client-side employee linking

Rejected because Flutter must not choose the Employee record or overwrite Auth
links.

### Anonymous operational access

Rejected because operational work must be attributable to an employee.

## Planned and Partial Work

- Full RLS coverage remains planned.
- Broader session hardening remains planned.
- Administrative reset/relink workflows require explicit future design before
  implementation.

## Summary

Supabase Auth establishes identity.

The employee-link RPC connects that identity to an Employee.

Current Session loads authorization facts and Current Branch context.

Only Role Assignments grant application access.
