---
name: aegis-n8n
description: Generates SDD specs (workflow-overview, requirements, design) from N8N workflows exported as JSON, preparing the ground for re-implementation in Python or another language. Use when the user has a JSON file exported from N8N and wants to document it as a spec or port it to code.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI, and other Agent Skills-compatible agents.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: aegis-spec
  phase: traducao
---

You are the N8N Translator. Your mission is to read an N8N workflow exported as JSON and produce an SDD spec that describes the system independently of N8N, sufficient for re-implementation in Python (or any other language).

## Antes de começar

### Pasta de entrada: `n8n_json_workflows/`

A skill usa uma pasta dedicada como ponto de entrada para os JSONs exportados do N8N.

1. Verifique se a pasta `n8n_json_workflows/` existe na raiz do projeto. Se não existir, crie.

2. Liste os arquivos `.json` dentro de `n8n_json_workflows/`:
   - **Se a pasta estiver vazia**: pare e informe o usuário com a mensagem:
     ```
     Pasta n8n_json_workflows/ criada (ou já vazia).
     Coloque os arquivos JSON exportados do N8N nessa pasta e execute novamente.
     ```
     Não prossiga até que haja pelo menos um arquivo.
   - **Se houver exatamente um arquivo**: use esse arquivo automaticamente, mas confirme com o usuário antes de processar.
   - **Se houver múltiplos arquivos**: liste todos numerados e pergunte ao usuário qual processar (aceite número, nome do arquivo ou `todos` para processar em sequência).

3. Valide o arquivo escolhido:
   - É JSON válido
   - Contém os campos mínimos: `name`, `nodes` (array não vazio), `connections` (objeto)

   Se faltar qualquer campo, pare e informe o usuário qual campo está ausente antes de continuar.

### Pasta de saída: `aegis/n8n/<slug>/`

4. Determine o slug a partir do `name` do workflow normalizado em kebab-case (minúsculas, espaços viram hífen, caracteres especiais removidos, acentos normalizados).

5. Se a pasta `aegis/n8n/<slug>/` já existir, pergunte: sobrescrever, criar versão nova (`-v2`, `-v3`...) ou cancelar.

## Processo

### 1. Parse do JSON

Extraia e mantenha em memória:
- `name`, `active`, `id`, `versionId`
- `nodes[]`: para cada nó capture `id`, `name`, `type`, `typeVersion`, `parameters`, `credentials`, `position`, `disabled` (se houver)
- `connections{}`: grafo direcionado entre nós (estrutura `connections[source][main][index] = [{node, type, index}]`)
- `settings`, `staticData`, `pinData` (se relevantes)

### 2. Identificação de triggers e fluxo

Triggers comuns (consulte `references/node-catalog.md` para a lista completa):
- `n8n-nodes-base.webhook`
- `n8n-nodes-base.scheduleTrigger`, `n8n-nodes-base.cron`
- `n8n-nodes-base.manualTrigger`
- `n8n-nodes-base.emailReadImap`
- `n8n-nodes-base.intervalTrigger`
- Triggers de serviços (`n8n-nodes-base.slackTrigger`, `n8n-nodes-base.googleSheetsTrigger`, etc.)

A partir do trigger, percorra `connections` e construa:
- Grafo direcionado completo
- Nós terminais (sem saída)
- Ramificações (`if`, `switch`)
- Pontos de junção (`merge`)
- Loops e iterações (`splitInBatches`, `itemLists`)
- Sub-workflows referenciados (`executeWorkflow`)

### 3. Análise semântica nó a nó

Para cada nó, descreva em linguagem natural:
- Propósito no contexto do negócio (não apenas o tipo técnico)
- Entradas esperadas (do nó anterior)
- Saídas produzidas (para o próximo nó)
- Dependências externas (APIs, bancos, serviços)
- Transformações ou regras aplicadas

Para nós `Function`, `FunctionItem` ou `Code`: leia o JS/Python embutido em `parameters.functionCode` (ou equivalente) e descreva a lógica em pseudocódigo. Não copie o código original na spec, descreva o que ele faz.

Para nós `IF` e `Switch`: descreva cada condição em linguagem natural ("se o status do pedido for igual a aprovado").

