# Step 4, Semantic regression check

> This step only runs on **re-extractions**, i.e., when a discovery pipeline is executed on a project that has gone through at least one `/aegis-coding` cycle. On projects without `aegis/forward/` or without `regression-watch.md`, this step is silently skipped.

## Why it exists

Aegis Spec is not just one-shot extraction. Each `/aegis-coding` leaves in `aegis/forward/<feature>/regression-watch.md` a list of rules that need to remain true on the next extraction. The discovery pipeline, when re-running, has the duty to check these rules against current code and report regressions. This is the competitive differentiator of Aegis Spec versus pure forward frameworks.

## When to run

After the **last agent in the plan** completes, before the final "extraction complete" message. The trigger is position (last item of `aegis/plan.md`), not agent name, because the last agent varies based on optional selections during install (Reviewer may be absent, for example). Do the checks in order:

1. Check if `aegis/forward/` exists in project root. If not, end this step silently.
2. List all subfolders of `aegis/forward/` that contain `regression-watch.md`.
3. If the list is empty, end.
4. Otherwise, proceed with the procedure below, one feature at a time.

## Procedure per feature

For each `aegis/forward/<feature>/regression-watch.md`:

1. Load the file. Identify the main watch items table (columns `ID | Source | Expected rule after change | Verification type | Violation signal`).
2. For each watch item in the main table (not archived ones):
   2.1. Identify the `Verification type`, possible values: `presence`, `absence`, `wording`, `confidence`.
   2.2. Apply the corresponding verification against newly generated artifacts in `aegis/`:
        - `presence`: the rule must be present in `aegis/reports/domain.md` (or in the file referenced by Source column) with the same semantic essence.
        - `absence`: the original rule must NOT appear anymore in the SDD.
        - `wording`: the text was intentionally changed, verify if the new version matches the expectation.
        - `confidence`: the rule remains present, but confidence (🟢, 🟡, 🔴) should be equal or greater than expected.
   2.3. Assign a verdict:
        - 🟢 **green**, the expectation matched integrally.
        - 🟡 **yellow**, there's semantic equivalence but text differs, or evidence is partial. Default verdict when there's ambiguity. Awaits human judgment.
        - 🔴 **red**, the expectation did NOT match. Previously confirmed rule became a broken rule.
3. After evaluating all watch items, update the `## Re-extraction history` section of the same `regression-watch.md` adding dated block:

```
### Re-extraction YYYY-MM-DD HH:MM

| ID | Verdict | Note |
|----|---------|------|
| W001 | 🟢 green | rule preserved in aegis/reports/domain.md#rule-X |
| W005 | 🔴 red | rule removed from current code; unintended change |
| W010 | 🟡 yellow | text equivalent but differs literally; awaits judgment |
```

4. DON'T alter the main watch items table. DON'T recycle IDs. DON'T automatically move watch items to "Archived".

5. For each watch item with three consecutive green verdicts in history, and as long as `setup.json#watch.archive-after` allows, move the item from the main table to the `## Archived` section at the end of the file. Keep the original ID.

## Writing policy

- Atomic write (tempfile plus rename) in `regression-watch.md`.
- Never rewrite or delete entries from re-extraction history.
- New re-extraction block always goes at the top of the `## Re-extraction history` section (descending order).

## User report

After iterating through all features, present:

1. Total features verified
2. Total watch items verified
3. Breakdown by verdict: green, yellow, red
4. Detailed list of reds (ID, feature, rule, reason for divergence)
5. Detailed list of yellows requesting human judgment

If there's at least one red, display a highlighted warning:

> 🔴 **Attention**, **N semantic regressions** were detected in previously coded features. Review before proceeding.

If `setup.json#watch.block-on-red` is `true`, suggest to the user **not** to proceed with new `/aegis-requirements` until each red is triaged. Aegis Spec only alerts, never automatically blocks user workflow.

## Special case, no `aegis/`

If during the procedure `aegis/` doesn't have expected files (because re-extraction was partial or documentation level was reduced), record 🟡 yellow verdict with note `evidence absent, aegis/<file> was not generated in this extraction` and continue.

## Known gap

Semantic equivalence between expected and extracted rule is subjective evaluation. When in doubt, prefer yellow verdict. Red verdict should be reserved for cases where the rule simply disappeared or was explicitly contradicted.
