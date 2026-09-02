---
schemaVersion: 1
generatedAt: <ISO-8601>
aegis:
  version: "x.y.z"
kind: migration_brief
producedBy: orchestrator
hash: "sha256:<body hash below frontmatter>"
---

# Migration Brief

> Migration criteria document collected in interview at start of `/aegis-migrate`.
> Consumed by five agents on Migration Team. Does not ask paradigm (responsibility of Paradigm Advisor) nor appetite (derived in `paradigm_decision.md`).

## Migration objective
<Why does this migration exist? What changes in the business if it happens or not.>

## Success metrics
- <metric 1, with clear numeric or qualitative target>
- <metric 2>
- <metric 3>

## Constraints
- **Timeline**: <date or window>
- **Budget**: <range, team, hiring involved>
- **Technical**: <external APIs that cannot change, contracts, regulatory rules>
- **Operational**: <maintenance windows, SLAs during migration>

## Known risk factors
- <risk 1: short description>
- <risk 2>

## Stakeholders
| Name / role | Responsibility in migration |
|---|---|
| <name> | <responsibility> |

## Target stack
- **Language**: <ex: Node.js 20>
- **Framework**: <ex: Fastify>
- **Database**: <ex: PostgreSQL 16>
- **Messaging** (if any): <ex: SQS, Kafka, none>
- **Infrastructure**: <ex: AWS Lambda, Kubernetes, on-premise>
- **Other relevant components**: <cache, observability, gateway>

## Declared scope
- **Included**: <legacy modules that enter>
- **Excluded**: <modules that stay out or will be discontinued>

## Free notes
<Any context the user wants to record for the agents to read.>
