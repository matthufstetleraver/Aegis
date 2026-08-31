---
name: aegis-principles
description: Cria ou atualiza os princípios duradouros do projeto e propaga sugestões de ajuste nos templates dependentes. Princípios são raros, mudam pouco e influenciam todos os artefatos. Use quando o usuário digitar "/aegis-principles", "aegis-principles", "definir princípios" ou pedir para criar/alterar/aposentar um princípio do projeto. Pode rodar antes mesmo da primeira feature.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI, and other Agent Skills-compatible agents.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: aegis-spec
  phase: forward
  stage: principles
---

You are the guardian of principles. This skill handles the project's durable rules, separate from the requirements of each feature. Principles change little and influence all other artifacts.

This skill is rare, typically used less than once a month. It is NOT part of the `requirements`, `plan`, `to-do`, `coding` pipeline. It can run on its own, before the first feature.

## Before you start

1. Read `aegis/config/state.json` to resolve `output_folder` and `forward_folder`
2. Use the real values wherever the text mentions `aegis/` or `aegis/forward/`

## Initial checks

1. Try to read `aegis/config/principles.md`
   1.1. If missing, mode is `create`
   1.2. If present, mode is `update`
2. Apply `before-principles` using the standard flow

## Create mode

1. Carregue `aegis/runtime/templates/principles-template.md`
2. Ask the user for candidate principles, in batch or one by one
3. For each principle:
   3.1. Assign sequential Roman numerals (I, II, III, ...)
   3.2. Ask for a short title, description, and a concrete example of application
   3.3. Record the creation date
4. List in the "Impact" section which templates will be affected when the principle changes (always `requirements-template.md`, `roadmap-template.md`, and potentially `actions-template.md`)
5. Start the "Change History" section with the initial entry

## Update mode

1. Present the current numbered principles to the user
2. Ask which operation they want:
   2.1. Add new (continues with the next Roman numeral, never reuses one)
   2.2. Change the text of an existing one (keeps the numeral, records the change in history)
   2.3. Retire one (does NOT delete it, marks it as `retired on YYYY-MM-DD` and moves it to the end of the document)
3. After the operation:
   3.1. Update the "Impact" section if needed
   3.2. Add an entry to "Change History"

## Impact propagation

1. For each template listed in the "Impact" section:
   1.1. Read the template in `aegis/runtime/templates/<name>`
   1.2. Check whether the template needs a new placeholder or section to reflect the principle
   1.3. NEVER rewrite the entire template automatically; generate only an impact report in `aegis/reports/principles-impact-YYYYMMDD.md`
2. The report lists textual adjustment suggestions by template
3. Applying those suggestions is the human's decision; this skill only suggests

## Persistence

- Write `aegis/config/principles.md` atomically
- Write the impact report to `aegis/reports/principles-impact-YYYYMMDD.md`
- Never overwrite old impact reports; each run creates a dated file

## Post-run hooks

Apply `after-principles` using the standard flow.

## Final report to the user

1. Absolute path of `principles.md`
2. List of active principles, with numeral and short title
3. List of retired principles, if any
4. Path of the generated impact report
5. Warning: new or changed principles only apply to features started after this date

Termine com:

> Type **CONTINUE** to proceed with the next action you want.
