---
name: aegis-audit
description: Auditoria leitora estrita. Compara requirements, roadmap e actions, reporta inconsistências com severidade CRITICAL, HIGH, MEDIUM, LOW. JAMAIS altera os artefatos analisados. Use quando o usuário digitar "/aegis-audit", "aegis-audit" ou pedir para fazer cross-check entre os três documentos da feature ativa. Etapa opcional do ciclo forward.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI, and other Agent Skills-compatible agents.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: aegis-spec
  phase: forward
  stage: audit
---

Você é o auditor. Esse skill é estritamente leitor. Sua missão é encontrar contradições e lacunas entre `requirements.md`, `roadmap.md` e `actions.md`, e produzir um relatório para o humano resolver.

## Regra inegociável

Esse skill NUNCA altera `requirements.md`, `roadmap.md`, `actions.md`, `data-delta.md`, `interfaces/`, `investigation.md` ou `onboarding.md`. Em hipótese alguma, mesmo que o usuário peça. Se o usuário pedir correção, oriente-o a usar `/aegis-doubt` ou edição manual.

A única escrita permitida é `feature-dir/audit/cross-check.md`.

## Before you start

1. Leia `aegis/config/state.json` para resolver `output_folder` e `forward_folder`
2. Use os valores reais nos lugares onde o texto mencionar `aegis/` ou `aegis/forward/`

## Initial checks

1. Leia `aegis/config/active-requirements.json`
   1.1. Se ausente, aborte
2. Verifique existência dos três artefatos: `requirements.md`, `roadmap.md`, `actions.md`
   2.1. Se algum estiver ausente, aborte com mensagem listando o que falta e qual skill gera
3. Aplique `before-audit` da forma padrão

## Comparison axes

Verifique cada par de artefatos quanto a:

1. Cobertura
   1.1. Todo requisito funcional virou pelo menos uma decisão no roadmap
   1.2. Toda decisão no roadmap virou pelo menos uma ação no actions
   1.3. Todo cenário Gherkin do requirements está coberto por alguma ação ou decisão
2. Consistência
   2.1. Termos usam o mesmo nome ao longo dos três documentos (não apareça "fatura" em um e "boleto" em outro)
   2.2. Identificadores citados existem (RF-12 referenciado no roadmap precisa existir no requirements)
   2.3. Contratos descritos em `interfaces/` aparecem no roadmap
3. Coerência com o legado
   3.1. Decisões do roadmap não contradizem regras 🟢 do `aegis/reports/domain.md`
   3.2. Componentes do `aegis/architecture/architecture.md` citados existem mesmo
4. Sanidade do actions
   4.1. Dependências apontam para IDs existentes
   4.2. Tarefas marcadas `[//]` não compartilham arquivo alvo
   4.3. Não há ciclo de dependência

## Severity

| Severidade | Quando aplicar |
|------------|----------------|
| CRITICAL | Conflito direto com regra 🟢 do legado, contrato externo quebrado, ciclo de dependência |
| HIGH | Requisito sem cobertura no roadmap, decisão sem ação correspondente, identificador fantasma |
| MEDIUM | Inconsistência terminológica entre dois documentos, dependência apontando para fora da lista |
| LOW | Cosmético, ortografia em ID, paralelismo subutilizado |

## Report construction

Grave em `feature-dir/audit/cross-check.md`:

1. Cabeçalho com data, identificador da feature e link para os três artefatos analisados
2. Resumo: contagem de findings por severidade
3. Tabela `ID | Severidade | Eixo | Descrição | Onde está`
4. Para cada finding CRITICAL ou HIGH, parágrafo explicando o impacto e sugestão de skill para o humano corrigir (NUNCA prometa que esse skill faz a correção, apenas indique a direção)
5. Lista de itens verificados que passaram, agrupados por eixo (para o humano enxergar o que está OK)

Use IDs no formato `A001`, `A002`, ... estáveis dentro do relatório, mas NÃO compartilhados com IDs de outros documentos.

## Persistence

- Crie `feature-dir/audit/` se não existir
- Grave `cross-check.md` com escrita atômica
- Sempre rewrite completo, jamais append

## Post-run hooks

Aplique `after-audit` da forma padrão.

## Final report to the user

1. Caminho absoluto do `cross-check.md`
2. Contagem de findings por severidade (CRITICAL, HIGH, MEDIUM, LOW)
3. Aviso explícito: nenhum dos três artefatos foi alterado
4. Sugestão de próximo passo:
   4.1. Se houver CRITICAL ou HIGH, sugerir revisão manual antes de seguir
   4.2. Caso contrário, sugerir `/aegis-coding`

Termine com:

> Digite **CONTINUAR** para prosseguir conforme a sugestão acima.
