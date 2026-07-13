# Yelena Inventory Architecture

## Purpose

Yelena Inventory is designed as a long-term inventory management platform that prioritizes simplicity, consistency, correctness, and maintainability over excessive configurability.

The purpose of this architecture is to define the permanent design principles of the system so that every future development decision remains consistent with the overall vision.

This document acts as the architectural source of truth for the project.

Whenever implementation details conflict with this architecture, the architecture takes precedence until an explicit architectural decision changes it.

---

# Design Philosophy

The system is intentionally opinionated.

Rather than providing unlimited configuration options, the application implements a carefully designed operational model based on proven business workflows.

This philosophy reduces complexity, minimizes user errors, simplifies maintenance, and produces a predictable user experience.

---

# Core Principles

## 1. One Source of Truth

Every business fact must have exactly one authoritative source.

Examples:

- Role assignments determine employee permissions.
- Audit logs determine historical actions.
- Employee records represent people.
- Branch records represent physical locations.

Business information must never be duplicated unless there is a measurable architectural benefit.

---

## 2. Server First

The server is always the authoritative data source.

Local storage exists only for:

- Caching
- Performance optimization

Offline operation is not supported. Without a network connection, the application must not operate.

Business logic must never depend on local persistence.

---

## 3. Fixed Business Model

The application intentionally implements a fixed business model.

Examples:

- Fixed system roles
- Fixed permission model
- Fixed authentication workflow

The system is not intended to become a generic ERP platform.

---

## 4. Simplicity over Flexibility

Whenever two solutions provide equivalent business value, the simpler solution must always be preferred.

Complexity must always justify itself.

---

## 5. One Logic for Everyone

Every authenticated user follows the same application workflow.

Differences between users are expressed through permissions rather than different application behavior.

Examples:

- Every user works inside one Current Branch.
- Every screen follows identical navigation.
- Permissions determine visibility and available actions.

---

## 6. Single Source of Permissions

Permissions are derived exclusively from active role assignments.

No duplicate permission structures exist.

No dynamic permission editor exists.

---

## 7. Business Rules Live in Code

The database stores business facts.

The application implements business behavior.

Permission evaluation, workflow rules, and UI decisions belong to application code.

---

## 8. Audit First

Administrative actions should always be traceable.

Historical information belongs inside the audit system rather than duplicated throughout operational tables.

---

## 9. Long-Term Maintainability

The architecture always favors maintainability over short-term implementation convenience.

Future developers should be able to understand the system without tribal knowledge.

---

# Architectural Scope

This documentation covers:

- Domain model
- Database architecture
- Authentication
- Roles
- Permissions
- Audit
- Branch model
- Employee model
- Future expansion principles

---

# Recommended Repository Structure

```text
docs/
    system-design/
    adr/

database/

lib/
```

---

# Handbook Contents

| Document | Purpose |
|----------|---------|
| README | Architectural philosophy and guiding principles |
| 01 – Domain Model | Business domain and core entities |
| 02 – Roles & Permissions | Authorization model |
| 03 – Authentication | Identity architecture |
| 04 – Audit System | Historical investigation model |
| 05 – Database Design | Target database architecture |
| 06 – Development Guidelines | Development standards |
| 07 – Security Roadmap | Planned security evolution |

---

# ADR Relationship

System Design documents describe:

> **How the system works**

ADR documents describe:

> **Why architectural decisions were made**

Both are considered official project documentation.

---

# Guiding Statement

> **Keep the architecture simple.**
>
> **Keep the business model deterministic.**
>
> **Keep one source of truth.**
>
> **Add complexity only when the business truly requires it.**
