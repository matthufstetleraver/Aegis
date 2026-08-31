# Aegis Agents — Behavioral Evaluation against poc-frame-ai

> Date: 2026-05-17
> Target repo: `/home/wellington/Documents/RD/IA-RD-Iframe/poc-frame-ai`
> Aegis v2.0.0 installed in `aegis/` (28 skills)
> Method: systematic reading of each `SKILL.md` + manual simulation against hypothetical diff
> Simulated diffs:
>   - SIM-1: modify `web/Shared/src/services/searchProducts/index.ts` (regex `{2,}` → `{3,}`, add param `customSort`)
>   - SIM-2: add `web/Shared/src/services/searchProducts/sortHelpers.ts`
>   - SIM-3: delete `web/Shared/src/containers/search/SearchContainer.test.tsx`

---

## Executive Summary

Discovery pipeline ran complete (Scout→Reviewer, confidence 0.81). Post-install state has 28 skills, but **reactive machinery never exercised**: empty Keeper queue, empty audit, empty session-summaries, no git hooks. **Entire Forward team blocked** (8 skills) by missing `active-requirements.json`. **Migration team blocked** (5 skills) by missing `migration_brief.md` — by design. Generative skills are non-destructive: re-running Writer/Architect **doesn't propagate code changes** to already-existing specs. **Only reactive agent is Keeper**, and it operates in degraded mode (without `graph.json`, without published CLI).

**Verdict:** architecture covers the cycle, but day-to-day integration depends on git hook installation + functional CLI + `aegis/forward/` bootstrap that **don't happen automatically** after `aegis install`.

---

## Issues by agent

Severity: 🔴 CRITICAL · 🟠 HIGH · 🟡 MEDIUM · 🔵 LOW

### Cross-cutting (affect multiple agents)

| # | Sev | Issue | Where |
|---|-----|-------|------|
| ~~X-01~~ | ❌ false positive | `npx aegis-spec <subcmd>` works post-publish: package has single bin (`aegis`), npm resolves single-bin packages automatically. No bug here. | reviewed 2026-05-17 |
| X-02 | 🔴 | Package `aegis-spec` **not published on npm registry** (HTTP 404). All references to `npx aegis-spec ...` break in client project. Version check from orchestrator (`registry.npmjs.org/aegis-spec/latest`) also breaks. | global |
| X-03 | 🟠 | `state.json.checkpoints` out of sync with filesystem. `detective.outputs` lists ADRs (`ADR-001-busca-dual-engine`, `ADR-002-patrocinados-topsort`) that **don't exist** — actual names in FS are `001-multi-tenant-via-yarn-workspaces.md` etc. No agent reconciles. | `aegis/config/state.json` |
| X-04 | 🟠 | 8 Forward skills (requirements, doubt, plan, to-do, audit, quality, coding, resume) abort due to missing `aegis/config/active-requirements.json`. This file is created **only** by `/aegis-requirements`. **No clear bootstrap path** — user must guess that `/aegis-requirements` is the entry point. | Forward team |
| X-05 | 🟠 | `aegis/forward/` referenced in `state.json.forward_folder` and `setup.json.paths.forward-dir`, but **doesn't exist**. Installer creates specs folder but not forward folder — inconsistent UX. | installer + state.json |
| X-06 | 🟠 | `aegis/runtime/context/graph.json` **never generated** (only modules.json + surface.json). Keeper `after` mode falls to degraded mode: no `blast_radius`, no `severity`. No pipeline step generates graph.json — it's v1.8.0+ feature but installer 2.0.0 doesn't trigger. | installer + graph cmd |
| X-07 | 🟡 | `aegis/runtime/hooks.yml` installed with all arrays empty (before-/after- for 9 stages). Installer doesn't interact with user to wire project-specific hooks. | installer |
| X-08 | 🟡 | `aegis/runtime/queue/`, `aegis/runtime/audit/`, `aegis/runtime/session-summaries/` created empty. Without git hook writing to `keeper-queue.jsonl`, Keeper depends on manual `git diff HEAD`. | installer |
| X-09 | 🟡 | Generative skills (writer, architect, detective, scout) are **non-destructive**: re-running doesn't update existing specs. **Only Keeper reacts to code changes**. Re-extraction only works if user manually deletes old specs. | writer, architect, detective, scout |
| X-10 | 🟡 | `setup.json.watch.archive-after` and `watch.block-on-red` defined but **not mirrored** in `state.json`. Two sources of truth for config — risk of divergence. | config |
| X-11 | 🔵 | `aegis/config/files-manifest.json` listed as **deleted** in git status. Installer seems to have generated it in previous runs but not in current install — reinstall may fail or duplicate. | installer |
| X-12 | 🔵 | Mix of naming convention in config: `state.json` uses `snake_case` (`output_folder`, `chat_language`), `setup.json` uses `kebab-case` (`schema-version`, `aegis-version`), `manifest.yaml` uses `camelCase` (`installDate`, `lastUpdated`). | config |

