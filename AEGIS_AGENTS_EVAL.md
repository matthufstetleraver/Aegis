# Aegis Agents — Avaliação Comportamental contra poc-frame-ai

> Data: 2026-05-17
> Repo alvo: `/home/wellington/Documents/RD/IA-RD-Iframe/poc-frame-ai`
> Aegis v2.0.0 instalado em `aegis/` (28 skills)
> Método: leitura sistemática de cada `SKILL.md` + simulação manual contra diff hipotético
> Diff simulado:
>   - SIM-1: modify `web/Shared/src/services/searchProducts/index.ts` (regex `{2,}` → `{3,}`, adicionar param `customSort`)
>   - SIM-2: add `web/Shared/src/services/searchProducts/sortHelpers.ts`
>   - SIM-3: delete `web/Shared/src/containers/search/SearchContainer.test.tsx`

---

## Resumo executivo

Pipeline de descoberta rodou completo (Scout→Reviewer, confidence 0.81). Estado pós-instalação tem 28 skills, mas **maquinaria reativa nunca foi exercitada**: keeper queue vazia, audit vazio, session-summaries vazio, sem hooks git. **Forward team inteiro bloqueado** (8 skills) por falta de `active-requirements.json`. **Migration team bloqueado** (5 skills) por falta de `migration_brief.md` — by design. Skills generativas são non-destructive: rerodar Writer/Architect **não propaga mudanças de código** para specs já existentes. O **único agente reativo a diffs é o Keeper**, e ele opera em modo degradado (sem `graph.json`, sem CLI publicada).

**Veredito**: arquitetura cobre o ciclo, mas integração no dia-a-dia depende de instalação de hooks git + CLI funcional + bootstrap de `aegis/forward/` que **não acontecem automaticamente** após `aegis install`.

---

## Issues por agente

Severidade: 🔴 CRITICAL · 🟠 HIGH · 🟡 MEDIUM · 🔵 LOW

### Cross-cutting (afetam múltiplos agentes)

| # | Sev | Issue | Onde |
|---|-----|-------|------|
| ~~X-01~~ | ❌ falso positivo | `npx aegis-spec <subcmd>` funciona pós-publish: pacote tem bin único (`aegis`), npm resolve single-bin packages automaticamente. Não há bug aqui. | revisado 2026-05-17 |
| X-02 | 🔴 | Pacote `aegis-spec` **não publicado no npm registry** (HTTP 404). Toda referência `npx aegis-spec ...` quebra em projeto cliente. Version check do orquestrador (`registry.npmjs.org/aegis-spec/latest`) também quebra. | global |
| X-03 | 🟠 | `state.json.checkpoints` desincronizado do filesystem. `detective.outputs` lista ADRs (`ADR-001-busca-dual-engine`, `ADR-002-patrocinados-topsort`) que **não existem** — nomes reais no FS são `001-multi-tenant-via-yarn-workspaces.md` etc. Nenhum agente reconcilia. | `aegis/config/state.json` |
| X-04 | 🟠 | 8 skills do Forward (requirements, doubt, plan, to-do, audit, quality, coding, resume) abortam por falta de `aegis/config/active-requirements.json`. Esse arquivo é criado **só** por `/aegis-requirements`. **Sem caminho de bootstrap claro** — usuário precisa adivinhar que `/aegis-requirements` é o ponto de entrada. | Forward team |
| X-05 | 🟠 | `aegis/forward/` referenciado em `state.json.forward_folder` e `setup.json.paths.forward-dir`, mas **não existe**. Instalador cria a pasta de specs mas não a pasta forward — UX inconsistente. | installer + state.json |
| X-06 | 🟠 | `aegis/runtime/context/graph.json` **nunca gerado** (só modules.json + surface.json). Keeper modo `after` cai em modo degradado: sem `blast_radius`, sem `severity`. Nenhum passo do pipeline de descoberta gera graph.json — ele é v1.8.0+ feature mas instalador 2.0.0 não dispara. | installer + graph cmd |
| X-07 | 🟡 | `aegis/runtime/hooks.yml` instalado com todos os arrays vazios (before-/after- pra 9 stages). Instalador não interage com usuário pra wirear hooks específicos do projeto. | installer |
| X-08 | 🟡 | `aegis/runtime/queue/`, `aegis/runtime/audit/`, `aegis/runtime/session-summaries/` criados vazios. Sem git hook que escreva em `keeper-queue.jsonl`, Keeper depende de `git diff HEAD` (manual). | installer |
| X-09 | 🟡 | Skills generativas (writer, architect, detective, scout) são **non-destructive**: rerodar não atualiza specs existentes. **Apenas Keeper reage a mudanças de código**. Re-extração só funciona se usuário deletar specs antigas manualmente. | writer, architect, detective, scout |
| X-10 | 🟡 | `setup.json.watch.archive-after` e `watch.block-on-red` definidos mas **não espelhados** em `state.json`. Duas fontes de verdade pra config — risco de divergência. | config |
| X-11 | 🔵 | `aegis/config/files-manifest.json` listado como **deleted** no git status. Instalador parece tê-lo gerado em runs anteriores mas não na instalação atual — re-instalação pode falhar ou duplicar. | installer |
| X-12 | 🔵 | Mistura de naming convention em config: `state.json` usa `snake_case` (`output_folder`, `chat_language`), `setup.json` usa `kebab-case` (`schema-version`, `aegis-version`), `manifest.yaml` usa `camelCase` (`installDate`, `lastUpdated`). | config |

