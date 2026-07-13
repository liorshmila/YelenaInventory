# Chapter 3 --- Authentication

## Purpose

This chapter defines the identity and authentication model of Yelena
Inventory.

Its purpose is to explain how a person becomes an authenticated system
user, how that identity is maintained over time, and how authentication
integrates with the business domain.

Authentication verifies **who the user is**.

Authorization determines **what the user is allowed to do**.

These two concepts are intentionally separated.

------------------------------------------------------------------------

# Design Philosophy

Authentication exists to establish identity.

It does not determine permissions.

It does not determine responsibilities.

It does not determine operational context.

Once identity has been established, the authorization system takes over.

This separation keeps the architecture simple, secure, and maintainable.

------------------------------------------------------------------------

# Identity Model

Every authenticated user is always associated with exactly one Employee.

An Employee may temporarily exist without an authenticated account.

This occurs before the employee completes the first SMS verification.

After successful verification, the authentication identity becomes
permanently linked to that employee.

This relationship remains stable throughout the employee's lifecycle.

------------------------------------------------------------------------

# Employee Lifecycle

### Stage 1 --- Employee Creation

The employee is created by an authorized administrator.

The employee exists in the business.

Authentication does not yet exist.

``` text
Employee
✓ Exists

Auth Account
✗ Not Linked
```

### Stage 2 --- First Authentication

The employee receives an SMS verification.

After successful verification:

-   A Supabase Auth account is created.
-   The employee is linked.
-   Future logins use the same identity.

### Stage 3 --- Normal Operation

Authentication becomes transparent.

The application restores the existing authenticated session
automatically.

Daily work does not require repeated SMS verification.

### Stage 4 --- Identity Reset

Certain events invalidate the authentication relationship.

Examples include:

-   Phone number change
-   Security recovery
-   Administrative reset

The existing authentication link is removed and a new SMS verification
is required.

------------------------------------------------------------------------

# Authentication Flow

``` text
Administrator
        │
Creates Employee
        │
        ▼
Employee Exists
        │
        ▼
SMS Verification
        │
        ▼
Supabase Authentication
        │
        ▼
Employee Linked
        │
        ▼
Normal Operation
```

------------------------------------------------------------------------

# Authentication Identity

Authentication is based on the employee's phone number.

The phone number is treated as an identity attribute rather than merely
contact information.

Changing the phone number changes the authentication identity while
preserving the business employee.

------------------------------------------------------------------------

# Session Philosophy

Authentication should become invisible after the first successful
verification.

Existing authenticated sessions are restored automatically.

Future security policies may invalidate sessions when appropriate.

------------------------------------------------------------------------

# Relationship to Authorization

Authentication never grants permissions.

``` text
Authenticated Employee
        │
        ▼
Role Assignments
        │
        ▼
Current Branch
        │
        ▼
Permissions
```

Authorization always follows authentication.

------------------------------------------------------------------------

# Developer Authentication

Developer follows the same authentication architecture.

It is represented by the protected technical employee:

``` text
EMP0000
```

The account cannot be created, modified, or assigned from within the
application.

------------------------------------------------------------------------

# Business Rules

-   Authentication identifies people.
-   Authorization grants permissions.
-   Every authenticated identity belongs to one Employee.
-   One Employee belongs to one authentication identity.
-   SMS verification occurs only when required.
-   Changing the phone number requires re-verification.
-   Inactive employees cannot authenticate.
-   Employees may exist before authentication.

------------------------------------------------------------------------

# Design Decisions

-   Employee-first identity.
-   SMS-based authentication.
-   Stable identity mapping.
-   Separation of authentication and authorization.
-   Transparent day-to-day authentication.

------------------------------------------------------------------------

# Rejected Alternatives

### Username and Password

Rejected because phone verification provides a simpler experience for
operational employees.

### Authentication Determines Permissions

Rejected because permissions belong to Role Assignments, not
authentication.

### Anonymous Operational Access

Rejected because every operational action must be attributable to a real
employee.

### Multiple Authentication Identities Per Employee

Rejected because one person should have one permanent business identity.

------------------------------------------------------------------------

# Future Considerations

Future authentication providers may be introduced without changing the
business model.

The authentication mechanism may evolve.

The identity architecture should not.

------------------------------------------------------------------------

# Summary

The authentication architecture of Yelena Inventory is intentionally
independent from authorization.

Authentication exists solely to establish and preserve the identity of a
real employee. It never grants permissions, determines responsibilities,
or defines operational access.

Every authenticated user is permanently linked to exactly one Employee
record. This business identity remains stable throughout the employee's
lifecycle, while authentication credentials may change over time, such
as after a phone number update or a security reset.

Once authentication succeeds, the authorization system evaluates the
employee's active Role Assignments together with the selected Current
Branch to determine the actions available within the application.

This separation creates a clear architectural boundary:

-   Authentication answers **who the user is.**
-   Authorization answers **what the user may do.**
-   Operational context answers **where the user is currently working.**

Keeping these responsibilities independent simplifies the architecture,
reduces coupling between system components, and allows each subsystem to
evolve without affecting the others.

This principle is fundamental to Yelena Inventory and should be
preserved throughout future development.