### aegis (orchestrator)

| # | Sev | Issue |
|---|-----|-------|
| O-01 | 🟠 | Behavior with `phase=complete` (current state of poc-frame-ai) **not documented** in `references/step-02-resume.md`. Probably says "nothing to do". Confusing UX — user doesn't know if should re-run individual agents or accept state. |
| O-02 | 🟡 | Version check via `registry.npmjs.org/aegis-spec/latest` fails (X-02). Skill says "inform discreetly after greeting" — silently broken. |
| O-03 | 🟡 | Context compression via `session-summaries/` is good idea but dir is empty. Never triggered on first run (probably skill generates summaries only during execution, not retroactively). |
| O-04 | 🔵 | "Save checkpoint" + "Mark task in plan.md" — current `plan.md` still has all `[ ]` despite `state.json.completed` listing everything. **plan.md not updated** despite checkpoint done. |

### aegis-scout

| # | Sev | Issue |
|---|-----|-------|
| S-01 | 🟡 | Hard-coded exclusions: `node_modules`, `.git`, `aegis`, `dist`, `build`, `coverage`, `__pycache__`, `.cache`. **Doesn't include** `.next`, `.turbo`, `.vercel`, `target` (Rust), `vendor` (Go), `_modules` (yarn berry pnp). |
| S-02 | 🔵 | Counts extensions but doesn't detect multi-language repos with same extension (`.js` Node vs Deno, `.ts` Node vs Bun). Not blocking. |

### aegis-archaeologist

| # | Sev | Issue |
|---|-----|-------|
| A-01 | 🟠 | Re-runs only if user invokes manually — doesn't auto-detect modified module. If SIM-2 (`sortHelpers.ts`) adds important file, archaeologist needs re-run but no signal to orchestrator. |
| A-02 | 🟡 | Does regenerated `modules.json` preserve existing ones? SKILL says "non-destructive" — verify if merges new modules with kept ones. |

### aegis-detective

| # | Sev | Issue |
|---|-----|-------|
| D-01 | 🟠 | ADRs generated with "topic" names (002-search-engine-fallback-ladder) instead of sequential "decision" names. `state.json` still references old names. No reconciliation. |
| D-02 | 🟡 | `domain.md` rules numbered (RN-01, RN-02…) but **without enforced schema**. Re-run renumbers? Keeps? Breaks traceability of keeper citing "RN-01". |

### aegis-architect

| # | Sev | Issue |
|---|-----|-------|
| AR-01 | 🟡 | Generates C4 + ERD + spec-impact-matrix. Re-execution with `non-destructive` means Mermaid diagrams don't update after changes. Manual delete necessary. |
| AR-02 | 🟡 | No "diff mode" — user can't request "update only C4 components". |

### aegis-writer

| # | Sev | Issue |
|---|-----|-------|
| W-01 | 🟠 | Strict non-destructive: **existing canonical files never overwritten**, even if code drifts. Only path: delete file manually before re-run. No documented `--force` flag. |
| W-02 | 🟡 | `state.json.redator_progress` field cited but **absent** in current state.json. Writer interrupted resume left orphaned. |
| W-03 | 🟡 | "Preventive pause between units (3+)" good for context budget but creates unnecessary UX friction when running in automation mode. |
| W-04 | 🔵 | Confidence marker (🟢🟡🔴) "always present" — verify if tooling validates or just textual convention. |

### aegis-reviewer

| # | Sev | Issue |
|---|-----|-------|
| R-01 | 🟠 | "Cross-review via Codex" conditional on `doc_level=complete/detailed`. Codex is specific provider — assumes API key. No clear fallback for other providers. |
| R-02 | 🟡 | `confidence-report.md` regenerated each run overwrites confidence history. No timeline for quality regression. |

### aegis-keeper ⭐ (most critical — only reactive)