### aegis (orquestrador)

| # | Sev | Issue |
|---|-----|-------|
| O-01 | 🟠 | Comportamento com `phase=completo` (estado atual do poc-frame-ai) **não documentado** em `references/step-02-resume.md`. Provavelmente diz "nada a fazer". UX confuso — usuário não sabe se deve re-rodar agentes individuais ou aceitar estado. |
| O-02 | 🟡 | Version check via `registry.npmjs.org/aegis-spec/latest` falha (X-02). Skill diz "informe discretamente após saudação" — silenciosamente broken. |
| O-03 | 🟡 | Compressão de contexto via `session-summaries/` é boa ideia mas dir está vazio. Nunca acionado em primeira run (provavelmente skill gera summaries só durante execução, não retroativamente). |
| O-04 | 🔵 | "Salve checkpoint" + "Marque tarefa em plan.md" — `plan.md` atual ainda tem todos `[ ]` apesar de `state.json.completed` listar tudo. **plan.md não foi atualizado** apesar de checkpoint feito. |

### aegis-scout

| # | Sev | Issue |
|---|-----|-------|
| S-01 | 🟡 | Hard-coded exclusions: `node_modules`, `.git`, `aegis`, `dist`, `build`, `coverage`, `__pycache__`, `.cache`. **Não inclui** `.next`, `.turbo`, `.vercel`, `target` (Rust), `vendor` (Go), `_modules` (yarn berry pnp). |
| S-02 | 🔵 | Conta extensões mas não detecta multi-language repos com mesma extensão (`.js` Node vs Deno, `.ts` Node vs Bun). Não bloqueante. |

### aegis-archaeologist

| # | Sev | Issue |
|---|-----|-------|
| A-01 | 🟠 | Reroda só se usuário invocar manualmente — não detecta automaticamente módulo modificado. Se SIM-2 (`sortHelpers.ts`) adiciona arquivo importante, archaeologist precisa ser re-rodado mas não há sinal pro orquestrador. |
| A-02 | 🟡 | `modules.json` regenerado preserva existentes? SKILL diz "non-destructive" — verificar se merge módulos novos com mantidos. |

### aegis-detective

| # | Sev | Issue |
|---|-----|-------|
| D-01 | 🟠 | ADRs gerados com nomes "tópicos" (002-search-engine-fallback-ladder) ao invés de "decisão" sequenciais. `state.json` ainda referencia nomes antigos. Não há reconciliação. |
| D-02 | 🟡 | `domain.md` regras numeradas (RN-01, RN-02…) mas **sem schema enforced**. Reroda renumera? Mantém? Quebra rastreabilidade do keeper que cita "RN-01". |

### aegis-architect

| # | Sev | Issue |
|---|-----|-------|
| AR-01 | 🟡 | Gera C4 + ERD + spec-impact-matrix. Re-execução com `non-destructive` significa que diagramas Mermaid não atualizam após mudanças. Manual delete necessário. |
| AR-02 | 🟡 | Não há "diff mode" — usuário não consegue pedir "atualize só C4 components". |

### aegis-writer

