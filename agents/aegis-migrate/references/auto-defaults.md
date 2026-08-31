# `--auto` defaults

When the user invokes `/aegis-migrate --auto`, the orchestrator skips human pauses and applies these defaults. Before starting, the user warning lists each of them. Every auto-applied item is recorded in `ambiguity_log.md` with the `auto-decided` tag for later review.

## Paradigm Advisor
- Choose **option 1: adopt the natural paradigm of the target stack**.
- `derived_appetite` = `transformational`.

## Curator
- HUMAN DECISION items are marked as pending in `ambiguity_log.md` and do not block the pipeline.
- 🟡 INFERRED items → MIGRATE (with note "validate in coding agent").
- 🔴 GAP and ⚠️ AMBIGUOUS items → DISCARD with explicit note "auto-discarded, requires review".

## Strategist
- Adopts the strategy marked as **recommended**.
- `critical` risks that would depend on a human owner are left with `owner = "to be defined"` in `risk_register.md`.

## Designer
- **Topology (Phase 1)**: accepts the proposed modern topology (option 2). The justification recorded in `topology_decision.md` is the Designer's own; in `ambiguity_log.md` it gets the `auto-decided` tag for later review. Rationale: `--auto` is for users who want the recommended path; refusing to decide would stop the pipeline and violate the `--auto` contract.
- **Architecture (Phase 2)**: approves the first proposal without iteration.
- Bounded contexts, events, and ADRs are accepted as proposed.

## Inspector
- Uses parity criteria derived directly from the chosen paradigm (see `parity-coverage-matrix.md` in the agent).
- Does not negotiate the "accepted parity" criterion with the user.

## Manual modifications detected
- Adopts **option (a)**: preserve the manually modified version and abort regeneration of that artifact. It never destroys human work.

## Mandatory warning

Always present before starting `--auto`:

> "⚠️ `--auto` mode enabled. The defaults below will be applied without pausing for confirmation:
> - Paradigm Advisor: adopt the stack's natural paradigm (transformational).
> - Curator: ⚠️/🔴 items will be DISCARDED with a note; 🟡 items will be MIGRATED with a note.
> - Strategist: the recommended strategy will be adopted.
> - Designer (topology): the proposed modern topology will be adopted (option 2).
> - Designer (architecture): the first architecture proposal will be accepted.
> - Inspector: parity criteria derived from the paradigm with no interactive adjustment.
> 
> The final `handoff.md` will highlight all auto-decided items for later review.
> Confirm? (y/N)"
