# Aegis Spec Roadmap — Control Plane v2.0

Detailed roadmap to evolve Aegis Spec from spec generation framework to **complete control plane** for AI agents.

## Overview

3 pillars (Foundation):

| Pillar | Role |
|---|---|
| **Aegis Spec** | Spec authority — features, contracts, invariants, ADRs |
| **Keeper** | Drift gate — sync between spec and code |
| **Graph** (proprietary, MIT) | Codebase oracle — knowledge graph of real code |

Architectural decision: **build own graph**, don't use GitNexus (PolyForm Noncommercial license + scope mismatch). Keeps Aegis Spec MIT pure.

## Pipeline (4 stages)

```
Stage 1 — Discovery     →  Scout, Archaeologist, Detective, Architect, Writer, Reviewer
                            legacy code → _aegis_sdd/ specs

Stage 2 — Migration     →  Paradigm Advisor, Curator, Strategist, Designer, Inspector
                            _aegis_sdd/ → _aegis_sdd/migration/ plan + parity tests

Stage 3 — Build         →  user's coding agent (Claude / Codex / Cursor / Gemini / Kimi)
                            migration plan → new code

Stage 4 — Control plane →  Keeper + Graph + Policy gate (file-level + signature diff)
                            new code → guarded against drift, signature break, blast-radius edits
```

Stage 1 and 2 are upstream product (Discovery v1.x, Migration v1.2.17). **This roadmap covers Stage 4** — the control plane that keeps code under control of AI agents continuously.

## Supported Languages (full scope)

L0 (file imports via regex) + L1 (AST symbols/calls via tree-sitter) for:
- JavaScript
- TypeScript (covers TSX/JSX)
- Python
- Go
- Java

## Operating Modes

| Mode | Who decides | When to use |
|---|---|---|
| **HITL** | Human answers 3 Qs in Keeper | Critical specs, public contracts |
| **Auto** | LLM classifies + writes via Claude API | Whitelist paths, trivial changes |
| **Hybrid** (recommended) | Auto whitelist + HITL blacklist | Default production |

---

## Phase 1 — Light hooks → v1.7.0 (1-2 days) ✅ shipped (PR #11)

**Objective:** Stop burdening system. Hook only annotates, processes in batch.

### Deliverables

| Item | File | What changes |
|---|---|---|
| 1.1 | `lib/installer/hooks/runner.js` | Refactor: append-only JSONL instead of full processing inline |
| 1.2 | `lib/installer/hooks/claude.js` | Remove PreToolUse matcher; add Stop hook |
| 1.3 | `lib/installer/hooks/opencode.js` | Remove heavy tool.execute.before; keep light after + session.end |
| 1.4 | `lib/installer/hooks/cursor.js` | afterFileEdit only append + debounce 30s timer in runner |
| 1.5 | `lib/installer/hooks/kimi.js` | Pre→remove; Post light; install git pre-commit fallback |
| 1.6 | `lib/installer/hooks/codex.js` | Same Kimi pattern |
| 1.7 | `agents/aegis-keeper/SKILL.md` | Read `.aegis/keeper-queue.jsonl` instead of `.json` snapshot; dedup by file |
| 1.8 | `agents/aegis-keeper/references/queue-schema.md` | JSONL Schema |

### Exit criteria

- [ ] Task with 30 edits generates 30 JSONL lines, ~300ms total (before: ~9s)
- [ ] Stop hook in Claude Code triggers batch Keeper
- [ ] Cursor debounce functional (30s without edit → batch)
- [ ] Pre-commit fallback installed in engines without Stop

---

## Phase 2 — Universal L0 Graph → v1.8.0-alpha.1 (3-4 days) ✅ shipped (PR #17)

**Objective:** file-level blast radius for **all** languages via regex.

### Deliverables

