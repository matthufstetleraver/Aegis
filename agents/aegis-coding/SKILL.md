---
name: aegis-coding
description: Executes actions.md in code. Updates checkboxes to [X], writes progress.jsonl, and generates legacy-impact.md and regression-watch.md. Use when the user types "/aegis-coding", "aegis-coding", "execute plan", or asks to start coding the active feature. Final skill in the forward cycle, after `/aegis-to-do` (and optionally `/aegis-audit` or `/aegis-quality`).
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI, and other Agent Skills-compatible agents.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: aegis-spec
  phase: forward
  stage: coding
---

You are the executor. Your mission is to turn `actions.md` into real code, phase by phase, respecting parallelism and dependencies. When finished, leave two trails for future audit: `legacy-impact.md` (what changed in the legacy) and `regression-watch.md` (what must keep holding true in later extractions).

## Before you start

1. Read `aegis/config/state.json` to resolve `output_folder` and `forward_folder`
2. Use the real values wherever the text mentions `aegis/` or `aegis/forward/`

## Non-negotiable prerequisite: specification extraction

This skill **REQUIRES** the discovery pipeline to have run at least once. Without `aegis/`, the two core artifacts (`legacy-impact.md` and `regression-watch.md`) have no anchor and lose their value; the forward cycle becomes a generic framework. Aegis Spec only makes sense with the legacy-code bridge alive.

The check is strict: `aegis/` must exist as a directory AND contain at least `architecture.md` AND `domain.md`. If any condition fails, the skill aborts with a clear message, does NOT offer to continue anyway, and writes nothing to disk.

## Initial checks

1. Read `aegis/config/active-requirements.json`
   1.1. If missing, abort with a message pointing to `/aegis-requirements`
2. Verify the existence of `feature-dir/actions.md`
   2.1. If missing, abort with a message pointing to `/aegis-to-do`
3. Verify the specification-extraction prerequisite:
   3.1. If `aegis/` does not exist as a directory, abort with the message:

       > 🛑 `/aegis-coding` exige a pipeline de descoberta executada antes. A pasta `aegis/` não foi encontrada.
       >
       > Run `/aegis` to generate the legacy extraction, then come back here. Without that context, `legacy-impact.md` and `regression-watch.md` would have no anchor and the forward cycle would lose its edge.

   3.2. If `aegis/` exists but `aegis/architecture/architecture.md` is missing, abort with the message:

       > 🛑 `/aegis-coding` exige `aegis/architecture/architecture.md` (gerado pelo Architect na pipeline de descoberta). O arquivo está ausente, talvez a extração tenha sido parcial.
       >
       > Run `/aegis` in full mode (minimum `essencial`) and come back here.

   3.3. If `aegis/architecture/architecture.md` exists but `aegis/reports/domain.md` is missing, abort with the message:

       > 🛑 `/aegis-coding` exige `aegis/reports/domain.md` (gerado pelo Detective na pipeline de descoberta). O arquivo está ausente.
       >
       > Run `/aegis` to complete the extraction and come back here.

   3.4. In all step 3 cases, do NOT create `legacy-impact.md`, do NOT create `regression-watch.md`, do NOT touch `actions.md`, and do NOT write `progress.jsonl`. Only report and stop.

4. Apply `before-coding` using the standard flow

## Round scope

1. If the freeform argument indicates a phase or ID range (e.g. "only Core", "T001-T005"), restrict execution to that scope
2. Otherwise, run all remaining `[ ]` actions in order

## Phase execution loop

For each phase, in the order Preparation, Tests, Core, Integration, Polish:

1. Select all `[ ]` actions in the phase
2. Calculate the independent set (actions without open dependencies)
3. For the independent set, identify the `[//]` subset
   3.1. Execute that subset treating each action as a coherent block, but report per item
4. Execute the remaining actions sequentially
5. After each action:
   5.1. Update `feature-dir/actions.md` by changing `[ ]` to `[X]`
   5.2. Write a line to `feature-dir/progress.jsonl` with ISO 8601 timestamp, action ID, final status, and touched files
6. If an action fails:
   6.1. Keep `[ ]` in actions
   6.2. Record `status: failed` in progress
   6.3. Stop the phase and report to the user

## Generating legacy-impact.md

After running (even partially):

1. For each touched project file, map it to the corresponding component in `aegis/architecture/architecture.md` when possible
2. For each affected component, classify the impact type: `rule-changed`, `rule-removed`, `new-rule`, `new-component`, `removed-component`, `data-delta`, `external-contract-delta`
3. Assign severity aligned with `/aegis-audit` (CRITICAL, HIGH, MEDIUM, LOW)
4. List 🟢 rules from `aegis/reports/domain.md` that remain intact (go in "Preserved")
5. List 🟢 rules that were changed or removed (go in "Modified")

File structure:

1. Header with date and feature identifier
2. Table `Affected file | Component | Type | Severity | Justification`
3. Conceptual diff by component, in prose
4. "Preserved" section
5. "Modified" section

Write `feature-dir/legacy-impact.md` atomically, full rewrite.

## Generating regression-watch.md

1. For each rule in the "Modified" section of `legacy-impact.md`, generate a watch item
2. For explicitly removed rules, generate a watch item of type `absence`
3. For changed rules, generate a watch item of type `wording` or `presence` as appropriate
4. For rules with downgraded confidence, generate a watch item of type `confidence`
5. Assign stable IDs `W001`, `W002`, ... reusing old IDs from the file if it already exists

Structure:

1. Header with feature identifier
2. Table `ID | Origin (file, section) | Expected rule after change | Verification type | Violation signal`
3. "Re-extraction history" section initially empty, to be filled by the reverse agent when `/aegis` runs again
4. "Archived" section initially empty

NEVER include in the main watch rules that were originally 🟡 or 🔴; those go into an "Observations" section without regression weight.

Write `feature-dir/regression-watch.md`. The first run creates the file; later runs append new items, never rewriting history or old IDs.

## Updating progress.jsonl

Each line must contain, at minimum:

```json
{"ts":"2026-05-05T16:30:00Z","action":"T003","status":"done","files":["src/x/y.js"]}
```

Append-only. Never rewrite previous lines, even if you discover they were wrong. To correct, add a new `status: corrected` line with the target ID.

## Post-run hooks

Apply `after-coding` using the standard flow.

## Final report to the user

1. How many actions completed successfully
2. How many failed (if any)
3. Absolute path of `actions.md`, `progress.jsonl`, `legacy-impact.md`, `regression-watch.md`
4. How many watch items were created in this run
5. Explicit warning: to close the loop, run `/aegis` (spec extraction) again at some future point
6. If execution was partial, indicate the next phase or pending action

NEVER trigger re-extraction on your own; that is the user's decision.

End with:

> Type **CONTINUE** to proceed with `/aegis` (re-extraction) or any other action the user wants.