| # | Sev | Issue |
|---|-----|-------|
| K-01 | 🔴 | Without `code-spec-matrix.md` aborts. Without `graph.json` falls to degraded without severity. **Two fragile pre-reqs**, default install guarantees neither. |
| K-02 | 🔴 | CLI `aegis-spec graph impact <file> --json` referenced but wrong command (X-01) + package not published (X-02). Mode `after` v1.8.0+ broken in any client project. |
| K-03 | 🟠 | "Update specs in-place" depends on LLM detecting textual contradiction between new code and old spec. **No AST/regex validation**. SIM-1 (regex `{2,}` → `{3,}`) could be missed if LLM doesn't notice specific string in spec. |
| K-04 | 🟠 | `aegis/reports/domain.md` contains RN-XX referenced in code (`services/searchProducts/index.ts:122-129` for RN-01). Keeper SKILL says read "business rules from domain.md **when referenced**" — ambiguous. If spec SDD doesn't explicitly mention RN-01, regex change invalidates RN-01 but keeper doesn't notice. |
| K-05 | 🟠 | "Parent directory spec" heuristic to map new file. **Fails** for cross-module utilities (e.g. `sortHelpers.ts` in SIM-2 — which spec is "parent"? `search/` or none?). Results in vague matrix entry. |
| K-06 | 🟠 | Deleted file: matrix marks `~~deleted~~` but corresponding spec **not updated** to remove references to dead file. SIM-3 (test removed) leaves spec referencing non-existent test. |
| K-07 | 🟡 | `state-machines.md`, `permissions.md`, `architecture/*` **not in keeper's read path**. Changes affecting flow (not simple business rule) can stay invisible. |
| K-08 | 🟡 | `aegis/changelog/` and `aegis/reports/drift.md` created on-demand — first Keeper run bootstraps these paths. User doesn't know they'll exist. |
| K-09 | 🟡 | Queue file `keeper-queue.jsonl` expected in `aegis/runtime/queue/` but **no hook generates**. Schema in `references/queue-schema.md` but installer doesn't wire git pre-commit/post-commit to write. |
| K-10 | 🟡 | `state.json` desync reconciliation (X-03) not Keeper's responsibility — but no one does. Orphaned bug. |
| K-11 | 🔵 | Mode `before` "Show to user" — only works in interactive mode. In CI/automation where Keeper runs without prompt, output discarded. |

### aegis-data-master / aegis-design-system / aegis-visor

| # | Sev | Issue |
|---|-----|-------|
| DM-01 | 🟡 | Skills "any phase" but without automatic trigger. User must remember to invoke when DB schema or design tokens change. |
| DS-01 | 🟡 | Design-system re-runs regenerating `color-palette.md` etc — overrides manual customizations. Non-destructive behavior documented for writer but unclear for design-system. |
| V-01 | 🔵 | Visor requires screenshots manually; no Playwright/storybook screenshot capture integration. |

### aegis-migrate / paradigm-advisor / curator / strategist / designer / inspector

| # | Sev | Issue |
|---|-----|-------|
| M-01 | 🟠 | Entire team blocked without `migration_brief.md`. `aegis-migrate` orchestrates creation but user must know that's the entry-point. |
| M-02 | 🟡 | Mandatory human pause between paradigm-advisor → curator → strategist → designer → inspector. **5 stops** in pipeline. Good for control, bad for throughput. No `--auto-approve` mode. |
| M-03 | 🟡 | `inspector` generates Gherkin `.feature` — no automatic translator to Jest/Playwright/Cypress. Specs become code via different path. |

### aegis-reconstructor

| # | Sev | Issue |
|---|-----|-------|
| RC-01 | 🟡 | "Bottom-up, one task per session" preserves tokens but requires discipline to summarize. Without robust state tracking, easy to lose place. |

### Forward team (requirements, doubt, plan, to-do, audit, quality, coding, resume)

| # | Sev | Issue |
|---|-----|-------|
| F-01 | 🟠 | **All blocked** without `active-requirements.json` (X-04). |
| F-02 | 🟠 | `aegis-coding` requires `architecture.md` AND `domain.md` "in `aegis/` directory". V2 layout moves to `aegis/architecture/architecture.md` and `aegis/reports/domain.md` — **check may fail on literal path**. Needs testing. |
| F-03 | 🟡 | `aegis-audit` outputs to `feature-dir/audit/cross-check.md`. Without active feature, dir doesn't exist. |
| F-04 | 🟡 | `aegis-doubt` integrates responses in original `requirements.md`. If user edits requirements between runs, integration can break markdown. |
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
