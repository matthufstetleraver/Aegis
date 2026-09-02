---
schemaVersion: 1
generatedAt: <ISO-8601>
aegis-spec:
  version: "x.y.z"
kind: discard_log
producedBy: curator
hash: "sha256:<hash do corpo abaixo do front-matter>"
---

# Discard Log

> Complete record of what was discarded from the migration and why. Each item has traceability to its origin in the legacy system.

## Discarded items

### BR-DESCARTAR-001
- **Origin**: `aegis/specs/sdd/<unit>/{requirements,design}.md` § <section>
- **Description**: <discarded rule or behavior>
- **Justification**: <text>
- **Linked to paradigm**: yes | no
  - If yes: <which paradigm and how the target paradigm absorbs the case>
- **Replacement in the new system**: <none | replaced by X>
- **Risk of discarding**: low | medium | high, with explanatory note

<repeat for each item>

## Items discarded because of paradigm change (dedicated subsection)

> Lists only the items whose `Linked to paradigm = yes`. Explicit audit for the coding agent.

| ID | Origin | Legacy paradigm | Replacement in the target paradigm |
|---|---|---|---|
| BR-DESCARTAR-XXX | <ref> | <e.g. synchronous pessimistic lock> | <e.g. idempotency via event ID> |

## Notes
<Curator's final observations about the discarded set.>
