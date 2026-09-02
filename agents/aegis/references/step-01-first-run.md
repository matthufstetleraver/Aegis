# Step 1 — First run

## 1. Read initial state

Read `aegis/config/state.json`.

If `user_name` is already filled (installation via CLI), skip section **3. Information collection** and go directly to **4. Personalized greeting**.

## 2. Version check

Compare `aegis/config/version` with npm registry. If there's a newer version, inform discretely:
> "💡 New version available. Run `npx aegis-spec update` when you want to upgrade."

## 3. Information collection (only if state.json is empty)

If `user_name` is blank, ask one at a time:

- "What is your name?"
- "What language do you prefer the agents to communicate with you in? (ex: pt-br, en-us)"
- "What language should specifications be generated in? (ex: Portuguese, English)"
- "What is the name of this project?"

Save the answers in `aegis/config/state.json` in fields `user_name`, `chat_language`, `doc_language` and `project`.
See `references/state-schema.md` for the complete schema.

## 4. Personalized greeting

With `user_name` and `project` in hand (either from state.json or collected now), say:

> "Hello, [Name]! I am Aegis Spec
>
> I will coordinate the complete analysis of **[project name]** and generate executable specifications — ready for use by AI agents.
>
> I'll work in stages, saving progress after each phase. If the session is interrupted, just type `aegis` again to continue where we left off."

## 5. Exploration plan

Check if `aegis/plan.md` already exists:

**If the file already exists** (created by installer):
- Read the file
- Present a summary of the plan to the user
- Ask: "Is the plan approved or do you want to adjust something before we start?"

**If the file doesn't exist** (manual installation):
1. Quickly analyze the root folder structure (exclude: `node_modules`, `.git`, `.reversa`, `aegis`, `dist`, `build`, `coverage`, `__pycache__`)
2. Identify main modules and components
3. Create `aegis/plan.md` with tasks structured by phase (use default plan template, adapting phase 2 with actual identified modules)
4. Present the plan and ask: "Is the plan approved or do you want to adjust something?"

## 6. State update

After plan approval, update `aegis/config/state.json`:
- `phase`: `"reconnaissance"`
- Save any information collected in this step that isn't already in the file

See `references/checkpoint-guide.md` for state.json writing rules.

## 7. Start

Ask: "[Name], can we start with the **Scout** — project mapping?"

After confirmation, activate the `aegis-scout` skill.
