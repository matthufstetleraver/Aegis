---
schemaVersion: 1
kind: migration_strategies
description: Advisory catalog of migration strategies with applicability criteria. Used by Strategist.
---

# Migration Strategies

> Catalog of canonical migration strategies with applicability criteria, cost, risk, time, example, and references.
> Updating this catalog is an independent maintenance task of the Strategist agent.

## Strategies

### Strangler Fig
- **Description**: New system grows around legacy, capturing functionality incrementally until legacy can be shut down.
- **When to apply**:
  - Production system that cannot stop.
  - Need for incrementality.
  - Possibility of routing between old and new (proxy / API gateway).
- **Cost**: medium.
- **Risk**: low (partial rollback is viable).
- **Time**: long (months to years in large systems).
- **Favorable appetite**: conservative, balanced.
- **Example**: API gateway redirects `/v2/orders/*` endpoints to new system while `/orders/*` continues in legacy.
- **References**: Martin Fowler, "StranglerFigApplication"; Sam Newman, "Monolith to Microservices".

### Big Bang
- **Description**: Complete replacement in a single cutover window.
- **When to apply**:
  - Small system.
  - Maintenance window tolerated.
  - High transformational appetite.
  - Low number of live external integrations.
- **Cost**: low (no maintenance of two versions).
- **Risk**: high (complete rollback is expensive; failure takes down service).
- **Time**: short.
- **Favorable appetite**: transformational (in small systems).
- **Example**: internal tool used by 50 people migrated in one night with documented rollback.
- **References**: described in various migration frameworks; high correlation with historical failures in large systems.

### Parallel Run
- **Description**: Legacy and new run in parallel receiving same input; output compared to detect divergences.
- **When to apply**:
  - Critical logic (financial, fiscal, regulatory).
  - Need for proof of equivalence over long period.
  - Large paradigm shift + high transformational appetite (high operational risk).
- **Cost**: high (two stacks operating simultaneously; output comparison).
- **Risk**: medium (risks come from dual operation, not from cutover).
- **Time**: medium.
- **Favorable appetite**: balanced.
- **Example**: tax calculation running in legacy and new for 60 days; cutover only after divergence < 0.01%.
- **References**: Michael Nygard, "Release It!"; common in banking and fiscal systems.

### Branch by Abstraction
- **Description**: Internal refactoring of legacy to introduce abstraction that allows swapping implementation underneath, then replace.
- **When to apply**:
  - Internal migration (language or framework changes, but domain stays).
  - Conservative appetite.
  - Team already inside legacy, with code domain knowledge.
- **Cost**: low.
- **Risk**: low.
- **Time**: medium.
- **Favorable appetite**: conservative.
- **Example**: extract `OrderRepository` interface in legacy, leave old and new implementations chosen by flag, then remove old one.
- **References**: Paul Hammant, "Branch By Abstraction".

## Quick Comparison

| Strategy | When to apply | Cost | Risk | Time |
|---|---|---|---|---|
| Strangler Fig | production system, cannot stop | medium | low | long |
| Big Bang | small system, controlled window, transformational appetite | low | high | short |
| Parallel Run | critical logic (financial / fiscal) | high | medium | medium |
| Branch by Abstraction | internal refactoring before migration | low | low | medium |

## Paradigm Influence on Choice

- **`conservative` appetite** → favors Branch by Abstraction and Strangler Fig.
- **`balanced` appetite** → favors Strangler Fig and Parallel Run.
- **`transformational` appetite** → allows Big Bang in small systems, Strangler Fig with deep edges in larger systems.
- **Large paradigm shift + transformational appetite** → signal `high operational divergence risk` and recommend Parallel Run for validation.

## Utility Function (use by Strategist)

Pseudo-procedure that the agent follows when consulting the catalog:

1. Receive `migration_brief` (scope, timeline, constraints) + `derived_appetite` + `paradigm gap`.
2. Filter strategies by applicability (drop-out those that clearly don't fit).
3. Score each remaining strategy by adherence to appetite and gap.
4. Select the 2 to 3 best candidates.
5. Mark one as `recommended` with explicit justification.
6. For each remaining strategy, list drawbacks as reasons for non-recommendation.

## Catalog Test Scenarios

1. brief = banking system in production, conservative appetite → recommend Strangler Fig + Branch by Abstraction.
2. brief = internal tool 50 users, transformational appetite → recommend Big Bang.
3. brief = fiscal system, balanced appetite, high paradigm shift → recommend Parallel Run + Strangler Fig.
4. brief = monolithic Rails to Go microservices, transformational appetite, large paradigm shift → recommend Strangler Fig with deep edges, signal operational risk, suggest Parallel Run for critical domains.
5. brief = .NET WebForms to Blazor, balanced appetite, no large paradigm shift → recommend Strangler Fig.
6. brief = legacy system with few integrations, tolerated maintenance window, balanced appetite → recommend Big Bang with robust rollback plan, alternative Strangler Fig.
