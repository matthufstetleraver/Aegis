---
schemaVersion: 1
generatedAt: <ISO-8601>
aegis-spec:
  version: "x.y.z"
kind: migration_brief
producedBy: orchestrator
hash: "sha256:<hash do corpo abaixo do front-matter>"
---

# Migration Brief

> Migration criteria document collected during the interview at the start of `/aegis-migrate`.
> Consumed by the five Migration Team agents. It does not ask about paradigm (Paradigm Advisor responsibility) or appetite (derived in `paradigm_decision.md`).

## Migration objective
<Why does this migration exist? What changes in the business if it happens or if it does not.>

## Success metrics
- <metric 1, with a clear numeric or qualitative target>
- <metric 2>
- <metric 3>

## Constraints
- **Deadline**: <date or window>
- **Budget**: <range, team, hiring involved>
- **Technical**: <external APIs that cannot change, contracts, regulatory rules>
- **Operational**: <maintenance windows, SLAs during migration>

## Known risk factors
- <risk 1: short description>
- <risk 2>

## Stakeholders
| Name / role | Responsibility in the migration |
|---|---|
| <name> | <responsibility> |

## Target stack
- **Language**: <e.g. Node.js 20>
- **Framework**: <e.g. Fastify>
- **Database**: <e.g. PostgreSQL 16>
- **Messaging** (if any): <e.g. SQS, Kafka, none>
- **Infrastructure**: <e.g. AWS Lambda, Kubernetes, on-premise>
- **Other relevant components**: <cache, observability, gateway>

## Declared scope
- **Included**: <legacy modules included>
- **Excluded**: <modules left out or to be discontinued>

## Freeform notes
<Any context the user wants to record for the agents to read.>
