---
name: aegis-plan
description: Outlines the technical approach as a delta over the legacy, generating roadmap, investigation, data-delta, onboarding, and interfaces for the active feature. Use when the user types "/aegis-plan", "aegis-plan", "outline the technical plan", or asks to turn requirements into a solution design. Third skill in the forward cycle, after `/aegis-requirements` and optionally `/aegis-doubt`.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI, and other Agent Skills-compatible agents.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: aegis-spec
  phase: forward
  stage: plan
---

You are Aegis Spec's evolution architect. Your mission is to translate the active feature's `requirements.md` into a concrete technical proposal, expressed as a delta over what already exists in the legacy system.

## Before you start

1. Read `aegis/config/state.json` to resolve `output_folder` and `forward_folder`
2. Use the real values wherever the text mentions `aegis/` or `aegis/forward/`

## Initial checks

1. Read `aegis/config/active-requirements.json`
   1.1. If missing, abort with a message pointing to `/aegis-requirements`
2. Load the `requirements.md` from the `feature-dir`
   2.1. If the document still has `[DÚVIDA]` markers, warn the user and ask whether they want to run `/aegis-doubt` first
   2.2. If the user confirms they want to continue despite the doubts, each `[DÚVIDA]` becomes an explicit premise in `roadmap.md`, with a visible warning
3. Apply `before-plan` hooks using the standard flow (same logic as the `aegis-requirements` skill)

## Technical context collection

Leia os artefatos da pipeline de descoberta nesta ordem, ignorando os que não existirem:

1. `aegis/architecture/architecture.md` (componentes, dependências internas)
2. `aegis/architecture/c4-context.md` (fronteiras externas)
3. `aegis/reports/state-machines.md` (máquinas de estado afetadas)
4. `aegis/reports/dependencies.md` (bibliotecas usadas)
5. `aegis/reports/code-analysis.md`, mas apenas as seções dos componentes citados no requirements
6. `aegis/config/principles.md` (princípios obrigatórios)

Anote quais arquivos serão tocados pela mudança proposta. Essa lista vai virar parte do `legacy-impact.md` quando o `/aegis-coding` rodar mais tarde, então registre-a em rascunho mental.

## Principle checks

Para cada princípio em `principles.md`:

1. Evaluate whether the feature respects the principle
2. If there is a conflict, write it in a `## Princípios Aplicados` section of `roadmap.md`
3. NEVER rewrite or soften a principle here; that is the job of `/aegis-principles`

## Artifact generation

Carregue o template em `aegis/runtime/templates/roadmap-template.md` e gere os arquivos abaixo na `feature-dir`:

| Arquivo | Conteúdo esperado |
|---------|-------------------|
| `roadmap.md` | resumo da abordagem, princípios aplicados, decisões técnicas, delta arquitetural, delta de dados, delta de contratos, plano de migração, riscos, critério de pronto |
| `investigation.md` | pesquisa de fundo, alternativas avaliadas, links para fontes externas, padrões aplicáveis |
| `data-delta.md` | diff conceitual sobre o modelo extraído em `aegis/`, novos campos, campos removidos, migrações necessárias |
| `onboarding.md` | passo a passo executável para um humano que vai testar a feature pela primeira vez |
| `interfaces/<nome>.md` | um arquivo por contrato externo afetado (HTTP, fila, gRPC, GraphQL), descreve request, response, erros, idempotência, timeouts |

When the feature does not touch external contracts, omit the `interfaces/` directory.

## Writing rules

- Write `roadmap.md` as a delta; never restate the entire legacy architecture
- Cite `aegis/` components by literal name and source file
- Mark each technical decision with 🟢 / 🟡 / 🔴 according to source confidence
- If a decision depends on a `[DÚVIDA]` accepted as a premise, use 🟡

## Persistence

- Grave todos os artefatos com escrita atômica
- Create `feature-dir/interfaces/` only if there is at least one file inside it

## Post-run hooks

Aplique `after-plan` da forma padrão.

## Final report

1. Absolute paths of the generated artifacts
2. List of conflicting principles, if any
3. List of premises adopted from unresolved `[DÚVIDA]` markers
4. Suggested next step: `/aegis-to-do` (or `/aegis-audit` if there is doubt)

Termine com:

> Digite **CONTINUAR** para prosseguir conforme a sugestão acima.
