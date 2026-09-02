# Step 3, Specs organization

This step happens immediately after the user chooses the `doc_level` (Essential / Complete / Detailed) and before the Archaeologist invocation. This is when Aegis Spec decides and persists in what structure the specs will be generated.

## 1. Decide whether the menu should be displayed

Read, in this order, and merge key by key (full precedence to `config.user.toml`):

1. `aegis/config/config.toml`, section `[specs]` (config managed by Aegis Spec)
2. `aegis/config/config.user.toml`, section `[specs]` (manual user override)

The merge is evaluated per key: each key present in `config.user.toml` replaces the corresponding one in `config.toml`. Missing keys continue to come from `config.toml`.

The section is considered **decided** when, after merging, `granularity` is filled with one of the valid values: `module`, `use-case`, `endpoint`, `hybrid`, `feature`, `custom`.

- **If decided:** skip this entire step. Go directly to the Archaeologist invocation.
- **If not decided** (section absent, or `granularity` empty): present the menu (step 2 below).

### Special case, RF-18

If `granularity` is empty in `config.toml` (or the section was removed) **and** section `[specs]` exists in `config.user.toml` with any key filled, warn the user before displaying the menu. Use exactly this format:

> "I detected that `aegis/config/config.toml` doesn't have specs organization decision, but `aegis/config/config.user.toml` contains an override in `[specs]`. The override will remain active after your choice and may overwrite fields you decide now.
>
> Current override in `config.user.toml`:
> [list keys and values]
>
> Do you want to proceed with the menu anyway? (y/N)"

Wait for explicit affirmative response before proceeding to the menu. Empty response or negative aborts without persisting anything.

## 2. Present the menu

Read `aegis/runtime/context/surface.json` → `organization_suggestion`. Use the `granularity` field to pre-mark the suggested option and the `rationale` field to show the reason.

If `surface.json` doesn't have `organization_suggestion` filled (Scout didn't run or failed), display the menu without a default and ask the user to choose manually, per EC-01 from the organization spec.

Use exactly this format (language following `chat_language` from `state.json`, example below in pt-br):

```
How do you want to organize the specs for this project?

Scout analyzed the legacy and suggests: [translation of suggested granularity].
Reason: [organization_suggestion.rationale]

  [1] [marker] By code module
  [2] [marker] By use case
  [3] [marker] By endpoint/contract
  [4] [marker] Hybrid (module at root, use cases nested)
  [5] [marker] By features (Scout lists discovered features)
  [6] [marker] Custom

Choose (Enter accepts the suggested):
```

Where `[marker]` is `*` (asterisk) in the pre-marked option and space in others. Add `(suggested)` next to the pre-marked option.

Mapping of 6 options to `granularity` value:

| Option | `granularity` |
|--------|---------------|
| 1 | `module` |
| 2 | `use-case` |
| 3 | `endpoint` |
| 4 | `hybrid` |
| 5 | `feature` |
| 6 | `custom` |

### Accept the input

- Enter without typing: accepts the pre-marked option.
- Number from 1 to 6: accepts the corresponding option.
- Any other input: ask again without persisting anything.
- Ctrl+C / ESC / cancellation: abort execution and don't persist anything (EC-02).

### Option 6, custom

If user chooses 6, open the following prompt:

> "What are the names of the top-level folders? List separated by comma or one per line (minimum 1)."

Accept the input, sanitize each name (remove characters prohibited by OS filesystem, discard empty names). If the list results in empty, repeat the prompt (EC-07). The names go to `custom_folders`.

## 3. Detect conflict with structure already on disk (RF-11)

Before persisting the decision, check if specs structure is already materialized in `<output_folder>/specs/sdd/` (defined in `state.json`).

If `specs/sdd/` has subfolders that correspond to a different granularity than what's chosen now (for example, chose `endpoint` but disk has folders that look like `module`), display a warning comparing the two structures and ask for confirmation:

> "I detected that specs are already generated with the **[old]** structure in `<output_folder>/specs/sdd/`. You chose **[new]** now, which differs from the previous one.
>
> I'll create the new structure in parallel, without touching the old one. Existing specs are preserved.
>
> Confirm? (y/N)"

Wait for explicit affirmative response. Negative aborts without persisting.

Detection is heuristic and best-effort: compare top-level folder names with modules identified by Scout (`module`), with URIs/routes (`endpoint`), with features (`feature`), etc. When the heuristic can't decide clearly, **don't** display the warning (avoids false positive).

## 4. Persist the decision (RNF-03, atomic write)

Update `aegis/config/config.toml`, section `[specs]`, with:

```toml
[specs]
layout = "feature-folder"
granularity = "<user choice>"
custom_folders = [<list>]   # only when granularity == "custom", otherwise []
scout_suggestion = "<organization_suggestion.granularity from surface.json>"
decided_at = "<ISO 8601 UTC timestamp, example 2026-05-03T14:32:00Z>"
```

Rules:

- **Atomic write:** write to a temporary file in the same directory (`config.toml.tmp`) and atomically rename to `config.toml`. Write failure must not leave `config.toml` corrupted.
- **scout_suggestion is immutable** (RF-14): if section `[specs]` already existed but was empty for `granularity` and `scout_suggestion` filled, preserve `scout_suggestion`. On first run, copy current value of `organization_suggestion.granularity` from `surface.json`.
- **Non-destructive:** preserve any key/section you're not explicitly updating. Don't touch `[project]`, `[user]`, `[output]`, `[agents]`, `[engines]`, `[analysis]` or other sections.
- **Don't touch `aegis/config/config.user.toml`.** This file belongs to the user.
- **IO failure** (disk full, no permission, EC-06): display clear error, don't create spec folders, don't consider the choice confirmed. User can try again on the next run.

## 5. Workflow continuation

After successful persistence, proceed with Archaeologist invocation per `plan.md`. The decision is available for all agents that write specs.

## 6. Manual re-presentation (RF-17)

There's no dedicated CLI flag for reconfiguring. The user re-presents the menu by manually removing the `[specs]` section from `aegis/config/config.toml` (or emptying `granularity`). On next run, this step detects the "not decided" state and runs again.

## Folder naming language (RF-10)

The names Aegis Spec uses for feature folders follow `doc_language` from `state.json`. Don't ask for language in this step. In a `pt-br` installation, folders come out in pt-br; in `en`, in English.

## Checklist before advancing

- [ ] Read `[specs]` from `config.toml` and merge with `config.user.toml` key by key
- [ ] If already decided, skip the step
- [ ] If override exists in `config.user.toml` but `config.toml` is empty, display RF-18 warning
- [ ] Read `organization_suggestion` from `surface.json`
- [ ] Display menu with suggestion pre-marked
- [ ] Accept Enter, number 1 to 6, or cancellation
- [ ] If option 6, collect `custom_folders`
- [ ] Detect conflict with structure on disk and ask for confirmation
- [ ] Atomic write to `config.toml`
- [ ] Preserve `scout_suggestion` on re-runs with partial section
- [ ] Proceed to Archaeologist