| Item | File | What it does |
|---|---|---|
| 2.1 | `lib/graph/parsers-l0/javascript.js` | Detects `import ... from 'X'`, `require('X')`, `import('X')` (dynamic) |
| 2.2 | `lib/graph/parsers-l0/typescript.js` | Same + `import type` |
| 2.3 | `lib/graph/parsers-l0/python.js` | `import X`, `from X import`, `__import__('X')` |
| 2.4 | `lib/graph/parsers-l0/go.js` | `import "X"`, `import (...)`, package decl |
| 2.5 | `lib/graph/parsers-l0/java.js` | `import X.Y.Z;`, package qualifier |
| 2.6 | `lib/graph/parsers-l0/index.js` | Registry + ext-to-parser mapping |
| 2.7 | `lib/graph/builder.js` | Walk repo → call parsers → produce nodes/edges |
| 2.8 | `lib/graph/resolve.js` | Path resolution (relative imports, package roots, tsconfig paths, go.mod) |

### Graph schema

```json
{
  "version": 1,
  "level": "L0",
  "built_at": "2026-05-01T16:00:00Z",
  "languages_detected": ["javascript", "typescript"],
  "nodes": [
    { "id": "src/auth/login.js", "type": "file", "lang": "javascript" }
  ],
  "edges": [
    { "from": "src/auth/login.js", "to": "src/db/users.js", "kind": "imports" }
  ]
}
```

### Exit criteria

- [ ] Runs on Aegis Spec repo (TS/JS) → graph with >50 nodes
- [ ] Runs on Python sample repo → resolve relative + absolute imports
- [ ] Resolve tsconfig paths
- [ ] Performance: 1000-file repo in <2s

---

## Phase 3 — Storage + queries L0 + CLI → v1.8.0-alpha.2 (2-3 days) ✅ shipped (PR #18)

**Objective:** persist graph + expose basic queries via CLI.

### Deliverables

| Item | File | What it does |
|---|---|---|
| 3.1 | `lib/graph/store.js` | Read/write `.aegis/context/graph.json`. Atomic writes. |
| 3.2 | `lib/graph/queries/impact.js` | BFS: file → all files that depend (transitive) |
| 3.3 | `lib/graph/queries/deps.js` | Direct: files that `file` imports |
| 3.4 | `lib/graph/queries/reverse-deps.js` | Inverse: who imports `file` (1 level) |
| 3.5 | `lib/graph/incremental.js` | Incremental update: re-parse only `dirty_files` |
| 3.6 | `lib/commands/graph.js` | CLI: `aegis graph build|impact|deps|stats` |
| 3.7 | `bin/aegis.js` | Registers `graph` command |

### CLI examples

```bash
npx aegis-spec graph build           # construct full graph
npx aegis-spec graph build --since HEAD~10  # incremental from N commits ago
npx aegis-spec graph impact src/auth/login.js
npx aegis-spec graph deps src/auth/login.js
npx aegis-spec graph stats
```

### Exit criteria

- [ ] `graph build` creates graph.json
- [ ] `graph impact` returns correct BFS
- [ ] Incremental update <500ms for 5 dirty files
- [ ] CLI has help + consistent exit codes

---

## Phase 4 — Basic policy gate (file-level) → v1.8.0-alpha.3 (3-4 days) ✅ shipped (PR #19)

**Objective:** Keeper blocks pre-edit based on path + spec metadata. Without parsing diff.

### Deliverables

| Item | File | What it does |
|---|---|---|
| 4.1 | `lib/policy/index-builder.js` | Read specs in `_aegis_sdd/sdd/`, extract frontmatter `protected:` + `contracts:`, generate `.aegis/context/policy-index.json` |
| 4.2 | `lib/policy/check.js` | Decision engine: file path → spec → protected? + auto-policy.yaml blacklist |
| 4.3 | `lib/policy/decisions.js` | 3 levels: approve / approve+advisory / block |
| 4.4 | `lib/policy/adapters/claude.js` | Output `{ "decision": "block", "reason": "..." }` |
| 4.5 | `lib/policy/adapters/codex.js` | Same format |
| 4.6 | `lib/policy/adapters/kimi.js` | Same format |
| 4.7 | `lib/policy/adapters/cursor.js` | Auto-revert + comment file (without pre-block) |
| 4.8 | `lib/policy/adapters/opencode.js` | Throw with message |
| 4.9 | `lib/policy/overrides.js` | Detect override: ADR exists, commit msg flag, CLI unprotect |
| 4.10 | `lib/installer/hooks/runner.js` | Add policy-check BEFORE queue append; if block, return decision |
| 4.11 | `lib/commands/policy-index.js` | CLI: `aegis policy-index build` |

