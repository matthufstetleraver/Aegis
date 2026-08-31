# Schema of `aegis/runtime/queue/keeper-queue.jsonl`

Communication file between engine hooks and Keeper agent. **JSONL format** (one JSON entry per line) — append-only, atomic on POSIX filesystems.

- **Hooks write** one line per edit event (append mode)
- **Keeper reads** all lines in `after` mode, deduplicates by file, processes and clears the file

Manual mode (without installed hooks): this file may not exist. Keeper uses `git diff HEAD` as alternative source.

> **History:** previous versions (≤ v1.6) used `aegis/keeper-queue.json` as single snapshot with locking. Changed in v1.7 to JSONL append-only to reduce hook overhead from ~150-300ms per edit to ~10ms.

---

## Schema (one JSON line per entry)

```jsonl
{"id":"uuid","ts":"2026-05-01T15:40:12.000Z","phase":"post","engine":"claude-code","tool":"Edit","files":["src/auth/login.js"]}
{"id":"uuid","ts":"2026-05-01T15:40:18.000Z","phase":"post","engine":"claude-code","tool":"Edit","files":["src/auth/mfa.js"]}
{"id":"uuid","ts":"2026-05-01T15:42:00.000Z","phase":"stop","engine":"claude-code","tool":"unknown","files":[]}
```

---

## Fields

| Field | Type | Required | Description |
|---|---|---|---|
| `id` | string (UUID v4) | yes | Unique identifier for entry |
| `ts` | string ISO 8601 (UTC) | yes | Event timestamp |
| `phase` | `"post"` or `"stop"` | yes | `post` = after edit; `stop` = end of session (advisory only) |
| `engine` | string | yes | `claude-code` / `cursor` / `kimi-cli` / `codex` / `opencode` |
| `tool` | string | yes | Tool/event name (`Edit`, `Write`, `MultiEdit`, `apply_patch`, `afterFileEdit`, etc.) |
| `files` | array of string | yes | Paths relative to project root. Empty in `phase: "stop"` entries |

> **Removed in v1.7+:**
> - `phase: "pre"` — pre-hooks were removed in Phase 1 of roadmap (were burdensome). Return in Phase 4 with policy gate, but via separate channel (not via queue).
> - `diff_summary`, `affected_specs` — Keeper now derives both at batch end-of-task, not by hook.

---

## Concurrency

Append-only JSONL is safe without lockfile:

- Writes < `PIPE_BUF` (~4KB on Linux, 512B minimum POSIX) are atomic
- Each line fits easily (~150 bytes average)
- Multiple processes can write in parallel without corruption

Hooks **don't** need to acquire lock. Just `appendFileSync` directly.

Keeper, when consuming, reads the entire file, processes it, then truncates/deletes. May race with hooks still writing during processing — solution: rename `keeper-queue.jsonl` → `keeper-queue.processing.jsonl` (atomic), process, delete.

---

## Cleanup by Keeper

After processing all entries in `after` mode:

1. Rename `keeper-queue.jsonl` → `keeper-queue.processing.jsonl` (atomic)
2. Read all lines from `processing` file
3. Deduplicate by `files` (last entry per file wins)
4. Process (update specs, drift.md, changelog)
5. Delete `keeper-processing.jsonl`
6. Save timestamp in `aegis/config/state.json.checkpoints.keeper.last_run`

If error: leave `processing.jsonl` in place and log to `aegis/keeper-errors.log`. Next invocation resumes.

---

## Deduplication

Same file edited N times during a task → N lines in queue. Keeper deduplicates:

```js
const lastByFile = new Map();
for (const line of lines) {
  const entry = JSON.parse(line);
  if (entry.phase !== 'post') continue;
  for (const file of entry.files) lastByFile.set(file, entry);
}
const uniqueFiles = Array.from(lastByFile.keys());
```

Result: unique list of modified files, with timestamp of last edit.

---

## Operational limits

- No hard size limit — JSONL append is cheap. Typically <1000 entries in long sessions.
- Entries with `ts` > 30 days can be purged by Keeper (assumes user forgot).

---

## Realistic example (5-edit + stop session)

```jsonl
{"id":"9f8e7d6c-5b4a-4321-9876-543210fedcba","ts":"2026-05-01T20:25:14.123Z","phase":"post","engine":"claude-code","tool":"Edit","files":["lib/auth/login.js"]}
{"id":"8e7d6c5b-4a39-4210-8765-43210fedcba9","ts":"2026-05-01T20:25:18.456Z","phase":"post","engine":"claude-code","tool":"Edit","files":["lib/auth/login.js"]}
{"id":"7d6c5b4a-3928-4109-7654-3210fedcba98","ts":"2026-05-01T20:26:02.789Z","phase":"post","engine":"claude-code","tool":"Write","files":["lib/middleware/rate-limit.js"]}
{"id":"6c5b4a39-2817-4098-6543-210fedcba987","ts":"2026-05-01T20:27:15.012Z","phase":"post","engine":"claude-code","tool":"Edit","files":["lib/auth/login.js","lib/auth/handler.js"]}
{"id":"5b4a3928-1706-4987-5432-10fedcba9876","ts":"2026-05-01T20:30:00.000Z","phase":"stop","engine":"claude-code","tool":"unknown","files":[]}
```

Keeper deduplicates → final list: `["lib/auth/login.js", "lib/middleware/rate-limit.js", "lib/auth/handler.js"]` (3 unique files).
