# `handoff.md` checklist

Before closing the pipeline, the orchestrator validates that `handoff.md` satisfies all items.

## Mandatory checklist

- [ ] `paradigm_decision.md` appears as the **first item** in the "Mandatory reading" section and in the "Recommended reading order".
- [ ] The list of produced artifacts is complete and reflects the real `aegis/migration/`.
- [ ] CODING-REFERRED items from `ambiguity_log.md` appear in a dedicated section of `handoff.md`.
- [ ] Blockers are listed or the line "no blockers, proceed" is present.
- [ ] Next steps for the coding agent are specific and actionable (not generic).
- [ ] In `--auto`: auto-decided items are listed explicitly.
- [ ] Style is consistent with the installed engine (adapted format, e.g. compatible front matter).

## Minimum structure

1. `paradigm_decision.md` mandatory reading banner.
2. Recommended reading order.
3. Artifact list.
4. Blockers.
5. Next steps for the coding agent.
6. Auto-decided items (only if `--auto`).
7. Final notes.

## Strong signaling to the coding agent

The first sentence of `handoff.md` should provide immediate clarity. Suggested pattern:

> "New system to be built in paradigm <X>. Before writing any line of code, read `paradigm_decision.md`."
