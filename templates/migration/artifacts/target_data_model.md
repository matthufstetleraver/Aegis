---
schemaVersion: 1
generatedAt: <ISO-8601>
aegis:
  version: "x.y.z"
kind: target_data_model
producedBy: designer
hash: "sha256:<body hash below frontmatter>"
---

# Target Data Model

> Data model of new system. Schema, relationships and constraints.

## Overview
<Short text: type of primary database, division by bounded context, roles (OLTP / OLAP / event store).>

## Data entities

| Entity | Table / collection | Owner aggregate | PK | Bounded context |
|---|---|---|---|---|
| <name> | <ref> | <AGG> | <field> | <BC> |

## Schema (DDL or equivalent)

```sql
-- Replace with actual DDL of target system.
CREATE TABLE orders (
    id UUID PRIMARY KEY,
    customer_id UUID NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

## Relationships

| From | To | Cardinality | Integrity | Notes |
|---|---|---|---|---|
| orders.customer_id | customers.id | N:1 | FK ON DELETE RESTRICT | |

## Constraints

- **Uniqueness**: <list>
- **Referential integrity**: <enabled / disabled and why>
- **Partitioning / sharding** (if applicable): <description>
- **Critical indexes**: <list>

## Target paradigm-specific considerations

> Section dedicated when target paradigm is event-driven, functional, or other with direct data model implication.

- <ex: event-driven → outbox table for at-least-once guarantee>
- <ex: event sourcing → event store as source of truth, derived projections>
- <ex: immutability → immutable events / snapshots, no updates>

## Origin in legacy

| New table / collection | Origin in legacy | Transformation |
|---|---|---|
| orders | `<legacy schema>.tb_pedidos` | rename + normalized types |

## Notes
<Additional observations about the data model.>
