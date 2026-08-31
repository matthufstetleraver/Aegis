---
name: aegis-quality
description: Text clarity audit for the requirements. Checks whether the prose is good enough to generate a plan without ambiguity. Do NOT mix this with implementation test audits. Use when the user types "/aegis-quality", "aegis-quality", or asks to review requirements quality before planning. Optional step in the forward cycle.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI, and other Agent Skills-compatible agents.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: aegis-spec
  phase: forward
  stage: quality
---

You are the text reviewer. Your mission is to check whether the active feature's `requirements.md` is well written, complete, and coherent enough to become a plan and code without rework. This skill is read-only over `requirements.md`. The only allowed writing is the audit report.

This skill evaluates WRITING QUALITY, not implementation TEST COVERAGE. If you feel like adding an item such as "check whether the button works," stop — that item does NOT belong here.

## Before you start

1. Read `aegis/config/state.json` to resolve `output_folder` and `forward_folder`
2. Use the real values wherever the text mentions `aegis/` or `aegis/forward/`

## Initial checks

1. Read `aegis/config/active-requirements.json`
   1.1. If missing, abort
2. Verify the existence of `feature-dir/requirements.md`
3. Apply `before-quality` using the standard flow

## Audit categories

Cada item do relatório se encaixa em uma destas categorias:

| Categoria | Pergunta-guia |
|-----------|---------------|
| Clareza | Cada frase tem um sujeito, um verbo e um significado único? |
| Completude | Todas as seções obrigatórias do template estão preenchidas? |
| Consistência | Termos do glossário do projeto são usados sempre da mesma forma? |
| Cobertura de cenários | Casos felizes, casos tristes e edge cases aparecem em Gherkin? |
| Edge cases | Limites numéricos, vazios, nulos, concorrência foram considerados? |
| Ausência de jargão | A escrita seria entendida por um humano novo no time? |
| Ausência de solução implícita | O texto descreve o quê, não o como (sem nome de biblioteca, sem framework) |
| Alinhamento com princípios | Cada regra do requirements respeita `aegis/config/principles.md` |

## How to generate the items

1. Carregue o template `aegis/runtime/templates/quality-template.md`
2. Para cada categoria, gere de uma a cinco perguntas avaliativas baseadas no conteúdo real do `requirements.md`
3. Total entre dez e trinta itens
4. Cada item segue formato `- [ ] Q-NNN | <categoria> | <pergunta>`
5. Após avaliar, marque `[X]` os aprovados, `[ ]` os reprovados
6. Para reprovados, adicione linha extra `> motivo: <razão objetiva>`
7. Para reprovados que poderiam ser auto-corrigidos pelo redator, adicione linha extra `> sugestão: <texto curto>`

## Final verdict

Ao final do relatório, emita uma de três classificações:

- **Aprovado**, todos os itens passaram
- **Aprovado com ressalvas**, até três itens reprovados, nenhum CRITICAL
- **Reprovado**, mais de três itens reprovados, ou pelo menos um CRITICAL (cobertura de cenários ausente, princípio violado, contradição interna)

## Persistence

- Crie `feature-dir/quality/` se não existir
- Grave `feature-dir/quality/requirements-audit.md` com escrita atômica
- Sempre rewrite completo

## Post-run hooks

Aplique `after-quality` da forma padrão.

## Final report to the user

1. Caminho absoluto de `requirements-audit.md`
2. Veredito (Aprovado, Aprovado com ressalvas, Reprovado)
3. Top três itens reprovados, com motivo, se houver
4. Aviso explícito: o `requirements.md` NÃO foi modificado
5. Sugestão de próximo passo:
   5.1. Aprovado, sugerir `/aegis-plan`
   5.2. Aprovado com ressalvas, sugerir `/aegis-doubt`
   5.3. Reprovado, sugerir reescrita manual ou nova execução de `/aegis-requirements`

Termine com:

> Type **CONTINUAR** to proceed with the suggestion above.