### Spec frontmatter used

```markdown
---
contracts:
  - name: login
    file: src/auth/login.js
    protected: true
    reason: "public API"
protected_files:
  - "src/api/public/**"
---
```

### Exit criteria

- [ ] Edit in `src/api/public/foo.js` returns block JSON with reason
- [ ] Edit in file without spec → approve silent
- [ ] Override via ADR works (create ADR → next edit passes)
- [ ] Pre-hook latency <30ms

---

## Phase 5 — Keeper integrates L0 graph → v1.8.0 (2-3 days) ✅ shipped (PR #20)

**Objective:** Step 2 of Keeper uses graph instead of just matrix.

### Deliverables

| Item | File | What changes |
|---|---|---|
| 5.1 | `agents/aegis-keeper/SKILL.md` | Step 2 updated: uses `aegis graph impact <file>` for blast radius |
| 5.2 | `agents/aegis-keeper/references/drift-rules.md` | New rule: "Change in file with 5+ reverse-deps = HIGH severity" |
| 5.3 | `lib/commands/drift-check.js` | Add `affected_files` field in output JSON using graph |
| 5.4 | `lib/installer/hooks/runner.js` | Stop hook calls incremental graph update before Keeper |
| 5.5 | `docs/keeper-graph-integration.{md,pt.md,es.md}` | Doc 3 langs |

### Exit criteria

- [ ] Edit in file WITHOUT matrix entry → graph finds spec via reverse-deps
- [ ] drift.md shows blast radius by spec
- [ ] PR comment lists affected files

---

## Fase 6 — Graph L1 JS/TS → v1.9.0-alpha.1 (4-5 dias) ✅ shipped (PR #21)

**Objetivo:** AST symbols + calls + signatures pra JS/TS. Base pra smart policy.

### Deliverables

| Item | Arquivo | O que faz |
|---|---|---|
| 6.1 | `lib/graph/parsers-l1/javascript.js` | Wrap tree-sitter-javascript |
| 6.2 | `lib/graph/parsers-l1/typescript.js` | Wrap tree-sitter-typescript (cobre TSX) |
| 6.3 | `lib/graph/extractors/functions.js` | AST → function declarations + signatures |
| 6.4 | `lib/graph/extractors/classes.js` | AST → class + methods |
| 6.5 | `lib/graph/extractors/calls.js` | AST → call sites |
| 6.6 | `lib/graph/extractors/exports.js` | AST → exports + module shape |
| 6.7 | `lib/graph/store.js` extension | Schema v2 com `symbols` + `calls` arrays |
| 6.8 | `lib/graph/queries/context.js` | symbol → declaration + callers + spec link |
| 6.9 | `lib/graph/queries/signature.js` | symbol → signature string normalizado |
| 6.10 | `lib/graph/queries/diff-symbols.js` | Compara before/after AST → lista mudanças |

### Schema graph v2

```json
{
  "version": 2,
  "level": "L1",
  "nodes": [
    {
      "id": "src/auth/login.js#login",
      "type": "function",
      "file": "src/auth/login.js",
      "name": "login",
      "signature": "(email: string, password: string) => string | null",
      "line": 12,
      "exported": true
    }
  ],
  "edges": [
    { "from": "src/auth/login.js#login", "to": "src/db/users.js#findUser", "kind": "calls", "line": 14 }
  ]
}
```

### Exit criteria

- [ ] Parse Aegis Spec próprio (TS) → graph tem >100 symbols
- [ ] `aegis graph context login` retorna assinatura + callers
- [ ] Performance: 1000-file repo em <8s

