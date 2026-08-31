---
name: aegis-doubt
description: Generates up to five targeted questions to resolve ambiguous points in requirements and integrates the answers into the document. Use when the user types "/aegis-doubt", "aegis-doubt", "clarify doubts", or asks to resolve open points in requirements before planning. Optional stage in the forward cycle, between `/aegis-requirements` and `/aegis-plan`.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI, and other Agent Skills-compatible agents.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: aegis-spec
  phase: forward
  stage: doubt
---

You are the clarifier. Your mission is to discover what is missing to know before the plan and return the answers to the `requirements.md` of the active feature.

## Before you start

1. Read `aegis/config/state.json` to resolve `output_folder` (spec extraction) and `forward_folder` (forward features)
2. When this skill mentions `aegis/` or `aegis/forward/`, use the real values from state.json

## Initial checks

1. Read `aegis/config/active-requirements.json`
   1.1. If the file does not exist, abort with a clear message pointing the user to `/aegis-requirements`
2. Load the `requirements.md` from the indicated `feature-dir`
3. Apply the standard `before-doubt` hook rule read from `aegis/runtime/hooks.yml` (same logic as the `aegis-requirements` skill)

## Question generation

1. Examine `requirements.md` for:
   1.1. Explicit `[DOUBT]` markers
   1.2. Vague phrases ("probably", "maybe", "if possible", "some")
   1.3. Undefined open terms (numeric limits, user profiles, expected formats)
   1.4. Obvious coverage gaps (missing negative scenario, implicit edge case)
2. Cross-check with the taxonomy below to choose candidates
3. Select at most five questions, ranked by impact on the plan
4. Each question must be either multiple choice or short answer; never open-ended without options

### Prioritization taxonomy

1. Functional scope and behavior
2. Domain and data model
3. Interaction flow and experience
4. Non-functional attributes (performance, security, observability)
5. Integrations and external dependencies
6. Permissions and authentication
7. Data persistence and migration
8. Audit, log, and telemetry
9. Internationalization and localization
10. Failures and recovery
11. Compatibility with the legacy mapped in `aegis/`

## User presentation

Present the questions in this format:

```
1. <question>
   a) <option>
   b) <option>
   c) <option>
   d) <option>
   e) Free response

2. ...
```

If a question is short-answer, omit the options block and use the format `Expected answer: <value-type hint>`.

Wait for the user to respond. If they answer only some, proceed only with the ones answered.

## requirements.md integration

1. Locate or create the `## Clarifications` section
2. Within it, create or update `### Session YYYY-MM-DD`
3. For each answered question:
   3.1. Add an item in the format `- **Q:** <question>` plus `**A:** <answer>`
   3.2. Locate the requirements excerpt where the doubt lived
   3.3. Rewrite the excerpt in place, removing the corresponding `[DOUBT]`
       - If `[DOUBT]` no longer exists (the user removed it manually), skip the rewrite and only record it in Clarifications
       - If the surrounding text was edited substantially (>50% diff), skip the rewrite and warn the user with the note: "⚠️ Text around the doubt was edited manually — integration skipped"
4. Update the `## Gaps` section, removing resolved entries and keeping the unresolved ones

## Persistence

- Write the modified `requirements.md` atomically
- The `## Clarifications` section must appear immediately before `## Gaps`

## Post-run hooks

Apply the standard rule for `after-doubt` (same logic as the `aegis-requirements` skill).

## Final report

1. Absolute path of `requirements.md`
2. Number of doubts resolved in this session
3. Number of remaining `[DÚVIDA]` markers
4. Suggested next step:
   4.1. If any `[DOUBT]` remain, suggest running `/aegis-doubt` again
   4.2. If none remain, suggest `/aegis-plan`

End with:

> Type **CONTINUE** to proceed according to the suggestion above.
