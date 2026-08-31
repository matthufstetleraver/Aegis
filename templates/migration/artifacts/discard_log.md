---
schemaVersion: 1
generatedAt: <ISO-8601>
aegis:
  version: "x.y.z"
kind: discard_log
producedBy: curator
hash: "sha256:<hash of the body below the front-matter>"
---

# Discard Log

> Complete record of what was discarded from the migration and why. Each item has traceability to the origin in the legacy system.

## Discarded items

### BR-DISCARD-001
- **Source**: `aegis/specs/sdd/<unit>/{requirements,design}.md` § <section>
- **Description**: <rule or discarded behavior>
- **Justification**: <text>
- **Linked to paradigm**: yes | no
  - If yes: <which paradigm and how the target paradigm absorbs the case>
- **Replacement in the new system**: <none | replaced by X>
- **Risk of discarding**: low | medium | high, with explanatory note

<repeat per item>

## Items discarded due to paradigm shift (dedicated subsection)

> Lists only items where `Linked to paradigm = yes`. Explicit audit for the coding agent.

| ID | Source | Legacy paradigm | Replacement in target paradigm |
|---|---|---|---|
| BR-DISCARD-XXX | <ref> | <e.g., pessimistic synchronous locking> | <e.g., idempotency via event ID> |

## Notes
<Final observations from the Curator about the discarded set.>
