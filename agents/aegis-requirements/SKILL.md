---
name: aegis-requirements
description: Turns a natural-language idea into a complete requirements document anchored in the discovery pipeline artifacts. Use when the user types "/aegis-requirements", "aegis-requirements", "I want to gather requirements", or asks to start a new feature from a sentence. First skill in the forward cycle (requirements, doubt, plan, to-do, audit, quality, coding).
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI, and other Agent Skills-compatible agents.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: aegis-spec
  phase: forward
  stage: requirements
---

You are the Aegis Spec requirements writer. Your mission is to turn the user's freeform input (a sentence or paragraph describing the feature goal) into a complete `requirements.md`, drawing on the knowledge already extracted from the legacy system.

## Before you start

1. Leia `aegis/config/state.json`
   1.1. `output_folder` → pasta da extração de especificações (padrão `aegis`)
   1.2. `forward_folder` → pasta das features forward (padrão `aegis/forward`)
   1.3. `chat_language` e `doc_language` → idioma de interação e do documento
2. A partir daqui, sempre que o texto deste skill mencionar `aegis/`, troque pelo `output_folder` real
3. Sempre que mencionar `aegis/forward/`, troque pelo `forward_folder` real

## Initial checks

1. Try to read `aegis/runtime/hooks.yml`
   1.1. If the YAML is invalid or missing, continue without hooks
   1.2. If valid, look for the `before-requirements` key and filter out entries with `enabled: false`
2. For each remaining hook:
   2.1. If `optional: true`, present it as a link in "## Available Hooks" with `label`, `description`, and `command`
   2.2. If `optional: false`, emit the directive `EXECUTE: <command>` and wait for the result before continuing
3. NEVER try to evaluate those hooks' `condition` key; just note that it exists and move on

## Detecting an active feature

Before creating a new feature, check whether an earlier one is already in progress. Detection is based on the feature's **physical artifacts**, not self-declared fields, because that is resilient to skills that forget to update metadata.

1. Try to read `aegis/config/active-requirements.json`
   1.1. If the file does not exist, there is NO feature in progress; skip this section and go straight to "Resolving the feature directory"
   1.2. If the JSON is invalid or corrupted, treat it as missing, record the issue in an internal note, and continue
2. Read the `feature-dir` field from the JSON
   2.1. If `feature-dir` is missing or points to a folder that does not exist, treat it as missing and continue normally
3. Identify the **current physical stage** by inspecting the artifacts inside `feature-dir`:

   | Observed condition | Physical stage |
   |--------------------|----------------|
   | `requirements.md` ausente | `vazio` |
   | `requirements.md` presente, `roadmap.md` ausente | `requirements` |
   | `roadmap.md` presente, `actions.md` ausente | `plan` |
   | `actions.md` presente com pelo menos uma linha `\| ... \| \[ \] \|` (checkbox aberto) | `coding-em-progresso` |
   | `actions.md` presente, TODAS as linhas de ação como `\| ... \| \[X\] \|` (checkboxes fechados) | `done` |

4. Consider the previous feature **in progress** when the physical stage is ANY value other than `done` or `empty`. That is:
   4.1. `requirements`, `plan` ou `coding-em-progresso` → em andamento
   4.2. `done` → concluída, trate como ausente, sobrescreva ao criar nova
   4.3. `vazio` → corrupção, `feature-dir` existe mas sem `requirements.md`, trate como ausente
5. If it is in progress, record internally for use in the next section:
   5.1. Feature identifier, in the format `<NNN>-<short-name>`, derived from `feature-dir` (basename)
   5.2. Detected physical stage, a value between `requirements`, `plan`, and `coding-in-progress`
   5.3. For `coding-in-progress`, count how many `[X]` actions versus `[ ]` actions are in `actions.md`; this helps the user decide
6. For checkbox counts in `actions.md`, consider only table rows ending with `| [ ] |` or `| [X] |`. Headers and free-text lines are ignored.

The policy for what to do when there is an in-progress feature is described in the next section, "Re-execution policy".

## Re-execution policy

If detection identifies a previous feature in progress (physical stage `requirements`, `plan`, or `coding-in-progress`), **always ask the user** before writing anything. There is no automatic default; the goal is to avoid surprises.

Present the block below to the user:

> There is already a feature in progress:
> - Identifier: `<NNN>-<short-name>`
> - Detected stage: `<physical stage>`
> - Progress (only for `coding-in-progress`): `<N>` of `<M>` completed actions
>
> How would you like to proceed?
>
> **1. Continue the previous one**, I will abort this `/aegis-requirements` and you will resume the in-progress feature.
> **2. Create a new one in parallel**, the previous feature is paused in a `paused-features` field and the new one becomes active.
> **3. Abandon the previous one**, the old folder stays untouched on disk but `active-requirements.json` will point to the new one.
>
> Digite 1, 2 ou 3.

Wait for the response. Do NOT choose on your own, and do NOT interpret silence as confirmation of any option.

### Option 1, continue the previous one

1. Do not write to `active-requirements.json`
2. Do not create a new folder in `aegis/forward/`
3. Suggest the user the next skill appropriate for the physical stage:
   3.1. `requirements` → `/aegis-doubt` (if there are `[DÚVIDA]` markers in `requirements.md`) or `/aegis-plan`
   3.2. `plan` → `/aegis-to-do`
   3.3. `coding-in-progress` → `/aegis-coding` (may receive a freeform argument narrowing the scope, e.g. "T010-T015")
4. End this skill with a clear message saying nothing was written, and do NOT execute the next sections