Para nós `HTTP Request`: registre método, URL (com placeholders), headers relevantes, body schema.

Consulte `references/node-catalog.md` ao mapear tipos de nó para conceitos.

### 4. Detecção de credenciais e segredos

Liste credenciais referenciadas em `node.credentials` sem expor valores:
- Nome lógico da credencial (como aparece no N8N)
- Tipo (`oAuth2Api`, `httpHeaderAuth`, `slackApi`, `googleApi`, etc.)
- Serviço associado (Slack, Google, OpenAI, Postgres, etc.)
- Como deve ser injetada em Python (variável de ambiente sugerida, secret manager)

### 5. Mapeamento para Python

Para cada nó, sugira:
- Biblioteca Python equivalente (consulte `references/node-catalog.md`)
- Padrão de implementação (síncrono vs assíncrono, função pura vs classe)

Para o workflow inteiro, sugira a arquitetura adequada:
- Trigger webhook: aplicação FastAPI ou Flask
- Trigger schedule/cron: script standalone com APScheduler ou systemd timer
- Trigger manual: script CLI (Typer ou argparse)
- Workflow longo com batches: worker assíncrono (asyncio, Celery, RQ)

### 6. Generation of artifacts

Generate three files following the SDD pattern:

**`workflow-overview.md`** (source analysis)
- Cabeçalho com metadados do workflow (nome, ativo, total de nós, total de conexões)
- Diagrama Mermaid `flowchart TD` representando o grafo
- Tabela com todos os nós: `| ID | Nome | Tipo | Propósito |`
- Lista de credenciais e dependências externas
- Seção `## Ambiguidades` no final, se houver

**`requirements.md`** (o que o sistema deve fazer)
- Visão geral: o que o workflow automatiza no negócio (1 a 3 parágrafos)
- Trigger: como o sistema é acionado (webhook, schedule, manual)
- Requisitos funcionais numerados (`RF-01`, `RF-02`...) derivados de cada ramo do fluxo. Use o formato: "O sistema deve [ação] quando [condição]."
- Requisitos não-funcionais (`RNF-01`...): latência esperada, frequência (do schedule), retries observados, idempotência, observabilidade
- Critérios de aceitação por requisito ou por ramo principal

**`design.md`** (como construir em Python)
- Arquitetura sugerida (script, FastAPI, worker, etc.) com justificativa
- Componentes e responsabilidades: agrupe nós relacionados em módulos Python
- Bibliotecas Python recomendadas (lista com versões majors sugeridas)
- Estrutura de pastas sugerida
- Schema de dados: entrada, saídas intermediárias, saída final
- Tratamento de erros e retries (espelhe o que o N8N faz quando aplicável)
- Configuração: variáveis de ambiente e secrets necessários
- Testes recomendados: unitários por módulo, integração nos pontos com APIs externas

### 7. Handoff para o pipeline Aegis Spec

After generating the three spec artifacts, prepare the state so that `/aegis` can orchestrate the following agents (Scout, Archaeologist, Detective, Architect, Writer, Reviewer) on the result.

#### 7.1 Creation of `aegis/config/state.json`

If `aegis/config/state.json` does not yet exist, create from the template in `templates/state.json` and populate:

- `version`: read from Aegis Spec's `package.json` (field `version`)
- `project`: the N8N workflow's `name` (human-readable, without slug)
- `user_name`: if already filled in another existing state, keep it; otherwise, ask the user before handoff
- `chat_language`: `pt-br` by default (or follow what the user used in the conversation)
- `doc_language`: `Portuguese` by default
- `doc_level`: `essential` (the N8N spec is already compact; the pipeline does not need to expand much)
- `output_folder`: `aegis` (default for the main pipeline)
- `phase`: `null` (let `/aegis` define it as `reconnaissance` when starting)
- `engines`: empty list (will be filled by /aegis)
- `agents`: empty list
- `created_files`: empty list
- Add a field `source` with value `"n8n"` and `source_artifacts` pointing to `aegis/n8n/<slug>/` so that Scout knows pre-analysis exists.

If `aegis/config/state.json` already exists, **do not overwrite**. Only update the `source` and `source_artifacts` fields, adding the new processed workflow to `source_artifacts` (list).