---

## Fase 7 — Graph L1 Python → v1.9.0-alpha.2 (3-4 dias) ✅ shipped (PR #22)

**Implementado:** `tree-sitter-python` via `optionalDependencies` (lazy load + fallback graceful pra L0 quando native binary ausente). Extractor produz mesmo schema canonical de JS/TS (`{ symbols, calls, exports }`). Captura type hints, async, decorators (staticmethod/property/classmethod), `__all__` para exports explícitos, `_prefix` pra nomes privados, superclasses para `extends`. Bonus: Python extractor já popula `from` (caller symbol) em cada call — JS/TS extractor receberá retrofit em follow-up.

| Item | Arquivo |
|---|---|
| 7.1 | `lib/graph/parsers-l1/python.js` (tree-sitter-python wrapper) |
| 7.2 | `lib/graph/extractors/python-functions.js` (def/class/method, type hints opcionais) |
| 7.3 | `lib/graph/extractors/python-calls.js` |
| 7.4 | Tests com sample repos Python |

---

## Fase 8 — Graph L1 Go → v1.9.0-alpha.3 (3-4 dias) ✅ shipped

**Implementado:** `tree-sitter-go` via `optionalDependencies` (lazy load + fallback graceful pra L0 quando native binary ausente). Extractor produz mesmo schema canonical (`{ symbols, calls, exports }`). Captura func declarations top-level, receivers (pointer e value) mapeados como `method` com id `file#Type.method`, type declarations (struct/interface/alias) com `goKind`, embedded fields como `extends`, call expressions com `from`-symbol resolvido (selector_expression incluso, ex. `fmt.Sprintf`), package decl, e exported flag via PascalCase rune. Suporta variadic params e multi-return signatures.

| Item | Arquivo |
|---|---|
| 8.1 | `lib/graph/parsers-l1/go.js` (tree-sitter-go wrapper) |
| 8.2 | `lib/graph/extractors/go.js` (func + receivers + interfaces + calls + exports) |
| 8.3 | `lib/graph/parsers-l1/index.js` (registry) |
| 8.4 | Resolve module via go.mod (deferido — L0 já cobre import path resolution) |

---

## Fase 9 — Graph L1 Java → v1.9.0-alpha.4 (4-5 dias) ✅ shipped

**Implementado:** `tree-sitter-java` via `optionalDependencies` (lazy load + fallback graceful pra L0). Extractor produz mesmo schema canonical (`{ symbols, calls, exports }`). Captura class/interface/record/enum (top-level e nested via prefixo `Outer.Inner`), métodos e construtores (id `file#Type.method`), modifiers via tokens anônimos do nó `modifiers` (public → exported), `extends`/`implements` como string em `extends`, `method_invocation` com receiver concatenado e `object_creation_expression` registrado como `new TypeName`. Maven/Gradle path resolution permanece em L0 — não bloqueia signature diff.

| Item | Arquivo |
|---|---|
| 9.1 | `lib/graph/parsers-l1/java.js` (tree-sitter-java wrapper) |
| 9.2 | `lib/graph/extractors/java.js` (class/interface/record/enum + methods + nested + calls + exports) |
| 9.3 | `lib/graph/parsers-l1/index.js` (registry) |
| 9.4 | Maven/Gradle path resolution (deferido — L0 cobre `import x.y.Z`) |

---

## Fase 10 — Smart policy gate (signature diff) → v1.9.0 (4-5 dias) ✅ shipped

**Implementado:** `lib/policy/diff-detector.js` parse before/after via L1 (qualquer das 5 langs já registradas) e devolve `{ added, removed, changed }` por id canonical. `check.js` agora distingue body-only vs signature-relevant edits em arquivos protegidos: quando `ctx.before` e `ctx.after` chegam, body-only é APPROVE; mudança de signature/exported/extends é BLOCK com `details` ricos (alternativas + callers extraídos do graph se `ctx.graph` for fornecido). Sem before/after, fallback ao comportamento conservador da Fase 4. `decisions.js` ganha categorias (`signature_change`, `deleted_symbol`, `new_export`, etc.) consumidas pelo CLI da Fase 11.

