---
schemaVersion: 1
generatedAt: <ISO-8601>
aegis:
  version: "x.y.z"
kind: parity_specs
producedBy: inspector
hash: "sha256:<body hash below frontmatter>"
---

# Parity Specs

> Strategy for validating behavioral equivalence between legacy and new system, adapted to paradigm chosen in `paradigm_decision.md`.

## General strategy
- **Applicable validation modes** (mark the ones used):
  - [ ] Shadow mode (traffic mirroring with async comparison)
  - [ ] Characterization tests (suite derived from current legacy behavior)
  - [ ] Contract tests (external interfaces)
  - [ ] Data parity (snapshots and checksums)
  - [ ] Other: <specify>

## "Parity accepted" criteria
- **Primary metric**: <ex: functional divergence index < 0.01% on N consecutive days>
- **Observation window**: <evaluation period>
- **Blocking criterion**: <when insufficient parity blocks cutover>

## Coverage adapted to paradigm

> This section changes based on the target paradigm confirmed in `paradigm_decision.md`.

### No paradigm change
- Standard functional equivalence: same input → same output → same observable side effect.

### Sync → event-driven change
- **Message order**: <acceptance criterion per channel / partition>
- **Idempotency**: <proof that reprocessing does not duplicate effect>
- **Eventual consistency**: <maximum propagation window accepted>
- **Behavior under queue failure**: <retry, DLQ, replay>

### Procedural → OO change
- **Invariants in aggregates**: <set to validate>
- **Validation in factories / constructors**: <critical cases>

### OO → functional change
- **Immutability**: <critical points to observe>
- **Absence of expected side effects**: <where legacy had implicit side effect>
- **Equivalence under composition**: <composed functions equivalent to legacy flow>

## Test types to apply
- **Functional**: <description, tool>
- **Contract**: <description, tool>
- **Load / performance**: <description, targets>
- **Resilience** (if applicable): <queue failure, external dependency unavailable>

## Reuse of discovery team's characterization_specs
- **Origin**: `aegis/specs/characterization_specs/` or equivalent available.
- **Necessary adaptations for new system**: <text>

## Outputs
- `parity_tests/*.feature`: scenarios in Gherkin for critical flows.

## Notes
<Additional observations.>
