---
schemaVersion: 1
generatedAt: <ISO-8601>
aegis-spec:
  version: "x.y.z"
kind: target_data_model
producedBy: designer
hash: "sha256:<hash do corpo abaixo do front-matter>"
---

# Target Data Model

> Data model of the new system. Schema, relationships, and constraints.

## Overview
<Short text: primary database type, division by bounded context, roles (OLTP / OLAP / event store).>

## Data entities

| Entity | Table / collection | Owning aggregate | PK | Bounded context |
|---|---|---|---|---|
| <name> | <ref> | <AGG> | <field> | <BC> |

## Schema (DDL or equivalent)

```sql
-- Substituir pelo DDL real do sistema alvo.
CREATE TABLE pedidos (
    id UUID PRIMARY KEY,
    cliente_id UUID NOT NULL,
    status TEXT NOT NULL,
    criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

## Relationships

| Source | Destination | Cardinality | Integrity | Notes |
|---|---|---|---|---|
| pedidos.cliente_id | clientes.id | N:1 | FK ON DELETE RESTRICT | |

## Constraints

- **Uniqueness**: <list>
- **Referential integrity**: <enabled / disabled and why>
- **Partitioning / sharding** (if applicable): <description>
- **Critical indexes**: <list>

## Target-paradigm-specific considerations

> Dedicated section when the target paradigm is event-driven, functional, or another paradigm with direct implications for the data model.

- <e.g. event-driven → outbox table for at-least-once guarantee>
- <e.g. event sourcing → event store as source of truth, derived projections>
- <e.g. immutability → immutable events / snapshots, no updates>

## Origin in the legacy system

| New table / collection | Origin in the legacy system | Transformation |
|---|---|---|
| pedidos | `<schema legado>.tb_pedidos` | rename + normalized types |

## Notes
<Additional observations about the data model.>