| # | Sev | Issue |
|---|-----|-------|
| W-01 | 🟠 | Non-destructive estrito: **arquivos canônicos existentes nunca são sobrescritos**, mesmo se código drift. Único caminho: deletar arquivo manualmente antes de re-rodar. Não há flag `--force` documentada. |
| W-02 | 🟡 | `state.json.redator_progress` campo citado mas **ausente** no state.json atual. Resume de Writer interrompido fica órfão. |
| W-03 | 🟡 | "Pausa preventiva entre units (3+)" boa para context budget mas força fricção UX desnecessária quando rodando em modo automation. |
| W-04 | 🔵 | Confidence marker (🟢🟡🔴) "sempre presente" — verificar se tooling valida ou é só convenção textual. |

### aegis-reviewer

| # | Sev | Issue |
|---|-----|-------|
| R-01 | 🟠 | "Revisão cruzada via Codex" condicional em `doc_level=completo/detalhado`. Codex é provedor específico — assume API key. Sem fallback claro pra outros providers. |
| R-02 | 🟡 | `confidence-report.md` regerado a cada run sobrescreve histórico de confiança. Sem timeline de regressão de qualidade. |

### aegis-keeper ⭐ (mais crítico — único reativo)

| # | Sev | Issue |
|---|-----|-------|
| K-01 | 🔴 | Sem `code-spec-matrix.md` aborta. Sem `graph.json` cai em degradado sem severity. **Dois pré-reqs frágeis**, instalação default não garante nenhum. |
| K-02 | 🔴 | CLI `aegis-spec graph impact <file> --json` referenciado mas comando errado (X-01) + package não publicado (X-02). Modo `after` v1.8.0+ broken em qualquer projeto cliente. |
| K-03 | 🟠 | "Atualizar specs in-place" depende de LLM detectar contradição textual entre código novo e spec antiga. **Sem validação AST/regex**. SIM-1 (regex `{2,}` → `{3,}`) pode passar batido se LLM não notar a string específica no spec. |
| K-04 | 🟠 | `aegis/reports/domain.md` contém RN-XX referenciadas no código (`services/searchProducts/index.ts:122-129` para RN-01). Keeper SKILL diz ler "regras de negócio do domain.md **quando referenciado**" — ambíguo. Se spec SDD não menciona RN-01 explicitamente, mudança no regex invalida RN-01 mas keeper não percebe. |
| K-05 | 🟠 | Heurística "spec do diretório pai" pra mapear arquivo novo. **Falha** pra utilitários cross-module (e.g. `sortHelpers.ts` em SIM-2 — qual spec é "pai"? `search/` ou nenhuma?). Resulta em entry vago na matrix. |
| K-06 | 🟠 | Arquivo deletado: matrix marca `~~deletado~~` mas spec correspondente **não é atualizada** para remover referências ao arquivo morto. SIM-3 (test removido) deixa spec referenciando teste inexistente. |
| K-07 | 🟡 | `state-machines.md`, `permissions.md`, `architecture/*` **não estão no read path** do keeper. Mudanças que afetam fluxo (não regra de negócio simples) podem ficar invisíveis. |
| K-08 | 🟡 | `aegis/changelog/` e `aegis/reports/drift.md` criados sob demanda — primeiro run de keeper bootstraps esses paths. Usuário não sabe que vão existir. |
| K-09 | 🟡 | Queue file `keeper-queue.jsonl` esperado em `aegis/runtime/queue/` mas **nenhum hook gera**. Schema em `references/queue-schema.md` mas instalador não wira git pre-commit/post-commit para escrever. |
| K-10 | 🟡 | Reconciliação `state.json` desync (X-03) não é responsabilidade do keeper — mas ninguém faz. Bug órfão. |
| K-11 | 🔵 | Modo `before` "Mostre ao usuário" — só funciona em modo interativo. Em CI/automation onde keeper roda sem prompt, retorno é descartado. |

### aegis-data-master / aegis-design-system / aegis-visor

| # | Sev | Issue |
|---|-----|-------|
| DM-01 | 🟡 | Skills "any phase" mas sem trigger automatic. Usuário precisa lembrar de invocar quando DB schema ou design tokens mudam. |
| DS-01 | 🟡 | Design-system reroda regenerando `color-palette.md` etc — overrides customizações manuais. Non-destructive comportamento documentado pro writer mas não-claro pra design-system. |
| V-01 | 🔵 | Visor precisa de screenshots manualmente; sem integração com Playwright/storybook screenshot capture. |

