# Checkpoint Guide — aegis/config/state.json

Aegis Spec is the only agent that **writes** to state.json. All other agents only read.

## Absolute rules

1. **Never remove existing fields.** Only add or update.
2. **Always read the file before writing** — another agent may have updated `checkpoints`.
3. **Save after each completed phase**, not just at the end.
4. **In case of context overflow**, save immediately before pausing.

## What to save per phase

### When starting a phase
```json
{
  "phase": "reconhecimento"
}
```

### When completing an agent
```json
{
  "checkpoints": {
    "scout": {
      "completed_at": "2026-04-26T10:30:00Z",
      "files": [
        "aegis/reports/inventory.md",
        "aegis/reports/dependencies.md",
        "aegis/runtime/context/surface.json"
      ]
    }
  }
}
```

### When completing an entire phase
```json
{
  "phase": "excavation",
  "completed": ["reconnaissance"],
  "pending": ["excavation", "interpretation", "generation", "review"]
}
```

### When marking a partial task of the Archaeologist
```json
{
  "checkpoints": {
    "archaeologist": {
      "modules_analyzed": ["auth", "orders"],
      "modules_pending": ["payments", "users"]
    }
  }
}
```

## Phase sequence

```
null → reconnaissance → excavation → interpretation → generation → review
```

When moving to a new phase:
- Remove the completed phase from `pending` and add to `completed`
- Update `phase` to the next phase

## Example of state.json with analysis in progress

```json
{
  "version": "1.0.0",
  "project": "my-system",
  "user_name": "Ana",
  "chat_language": "pt-br",
  "doc_language": "Portuguese",
  "answer_mode": "chat",
  "output_folder": "aegis",
  "phase": "excavation",
  "completed": ["reconnaissance"],
  "pending": ["excavation", "interpretation", "generation", "review"],
  "checkpoints": {
    "scout": {
      "completed_at": "2026-04-26T10:30:00Z",
      "files": [
        "aegis/reports/inventory.md",
        "aegis/reports/dependencies.md",
        "aegis/runtime/context/surface.json"
      ]
    },
    "archaeologist": {
      "modules_analyzed": ["auth", "orders"],
      "modules_pending": ["payments", "users"]
    }
  },
  "engines": ["claude-code"],
  "agents": ["reversa", "aegis-scout", "aegis-archaeologist"],
  "created_files": []
}
```

## Context overflow pause message

If context is running low, save the current checkpoint and say:

> "[Name], I'll pause here to preserve context. Everything is saved in `aegis/config/state.json`. Type `reversa` in a new session to continue where we left off."