| Item | Arquivo |
|---|---|
| 10.1 | `lib/policy/diff-detector.js` (parse before/after via L1, indexa por id canonical) |
| 10.2 | `lib/policy/check.js` (smart resolve para protected_files / protected_globs) |
| 10.3 | `lib/policy/decisions.js` (categorias) |
| 10.4 | `lib/policy/reason-builder.js` (headline + details + alternatives) |
| 10.5 | `lib/policy/alternatives.js` (heurísticas: optional-param, overload, internal-export, spec-first) |
| 10.6 | Smoke test cross-lang (JS verificado; mesmo path roda Python/Go/Java/TS sem código adicional) |

Bump pra `1.9.0`.

---

## Fase 11 — policy-check CLI (CI gate) → v1.10.0 (3-4 dias) ✅ shipped

**Implementado:** CLI standalone que roda smart gate em git diff. Lê `git diff base...head`, materializa conteúdo via `git show ref:path` e alimenta `checkFile` com `ctx.before`/`ctx.after` — então signature/export/extends mudanças disparam BLOCK; body-only é APPROVE. Severidade `high` (default) bloqueia só `signature_change`/`deleted_symbol`; `medium` adiciona `protected_*` e `new_export`; `low` inclui blacklist. Exit 0/1/2 usável em qualquer CI. Templates pra GitHub Actions e GitLab CI prontos pra colar.

| Item | Arquivo |
|---|---|
| 11.1 | `lib/commands/policy-check.js` |
| 11.2 | `bin/aegis.js` (registra `policy-check`) |
| 11.3 | `--format=text` (default) e `--format=json` |
| 11.4 | `--severity` flag (high/medium/low) |
| 11.5 | `templates/ci/github-actions.yml` |
| 11.6 | `templates/ci/gitlab-ci.yml` |
| 11.7 | `docs/policy-check.{md,pt.md,es.md}` |

Bump pra `1.10.0`.

### CLI exemplo

```bash
npx aegis-spec policy-check --base origin/main --head HEAD --severity high
# Comparing origin/main...HEAD (severity=high)
#   ✗ src/auth/login.js: Signature change to protected `login` ...
#       kind: signature_change
#       old:  (email, password)
#       new:  (email, password, mfaCode)
#       → Make the new parameter optional
#       → Update the spec first
# Results: 0 approved · 0 advisory · 1 blocked (1 at gate)
# FAIL — exit 1
```

---

## Fase 12 — Auto Keeper mode → v2.0.0-alpha.1 (5-7 dias) ✅ shipped

**Implementado:** Pipeline de decisão completo, com LLM opt-in. Decision tree puro JS roda whitelist/blacklist/escalate antes de qualquer call à API; só quando nada cobre o caso, o classifier (Haiku) é chamado. Spec rewriter (Sonnet) só roda em ROUTE_AUTO. CLI `aegis keeper auto --dry-run` valida policy + queue sem rede — útil em CI. Anthropic SDK declarado em `optionalDependencies` + lazy load via createRequire (offline / dry-run não exige instalação). Prompt caching via system blocks: instrução estável + spec context separados, breakpoint no segundo bloco, diff per-PR no user turn (segue prefix-match invariant). Audit writer append-only em `.aegis/audit/YYYY-MM-DD.jsonl`.

| Item | Arquivo |
|---|---|
| 12.1 | `lib/auto/policy-schema.js` (parser YAML específico — 2-space + listas) |
| 12.2 | `lib/auto/classifier.js` (Haiku, lazy load, JSON-only response, fallback graceful) |
| 12.3 | `lib/auto/spec-writer.js` (Sonnet, full-spec rewrite com cache no spec content) |
| 12.4 | `lib/auto/decision-tree.js` (paths/change_types/escalate_on antes do LLM) |
| 12.5 | `lib/auto/prompt-cache.js` (system blocks com cache_control no contexto estável) |
| 12.6 | `lib/commands/keeper-auto.js` (`--dry-run`, `--max-specs`, audit append) |
| 12.7 | `templates/auto-policy.example.yaml` |
| 12.8 | `lib/audit/writer.js` (mínimo — Phase 13 expande) |

