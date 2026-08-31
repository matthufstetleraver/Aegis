---
schemaVersion: 1
generatedAt: <ISO-8601>
aegis:
  version: "x.y.z"
kind: pending_decisions
producedBy: orchestrator
hash: "sha256:<hash of the body below the front-matter>"
---

# Pending Decisions

> Temporary file used during human pauses. Each item describes an open decision with context and options.
> After the user responds, the item is moved to `ambiguity_log.md` (or to the owning artifact) and this file can be deleted.

## Open decisions

### PD-001
- **Agent requesting**: paradigm_advisor | curator | strategist | designer | inspector
- **Topic**: <short title>
- **Context**:
  <text explaining why this decision is necessary here>
- **Options**:
  1. <option 1>
  2. <option 2>
  3. <option 3>
- **Proposed default** (used in `--auto`): <option number>
- **Impact if decided wrong**: <text>
- **Where the decision will be recorded**: <e.g., `paradigm_decision.md § User Decision`>

<repeat per decision>

## How to respond

- In chat: reply directly to the agent with the option number and justification.
- In file: edit this `pending_decisions.md`, adding a `Response:` field to each item.
