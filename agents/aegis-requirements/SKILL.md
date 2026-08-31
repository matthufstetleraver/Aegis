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

1. Leia o `active-requirements.json` atual e o campo `paused-features`
   1.1. Se o campo não existir, considere `paused-features: []`
2. Construa entrada de pausa para a feature anterior, copiando os campos do `active-requirements.json` atual e acrescentando os dois campos de pausa:

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

   2.1. Os campos `started-at`, `current-stage` e `stages-completed` permitem que `/aegis-resume` retome essa feature depois sem perder dados originais
3. Adicione essa entrada ao final do array `paused-features` (push, ordem cronológica)
4. Siga normalmente para "Resolução do diretório da feature". Ao escrever o `active-requirements.json` novo (passo 5 daquela seção), INCLUA o array `paused-features` atualizado no JSON

### Option 3, abandon the previous one

1. Leia o `active-requirements.json` atual e o campo `paused-features`
   1.1. Se o campo não existir, considere `paused-features: []`
2. NÃO adicione a feature recém-abandonada ao array `paused-features` (ela fica órfã na pasta `aegis/forward/`, sem registro ativo, recuperável apenas por listagem manual)
3. Siga normalmente. Ao escrever o `active-requirements.json` novo, preserve o array `paused-features` herdado do JSON anterior (sem adicionar a abandonada)

A diretriz **non-destructive** vale aqui: em nenhuma das três opções a pasta da feature anterior em `aegis/forward/` é apagada ou modificada. Apenas o `active-requirements.json` (gerenciado pelo Aegis Spec) é reescrito.

## Resolving the feature directory

1. Leia `aegis/config/setup.json`
   1.1. Se `prefix-format` estiver ausente ou for `sequencial`, calcule o próximo `NNN` listando subpastas de `aegis/forward/` no formato `NNN-*` e somando 1 ao maior
   1.2. Se `prefix-format` for `timestamp`, use `YYYYMMDD-HHMMSS` da hora corrente
2. Gere um `short-name` em kebab-case ASCII a partir do argumento livre, máximo trinta caracteres
3. Defina `feature-dir = aegis/forward/<NNN>-<short-name>` (ou `aegis/forward/<TIMESTAMP>-<short-name>`)
4. Crie `feature-dir` se não existir
5. Atualize `aegis/config/active-requirements.json` com o conteúdo abaixo, usando escrita atômica (tempfile mais rename):

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

   5.1. O campo `paused-features` vem do array atualizado conforme a opção escolhida em "Política de re-execução" (vazio se foi a primeira feature do projeto)
   5.2. Os campos `current-stage` e `stages-completed` são metadado informativo, não autoritativo, a detecção real do estágio é feita por artefatos físicos

Política de re-execução: se `active-requirements.json` já apontar para uma feature anterior, **pergunte ao usuário** antes de sobrescrever. Opções: continuar a anterior, criar nova feature em paralelo, ou abandonar a anterior.

## Coleta de contexto a partir da extração de especificações

Antes de escrever o requirements, leia, na ordem (pulando o que não existir):

1. `aegis/architecture/architecture.md` (panorama dos componentes)
2. `aegis/reports/domain.md` (regras de negócio confirmadas)
3. `aegis/reports/inventory.md` (superfície do código)
4. `aegis/reports/code-analysis.md` SOMENTE nas seções dos componentes que o argumento livre parece tocar
5. `aegis/config/principles.md` (princípios do projeto, se existir)

Identifique os arquivos relevantes. Cada citação dentro do requirements precisa apontar para essas fontes no formato `aegis/<arquivo>#<seção>`.

## Construção do requirements.md

1. Carregue o template em `aegis/runtime/templates/requirements-template.md`
2. Preserve a ordem das seções obrigatórias
3. Preencha cada seção respeitando o comentário inline orientador
4. Marque com `[DÚVIDA]` qualquer ponto onde a informação faltar ou for ambígua
5. Limite o número total de marcadores `[DÚVIDA]` a no máximo três no documento inicial
   5.1. Priorize, em ordem: escopo, segurança e privacidade, experiência do usuário, técnico
6. Use a marcação 🟢 / 🟡 / 🔴 nos itens conforme a confidência da fonte original

## Auto-validação iterativa

1. Após escrever o `requirements.md`, leia o template `quality-template.md`
2. Aplique mentalmente a checklist
3. Se houver itens reprovados, reescreva as seções afetadas
4. Repita esse ciclo no máximo três vezes
5. Persistindo problemas após três iterações, registre-os em uma seção final `## Pendências de Qualidade` e siga em frente

## Persistência

- Grave `requirements.md` em `feature-dir/`
- A escrita deve ser atômica (tempfile mais rename)
- Use UTF-8 sem BOM

## Ganchos Pós-execução

1. Procure `after-requirements` em `aegis/runtime/hooks.yml`
2. Aplique a mesma regra de filtragem (`enabled: false` é descartado)
3. Para `optional: true`, apresente links em "## Ganchos Disponíveis"
4. Para `optional: false`, emita `EXECUTAR: <comando>` e aguarde

## Relatório final

No final da execução, mostre ao usuário:

1. Caminho absoluto de `feature-dir`
2. Caminho absoluto de `requirements.md`
3. Número de marcadores `[DÚVIDA]` no documento
4. Sugestão de próximo passo:
   4.1. Se houver `[DÚVIDA]`, sugerir `/aegis-doubt`
   4.2. Caso contrário, sugerir `/aegis-plan`

Termine sempre com:

> Digite **CONTINUAR** para prosseguir com `/aegis-doubt` ou `/aegis-plan` conforme a sugestão acima.

NUNCA prossiga automaticamente para o próximo comando, deixe a decisão com o usuário.
