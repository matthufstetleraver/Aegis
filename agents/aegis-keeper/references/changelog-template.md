# Changelog entry template

Use this format when adding entries in `<output_folder>/changelog/YYYY-MM-DD.md`.

Each entry starts with `## HH:MM` (time in UTC). Always **append** — never overwrite previous entries from the same day.

---

## Structure

```markdown
## HH:MM — [short description of change]

**What:** [technical summary based on diff — 1-3 lines]

**Why:** [user answer to question 1]

**Impact:** [answer to question 2 — breaks / side effects. Use "None" if confirmed]

**Files:**
- `path/file1.ext` — [verb: added | modified | deleted]
- `path/file2.ext` — [verb]

**Specs affected:**
- `specs/sdd/component1.md` — updated
- `specs/sdd/component2.md` — confidence reclassified (🟢 → 🟡)

**Context:** [answer to question 3, or omit this line if user skipped]

**Engine:** [claude-code | codex | cursor | kimi-cli | opencode | manual]
```

---

## Filled example

```markdown
## 14:32 — Add rate limiting to login endpoint

**What:** Added rate limit middleware (5 req/min per IP) to POST /auth/login route. Blocks return 429 with Retry-After header.

**Why:** Spikes in brute force attempts detected in production this week.

**Impact:** Breaks for clients that do >5 logins/min from same IP (rare case — human usage stays below). Frontend needs to handle 429.

**Files:**
- `lib/auth/login.js` — modified
- `lib/middleware/rate-limit.js` — added
- `lib/routes.js` — modified

**Specs affected:**
- `specs/sdd/authentication.md` — updated (new section "Rate limiting")
- `specs/sdd/api-contract.md` — confidence of error response reclassified (🟡 → 🟢)

**Context:** Implementation uses `express-rate-limit`. Configuration centralized in `config/rate-limits.js` for future routes.

**Engine:** claude-code
```

---

## File header for the day

When the day's file is created for the first time, start with:

```markdown
# Changelog — YYYY-MM-DD

Entries in chronological order (oldest at top).
```

Then, append each new entry with `## HH:MM`.
