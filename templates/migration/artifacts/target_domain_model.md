---
schemaVersion: 1
generatedAt: <ISO-8601>
aegis:
  version: "x.y.z"
kind: target_domain_model
producedBy: designer
hash: "sha256:<body hash below frontmatter>"
---

# Target Domain Model

> Domain model of new system. Explicit traceability to legacy (in `aegis/reports/domain.md` or equivalent).

## Aggregates

### AGG-Order
- **Aggregate root**: Order
- **Invariants**:
  - <invariant 1>
  - <invariant 2>
- **Accepted commands**: <list>
- **Published events** (if paradigm is event-driven): <list>
- **Origin in legacy**: <ref to `domain.md` or equivalent>

<repeat per aggregate>

## Entities

| Entity | Owner aggregate | Main attributes | Origin in legacy |
|---|---|---|---|
| <name> | <agg> | <summary list> | <ref> |

## Value objects

| Value object | Attributes | Validations | Origin |
|---|---|---|---|
| <name> | <list> | <rules> | <ref> |

## Domain events
> Mandatory section if paradigm is event-driven or hybrid.

| Event | Published by | Consumed by | Schema (summary) |
|---|---|---|---|
| <OrderCreated> | AGG-Order | Payment, Inventory | <fields> |

## Domain rules
> Mapping of rules from `target_business_rules.md` (only MIGRATE) to aggregates / services where they now live.

| Rule (ID) | Location in new domain | Origin (target_business_rules.md) |
|---|---|---|
| BR-MIGRATE-001 | AGG-Order.invariant <name> | BR-MIGRATE-001 |

## Traceability to legacy

| New element | Origin in legacy | Type of mapping |
|---|---|---|
| AGG-Order | `domain.md § Order` + `sdd/orders.md` | merged |
| <new> | <ref> | 1-to-1 / merged / split / new |

## Notes
<Additional modeling observations.>
