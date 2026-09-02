---
schemaVersion: 1
generatedAt: <ISO-8601>
aegis-spec:
  version: "x.y.z"
kind: ambiguity_log
producedBy: orchestrator
hash: "sha256:<hash do corpo abaixo do front-matter>"
---

# Ambiguity Log

> Consolidation of all ⚠️ AMBIGUOUS or pending items detected by the agents throughout the pipeline.
> Expected final status when the pipeline completes: no PENDING items.

## Summary
- Total items: <N>
- PENDING: <n>
- RESOLVED WITH HUMAN DECISION: <n>
- REFERRED TO CODING: <n>

## Items

### AMB-001
- **Description**: <text>
- **Detected by**: paradigm_advisor | curator | strategist | designer | inspector
- **Origin**: <reference to artifact and section>
- **Status**: PENDING | RESOLVED WITH HUMAN DECISION | REFERRED TO CODING
- **Decision made** (if any):
  - **Choice**: <text>
  - **Decision-maker**: <name>
  - **When**: <ISO-8601>
  - **Justification**: <text>

<repeat for each item>

## Items referred to coding
> Lists only items with status `REFERRED TO CODING`. They appear highlighted in `handoff.md`.

- AMB-XXX: <short description>

## Notes
<Final orchestrator observations.>