### aegis-migrate / paradigm-advisor / curator / strategist / designer / inspector

| # | Sev | Issue |
|---|-----|-------|
| M-01 | 🟠 | Time inteiro bloqueado sem `migration_brief.md`. `aegis-migrate` orquestra criação mas usuário precisa saber que esse é o entry-point. |
| M-02 | 🟡 | Pausa humana obrigatória entre paradigm-advisor → curator → strategist → designer → inspector. **5 stops** em pipeline. Bom pra controle, ruim pra throughput. Sem modo `--auto-approve`. |
| M-03 | 🟡 | `inspector` gera Gherkin `.feature` — não há tradutor automático pra Jest/Playwright/Cypress. Specs viram código por outro caminho. |

### aegis-reconstructor

| # | Sev | Issue |
|---|-----|-------|
| RC-01 | 🟡 | "Bottom-up, uma tarefa por sessão" preserva tokens mas requer disciplina pra resumir. Sem state tracking robusto, fácil perder o lugar. |

### Forward team (requirements, doubt, plan, to-do, audit, quality, coding, resume)

| # | Sev | Issue |
|---|-----|-------|
| F-01 | 🟠 | **Todos bloqueados** sem `active-requirements.json` (X-04). |
| F-02 | 🟠 | `aegis-coding` exige `architecture.md` E `domain.md` "no diretório aegis/". V2 layout move pra `aegis/architecture/architecture.md` e `aegis/reports/domain.md` — **check pode falhar por path literal**. Precisa testar. |
| F-03 | 🟡 | `aegis-audit` produz `feature-dir/audit/cross-check.md`. Sem feature ativa, dir nem existe. |
| F-04 | 🟡 | `aegis-doubt` integra respostas no `requirements.md` original. Se usuário edita requirements entre runs, integração pode quebrar markdown. |
| F-05 | 🟡 | `aegis-quality` purely reader — good principle. But report goes in `feature-dir/quality/`? SKILL doesn't specify exact path. |
| F-06 | 🟡 | `aegis-coding` "updates checkboxes to [X]" in `actions.md` — depends on consistent checkbox pattern. Without validated schema. |
| F-07 | 🔵 | `aegis-resume` swap only works if `paused-features` has entries. Without it, clear abort. OK. |

### aegis-principles

| # | Sev | Issue |
|---|-----|-------|
| P-01 | 🟡 | "Propagates suggestions in dependent templates" — no automatic propagation mechanism, just LLM prompt. Fragile. |
| P-02 | 🔵 | Principles in `aegis/config/principles.md`. Template exists in `runtime/templates/principles-template.md` but Keeper/Writer don't read principles by default. |

### aegis-n8n

| # | Sev | Issue |
|---|-----|-------|
| N-01 | 🔵 | Only skill with dedicated external input (`n8n_json_workflows/`). Isolated convention, doesn't integrate naturally with `aegis/specs/`. |

### aegis-agents-help

| # | Sev | Issue |
|---|-----|-------|
| H-01 | 🔵 | Static text presented verbatim ("unchanged, not summarized"). Can become outdated vs actual agent list. |

---

## Improvement Recommendations (strategic)

### Tier 1 — blockers

1. **Publish `aegis-spec` on npm** or replace all mentions with local install path (`./node_modules/.bin/aegis`, git URL install). X-02.
2. **Fix CLI invocation** in SKILL.md: `aegis graph build` instead of `npx aegis-spec graph build`. X-01, K-02.
3. **Generate `graph.json` automatically** at end of discovery pipeline (or in Writer / Architect). Without graph, Keeper can't calculate severity. X-06.
4. **Bootstrap `active-requirements.json`** when installer finishes, with placeholder `null` — forward skills detect null vs absent and show clear onboarding. X-04, F-01.

### Tier 2 — robustness