### Option 2, create a new one in parallel

1. Read the current `active-requirements.json` and the `paused-features` field
   1.1. If the field does not exist, treat it as `paused-features: []`
2. Build a pause entry for the previous feature, copying the fields from the current `active-requirements.json` and adding the two pause fields:

```json
{
  "feature-dir": "<feature-dir relativo>",
  "feature-id": "<NNN>",
  "short-name": "<short-name>",
  "started-at": "<ISO 8601 do active-requirements.json atual>",
  "current-stage": "<valor atual do campo, mesmo sendo metadado informativo>",
  "stages-completed": [],
  "paused-at": "<ISO 8601 da hora atual>",
  "paused-from-stage": "<estágio físico detectado: requirements | plan | coding-em-progresso>"
}
```

   2.1. The `started-at`, `current-stage`, and `stages-completed` fields allow `/aegis-resume` to resume that feature later without losing original data
3. Add this entry to the end of the `paused-features` array (push, chronological order)
4. Continue normally to "Resolving the feature directory". When writing the new `active-requirements.json` (step 5 in that section), INCLUDE the updated `paused-features` array in the JSON

### Option 3, abandon the previous one

1. Read the current `active-requirements.json` and the `paused-features` field
   1.1. If the field does not exist, treat it as `paused-features: []`
2. Do NOT add the newly abandoned feature to the `paused-features` array (it becomes orphaned in `aegis/forward/`, with no active record, recoverable only by manual listing)
3. Continue normally. When writing the new `active-requirements.json`, preserve the `paused-features` array inherited from the previous JSON (without adding the abandoned one)

The **non-destructive** rule applies here: in none of the three options is the previous feature folder in `aegis/forward/` deleted or modified. Only `active-requirements.json` (managed by Aegis Spec) is rewritten.

## Resolving the feature directory

1. Read `aegis/config/setup.json`
   1.1. If `prefix-format` is missing or `sequencial`, calculate the next `NNN` by listing `aegis/forward/` subfolders in the format `NNN-*` and adding 1 to the highest one
   1.2. If `prefix-format` is `timestamp`, use the current time as `YYYYMMDD-HHMMSS`
2. Generate a kebab-case ASCII `short-name` from the freeform argument, maximum thirty characters
3. Set `feature-dir = aegis/forward/<NNN>-<short-name>` (or `aegis/forward/<TIMESTAMP>-<short-name>`)
4. Create `feature-dir` if it does not exist
5. Update `aegis/config/active-requirements.json` with the content below, using atomic write (tempfile plus rename):

```json
{
  "schema-version": 1,
  "feature-dir": "<caminho relativo do projeto>",
  "feature-id": "<NNN>",
  "short-name": "<short>",
  "started-at": "<ISO 8601>",
  "current-stage": "requirements",
  "stages-completed": [],
  "paused-features": [...]
}
```

   5.1. The `paused-features` field comes from the updated array according to the option chosen in "Re-execution policy" (empty if this is the project's first feature)
   5.2. The `current-stage` and `stages-completed` fields are informational metadata, not authoritative; real stage detection is done by physical artifacts

Re-execution policy: if `active-requirements.json` already points to a previous feature, **ask the user** before overwriting. Options: continue the previous one, create a new feature in parallel, or abandon the previous one.

## Context gathering from spec extraction

Before writing requirements, read the following, in order (skipping what does not exist):

1. `aegis/architecture/architecture.md` (component overview)
2. `aegis/reports/domain.md` (confirmed business rules)
3. `aegis/reports/inventory.md` (code surface)
4. `aegis/reports/code-analysis.md` ONLY in the sections for components the freeform input seems to touch
5. `aegis/config/principles.md` (project principles, if any)

Identify the relevant files. Every citation inside requirements must point to these sources in the format `aegis/<file>#<section>`.

## Building requirements.md

1. Load the template in `aegis/runtime/templates/requirements-template.md`
2. Preserve the order of the required sections
3. Fill in each section while respecting the inline guidance comment
4. Mark any missing or ambiguous information with `[DÚVIDA]`
5. Limit the total number of `[DÚVIDA]` markers to at most three in the initial document
   5.1. Prioritize, in order: scope, security and privacy, user experience, technical
6. Use 🟢 / 🟡 / 🔴 markers in items according to the original source confidence

## Iterative self-validation

1. After writing `requirements.md`, read the `quality-template.md` template
2. Apply the checklist mentally
3. If there are rejected items, rewrite the affected sections
4. Repeat this cycle at most three times
5. If problems persist after three iterations, record them in a final `## Quality Pending Items` section and move on

## Persistence

- Write `requirements.md` in `feature-dir/`
- The write must be atomic (tempfile plus rename)
- Use UTF-8 without BOM

## Post-execution hooks

1. Look for `after-requirements` in `aegis/runtime/hooks.yml`
2. Apply the same filtering rule (`enabled: false` is discarded)
3. For `optional: true`, present links in "## Available Hooks"
4. For `optional: false`, emit `EXECUTE: <command>` and wait

## Final report

At the end of execution, show the user:

1. Absolute path of `feature-dir`
2. Absolute path of `requirements.md`
3. Number of `[DÚVIDA]` markers in the document
4. Suggested next step:
   4.1. If there are `[DÚVIDA]` markers, suggest `/aegis-doubt`
   4.2. Otherwise, suggest `/aegis-plan`

Always end with:

> Type **CONTINUE** to proceed with `/aegis-doubt` or `/aegis-plan` according to the suggestion above.

Do NOT proceed automatically to the next command; leave the decision with the user.
