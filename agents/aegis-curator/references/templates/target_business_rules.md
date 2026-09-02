---
schemaVersion: 1
generatedAt: <ISO-8601>
aegis-spec:
  version: "x.y.z"
kind: target_business_rules
producedBy: curator
hash: "sha256:<hash do corpo abaixo do front-matter>"
---

# Target Business Rules

> Catalog of legacy business rules with a migration decision: MIGRATE, DISCARD, or HUMAN DECISION.
> Each item traces back to its origin in `aegis/` and respects `paradigm_decision.md`.

## Summary
- Total rules analyzed: <N>
- MIGRATE: <n>
- DISCARD: <n> (details in `discard_log.md`)
- HUMAN DECISION: <n>

## MIGRATE rules

### BR-MIGRAR-001
- **Origin**: `aegis/specs/sdd/<unit>/{requirements,design}.md` § <section>
- **Original confidence**: 🟢 | 🟡 | 🔴 | ⚠️
- **Description**: <rule>
- **Migration justification**: <why it migrates>
- **Compatibility with target paradigm**: <note; e.g. it will need to be expressed as an event>

<repeat for each rule>

## DISCARD rules (summary)

| ID | Origin | Short reason | Linked to paradigm? |
|---|---|---|---|
| BR-DESCARTAR-001 | <ref> | <reason> | yes/no |

> Full detail in `discard_log.md`.

## HUMAN DECISION rules

### BR-HUMANA-001
- **Origin**: <ref>
- **Type of ambiguity**: ⚠️ AMBIGUOUS | 🔴 GAP | stakeholder dependency
- **Description**: <rule>
- **Options**: <clear options>
- **Curator recommendation**: <suggested option and why>
- **Status**: PENDING | RESOLVED (choice + decision-maker + date)

<repeat for each item>

## Notes
<General Curator observations. Items that will be consolidated in `ambiguity_log.md`.>