Bump pra `2.0.0-alpha.1`. Doc do agente e SKILL.md auto-mode ficam para Phase 14 final docs.

### auto-policy.yaml exemplo

```yaml
auto_resolve:
  enabled: true
  confidence_threshold: 0.85
  max_specs_per_pr: 5

  whitelist:
    paths: ["**/*.test.*", "**/*.spec.*", "docs/**"]
    change_types: [add_logging, format_only, comment_only, dep_bump_minor, test_only]

  blacklist:
    paths: ["**/contracts/**", "**/api/public/**", "**/migrations/**"]
    change_types: [public_api_change, business_rule_change, schema_migration, adr_required]

  escalate_on:
    - "🟢 → 🟡 downgrade"
    - "spec_deletion"
    - "new_adr_required"
    - "cross_cluster_change"

  llm:
    model: claude-haiku-4-5-20251001
    fallback: claude-sonnet-4-6
```

### Exit criteria

- [ ] `aegis keeper auto --dry-run` mostra decisões sem aplicar
- [ ] Whitelist de paths funciona (test files auto-resolved)
- [ ] Confidence threshold escalations funciona
- [ ] LLM cost <$0.10 por PR médio (cache hit ratio >70%)

---

## Fase 13 — Audit log + bot → v2.0.0-beta.1 (4-5 dias) ✅ shipped

**Implementado:** Audit writer ganhou redação configurável via `_aegis_sdd/audit-policy.json` (`{ "redact": [...] }` substitui campos por `sha256:<16hex>` mantendo correlação). Schema documentado em `lib/audit/schema.md`. Bot scaffold é webhook-shape-agnostic — handler `pr.js` aceita qualquer client com formato Octokit, executa `policy-index build` + `policy-check` + `keeper auto` via spawn (mesmo path que humano usa local), comita atualizações de spec com guard hard-fail se algo fora de `_aegis_sdd/**` aparecer no porcelain. Labels mapeadas em `lib/auto/labels.js` com escalate dominante.

| Item | Arquivo |
|---|---|
| 13.1 | `lib/audit/writer.js` (com redaction integrada) |
| 13.2 | `lib/audit/schema.md` |
| 13.3 | `lib/audit/redact.js` (sha256-prefix preserva correlação) |
| 13.4 | `bot/keeper-bot/` (handler + commit guard + install.md) |
| 13.5 | `bot/keeper-bot/handlers/pr.js` |
| 13.6 | `bot/keeper-bot/install.md` |
| 13.7 | `lib/auto/labels.js` (`keeper:auto-resolved` / `:needs-review` / `:escalated`) |
| 13.8 | `docs/keeper-auto.{md,pt.md,es.md}` (3 langs) |

Bump pra `2.0.0-beta.1`.

### Exit criteria

- [ ] Bot scaffold deployado (manifest + permissions)
- [ ] Bot commita só em `_aegis_sdd/**` (path-restricted)
- [ ] Audit log persiste todas decisões
- [ ] PR labels aplicados corretamente

---

## Fase 14 — CI templates + docs final → v2.0.0 (2-3 dias) ✅ shipped

**Implementado:** Templates CI prontos pra colar (GitHub Actions, GitLab CI, CircleCI), todos com 3 jobs (drift-check → policy-check → keeper-auto opcional). O job auto é gated pela secret `ANTHROPIC_API_KEY` em todos os três providers — sem secret o resto do gate continua rodando. Audit log é uploaded como artifact em todos. Pre-commit hook local idempotente via `lib/installer/git-hooks.js` (block guarded pelos markers `>>> aegis policy-check >>>`). Doc do control plane em 3 langs cobre toolset, modos HITL/Auto/Hybrid, lista de arquivos, e CI templates. Migration guide 1.x→2.0 enumera mudanças e rollback.

