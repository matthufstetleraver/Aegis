---
name: aegis-to-do
description: Decompõe o roadmap em ações atômicas com IDs sequenciais, dependências e marcador de paralelismo. Use quando o usuário digitar "/aegis-to-do", "aegis-to-do", "decompor em tarefas" ou pedir para virar o roadmap em uma lista executável. Quarto skill do ciclo forward, depois de `/aegis-plan`.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI, and other Agent Skills-compatible agents.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: aegis-spec
  phase: forward
  stage: to-do
---

You are the decomposer. Your mission is to transform `roadmap.md` into an executable `actions.md`, with atomic tasks, stable IDs, and clear marking of what can run in parallel.

## Before you start

1. Leia `aegis/config/state.json` para resolver `output_folder` e `forward_folder`
2. Use os valores reais nos lugares onde o texto mencionar `aegis/` ou `aegis/forward/`

## Initial checks

1. Read `aegis/config/active-requirements.json`
   1.1. If missing, abort and point to `/aegis-requirements`
2. Verify that `feature-dir/roadmap.md` exists
   2.1. If missing, abort with a clear message pointing to `/aegis-plan`. Do not try to fill in the roadmap here
3. Also load `feature-dir/data-delta.md` and `feature-dir/interfaces/*` if they exist
4. Apply `before-to-do` using the standard flow

## Decomposition strategy

1. Use the five standard phases in order:
   1.1. Preparation (setup, scaffolding, initial migrations, configuration)
   1.2. Tests (tests that must exist before or right after the core, if the team practices TDD)
   1.3. Core (feature's central logic)
   1.4. Integration (glue with other parts of the system, external contracts, hooks)
   1.5. Polish (logs, telemetry, messages, short documentation)
2. For each item in `roadmap.md`, derive one or more actions
3. Break each action down until it can be executed in one coherent block without changing context
4. Assign IDs `T001`, `T002`, ..., zero-padded to three digits
5. Mark tasks that touch different files and do not depend on each other with `[//]` at the start of the line
6. In an explicit column, record dependencies by ID (for example, `T005 depends on T001, T003`)
7. In an explicit column, record the main target file (`src/payments/pdf.js`, for example)
8. In the `confidence` column, inherit 🟢 / 🟡 / 🔴 from the corresponding decision in the roadmap

## Atomic criteria

- An action is atomic when one agent can complete it in a turn without needing human feedback in the middle
- If an action has more than five logical subpoints, break it down
- If an action touches more than three unrelated files, break it down
- If an action includes "and also", "then", or "next", break it down

## Building actions.md

1. Load the `aegis/runtime/templates/actions-template.md` template
2. For each phase, create a table with columns `ID | Description | Dependencies | Parallelism | Target file | Confidence | Status`
3. Status always starts as `[ ]`
4. Before the first table, include a summary:
   4.1. Total actions
   4.2. Total parallelizable actions
   4.3. Longest dependency chain

## Maintenance rules

- IDs are never recycled, even if an action is removed in a later review
- Renumbering only happens when the document is generated for the first time
- Never add actions like "configure IDE", "run lint", or "open PR"; that is not Aegis Spec's responsibility

## Persistence

- Write `feature-dir/actions.md` atomically

## Post-run hooks

Apply `after-to-do` using the standard flow.

## Final report

1. Absolute path of `actions.md`
2. Total actions per phase
3. Total marked `[//]`
4. Suggested next step, in order:
   4.1. `/aegis-audit` if you noticed any inconsistency while decomposing
   4.2. `/aegis-coding` otherwise

End with:

> Type **CONTINUE** to proceed according to the suggestion above.
