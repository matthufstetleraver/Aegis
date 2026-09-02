# Exploration Plan — {{PROJECT}}

> Created by Aegis Spec on {{DATE}}
> Mark each task with ✅ when completed.
> You can edit this plan before starting: add, remove, or reorder tasks as needed.

---

## Phase 1: Reconnaissance 🔍

- [ ] **Scout** — Mapping of folder structure and technologies
- [ ] **Scout** — Analysis of dependencies and package managers
- [ ] **Scout** — Identification of entry points, CI/CD and configurations

## Specs Organization Decision 🗂️

> Between Scout and Archaeologist, Aegis Spec asks how you want to organize specs (by module, use case, endpoint, hybrid, by features, or custom). The choice is persisted in `aegis/config/config.toml` under `[specs]` and will not be asked again in future runs. To reshow the menu, manually remove the section.

## Phase 2: Excavation 🏗️

> Aegis Spec fills this section with real modules after Scout completes the reconnaissance.

- [ ] **Archaeologist** — Analysis of modules identified by Scout

## Phase 3: Interpretation 🧠

- [ ] **Detective** — Git archaeology and retroactive ADRs
- [ ] **Detective** — Implicit business rules and state machines
- [ ] **Detective** — Permissions matrix (RBAC/ACL)
- [ ] **Architect** — C4 diagrams (Context, Containers, Components)
- [ ] **Architect** — Complete ERD and external integrations
- [ ] **Architect** — Spec Impact Matrix

## Phase 4: Generation 📝

- [ ] **Writer** — SDD specs per component
- [ ] **Writer** — OpenAPI (if applicable)
- [ ] **Writer** — User Stories (if applicable)
- [ ] **Writer** — Code/Spec Matrix

## Phase 5: Review ✅

- [ ] **Reviewer** — Cross review of specs
- [ ] **Reviewer** — Gap resolution with user
- [ ] **Reviewer** — Final confidence report

---

## Independent Agents

> Run these agents when resources are available — they can run in any phase.

- [ ] **Visor** — Interface analysis via screenshots
- [ ] **Data Master** — Complete database analysis
- [ ] **Design System** — Design token extraction
- [ ] **Tracer** — Dynamic analysis (requires system access)

---

## Next Step

After the Discovery Team completes and `aegis/specs/` is populated, you can trigger one of the following flows:

- `/aegis-migrate`: orchestrator of the **Migration Team** (Paradigm Advisor → Curator → Strategist → Designer → Inspector). Generates specs for the new system. Output in `aegis/migration/`.
- `/aegis-reconstructor`: generates bottom-up plan to reimplement the software from legacy specs (one task per session).