| Item | Arquivo |
|---|---|
| 14.1 | `templates/ci/github-actions-full.yml` |
| 14.2 | `templates/ci/gitlab-ci-full.yml` |
| 14.3 | `templates/ci/circleci-full.yml` |
| 14.4 | `lib/installer/git-hooks.js` (instala pre-commit hook idempotente) |
| 14.5 | `docs/control-plane.{md,pt.md,es.md}` |
| 14.6 | `docs/migration-1.x-to-2.0.md` |
| 14.7 | `README.md` (refs ao policy-check shipped) |

Bump pra `2.0.0`. **Aegis Spec 2.0 GA.**

### Exit criteria

- [ ] CI template clonável funciona em repo limpo
- [ ] Docs 3 langs completas
- [ ] Migration guide testado

---

## Resumo total

| Fase | Item | Dias | Versão |
|---|---|---|---|
| 1 | Hooks leves | 2 | 1.7.0 |
| 2 | Graph L0 5 langs | 4 | 1.8.0-α.1 |
| 3 | Storage + queries L0 + CLI | 3 | 1.8.0-α.2 |
| 4 | Basic policy gate | 4 | 1.8.0-α.3 |
| 5 | Keeper integra L0 | 3 | 1.8.0 |
| 6 | Graph L1 JS/TS | 5 | 1.9.0-α.1 |
| 7 | Graph L1 Python | 4 | 1.9.0-α.2 |
| 8 | Graph L1 Go | 4 | 1.9.0-α.3 |
| 9 | Graph L1 Java | 5 | 1.9.0-α.4 |
| 10 | Smart policy gate | 5 | 1.9.0 |
| 11 | policy-check CLI | 4 | 1.10.0 |
| 12 | Auto Keeper mode | 7 | 2.0.0-α |
| 13 | Audit + bot | 5 | 2.0.0-β |
| 14 | CI templates + docs | 3 | 2.0.0 |

**Total: ~58 dias úteis (~12 semanas).** Solo dev. Paralelizável a 8 semanas com 2 devs.

---

## Critical path

```
Fase 1 → Fase 2 → Fase 3 → Fase 5 (libera Keeper L0)
                       └→ Fase 4 (libera basic policy)
Fase 6 → Fase 10 → Fase 11 (libera smart policy + CI)
       ↓ paralelo
Fase 7,8,9 (langs adicionais)
Fase 12 → Fase 13 → Fase 14 (auto mode end-to-end)
```

Pode mergear em main por fase (cada fase = PR independente).

**Versão produção early:** v1.8.0 já vale (Keeper + L0 + basic policy).

---

## Decisões arquiteturais já tomadas

| Decisão | Razão |
|---|---|
| **Não usar GitNexus** | License PolyForm Noncommercial bloqueia users comerciais; scope 80% sobrando |
| **Build graph próprio MIT** | Controle total, tailored ao Aegis Spec, license limpa |
| **Tree-sitter como dep** | MIT, mature, multi-lang |
| **L0 + L1 layered** | L0 cobre todas langs raso (regex); L1 deep per-lang (AST) |
| **Hooks leves + batch** | Onerar sistema na ordem de 9s/task → 300ms/task |
| **HITL default + Auto opt-in** | Não quebra users existentes; auto via flag |
| **JSONL append-only** | Atomic writes POSIX, rápido, persiste crash |
| **Spec frontmatter pra contracts** | Mecanismo declarativo de proteção |
| **Override via ADR** | Força fluxo correto: spec antes de código |

---

## Modos de uso target

| Perfil | Como usa Aegis Spec 2.0 |
|---|---|
| Time legado | Aegis Spec extrai spec + Keeper mantém atualizada |
| Time com agent farm | Auto mode + auto-policy.yaml + audit |
| Empresa regulada | HITL mode + audit log persistente |
| Open source maintainer | drift-check + policy-check em CI bloqueia PR ruim |
