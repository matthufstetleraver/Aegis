# Aegis — Sprint Status
Source: `AEGIS_AGENTS_EVAL.md` · 2026-05-18

---

## Sprint 1 — Functional CLI ✅

| # | Status | Problem | What was done |
|---|--------|---------|---------------|
| T01 | ✅ | `aegis-spec` not published on npm — any `npx aegis` broke in client project | Created GitHub Actions workflow with OIDC to publish automatically on npm on each main push |
| T02 | ~~canceled~~ | False positive — thought `npx aegis-spec graph` was wrong | npm resolves single-bin automatically, there was no bug |
| T03 | ✅ | After `aegis install`, `graph.json` was never generated — Keeper was in degraded mode without severity/blast_radius | Added hint at end of installer: "Run `aegis graph build` once to enable impact analysis" |
| T04 | ✅ | 8 Forward team skills aborted due to missing `active-requirements.json` and `aegis/forward/` didn't exist | `lib/paths.js` + constants `FORWARD_DIR`/`ACTIVE_REQUIREMENTS_JSON`. Writer creates the folder and JSON `{active:null}` on install |

---

## Sprint 2 — State Reconciliation ✅ (commit 39cb646)

| # | Status | Problem | What was done |
|---|--------|---------|---------------|
| T05 | ✅ | `state.json.checkpoints` listed ADRs (`ADR-001-busca-dual-engine`) that didn't exist in FS — no agent detected the drift | Created `reconcileState()` and `pruneStaleCheckpoints()`. CLI: `aegis state reconcile [--prune] [--json]`. 8 tests |
| T06 | ✅ | `plan.md` had all `[ ]` even after checkpoints saved in `state.json.completed` — two sources of truth diverging | Orchestrator SKILL.md now instructs mirroring `state.json.completed` → checkboxes in `plan.md` after each checkpoint |
| T07 | ✅ | `state.json` used `snake_case`, `setup.json` used `kebab-case` — inconsistent config, risk of divergence | Migrated `setup.json` template to snake_case. `migrateSetupJson()` converts existing projects on install/update. 4 tests |
| T08 | ✅ | `files-manifest.json` appeared as `deleted` in git — suspected installer wasn't saving | Confirmed `buildManifest/saveManifest` was already wired. Was problem of specific project state, not code bug |

---

## Sprint 3 — Keeper Robustness 🔄

| # | Status | Problem | What was done / will do |
|---|--------|---------|------------------------|
| T09 | ✅ | Keeper only read specs/sdd. Changes invalidating business rules (`domain.md`), state flows or permissions passed invisibly | SKILL.md expanded: reads `domain.md` cross-referencing RN-XX by line number, `state-machines.md` when diff touches transitions, `permissions.md` in auth/RBAC changes, `architecture/*.md` when involving C4 containers |
| T10 | ✅ | Keeper detects contradictions only by LLM textual reading. SIM-1 (regex `{2,}` → `{3,}`) can slip through if LLM doesn't notice exact string in spec | `lib/auto/literal-extractor.js`: extracts literals from diff, detects removed values still present in spec, injects explicit hint in prompt. 10 tests. |
| T11 | ✅ | New file (`sortHelpers.ts`) mapped to spec by heuristic "parent directory" — fails for cross-module utilities without obvious parent spec | `lib/auto/spec-resolver.js`: matrix first, then graph reverse-deps (1 level) as fallback. keeper-auto uses when `entry.spec_path` absent. 6 tests. |
| T12 | ✅ | Deleted file: matrix marks `~~deleted~~` but specs referencing that file remain intact, pointing to dead code | `lib/auto/deleted-ref-cleaner.js`: scans `aegis/specs/**/*.md`, finds mentions of dead file, rewrites via LLM with removal instruction. 5 tests. |
| T13 | ✅ | `keeper-queue.jsonl` never received entries — without git hook, Keeper depended only on manual `git diff HEAD` | Opt-in prompt in installer. `installGitHook()` wires `aegis policy-check --severity medium` in staged diff via `.git/hooks/pre-commit` |