#### 7.2 Creation of `aegis/plan.md`

If `aegis/plan.md` does not yet exist, create from the template in `templates/plan.md` and replace:
- `{{PROJECT}}`: N8N workflow name
- `{{DATE}}`: current date in ISO format

Add a section `## Phase 0: N8N Origin 🔁` at the top (before Phase 1) with the content:

```markdown
## Phase 0: N8N Origin 🔁

> Analysis was initiated from an N8N workflow. The pre-analysis generated specs in `aegis/n8n/<slug>/`. Scout should include these artifacts in the inventory.

- [x] **N8N Translator**: conversion of workflow `<slug>` to SDD spec
```

If `aegis/plan.md` already exists, only add the N8N Translator line in the appropriate section (or create Phase 0 if it does not yet exist).

#### 7.3 User confirmation

After creating the files, show:
```
✅ Spec generated in aegis/n8n/<slug>/
✅ Initial state created in aegis/config/state.json
✅ Plan created in aegis/plan.md

To continue with the full pipeline (Scout, Archaeologist, etc.), type /aegis.
```

## Escala de confiança

Use estes marcadores ao afirmar algo na spec:
- 🟢 CONFIRMADO: derivado diretamente do JSON
- 🟡 INFERIDO: deduzido por contexto (nome do nó, parâmetros, código embutido)
- 🔴 LACUNA: ambíguo ou não detectável a partir do JSON

Aplique principalmente em `requirements.md` e `design.md`.

## Ambiguidades

Se durante a análise encontrar qualquer um destes casos, pare e pergunte ao usuário antes de seguir:
- Function node com lógica obscura, variáveis sem nome ou efeitos colaterais externos não declarados
- Credenciais sem rótulo claro de serviço
- Webhooks com payload não documentado e sem exemplo no `pinData`
- Loops com condições de saída implícitas
- Sub-workflows referenciados que não estão disponíveis

Registre cada ambiguidade no `workflow-overview.md` em `## Ambiguidades`, com formato:
```
- 🔴 [tipo] [descrição curta]. Pergunta ao usuário: [pergunta direta].
```

## Saída

```
n8n_json_workflows/                  (entrada, criada se não existir)
└── <arquivo>.json

aegis/n8n/<slug-do-workflow>/     (spec gerada da fonte)
├── workflow-overview.md
├── requirements.md
└── design.md

aegis/                            (estado para handoff ao /aegis)
├── state.json
└── plan.md
```

## Cross-cutting layout

The spec artifacts go in `aegis/n8n/<slug>/`. The state files for the main pipeline go in `aegis/`. The input JSONs remain in `n8n_json_workflows/` untouched. Do not write to `aegis/` here (that folder is populated by the main pipeline agents from `/aegis`).

## Next step

When complete, inform the user:
- Files generated (relative paths)
- Summary: number of nodes, number of external integrations, main architectural decision
- Pending ambiguities (if any)

Sugira ao usuário:
1. Revisar a spec em `aegis/n8n/<slug>/`
2. Digitar `/aegis` para acionar o pipeline completo (Scout em diante) sobre a pré-análise N8N
3. Ou processar outro workflow direto, se houver mais arquivos em `n8n_json_workflows/`

Termine com: `Digite CONTINUAR para processar outro workflow, ou /aegis para iniciar o pipeline principal.`

## Regras absolutas

- Nunca modificar o arquivo JSON original em `n8n_json_workflows/`
- Escrever apenas em `n8n_json_workflows/` (criar a pasta), `aegis/n8n/` e `aegis/`
- Nunca sobrescrever `aegis/config/state.json` se já existir, apenas atualizar os campos `source` e `source_artifacts`
- Nunca expor credenciais, tokens ou secrets em nenhum artefato (registrar apenas o tipo e o serviço)
- Nunca inventar funcionalidades não presentes no workflow
- Marcar com 🔴 LACUNA tudo que não puder ser confirmado pela leitura do JSON
- Manter compatibilidade multi-engine: a skill deve rodar em Claude Code, Codex, Cursor e Gemini CLI sem dependência de tools específicas
