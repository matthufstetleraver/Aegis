# Step 2 — Session resume

## 1. Read state

Read `aegis/config/state.json` and `aegis/plan.md`.

## 2. Version check

Compare `aegis/config/version` with npm registry. If there's a newer version, inform discretely:
> "💡 New version available. Run `npx aegis-spec update` when you want to upgrade."

## 3. Greeting

Say: "[Name], welcome back to Aegis Spec! 🎼"

## 4. Progress summary

### 4.1 Read session summary (context compression)

Before presenting the summary, check if there's any session summary in `aegis/runtime/session-summaries/`:

1. List files in `aegis/runtime/session-summaries/`
2. If there are files, read the **most recent** (sort by timestamp in filename)
3. Use session summary content as base for progress summary

Session summary contains main findings and decisions, enabling efficient resume without loading full previous session history.

### 4.2 Progress presentation

Show:
- ✅ Completed phases (field `completed` from state.json)
- 🔄 Current phase (field `phase`) with last recorded task in `checkpoints`
- ⏳ Next phases (field `pending`)
- 📄 **Summary of last session** (from most recent session summary, if available)

Example:
> "Current progress:
> ✅ Reconnaissance completed
> 🔄 Excavation in progress — modules `auth` and `orders` analyzed, `payments` and `users` pending
> ⏳ Interpretation, Generation, Review
>
> 📄 **Summary of last session** (Scout, 07/05 14:30):
> - 12 modules identified in monolith Next.js architecture + PostgreSQL
> - Main stack: Next.js 14, TypeScript 5, Prisma
> - Decisions: doc_level=complete, organization=by module"

## 5. Gap response mode

If `answer_mode` is `"file"`:
> "Remember: your answers to questions should be filled in `aegis/reports/questions.md`. Let me know when you're done."

If `answer_mode` is `"chat"` (default):
> Continue normally — I'll ask the questions here in chat.

## 6. Confirmation

Ask only: "Do we continue where we left off? (CONTINUE to proceed)"

After confirmation, resume the next pending task in the plan (`aegis/plan.md`).

**🚫 Do NOT offer `/clear` + `/aegis` at this moment.** User just resumed the session; asking to clear and reopen now is redundant. The checkpoint pause prompt between steps (described in `SKILL.md`, section "Preventive checkpoint between steps") only applies **after** an agent completes work within this session, never on the resume greeting itself.

See `references/checkpoint-guide.md` for state.json writing rules.
