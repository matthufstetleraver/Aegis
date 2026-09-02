# Confidence Classification Rules

Use this scale on **every** statement in specs. No exceptions.

## Definitions

| Symbol | Name | Meaning |
|--------|------|---------|
| 🟢 | CONFIRMED | Extracted directly from code — can be cited with file and line |
| 🟡 | INFERRED | Deduced from patterns, names, conventions or context — may be wrong |
| 🔴 | GAP | Could not be determined from code — requires human validation |

## When to use each level

### 🟢 CONFIRMED
- The behavior is explicit in code (if/else, return, throw)
- The value is a constant or enum defined in code
- The rule is in a descriptive comment near relevant code
- Exists an automated test that covers exactly this behavior
- DDL/migration defines constraint directly

### 🟡 INFERRED
- Function/variable name suggests behavior, but there's no explicit logic
- Behavior is consistent with framework conventions (ex: soft delete in Eloquent)
- There are clues in code but complete logic isn't visible in scanned scope
- Rule was inferred from multiple similar examples, not single definition
- Old comment or TODO that may not reflect current state

### 🔴 GAP
- Feature is referenced but not implemented in visible code
- Logic depends on external configuration (env var, database, API)
- Expected behavior contradicts what's in code (possible bug or hidden logic)
- Code is generated or compiled without access to original source
- Business rule that only exists in stakeholders' heads

---

## Reclassification during review

### Upgrade: 🟡 → 🟢
Conditions: find direct evidence in code that confirms the statement.
Action: note the evidence (file + line) in spec.

### Upgrade: 🔴 → 🟡
Conditions: find enough clues for reasonable inference.
Action: rephrase statement as inference, not certainty.

### Upgrade: 🔴 → 🟢
Conditions: user confirms with concrete evidence (ex: "yes, that's the rule").
Action: update spec and record confirmation.

### Downgrade: 🟢 → 🟡
Conditions: find contradiction between spec and actual code.
Action: flag contradiction and reclassify.

### Downgrade: 🟡 → 🔴
Conditions: find evidence that inference was wrong.
Action: reclassify and create user question if needed.

---

## Golden rule

**When in doubt, use the lowest level.**
An honest 🔴 is more useful than a misleading 🟡.
