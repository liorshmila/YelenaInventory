# Yelena Inventory ERD

## Relationship Diagram

```mermaid
erDiagram
    BRANCHES ||--o{ EMPLOYEE_BRANCHES : assigns
    EMPLOYEES ||--o{ EMPLOYEE_BRANCHES : belongs_through
    BRANCHES ||--o{ INVENTORY_COUNTS : counted_at
    EMPLOYEES o|--o{ INVENTORY_COUNTS : performed_by
    PRODUCTS ||--o{ INVENTORY_COUNTS : counted_as_events
    BRANCHES o|--o{ AUDIT_LOGS : contextualizes
    EMPLOYEES o|--o{ AUDIT_LOGS : performed_by

    BRANCHES {
        uuid id PK
        text name UK
        text branch_code UK
        boolean is_active
        timestamptz created_at
        timestamptz updated_at
    }

    EMPLOYEES {
        uuid id PK
        text name
        text phone UK
        text employee_code UK
        boolean is_active
        timestamptz created_at
        timestamptz updated_at
    }

    EMPLOYEE_BRANCHES {
        uuid id PK
        uuid employee_id FK
        uuid branch_id FK
        boolean is_active
        timestamptz created_at
        timestamptz updated_at
    }

    PRODUCTS {
        uuid id PK
        text barcode UK
        text name
        text notes
        text image_path
        boolean is_active
        timestamptz created_at
        timestamptz updated_at
    }

    INVENTORY_COUNTS {
        uuid id PK
        uuid product_id FK
        uuid branch_id FK
        uuid employee_id FK
        integer quantity
        timestamptz counted_at
        timestamptz created_at
        timestamptz updated_at
    }

    AUDIT_LOGS {
        uuid id PK
        text action
        text entity_type
        uuid entity_id
        uuid branch_id FK
        uuid employee_id FK
        jsonb details
        timestamptz created_at
        jsonb device_info
        text app_version
    }

    APP_SETTINGS {
        text key PK
        jsonb value
        timestamptz updated_at
    }
```

## Derived View

```text
products ─────┐
              ├── inventory_counts ── latest event per product + branch
branches ─────┤                         │
employees ────┘                         ▼
                                 current_inventory
```

`current_inventory` is a read-only derivation of inventory events. It does not
store a second copy of inventory state. It joins products, branches, and the
optional counting employee, filters inactive products and branches, and picks
one deterministic latest event for every product-and-branch pair.

`app_settings` is independent system metadata. `audit_logs.entity_id` is a
generic audited-entity reference and intentionally has no foreign key because
it may identify records of different entity types.
