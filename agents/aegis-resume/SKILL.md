---
name: aegis-resume
description: Resumes a paused feature (listed in paused-features of active-requirements.json) and makes it active. Use when the user types "/aegis-resume", "aegis-resume", "resume paused feature" or asks to return to a previous feature. Does NOT create new features, only swaps the active one for the chosen one and (when appropriate) moves the current active one to paused-features.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI, and other Agent Skills-compatible agents.
metadata:
  author: sandeco
  version: "1.0.0"
  framework: aegis-spec
  phase: forward
  stage: resume
---

You are the resumer. Your mission is to swap the active feature for one from `paused-features`, without losing the work of either one.

## Before you start

1. Read `aegis/config/state.json` to resolve `output_folder` and `forward_folder`
2. Use the actual values in places where text mentions `aegis/` or `aegis/forward/`

## Initial checks

1. Read `aegis/config/active-requirements.json`
   1.1. If absent, abort with message:

       > 🛑 `/aegis-resume` requires an active feature to do the swap. `active-requirements.json` does not exist.
       >
       > Use `/aegis-requirements` to create the first feature in the project.

2. Check the `paused-features` field
   2.1. If absent or empty array, abort with message:

       > 🛑 There are no paused features to resume. The `paused-features` array is empty.
       >
       > Features get paused when you run `/aegis-requirements` on an ongoing active feature and choose option 2 (create parallel).

3. Apply `before-resume` hooks the standard way (reads `aegis/runtime/hooks.yml`, filters `enabled: false`, same logic as other forward cycle skills)

## Listing paused features

For each entry in `paused-features`:

1. Check if the `feature-dir` still exists on disk
   1.1. If NOT, mark as `absent` (folder was deleted manually, entry became orphaned)
2. If it exists, detect the **current physical stage** using the same logic as `/aegis-requirements`:

   | Condition observed in `feature-dir` | Physical stage |
   |--------------------------------------|----------------|
   | `requirements.md` absent | `empty` |
   | `requirements.md` present, `roadmap.md` absent | `requirements` |
   | `roadmap.md` present, `actions.md` absent | `plan` |
   | `actions.md` present with at least one line `\| ... \| \[ \] \|` | `coding-in-progress` |
   | `actions.md` present, all actions as `\| ... \| \[X\] \|` | `done` |

3. For `coding-in-progress`, count `[X]` vs `[ ]` actions

Present numbered list to user:

```
Paused features:

1. <NNN-short-name>  ·  stage: <physical>  ·  paused on <YYYY-MM-DD>  [· N of M actions]
2. <NNN-short-name>  ·  stage: <physical>  ·  paused on <YYYY-MM-DD>
3. <NNN-short-name>  ·  stage: absent   ·  paused on <YYYY-MM-DD>  (folder deleted, orphaned entry)
```

For `absent` entries, mark visually that they are orphaned.

## User choice

Ask:

> Which feature do you want to resume? Type the list number, or `0` to cancel.

Wait for response. Do NOT choose on your own.

## Orphan entry handling

If the user chose an entry with stage `absent`:

1. Do NOT do swap
2. Ask: "The folder for this feature was deleted. Do you want to remove this entry from `paused-features`? (yes / no)"
3. If yes, remove only this entry from the array, write updated `active-requirements.json` (atomically), stop the skill.
4. If no, stop without changing anything.

## Detecting the state of the currently active feature

For the feature in `active-requirements.json#feature-dir`, detect the physical stage using the same table above. This value decides whether it will be paused or discarded in the swap.

## Swap

1. Build the new pause entry for the **currently active** feature, copying all fields from `active-requirements.json` except `paused-features`, and adding:
   - `paused-at`: ISO 8601 of current time
   - `paused-from-stage`: detected physical stage of current active
2. Decide the destination of the currently active feature:
   - 2.1. If physical stage is `requirements`, `plan`, or `coding-in-progress`: **pause**, i.e., push the constructed entry to `paused-features` array
   - 2.2. If physical stage is `done`: **discard from active**, do NOT push (feature is complete, not worth taking up space in paused-features). Its folder remains untouched in `aegis/forward/`
   - 2.3. If physical stage is `empty`: **discard from active**, do NOT push (corruption, folder without `requirements.md`)
3. Remove the chosen feature from `paused-features` array
4. Build the new `active-requirements.json`:

```json
{
  "schema-version": 1,
  "feature-dir": "<feature-dir of chosen>",
  "feature-id": "<feature-id of chosen>",
  "short-name": "<short-name of chosen>",
  "started-at": "<started-at original of chosen>",
  "current-stage": "<current-stage original of chosen, or detected physical stage>",
  "stages-completed": [<copied from chosen, or [] if absent>],
  "paused-features": [<updated array>]
}
```

   4.1. If the chosen one didn't have `started-at`/`current-stage`/`stages-completed` (old schema entry, before rich schema), use detected physical stage for `current-stage` and current time as `started-at` (record this fallback in message to user)

5. Write JSON atomically (tempfile plus rename)

## Post-run hooks

Apply `after-resume` the standard way.

## Final report to the user

1. Feature resumed: identifier `<NNN-short-name>`
2. Detected physical stage of this feature: value between `requirements` / `plan` / `coding-in-progress`
3. For `coding-in-progress`, show `N of M actions completed`
4. Destination of previously active feature:
   4.1. "paused" (if pushed to paused-features)
   4.2. "discarded from active (state: done)" or "discarded from active (state: empty)"
5. Suggestion for next skill according to stage of resumed feature:
   5.1. `requirements` → suggest `/aegis-doubt` (if there's `[DOUBT]`) or `/aegis-plan`
   5.2. `plan` → suggest `/aegis-to-do`
   5.3. `coding-in-progress` → suggest `/aegis-coding` (with optional argument to restrict scope)

Always end with:

> Type **CONTINUE** to proceed according to the suggestion above.

Do NOT automatically execute the next skill, leave the decision to the user.
