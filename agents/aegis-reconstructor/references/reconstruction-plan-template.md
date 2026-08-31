# Reconstruction Plan — {{PROJECT_NAME}}

**Stack:** {{STACK}}
**Generated on:** {{DATE}}
**Status:** {{TOTAL}} tasks | {{DONE}} completed | {{PENDING}} pending

---

## Preflight alerts

> Review these points before starting. Gaps marked with ⚠️ block the associated task.

{{#each PREFLIGHT_ALERTS}}
- ⚠️ **{{this.gap}}** — blocks Task {{this.task_number}} ({{this.task_name}})
{{/each}}

{{#if NO_ALERTS}}
No critical gap identified. You can start safely.
{{/if}}

---

## Tasks

### Task 01 — Database Schema
**Status:** pending
**Reads:** `aegis/architecture/erd-complete.md`, `aegis/reports/data-dictionary.md`
**Builds:** migrations, schema, ORM models (according to the detected stack)
**Ready when:** All ERD tables exist with correct types, constraints, and foreign keys

---

### Task 02 — Domain Entities
**Status:** pending
**Reads:** `aegis/reports/domain.md`, `aegis/reports/data-dictionary.md`
**Builds:** entities, value objects, domain validations
**Ready when:** All entities are implemented with the described business rules

---

### Task 03 — State Machines
**Status:** pending
**Reads:** `aegis/reports/state-machines.md`
**Builds:** implementation of the state flows for each entity
**Ready when:** All documented states and transitions are implemented
**Note:** Skip this task if `aegis/reports/state-machines.md` does not exist

---

<!-- COMPONENT_TASKS_START -->
<!-- The Reconstructor inserts one task per unit here, in the bottom-up order determined by dependencies.md -->
<!-- Example unit task: -->

### Task 04 — [Unit Name]
**Status:** pending
**Reads:** `aegis/specs/sdd/[unit]/requirements.md`, `aegis/specs/sdd/[unit]/design.md`, `aegis/specs/sdd/[unit]/tasks.md`, `aegis/reports/dependencies.md`
**Builds:** [module path according to stack]
**Ready when:** [acceptance criterion extracted from requirements.md, field "Given/When/Then"]
**Alert:** [if there is an associated gap, describe it here]

<!-- COMPONENT_TASKS_END -->

---

### Task {{API_N}} — API Layer
**Status:** pending
**Reads:** `aegis/specs/openapi/[list of files]`
**Builds:** endpoints, controllers, middlewares, authentication
**Ready when:** All endpoints respond according to the OpenAPI contracts

---

### Task {{STORIES_N}} — User Flows
**Status:** pending
**Reads:** `aegis/specs/user-stories/[list of files]`
**Builds:** end-to-end integration, complete user flows
**Ready when:** All user story acceptance criteria are satisfied
