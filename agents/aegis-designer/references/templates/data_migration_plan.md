---
schemaVersion: 1
generatedAt: <ISO-8601>
aegis-spec:
  version: "x.y.z"
kind: data_migration_plan
producedBy: designer
hash: "sha256:<hash do corpo abaixo do front-matter>"
---

# Data Migration Plan

> Migration plan for data from the legacy system to the new system: mapping, transformations, ETL, data cutover, and validation.

## Summary
- Estimated volume: <rows / GB per main entity>
- Migration window: <see `cutover_plan.md`>
- Strategy: prior backfill + delta + cutover | single bulk load | continuous replication

## Legacy → new mapping

| Source | Destination | Type | Notes |
|---|---|---|---|
| `<schema legado>.tb_pedidos` | `pedidos` | rename | type normalization |
| `<schema legado>.tb_pedido_item` | `pedido_itens` | rename | adjusted FK |
| `<schema legado>.usr_x` | `usuarios` (partial) + `perfis` | split | extracts profile data |

## Transformations

### Transformation T-01: <name>
- **Applies to**: <column or table>
- **Rule**: <explicit text>
- **Invalid data handling**: <discard | reject | fill with default>
- **Rule source**: <reference to `target_business_rules.md` or `discard_log.md`>

<repeat for each transformation>

## ETL strategy

- **Tool**: <e.g. SQL scripts, dbt, Airbyte, custom>
- **Flow**:
  1. <extraction>
  2. <transformation>
  3. <load>
- **Idempotency**: <how the ETL is safe to rerun>
- **Expected throughput**: <e.g. 50k rows/s>

## Backfill and delta

- **Backfill**: <initial date, scope, duration>
- **Delta capture**:
  - **Mechanism**: CDC | log mining | timestamps | replication | trigger
  - **Acceptable latency**: <seconds>
- **Periodic reconciliation**: <frequency, scope>

## Data cutover

> See also `cutover_plan.md`. Only the data-specific part belongs here.

- **Window**: <ISO-8601>
- **Cutover sequence**:
  1. <step>
  2. <step>
- **Post-cutover verification**:
  - **Counts**: <which tables, tolerance>
  - **Checksums**: <critical columns>

## Quality validation

| Metric | Target | Measurement source |
|---|---|---|
| Count by entity | equal ± 0% | direct comparison |
| Sum of monetary values | equal ± 0.01% | financial reconciliation |
| Referential integrity | 0 orphans | audit scripts |

## Data-specific risks
- <RISK-XXX: see `risk_register.md`>

## Notes
<Additional observations.>
