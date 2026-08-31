---
schemaVersion: 1
generatedAt: <ISO-8601>
aegis:
  version: "x.y.z"
kind: ambiguity_log
producedBy: orchestrator
hash: "sha256:<body hash below frontmatter>"
---

# Ambiguity Log

> Consolidation of all ⚠️ AMBIGUOUS or pending items detected by agents throughout the pipeline.
> Expected final status when pipeline completes: no PENDING items.

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
  - **Decider**: <name>
  - **When**: <ISO-8601>
  - **Justification**: <text>

<repeat per item>

## Items referred to coding
> List only items with status `REFERRED TO CODING`. They appear highlighted in `handoff.md`.

- AMB-XXX: <short description>

## Notes
<Final observations from orchestrator.>
