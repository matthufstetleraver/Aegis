---
schemaVersion: 1
generatedAt: <ISO-8601>
aegis-spec:
  version: "x.y.z"
kind: handoff
producedBy: orchestrator
hash: "sha256:<hash do corpo abaixo do front-matter>"
---

# Handoff to the Coding Agent

> This document is the entry point for the coding agent (Claude Code, Codex, Cursor, Antigravity, etc.) that will write the new system from the specs.

## ⚠️ Mandatory reading first

1. **`paradigm_decision.md`**, non-negotiable reading. The target paradigm shapes how all coding must happen.
2. **`topology_decision.md`**, non-negotiable reading. The chosen topology (preserve / modernize / hybrid) defines the folder tree and the boundary between modules.

## Recommended reading order

1. `paradigm_decision.md` (mandatory, first)
2. `topology_decision.md` (mandatory, second)
3. `migration_brief.md`
4. `target_business_rules.md`
5. `migration_strategy.md`
6. `target_architecture.md`
7. `target_domain_model.md`
8. `target_data_model.md`
9. `data_migration_plan.md`
10. `parity_specs.md` + `parity_tests/`
11. `risk_register.md` + `cutover_plan.md`
12. `discard_log.md` (advisory)
13. `ambiguity_log.md` (advisory)

## List of produced artifacts

| Artifact | Produced by | Status |
|---|---|---|
| migration_brief.md | orchestrator | created |
| paradigm_decision.md | paradigm_advisor | created |
| target_business_rules.md | curator | created |
| discard_log.md | curator | created |
| migration_strategy.md | strategist | created |
| risk_register.md | strategist | created |
| cutover_plan.md | strategist | created |
| topology_decision.md | designer (Phase 1) | created |
| target_architecture.md | designer | created |
| target_domain_model.md | designer | created |
| target_data_model.md | designer | created |
| data_migration_plan.md | designer | created |
| parity_specs.md | inspector | created |
| parity_tests/*.feature | inspector | <N> files |
| ambiguity_log.md | orchestrator | consolidated |

## Blockers to start implementation
> Items that need human decision before the coding agent starts.

- <AMB-XXX: short description + where to decide>
- <or: no blockers, proceed>

## Next steps for the coding agent

1. **Read and internalize `paradigm_decision.md`**: the target paradigm is <from paradigm_decision>. Every code choice must honor this paradigm.
2. **Read and internalize `topology_decision.md`**: the chosen topology is <preserve | modernize | hybrid>. Use the tree sketch recorded in this artifact as the basis for creating the folder structure of the new repository.
3. **Set up the new repository** with the stack declared in `migration_brief.md` and the decided topology.
4. **Implement bottom-up** following `target_architecture.md` and `target_domain_model.md`:
   - infrastructure → data → domain → application → boundaries.
5. **Write the tests** from `parity_specs.md` and `parity_tests/*.feature` from the start.
6. **For each component**, validate that it respects the chosen paradigm (explicit signals in `target_architecture.md § Adherence to the chosen paradigm`) and the chosen topology (explicit signals in `target_architecture.md § Adherence to the chosen topology`).
7. **For data migration**, follow `data_migration_plan.md`.
8. **For cutover**, follow `cutover_plan.md` and the go/no-go criteria.

## Auto-decided items (only if run with --auto)
> List here items whose default was applied without human confirmation. Reviewing them before cutover is recommended.

- <or: pipeline ran in interactive mode, no auto-decided items>

## Final notes
<Orchestrator observations for the coding agent.>
