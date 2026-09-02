# Schema — aegis/config/state.json

This file persists the complete state of analysis across sessions. Aegis Spec reads and writes to this file.

## Complete structure

```json
{
  "version": "1.0.0",
  "project": "project-name",
  "user_name": "User Name",
  "chat_language": "pt-br",
  "doc_language": "Portuguese",
  "answer_mode": "chat",
  "doc_level": null,
  "output_folder": "aegis",
  "phase": "reconnaissance",
  "completed": ["reconnaissance"],
  "pending": ["excavation", "interpretation", "generation", "review"],
  "engines": ["claude-code"],
  "agents": ["reversa", "aegis-scout", "aegis-archaeologist"],
  "checkpoints": {
    "scout": {
      "completed_at": "2026-04-26T10:00:00Z",
      "files": [
        "aegis/reports/inventory.md",
        "aegis/reports/dependencies.md",
        "aegis/runtime/context/surface.json"
      ]
    },
    "archaeologist": {
      "completed_at": "2026-04-26T11:00:00Z",
      "modules_analyzed": ["auth", "orders", "payments"],
      "files": [
        "aegis/reports/code-analysis.md",
        "aegis/reports/data-dictionary.md",
        "aegis/runtime/context/modules.json"
      ]
    }
  },
  "created_files": [
    "CLAUDE.md",
    "aegis/skills/aegis/SKILL.md",
    "aegis/config/state.json",
    "aegis/plan.md"
  ]
}
```

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `version` | string | Version of installed Aegis Spec |
| `project` | string | Legacy project name |
| `user_name` | string | User name (for interactions) |
| `chat_language` | string | Language for interactions (ex: pt-br, en-us) |
| `doc_language` | string | Language for generated specs (ex: Portuguese, English) |
| `answer_mode` | string | How user answers gaps: `chat` or `file` |
| `doc_level` | string \| null | Volume of generated documentation: `essential`, `complete` or `detailed`. Starts `null` — must be filled by user choice after Scout. |
| `output_folder` | string | Output folder for specs (default: `aegis`) |
| `phase` | string \| null | Current phase. `null` = not started |
| `completed` | string[] | Completed phases |
| `pending` | string[] | Pending phases |
| `checkpoints` | object | Completion record for each agent |
| `engines` | string[] | Configured engines (ex: `["claude-code", "codex"]`) |
| `agents` | string[] | Installed agents |
| `created_files` | string[] | All files created by Aegis Spec (for safe uninstall) |

## Valid phases

`reconnaissance` → `excavation` → `interpretation` → `generation` → `review`

## Writing rule

Never remove existing fields. Only add or update.

## Where NOT to write

The decision about specs organization (granularity, custom folders, original Scout suggestion, choice timestamp) does **not** go in `state.json`. It is persisted in `aegis/config/config.toml`, section `[specs]`, per `references/step-03-specs-organization.md`. `state.json` is runtime state, `config.toml` is long-term decision.
