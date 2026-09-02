---
schemaVersion: 1
generatedAt: <ISO-8601>
aegis:
  version: "x.y.z"
kind: target_business_rules
producedBy: curator
hash: "sha256:<body hash below frontmatter>"
---

# Target Business Rules

> Catalog of legacy business rules with migration decision: MIGRATE, DISCARD, or HUMAN DECISION.
> Each item tracks to origin in `aegis/` and respects `paradigm_decision.md`.

## Summary
- Total rules analyzed: <N>
- MIGRATE: <n>
- DISCARD: <n> (details in `discard_log.md`)
- HUMAN DECISION: <n>

## MIGRATE Rules

### BR-MIGRATE-001
- **Origin**: `aegis/specs/sdd/<unit>/{requirements,design}.md` § <section>
- **Original confidence**: 🟢 | 🟡 | 🔴 | ⚠️
- **Description**: <rule>
- **Migration justification**: <why it migrates>
- **Compatibility with target paradigm**: <note; ex: will need to be expressed as event>

<repeat per rule>

## DISCARD Rules (summary)

| ID | Origin | Short reason | Linked to paradigm? |
|---|---|---|---|
| BR-DISCARD-001 | <ref> | <reason> | yes/no |

> Full details in `discard_log.md`.

## HUMAN DECISION Rules

### BR-HUMAN-001
- **Origin**: <ref>
- **Type of ambiguity**: ⚠️ AMBIGUOUS | 🔴 GAP | stakeholder dependency
- **Description**: <rule>
- **Options**: <clear options>
- **Curator recommendation**: <suggested option and why>
- **Status**: PENDING | RESOLVED (choice + decider + date)

<repeat per item>

## Notes
<General observations from Curator. Items that will be consolidated in `ambiguity_log.md`.>
