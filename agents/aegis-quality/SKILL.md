---
name: aegis-quality
description: Text clarity audit for the requirements. Checks whether the prose is good enough to generate a plan without ambiguity. Do NOT mix this with implementation test audits. Use when the user types "/aegis-quality", "aegis-quality", or asks to review requirements quality before planning. Optional step in the forward cycle.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI, and other Agent Skills-compatible agents.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: aegis-spec
  phase: forward
  stage: quality
---

You are the text reviewer. Your mission is to check whether the active feature's `requirements.md` is well written, complete, and coherent enough to become a plan and code without rework. This skill is read-only over `requirements.md`. The only allowed writing is the audit report.

This skill evaluates WRITING QUALITY, not implementation TEST COVERAGE. If you feel like adding an item such as "check whether the button works," stop — that item does NOT belong here.

## Before you start

1. Read `aegis/config/state.json` to resolve `output_folder` and `forward_folder`
2. Use the real values wherever the text mentions `aegis/` or `aegis/forward/`

## Initial checks

1. Read `aegis/config/active-requirements.json`
   1.1. If missing, abort
2. Verify the existence of `feature-dir/requirements.md`
3. Apply `before-quality` using the standard flow

## Audit categories

Each report item fits into one of these categories:

| Category | Guiding question |
|-----------|---------------|
| Clarity | Does each sentence have one subject, one verb, and one unique meaning? |
| Completeness | Are all required template sections filled in? |
| Consistency | Are project glossary terms used the same way every time? |
| Scenario coverage | Do happy paths, sad paths, and edge cases appear in Gherkin? |
| Edge cases | Were numeric limits, empty values, nulls, and concurrency considered? |
| No jargon | Would a new person on the team understand the writing? |
| No implicit solution | Does the text describe the what, not the how (no library names, no framework names)? |
| Principle alignment | Does each requirement rule respect `aegis/config/principles.md`? |

## How to generate the items

1. Load the `aegis/runtime/templates/quality-template.md` template
2. For each category, generate one to five evaluation questions based on the real `requirements.md` content
3. Total between ten and thirty items
4. Each item follows the format `- [ ] Q-NNN | <category> | <question>`
5. After evaluating, mark `[X]` for approved items and `[ ]` for rejected ones
6. For rejected items, add an extra line `> reason: <objective reason>`
7. For rejected items that could be auto-corrected by the writer, add an extra line `> suggestion: <short text>`

## Final verdict

At the end of the report, emit one of three classifications:

- **Approved**, all items passed
- **Approved with reservations**, up to three rejected items, none CRITICAL
- **Rejected**, more than three rejected items, or at least one CRITICAL (missing scenario coverage, violated principle, internal contradiction)

## Persistence

- Create `feature-dir/quality/` if it does not exist
- Write `feature-dir/quality/requirements-audit.md` atomically
- Always rewrite completely

## Post-run hooks

Apply `after-quality` using the standard flow.

## Final report to the user

1. Absolute path of `requirements-audit.md`
2. Verdict (Approved, Approved with reservations, Rejected)
3. Top three rejected items, with reason, if any
4. Explicit warning: `requirements.md` was NOT modified
5. Suggested next step:
   5.1. Approved, suggest `/aegis-plan`
   5.2. Approved with reservations, suggest `/aegis-doubt`
   5.3. Rejected, suggest manual rewrite or a new run of `/aegis-requirements`

End with:

> Type **CONTINUE** to proceed with the suggestion above.