5. **Reconcile `state.json` ↔ filesystem** on any skill start. Stale checkpoint outputs = visible warning. X-03.
6. **Auto-update `plan.md`** after checkpoint (orchestrator). O-04.
7. **Keeper reads reports/** (domain, state-machines, permissions) always, not just specs/sdd. K-04, K-07.
8. **Explicit force flag** in writer/architect/detective for controlled destructive rerun. W-01.
9. **Git hook installed optionally** in `aegis install` (with prompt). Without hook, queue only receives via `git diff`. K-09, X-08.

### Tier 3 — DX/automation

10. **`--auto-approve` mode** for migration team. M-02.
11. **Optional AST validation** in Keeper to detect code↔spec contradiction (e.g. regex string match). K-03.
12. **Reconciliation between extractions**: skill `aegis-sync` that takes diff of specs vs state.json and proposes merge. Doesn't exist.
13. **Single naming convention** in config files. X-12.
14. **Show post-install onboarding**: user finishes `aegis install`, gets checklist "next step: run `/aegis` (discovery) or `/aegis-requirements` (new feature)". Today setup ends silent.

---

## Task List (actionable in order)

Severity + dependency considered. IDs linked to issues above.

### Sprint 1 — Functional CLI (blockers) — STATUS: partial

- [x] **T01** [X-02, K-02] Publish npm: OIDC workflow created (`.github/workflows/publish.yml`). Waiting for first manual publish (OTP).
- [x] ~~**T02**~~ Canceled — false positive (single-bin auto-resolution).
- [x] **T03** [X-06] Hint added at end of installer ("Run `aegis graph build` once..."). Doesn't auto-run to avoid blocking install on large repos.
- [x] **T04** [X-04, X-05, F-01] `lib/paths.js` gains `FORWARD_DIR` + `ACTIVE_REQUIREMENTS_JSON`. `writer.js` creates forward directory + bootstrap json `{active:null,paused-features:[]}`. 330 tests passing.

### Sprint 2 — State Reconciliation — STATUS: completed (39cb646)

- [x] **T05** [X-03] `reconcileState()` + `pruneStaleCheckpoints()` in `lib/state/reconcile.js`. CLI `aegis state reconcile [--prune] [--json]`. 8 unit tests.
- [x] **T06** [O-04] `agents/aegis/SKILL.md` instructs orchestrator to mirror `state.json.completed` in `plan.md` after each checkpoint.
- [x] **T07** [X-12, X-10] `templates/forward/setup.json` migrated kebab→snake_case. `migrateSetupJson()` runs on install and update (idempotent). 4 unit tests.
- [x] **T08** [X-11] Confirmed: `buildManifest/saveManifest` already wired in install/update/uninstall. Gap was specific project state, not code.

### Sprint 3 — Keeper Robustness

- [x] **T09** [K-04, K-07] Keeper SKILL.md expands read path: `domain.md` (cross-references RN-XX by line), `state-machines.md`, `permissions.md`, `architecture/*.md` always read when relevant.
- [x] **T10** [K-03] `lib/auto/literal-extractor.js`: extracts literals from diff, cross-references with spec, injects hint in spec-writer prompt. 10 tests.
- [x] **T11** [K-05] `lib/auto/spec-resolver.js`: fallback graph reverse-deps when matrix has no match for new file. 6 tests.
- [x] **T12** [K-06] `lib/auto/deleted-ref-cleaner.js`: scans `aegis/specs/**/*.md`, finds refs to deleted file, rewrites via LLM with deletion hint. 5 tests.
- [x] **T13** [K-09, X-08] Pre-commit hook opt-in in installer: `installGitHook()` wired in `install.js`, prompt `install_git_hook` in `prompts.js`. Runs `aegis policy-check --severity medium` on staged diff.

### Sprint 4 — Writer/Architect/Detective Controlled Non-destructive — STATUS: completed (72e8e0d)

- [x] **T14** [W-01, AR-01] SKILLs document `--force` (regenerate all) and `--regenerate <file>` (regenerate specific file). Controlled override of non-destructive.
- [x] **T15** [W-02] `state.json.redator_progress` added. Writer saves `{"last_unit": "...", "last_file": "..."}` after each file. Resume offers "continue from where left off".
- [ ] **T16** [W-04] Skipped — confidence marker linter optional, low priority.
- [x] **T17** [R-02] Reviewer appends new run in `confidence-report.md` with delimiter `---\n## Run [ts]` instead of overwriting. History preserved.

### Sprint 5 — Forward Bootstrap — STATUS: completed (b29cc68)

- [x] **T18** [F-02] aegis-coding check line 40: `aegis/architecture/architecture.md` (full path) vs ambiguous `architecture.md`. Correct path for v2.
- [x] **T19** [F-03, F-04, F-05, F-06] aegis-quality output moved from `feature-dir/audit/` to `feature-dir/quality/`. Other agents already correct.
- [x] **T20** [F-04] aegis-doubt: guards added — if `[DOUBT]` absent or text edited >50%, skip patch and warn user. Doesn't overwrite manual edits.

