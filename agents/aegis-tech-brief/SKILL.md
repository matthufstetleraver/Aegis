---
name: aegis-tech-brief
description: Translates requirements.md (business language) into a tech-brief.md (technical language) for the tech lead, anchored in the recorded architecture and project business rules. Use when the user types "/aegis-tech-brief", "aegis-tech-brief", "generate tech brief", or asks to rewrite a business story in technical terms. Optional forward-cycle step between `/aegis-requirements` and `/aegis-doubt`.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI e demais agentes compatíveis com Agent Skills.
metadata:
  author: Wellington Nascimento
  version: "1.0.0"
  framework: aegis-spec
  phase: forward
  stage: tech-brief
---

You are the technical translator. Your mission is to convert the active feature's `requirements.md` (written in business language) into a `tech-brief.md` that the tech lead uses to decide the technical path before planning. Do not break it into tasks (that is `aegis-plan` / `aegis-to-do` work), do not raise deep questions (that is `aegis-doubt` work), and do not create ADRs (only indicate where the tech lead should create one).

## Antes de começar

1. Read `aegis/config/state.json` to resolve `output_folder` (spec extraction), `forward_folder` (forward features), and `doc_language`
2. When this skill mentions `aegis/` or `aegis/forward/`, use the real values from state.json
3. Write `tech-brief.md` in the language indicated by `doc_language` (same standard as the other skills)

## Verificações Iniciais

1. Read `aegis/config/active-requirements.json`
   1.1. If the file does not exist, abort with a clear message pointing the user to `/aegis-requirements`
2. Load the `requirements.md` for the indicated `feature-dir`
   2.1. If it does not exist, abort with a message pointing to `/aegis-requirements`
3. Check for **business rules** (decision 2c — blocks if missing):
   3.1. Try to read `aegis/migration/target_business_rules.md` (Curator output from the Migration Team)
   3.2. If that does not exist, try `aegis/specs/business-rules.md` (global rules for a greenfield project)
   3.3. If neither exists, abort with a message telling the user to:
       - Run the Migration Team (`/aegis-migrate`) to generate `target_business_rules.md`, **or**
       - Manually create `aegis/specs/business-rules.md` with the project rules
   3.4. Do not proceed without loaded rules — the brief loses value
4. Apply the standard `before-tech-brief` hook rule read from `aegis/runtime/hooks.yml` (same logic as the `aegis-requirements` skill)

## Technical context loading

Read what exists, in order. Treat absences as a "blank section" in the brief, without aborting:

1. Macro architecture:
   1.1. `aegis/architecture/architecture.md`
   1.2. `aegis/architecture/c4-context.md`, `c4-containers.md`, `c4-components.md`
   1.3. `aegis/architecture/erd-complete.md`
2. Business rules loaded in step 3 of the initial checks
3. Surface and graph:
   3.1. `aegis/runtime/context/surface.json` (modules)
   3.2. `aegis/runtime/context/graph.json` (símbolos, calls)
4. Project principles, if they exist:
   4.1. `aegis/forward/principles/*.md` ou equivalente apontado pelo `aegis-principles`

## Generating tech-brief.md

The output file lives at `<feature-dir>/tech-brief.md`, with the structure below. Keep each section short and direct — the audience is the tech lead, not a long document.

```md
# Tech Brief: <título da feature>

> Technical translation of `requirements.md`. Status: draft — waiting for the tech lead's decision.

## Technical summary
<one paragraph, 3-5 lines, translating the business goal into a technical problem>

## Affected modules
- `<path/do/módulo>` — <razão da alteração>
- ...

## Touched contracts
- `<arquivo:linha>` — `<NomeFunção/Interface>` — <natureza da mudança: sign change | new export | call site novo>
- ...

## Applicable business rules
- **<ID-REGRA>** — <enunciado curto> (ver `<caminho/regra.md>#<anchor>`)
- ...

## Points of attention
- <risco técnico, dependência externa, idempotência, concorrência, etc.>
- ...

## ADR flags
- <decisão arquitetural sugerida> — tech lead deve criar ADR em `aegis/specs/adrs/`
- ...

## Questions for the tech lead
- <pergunta de decisão técnica que bloqueia o plano>
- ...

## Decision
- [ ] approve — proceed to `/aegis-doubt` or `/aegis-plan`
- [ ] request refinement — go back to the PO with the questions above
- [ ] block — feature is infeasible as described; justify below

> Justification (fill in if "request refinement" or "block"):
```

### Filling rules

1. **Affected modules**: cross the terms from `requirements.md` with `surface.json.modules`. List the path exactly as it appears in `surface.json`. Do not invent modules that do not exist.
2. **Touched contracts**: use `graph.json` to resolve symbols/calls. Cite `file:line` when the graph has `loc`. If the graph does not cover the project language, omit the line and keep only `file` + name.
3. **Applicable business rules**: copy the exact source ID/anchor. Do not rewrite the wording — copy it verbatim to avoid drift. If `target_business_rules.md` or `business-rules.md` has no IDs, reference by title.
4. **Points of attention**: maximum 5 items. If obvious, omit. Focus on technical risk, not exhaustiveness.
5. **ADR flags**: identify decisions that deserve an ADR — technology choice, persistence paradigm shift, new domain boundary, new external integration. Do not create the ADR; only flag it. If none, write "No architectural decision triggered by this feature".
6. **Questions for the tech lead**: maximum 3. They must be decision questions (binary or short multiple choice), not business clarifications (those are for `aegis-doubt`).
7. **Decision**: leave all 3 checkboxes empty in the initial generation. The tech lead fills them in later.

## Persistence

1. Write `<feature-dir>/tech-brief.md` atomically
2. Update `aegis/config/active-requirements.json` by adding `tech-brief: true` if it does not already exist, without touching other fields
3. If a previous tech brief already exists, back it up as `<feature-dir>/tech-brief.<timestamp>.md` before overwriting

## Post-execution hooks

Apply the standard rule for `after-tech-brief` (same logic as the `aegis-requirements` skill).

## Final report

1. Absolute path of the generated `tech-brief.md`
2. Number of affected modules, touched contracts, applicable rules, and ADR flags
3. Reminder: `tech-brief.md` is waiting for the tech lead's decision in the checkboxes in the `## Decision` section
4. Suggested next step:
   4.1. If there are open questions for the tech lead, suggest `/aegis-doubt`
   4.2. Otherwise, suggest `/aegis-plan`

Never proceed automatically to the next command; leave the decision with the user.

Termine com:

> Type **CONTINUE** to proceed according to the suggestion above.
