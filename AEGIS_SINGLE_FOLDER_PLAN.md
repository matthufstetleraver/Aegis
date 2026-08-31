# Plan: Single Aegis Folder Structure

Objective: All Aegis content in the target repo lives within `aegis/`, except for engine entry points in the root (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, etc.).

## Final Structure

```txt
aegis/
├── config/
│   ├── state.json
│   ├── config.toml
│   ├── config.user.toml
│   ├── manifest.yaml
│   ├── files-manifest.json
│   ├── auto-policy.yaml         # opt-in (keeper auto)
│   └── audit-policy.json        # opt-in (audit redaction)
├── runtime/
│   ├── context/
│   │   ├── graph.json
│   │   ├── policy-index.json
│   │   ├── surface.json         # scout
│   │   └── modules.json         # archaeologist
│   ├── queue/
│   │   └── keeper-queue.jsonl
│   ├── audit/
│   │   ├── YYYY-MM-DD.jsonl
│   │   └── keeper-errors.log
│   ├── hooks/
│   │   └── runner.js
│   └── session-summaries/
├── skills/
│   ├── aegis/
│   ├── aegis-keeper/
│   └── ...
├── specs/                       # Everything that describes the system
│   ├── sdd/<unit>/              # writer: requirements, design, tasks (+ optional)
│   ├── user-stories/            # writer
│   ├── adrs/                    # detective
│   ├── openapi/                 # writer
│   ├── database/                # data-master: erd, dictionary, etc
│   ├── design-system/           # design-system: tokens, palette, etc
│   └── ui/                      # visor: screen inventory, flow
├── architecture/                # architect: diagrams + overview
│   ├── architecture.md
│   ├── c4-context.md
│   ├── c4-containers.md
│   ├── c4-components.md
│   └── erd-complete.md
├── traceability/
│   ├── code-spec-matrix.md      # writer
│   └── spec-impact-matrix.md    # architect
├── reports/                     # Generated analyses
│   ├── drift.md                 # Keeper
│   ├── confidence-report.md     # reviewer
│   ├── gaps.md                  # reviewer
│   ├── questions.md             # reviewer
│   ├── cross-review-result.md   # reviewer
│   ├── code-analysis.md         # archaeologist
│   ├── data-dictionary.md       # archaeologist
│   ├── domain.md                # detective
│   ├── state-machines.md        # detective
│   ├── permissions.md           # detective
│   ├── deployment.md            # architect
│   ├── inventory.md             # scout
│   ├── dependencies.md          # scout
│   └── flowcharts/<module>.md   # archaeologist
├── changelog/                   # Keeper append-only
│   └── YYYY-MM-DD.md
├── migration/                   # Migration team
└── forward/                     # aegis-requirements: new features (NNN-name/)
```

Root contains only:
```txt
aegis/
AGENTS.md
CLAUDE.md
GEMINI.md
```

## Status

Single-folder layout finalized on 2026-05-09. All implementation phases completed; target repo validation phases pending.

Divergence notes vs. original plan:
- `aegis/forward/` planned in the structure but not exposed in `lib/paths.js` (writer writes to `aegis/runtime/templates/`, not `forward/`). Update plan or add constant when `aegis-requirements` feature is implemented.
- `aegis/runtime/hooks/runner.js` planned but currently only `aegis/runtime/hooks.yml` exists. `hooks/` subdirectory not created.

## Phases

### Phase 1 — Path Constants ✅
- `lib/paths.js` created, 57 constants exported.
- Hard-coded `.aegis/`, `_aegis_sdd/`, `.agents/skills/`, `.claude/skills/` removed from code (only migrations use `LEGACY_*`).

### Phase 2 — Installer/Writer ✅
- `lib/installer/writer.js#createAegisSpecDir` creates full tree.
- State, config, manifest → `aegis/config/`.
- Skills → `aegis/skills/`.

### Phase 3 — Entry Points ✅
- Engine templates updated in `templates/engines/` point to `aegis/skills/...`.

### Phase 4 — Specs and Reports ✅
- Default output = `aegis/`.
- Agents (writer, scout, archaeologist, reviewer, Keeper, etc.) updated to write to `aegis/specs/`, `aegis/reports/`, `aegis/traceability/`, `aegis/architecture/`.

### Phase 5 — Graph, Policy, Keeper ✅
- Graph → `aegis/runtime/context/graph.json`.
- Policy index → `aegis/runtime/context/policy-index.json`.
- Keeper queue → `aegis/runtime/queue/keeper-queue.jsonl`.
- Audit → `aegis/runtime/audit/`.

### Phase 6 — Migration ✅
- `lib/commands/migrate-layout.js` implemented with 33 mappings.
- Supports dry-run, confirm prompt, merge for duplicate skills.
- Warns when `output_folder` in `state.json` is custom value.

### Phase 7 — Gitignore ✅
- `aegis/runtime/`, `aegis/config/config.user.toml` in `.gitignore`.
- `aegis/specs/`, `aegis/reports/`, `aegis/traceability/`, `aegis/architecture/` versioned.

### Phase 8 — Docs ✅
- README, docs (md/es/pt), templates and agents updated.

### Phase 9 — CI/Bot/Hooks ✅
- Templates `templates/ci/*.yml` updated.
- Hooks and bot reference `aegis/`.

### Phase 10 — Aegis Repo Tests ✅
- Syntax/import check passes on all refactored modules.
- Smoke and `npm pack` pending manual validation.

### Phase 11 — Target Repo Test ⏳
- Apply `migrate-layout` to poc-frame-ai.
- Run end-to-end commands on migrated repo.

### Phase 12 — Release ⏳
- Document breaking change in CHANGELOG and migration guide.