---

## Sprint 4 — Writer/Architect/Detective Non-destructive ✅ (commit 72e8e0d)

| # | Status | Problem | What was done |
|---|--------|---------|---------------|
| T14 | ✅ | Writer/Architect are strict non-destructive — only way to re-run is delete specs manually. No `--force` documented | SKILLs document `--force` (all) and `--regenerate <file>` (single). Agents interpret via prompt, don't need CLI code |
| T15 | ✅ | `state.json.redator_progress` cited in SKILL but absent in real JSON — interrupted Writer has no way to resume where it stopped | `templates/state.json` now has `redator_progress: null`. Writer saves `{"last_unit", "last_file"}` after each file. Resume offers retry vs restart |
| T16 | ⬜ | Confidence markers (🟢🟡🔴) are textual convention — nothing validates if they're present/correct | Skipped — optional, low priority |
| T17 | ✅ | `confidence-report.md` is regenerated each run, overwriting history — impossible to see quality regression over time | Reviewer appends runs with `---\n## Run [timestamp]` delimiter. History preserved |

---

## Sprint 5 — Forward Bootstrap ✅ (commit b29cc68)

| # | Status | Problem | What was done |
|---|--------|---------|---------------|
| T18 | ✅ | `aegis-coding` demands `architecture.md` at literal path `aegis/` — v2 moved to `aegis/architecture/architecture.md`, check could fail silently | Check line 40 fixed: `aegis/architecture/architecture.md` (full path). Compatible v2 |
| T19 | ✅ | Forward team output paths (`audit/`, `quality/`, etc.) not standardized in SKILL — inconsistency between agents | `aegis-quality` output moved to `feature-dir/quality/`. Other agents already correct (coding, audit, doubt, plan, to-do, resume) |
| T20 | ✅ | `aegis-doubt` integrates responses directly in `requirements.md` — if user edited file manually between runs, integration can break markdown | Guards added: if `[DOUBT]` absent or chunk edited >50%, skip patch and only register in Clarifications with warning |

---

## Sprint 6 — UX/DX ⬜

| # | Status | Problem | What will do |
|---|--------|---------|---------------|
| T21 | ⬜ | `/aegis` with `phase=complete` has undocumented behavior — user doesn't know if should re-run agents or accept state | Document explicitly: re-extraction? force? noop? |
| T22 | ⬜ | Version check tries `registry.npmjs.org/aegis-spec/latest` — fails while package isn't published, error message silent | Fallback to local git tag or skip silently without error |
| T23 | ⬜ | `aegis-principles` "propagates suggestions in templates" but no real mechanism — just LLM instruction, fragile | Explicit linker: principles reference templates, change in principle triggers suggestion in templates |
| T24 | ⬜ | Skills "any-phase" (data-master, design-system, visor) without automatic trigger — user needs to remember to invoke when schema/tokens change | Document standard: when to run, what overwrites, what's idempotent |
| T25 | ⬜ | Migration team has 5 mandatory human approval stops — unfeasible in automated pipelines | `--auto-approve` flag to pass through pipeline without interruptions |
| T26 | ⬜ | Scout doesn't exclude `.next`, `.turbo`, `.vercel`, `target` (Rust), `vendor` (Go) — scans irrelevant folders | Expand hard-coded exclusion list |
| T27 | ⬜ | `aegis-agents-help` lists agents in static text — becomes outdated when agents added/removed | Generate list dynamically from installed SKILLs |

---

## Sprint 7 — End-to-End Validation ⬜

| # | Status | Problem | What will do |
|---|--------|---------|---------------|
| T28 | ⬜ | No automated smoke test — impossible to know if change broke full flow | Minimal repo fixture + script: `aegis install` → simulate changes → invoke each skill → validate generated artifacts |
| T29 | ⬜ | No Keeper coverage metric — no way to know if project is well documented in specs | Calculate % files with entry in `code-spec-matrix.md` and % specs with `last_synced` recent |
