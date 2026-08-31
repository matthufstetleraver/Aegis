---
schemaVersion: 1
generatedAt: <ISO-8601>
aegis:
  version: "x.y.z"
kind: cutover_plan
producedBy: strategist
hash: "sha256:<body hash below frontmatter>"
---

# Cutover Plan

> Plan to cut over from legacy to new system, aligned to the strategy chosen in `migration_strategy.md`.

## Base strategy
- **Confirmed strategy**: <reference to migration_strategy.md>

## Prerequisites
- [ ] <prerequisite 1: ex. behavioral parity ≥ X% for N days>
- [ ] <prerequisite 2>
- [ ] <prerequisite 3>

## Cutover window
- **Target date**: <ISO-8601 or window>
- **Estimated duration**: <hours>
- **Affected environment**: <production / staging / other>
- **Prior communication**: <stakeholders notified, deadline>

## Cutover steps

| # | Step | Owner | Duration | Reversible? |
|---|---|---|---|---|
| 1 | <ex: freeze writes to legacy> | | | |
| 2 | <ex: final data ETL> | | | |
| 3 | <ex: DNS routing> | | | |
| 4 | <ex: smoke tests on new> | | | |

## Rollback plan
- **Trigger criteria**: <when rollback is decided>
- **Steps**:
  1. <step>
  2. <step>
- **Maximum acceptable time to rollback**: <minutes / hours>
- **Rollback owner**: <name / role>

## Go / no-go criteria
- **Go**:
  - <criterion 1>
  - <criterion 2>
- **No-go**:
  - <criterion 1>
  - <criterion 2>

## Post-cutover
- [ ] Extended monitoring for <period>
- [ ] Parity validation per `parity_specs.md`
- [ ] Decommission legacy at <date>

## Notes
<Additional observations.>