### Sprint 6 — UX/DX — STATUS: completed (33d016c)

- [x] **T21** [O-01] aegis SKILL.md: phase=complete now informs "Pipeline complete. Delete aegis/specs/ or --force for re-extraction. Use /aegis-keeper after for drift."
- [x] **T22** [O-02] aegis SKILL.md: version check tries npm, fallback to `git tag | sort -V | tail -1`, if both fail skip silently.
- [ ] **T23** [P-01] Skipped — principles propagation complex, low priority.
- [x] **T24** [DM-01, DS-01, V-01] data-master/design-system/visor: "When to run" section added. Any-phase: merge when artifacts exist, --force for full regen.
- [x] **T25** [M-02] aegis-migrate SKILL.md: --auto / --auto-approve mode documented. Applies auto-defaults, logs to ambiguity_log.md, zero pauses.
- [x] **T26** [S-01] aegis-scout: exclusions expanded (.next, .turbo, .vercel, target, vendor, .gradle, .maven, out).
- [x] **T27** [H-01] aegis-agents-help: dynamic generation. Reads installed agents from SKILL.md frontmatter, groups by role. Removes hard-code.

### Sprint 7 — End-to-End Validation — STATUS: completed (2cdab29)

- [x] **T28** test/smoke-keeper.sh: smoke test Keeper enhancements (T10-T12 unit tests). test/smoke.sh attempted full installer (skipped — installer needs --non-interactive). test/fixtures/smoke-minimal created for future e2e.
- [x] **T29** lib/commands/coverage.js: CLI `aegis coverage [--json]`. Reports source file coverage (% in matrix) and spec freshness (% last_synced <30d). Wired in bin/aegis.js.

---

## Appendix — Simulated agent behavior vs SIM-1/2/3

| Agent | SIM-1 (mod regex) | SIM-2 (add helper) | SIM-3 (del test) |
|-------|-------------------|--------------------|--------------------|
| aegis (orchestrator) | noop (phase=complete) | noop | noop |
| scout | rerun overwrite surface.json? non-destructive unclear | same | same |
| archaeologist | rerun doesn't detect — manual | manual | manual |
| detective | RN-01 invalidated — doesn't detect without manual rerun | n/a | n/a |
| architect | C4 doesn't change (no new containers) | would add component — doesn't detect | n/a |
| writer | non-destructive — specs/sdd/search/* intact | same — new spec NOT created automatically | same |
| reviewer | confidence may be stale — no rerun | same | same |
| Keeper after | **detects via git diff**, updates spec/sdd/search if LLM notices regex; **doesn't auto-update domain.md/RN-01** | matrix entry via "parent dir" heuristic → search/. Spec NOT created. | matrix marks `~~deleted~~`; spec NOT removed from references |
| data-master | n/a (no DDL) | n/a | n/a |
| design-system | n/a (no CSS) | n/a | n/a |
| visor | n/a (no screenshots) | n/a | n/a |
| migrate team | blocked without brief | blocked | blocked |
| forward team | blocked without active-requirements | blocked | blocked |
| reconstructor | n/a | n/a | n/a |
| n8n | n/a | n/a | n/a |
| principles | n/a (no principle change) | n/a | n/a |

**Translation**: of 28 agents, **only Keeper reacts** to simulated diff — and in degraded mode. Everything else is manual or blocked.

---

## Appendix 2 — Inventory of gaps in poc-frame-ai

Initial state after installation (expected gaps to close when T1-T4 ready):

- [ ] `aegis/runtime/context/graph.json` — generate via `aegis graph build`
- [ ] `aegis/config/active-requirements.json` — null template
- [ ] `aegis/forward/` — directory
- [ ] `aegis/reports/drift.md` — first Keeper run bootstraps
- [ ] `aegis/changelog/` — first Keeper run bootstraps
- [ ] `aegis/config/files-manifest.json` — regenerate (is deleted in git status)
- [ ] `aegis/runtime/session-summaries/` — populates in orchestrator runs
- [ ] state.json checkpoints reconciled (ADRs with real names)
- [ ] plan.md checkboxes aligned to state.json.completed

---

> Next step: prioritize T01-T04 (Sprint 1) and validate with smoke test (T28).
