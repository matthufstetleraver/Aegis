---
name: aegis-audit
description: Strict reader-only audit. Compares requirements, roadmap, and actions, and reports inconsistencies with CRITICAL, HIGH, MEDIUM, LOW severity. Never changes the artifacts being analyzed. Use when the user types "/aegis-audit", "aegis-audit", or asks to cross-check the three documents for the active feature. Optional step in the forward cycle.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI, and other Agent Skills-compatible agents.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: aegis-spec
  phase: forward
  stage: audit
---

You are the auditor. This skill is strictly read-only. Your mission is to find contradictions and gaps between `requirements.md`, `roadmap.md`, and `actions.md`, and produce a report for the human to resolve.

## Regra inegociável

This skill NEVER changes `requirements.md`, `roadmap.md`, `actions.md`, `data-delta.md`, `interfaces/`, `investigation.md`, or `onboarding.md`. Under no circumstances, even if the user asks. If the user requests a correction, direct them to `/aegis-doubt` or manual editing.

A única escrita permitida é `feature-dir/audit/cross-check.md`.

## Before you start

1. Read `aegis/config/state.json` to resolve `output_folder` and `forward_folder`
2. Use the real values wherever the text mentions `aegis/` or `aegis/forward/`

## Initial checks

1. Read `aegis/config/active-requirements.json`
   1.1. If missing, abort
2. Verify the existence of the three artifacts: `requirements.md`, `roadmap.md`, `actions.md`
   2.1. If any is missing, abort with a message listing what is missing and which skill generates it
3. Apply `before-audit` using the standard flow

## Comparison axes

Check each pair of artifacts for:

1. Coverage
   1.1. Every functional requirement became at least one decision in the roadmap
   1.2. Every roadmap decision became at least one action in actions
   1.3. Every Gherkin scenario in requirements is covered by some action or decision
2. Consistency
   2.1. Terms use the same name across the three documents (do not show "invoice" in one and "receipt" in another)
   2.2. Cited identifiers exist (RF-12 referenced in the roadmap must exist in requirements)
   2.3. Contracts described in `interfaces/` appear in the roadmap
3. Legacy coherence
   3.1. Roadmap decisions do not contradict 🟢 rules in `aegis/reports/domain.md`
   3.2. Cited components in `aegis/architecture/architecture.md` actually exist
4. Actions sanity
   4.1. Dependencies point to existing IDs
   4.2. Tasks marked `[//]` do not share a target file
   4.3. There is no dependency cycle

## Severity

| Severity | When to apply |
|------------|----------------|
| CRITICAL | Direct conflict with a 🟢 legacy rule, broken external contract, dependency cycle |
| HIGH | Requirement without roadmap coverage, decision without corresponding action, phantom identifier |
| MEDIUM | Terminology inconsistency between two documents, dependency pointing outside the list |
| LOW | Cosmetic issue, ID spelling, underused parallelism |

## Report construction

Write to `feature-dir/audit/cross-check.md`:

1. Header with date, feature identifier, and link to the three analyzed artifacts
2. Summary: findings count by severity
3. Table `ID | Severity | Axis | Description | Where it is`
4. For each CRITICAL or HIGH finding, a paragraph explaining the impact and suggesting which skill the human should use to fix it (NEVER promise this skill makes the correction; only point the way)
5. List of checked items that passed, grouped by axis (so the human can see what is OK)

Use IDs in the format `A001`, `A002`, ... stable within the report, but NOT shared with IDs from other documents.

## Persistence

- Create `feature-dir/audit/` if it does not exist
- Write `cross-check.md` atomically
- Always rewrite completely; never append

## Post-run hooks

Apply `after-audit` using the standard flow.

## Final report to the user

1. Absolute path of `cross-check.md`
2. Findings count by severity (CRITICAL, HIGH, MEDIUM, LOW)
3. Explicit warning: none of the three artifacts was changed
4. Suggested next step:
   4.1. If there are CRITICAL or HIGH findings, suggest manual review before proceeding
   4.2. Otherwise, suggest `/aegis-coding`

Termine com:

> Type **CONTINUE** to proceed according to the suggestion above.
