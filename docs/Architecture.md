# Yelena Inventory

## Software Architecture & Product Specification

**Version:** Draft 0.1\
**Owner:** Yelena Portnoy\
**Status:** Active Development

------------------------------------------------------------------------
Section	Status
Architecture	✅ Active
UI Guidelines	✅ Active
Branches	✅ Implemented
Employees	✅ Implemented
Audit Log	✅ Implemented
Authentication	🚧 Planned
Permissions	🚧 Planned
Admin Panel	🚧 Planned
Server API	🚧 Planned
Synchronization	🚧 Planned

Every new feature must directly improve the inventory counting process. Features that do not provide measurable value during inventory counting should be postponed unless they are required infrastructure (security, synchronization, permissions, etc.).
------------------------------------------------------------------------

# 1. Vision

Yelena Inventory is a professional cross-platform inventory management
system designed for multi-branch inventory counting and management.

Core principles:

-   Server-first architecture
-   Offline capable
-   Cross-platform
-   Clean Architecture
-   Scalable
-   Secure

------------------------------------------------------------------------

# 2. Supported Platforms

-   Android
-   iPhone (iOS)
-   Windows
-   Web (Chrome)

------------------------------------------------------------------------

# 3. Architecture Principles

The central server database is the **single source of truth**.

Local Drift/SQLite databases are used only for:

-   Offline work
-   Local cache
-   Temporary synchronization

------------------------------------------------------------------------

# 4. Technology Stack

## Frontend

-   Flutter
-   Riverpod
-   Material 3

## Local Storage

-   Drift
-   SQLite

## Planned Backend

-   ASP.NET Core
-   SQL Server
-   REST API
-   JWT Authentication

------------------------------------------------------------------------

# 5. Architecture

Presentation

↓

Riverpod

↓

Repositories

↓

Data Sources

↓

Local Drift

↓

Future REST API

↓

SQL Server

------------------------------------------------------------------------

# 6. Current Modules

Implemented

-   Responsive Design System
-   App Theme
-   AppFrame
-   Branch Selection
-   Employee Selection
-   Inventory Scan
-   Branch Management
-   Employee Management
-   Audit Log
-   Settings

------------------------------------------------------------------------

# 7. Planned Modules

-   Authentication (SMS)
-   Admin Panel
-   Managers
-   Roles
-   Permissions
-   Dashboard
-   Reports
-   Synchronization
-   Notifications
-   Device Management

------------------------------------------------------------------------

# 8. Core Business Entities

-   Company
-   Branch
-   Employee
-   Inventory Session
-   Inventory Item
-   Audit Log
-   Role
-   Permission
-   Device

------------------------------------------------------------------------

# 9. Authentication Vision

Administrator creates employee.

Employee receives SMS verification.

Phone becomes permanently linked.

Application always displays employee full name.

------------------------------------------------------------------------

# 10. Permissions

Roles planned:

-   Administrator
-   Branch Manager
-   Employee

Future permissions include:

-   Manage Branches
-   Manage Employees
-   Inventory
-   Reports
-   Audit Log
-   User Management

------------------------------------------------------------------------

# 11. Synchronization

Offline-first client.

Background synchronization.

Conflict resolution handled by server.

Server remains authoritative.

------------------------------------------------------------------------

# 12. Audit

Every important action is logged.

Examples:

-   Branch CRUD
-   Employee CRUD
-   Inventory save
-   Login
-   Permission changes
-   Synchronization

------------------------------------------------------------------------

# 13. UI Guidelines

-   One AppTheme
-   One AppFrame
-   Material 3
-   Responsive
-   Desktop centered
-   Minimal clicks
-   Large touch targets

------------------------------------------------------------------------

# 14. Roadmap

## Version 0.1 (Completed)

-   Cross-platform architecture
-   Drift
-   Branch Management
-   Employee Management
-   Audit Log
-   Responsive UI

## Version 0.2

-   Product Management
-   Inventory Sessions
-   Search
-   Validation improvements

## Version 0.3

-   SMS Authentication
-   Roles
-   Permissions
-   Admin Panel

## Version 0.4

-   ASP.NET Core Server
-   SQL Server
-   REST API
-   Synchronization

## Version 1.0

Production Release

------------------------------------------------------------------------

# 15. Development Principles

Every new feature must:

-   Respect Clean Architecture
-   Keep business logic out of UI
-   Use Repository pattern
-   Use Riverpod
-   Be cross-platform
-   Be ready for server synchronization

------------------------------------------------------------------------

# Future Documentation

To be added:

-   Entity Relationship Diagram (ERD)
-   API Specification
-   Synchronization Protocol
-   Security Model
-   Product Backlog
-   Release Notes
