# Drift detection and classification rules

Drift = divergence between what the spec describes and what the code actually does.

Use this guide when processing changes in `after` mode to decide how to update the spec and how to reclassify the confidence of statements.

---

## Drift categories

### 1. Trivial drift — direct spec update

Code change that **replaces** described behavior without changing contract:

- Internal refactoring (same input/output, different logic)
- Local variable / private function renaming
- Performance optimization without behavior change
- Bug fix that aligns code with what the spec already said

**Action:** update spec maintaining original confidence (🟢 stays 🟢). If spec described incorrect prior behavior, update without downgrade.

### 2. Incremental drift — addition

New code adds behavior that spec doesn't cover:

- New function / method / endpoint
- New logical branch (if/else, new case)
- New validation / guard clause

**Action:** add new section in spec describing the behavior. Mark as 🟢 if direct evidence in diff, 🟡 if inferred from context.

### 3. Structural drift — contract break

Change that violates what spec described as invariant:

- Function signature changed (parameters added/removed/reordered)
- Return type changed
- Behavior documented as 🟢 is no longer true
- API status code changed

**Action:**
1. Update spec with new contract
2. Keep 🟢 if evidence remains direct
3. Add note of "breaking change" referencing changelog: `> ⚠️ Breaking change on YYYY-MM-DD HH:MM — see changelog`
4. Force question about backward compatibility in question #2 of after mode

### 4. Semantic drift — code diverges from business rule

Code violates rule documented in `aegis/reports/domain.md`:

- Business rule validation removed or loosened
- State allowed that shouldn't be (state machine broken)
- Financial / fiscal / regulatory calculation altered

**Action:**
1. **Don't update the rule silently.** Ask the user: "Did the business rule in `domain.md` change intentionally, or is the code buggy?"
2. If intentional: update `domain.md` + spec, mark changelog entry with `**Impact:** Business rule change — review with stakeholders`
3. If bug: DON'T update spec. Add entry in `aegis/reports/drift.md` as `pending` with `suggested_action: "Revert change or align rule"`

### 5. Drift by deletion

Code removed that had spec:

- Function / endpoint / module deleted

**Action:**
1. Mark the spec section as `~~deprecated~~` instead of deleting
2. Add note: `> Removed on YYYY-MM-DD — see changelog`
3. In `code-spec-matrix.md`, strikethrough the file line

---

## Confidence reclassification after drift

Use the rules from `agents/aegis-reviewer/references/confidence-rules.md` as base. Additions specific to Keeper:

### Post-change — when to keep 🟢

- Diff directly confirms the new statement (line visible, logic clear)
- New automated test covers the behavior

### Post-change — when to downgrade 🟢 → 🟡

- Partial change — one part of contract confirmed by diff, other inferred
- Spec describes large module, diff only touches a slice
- Comment in diff suggests behavior but code isn't fully visible

### Post-change — when to create 🔴 new

- Diff removes implementation but spec still references functionality
- Diff cites external configuration (env var, feature flag) that can't be inspected
- Change contradicts state machine without clear transition path

---

## When NOT to update spec

- Change in test file only (doesn't affect contract — register in changelog but don't touch spec)
- Change in comment / formatting / lint
- Change in build / CI / config file without runtime impact
- Change in dependency without observable impact (internal patch update)

For these cases: register changelog entry but with `**Specs affected:** None — internal change without contract impact`.

---

## Alert signals — escalate to Reviewer or Archaeologist

If during `after` mode you find:

- Change that affects **>5 specs** at the same time → suggest running `/aegis-reviewer` afterwards
- Architectural refactoring (moves multiple modules) → suggest running `/aegis-archaeologist` on affected module(s)
- Change in entry point or DI container → suggest `/aegis-architect`
- Change in database schema → suggest `/aegis-data-master`

Add these suggestions in final message to the user.

---

## Severity by blast radius (v1.8.0+)

When the L0 graph (`aegis/runtime/context/graph.json`) is available, classify drift severity by **direct reverse-deps count** of the modified file:

| Direct reverse-deps | Severity | Action |
|---|---|---|
| 0-1 | `LOW` | Update spec normally; no alert |
| 2-4 | `MEDIUM` | Update spec; mention blast radius in changelog |
| **5+** | **`HIGH`** | Update spec; **suggest `/aegis-reviewer`** + list affected files in `drift.md` (field `blast_radius`) |

Reference commands:

```bash
npx aegis-spec graph reverse-deps <file> --json    # 1 level (severity)
npx aegis-spec graph impact <file> --json          # transitive BFS (blast_radius)
```

Severity goes to the `severity` field in `drift.md`. Affected files (top 20) go to `blast_radius`. Above 20, annotate `+N more`.

> **Why 5:** below that, changes tend to be localized refactorings. Starting at 5 reverse-deps, propagation risk grows non-linearly — each affected file may have its own reverse-deps.

If the graph doesn't exist, suggest the user run `npx aegis-spec graph build` before the next `/aegis-keeper after`. Degraded mode: classify everything as `MEDIUM` by default.
